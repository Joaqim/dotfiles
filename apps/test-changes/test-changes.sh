# Incremental flake testing - only evaluate changed modules
# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; }
cmd() { echo -e "${CYAN}[CMD]${NC} $*"; }

# Flags
DRY_RUN="${DRY_RUN:-false}"
EVAL_ONLY="${EVAL_ONLY:-false}"

# Get changed files since last commit (or against main if specified)
get_changed_files() {
    local base="${1:-HEAD}"
    if [[ "$base" == "HEAD" ]]; then
        # Uncommitted changes
        git diff --name-only HEAD
        git diff --name-only --cached
        git ls-files --others --exclude-standard
    else
        # Changes against a branch
        git diff --name-only "$base"...HEAD
    fi | sort -u
}

# Map file to affected outputs
map_file_to_outputs() {
    local file="$1"
    local outputs=()

    case "$file" in
        # NixOS host-specific files
        hosts/nixos/desktop/*)
            outputs+=("nixosConfigurations.desktop")
            ;;
        hosts/nixos/deck/*)
            outputs+=("nixosConfigurations.deck")
            ;;
        hosts/nixos/qb/*)
            outputs+=("nixosConfigurations.qb")
            ;;
        hosts/nixos/raket/*)
            outputs+=("nixosConfigurations.raket")
            ;;
        hosts/nixos/generic/*)
            outputs+=("nixosConfigurations.generic")
            ;;
        hosts/nixos/container/*)
            outputs+=("nixosConfigurations.container")
            ;;

        # Home-manager configs
        hosts/homes/jq@desktop/*)
            outputs+=("homeConfigurations.jq@desktop")
            ;;
        hosts/homes/jq@qb/*)
            outputs+=("homeConfigurations.jq@qb")
            ;;
        hosts/homes/deck@deck/*)
            outputs+=("homeConfigurations.deck@deck")
            ;;
        hosts/homes/wilton@raket/*)
            outputs+=("homeConfigurations.wilton@raket")
            ;;
        hosts/homes/github-actions@generic/*)
            outputs+=("homeConfigurations.github-actions@generic")
            ;;
        hosts/homes/user@container/*)
            outputs+=("homeConfigurations.user@container")
            ;;
        hosts/homes/jq@generic/*)
            outputs+=("homeConfigurations.jq@generic")
            ;;
        hosts/homes/jq/*)
            outputs+=("homeConfigurations.jq")
            ;;

        # Shared module changes affect all hosts using them
        modules/nixos/*|modules/home/*)
            # These affect everything - return special marker
            echo "ALL"
            return
            ;;

        # Flake structure changes
        flake.nix|flake.lock|flake/*)
            echo "ALL"
            return
            ;;

        # Overlays and packages affect everything
        overlays/*|pkgs/*)
            echo "ALL"
            return
            ;;

        *)
            # Unknown file, might affect things
            ;;
    esac

    # Output unique list
    printf '%s\n' "${outputs[@]}" | sort -u
}

# Analyze what changed and what needs testing
analyze_changes() {
    local base="${1:-HEAD}"
    local verbose="${2:-true}"

    [[ "$verbose" == "true" ]] && log "Analyzing changes since: $base"

    local changed_files
    changed_files=$(get_changed_files "$base")

    if [[ -z "$changed_files" ]]; then
        [[ "$verbose" == "true" ]] && warn "No changes detected"
        return 1
    fi

    if [[ "$verbose" == "true" ]]; then
        log "Changed files:"
        while IFS= read -r line; do echo "  $line"; done <<< "$changed_files"
        echo
    fi

    local all_outputs=()
    local needs_full_check=false

    while IFS= read -r file; do
        local outputs
        outputs=$(map_file_to_outputs "$file")

        if [[ "$outputs" == "ALL" ]]; then
            needs_full_check=true
            [[ "$verbose" == "true" ]] && warn "File '$file' affects all configurations"
            break
        fi

        if [[ -n "$outputs" ]]; then
            while IFS= read -r output; do
                all_outputs+=("$output")
            done <<< "$outputs"
        fi
    done <<< "$changed_files"

    if [[ "$needs_full_check" == "true" ]]; then
        echo "FULL_CHECK"
        return 0
    fi

    # Return unique outputs
    printf '%s\n' "${all_outputs[@]}" | sort -u
}

# Time a command
time_command() {
    local label="$1"
    shift

    log "Timing: $label"
    local start
    start=$(date +%s%N)

    if "$@"; then
        local end
        end=$(date +%s%N)
        local duration_ns=$((end - start))
        local duration_s=$((duration_ns / 1000000000))
        local duration_ms=$(((duration_ns / 1000000) % 1000))
        success "$label completed in ${duration_s}.$(printf '%03d' $duration_ms)s"
        echo "${duration_s}.$(printf '%03d' $duration_ms)"
    else
        local end
        end=$(date +%s%N)
        local duration_ns=$((end - start))
        local duration_s=$((duration_ns / 1000000000))
        local duration_ms=$(((duration_ns / 1000000) % 1000))
        error "$label failed after ${duration_s}.$(printf '%03d' $duration_ms)s"
        return 1
    fi
}

# Build or evaluate specific outputs
build_outputs() {
    local outputs=("$@")

    if [[ ${#outputs[@]} -eq 0 ]]; then
        warn "No outputs to build"
        return 0
    fi

    local action="Building"
    [[ "$EVAL_ONLY" == "true" ]] && action="Evaluating"

    log "$action ${#outputs[@]} output(s)..."

    local failed=0
    for output in "${outputs[@]}"; do
        local build_cmd
        local eval_path

        # Determine the right eval path for each output type
        if [[ "$output" =~ ^nixosConfigurations\. ]]; then
            eval_path="$output.config.system.build.toplevel"
        elif [[ "$output" =~ ^homeConfigurations\. ]]; then
            eval_path="$output.activationPackage"
        else
            eval_path="$output"
        fi

        if [[ "$EVAL_ONLY" == "true" ]]; then
            build_cmd="nix eval path:.#$eval_path --show-trace"
            action="Evaluating"
        else
            build_cmd="nix build path:.#$output --no-link --show-trace"
        fi

        log "$action: $output"
        cmd "$build_cmd"

        if [[ "$DRY_RUN" == "true" ]]; then
            warn "[DRY RUN] Skipping actual execution"
            continue
        fi

        if eval "$build_cmd" >/dev/null 2>&1; then
            success "$action completed: $output"
        else
            error "Failed: $output"
            # Show last few lines of error
            eval "$build_cmd" 2>&1 | tail -10 >&2
            ((failed++))
        fi
    done

    if [[ $failed -gt 0 ]]; then
        error "$failed output(s) failed"
        return 1
    fi

    success "All outputs succeeded"
}

# Test with timing comparison
test_incremental() {
    local base="${1:-HEAD}"

    log "Starting incremental test..."
    echo

    # Analyze changes (verbose mode)
    local changed_files
    changed_files=$(get_changed_files "$base")

    if [[ -z "$changed_files" ]]; then
        warn "No changes detected"
        return 1
    fi

    log "Changed files:"
    while IFS= read -r line; do echo "  $line"; done <<< "$changed_files"
    echo

    # Get outputs (non-verbose)
    local outputs
    outputs=$(analyze_changes "$base" "false")

    local mode="INCREMENTAL"

    if [[ "$outputs" == "FULL_CHECK" ]]; then
        warn "Changes require full evaluation"
        mode="FULL"
        outputs=$(list_all_outputs)
    fi

    # Convert to array
    local output_array=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && output_array+=("$line")
    done <<< "$outputs"

    if [[ ${#output_array[@]} -eq 0 ]]; then
        warn "No outputs affected by changes (might be non-Nix files)"
        return 0
    fi

    log "Mode: $mode"
    log "Outputs to test: ${#output_array[@]}"
    printf '%s\n' "${output_array[@]}" | sed 's/^/  /'
    echo

    # Time the build
    local duration
    duration=$(time_command "Build test" build_outputs "${output_array[@]}")

    echo
    success "Incremental test completed in ${duration}s"

    # Show comparison hint
    if [[ "$mode" == "INCREMENTAL" && ${#output_array[@]} -lt 5 ]]; then
        echo
        log "💡 For comparison, run: time task test"
    fi
}

# List all outputs for full check
list_all_outputs() {
    cat <<EOF
nixosConfigurations.desktop
nixosConfigurations.deck
nixosConfigurations.qb
nixosConfigurations.raket
homeConfigurations.jq@desktop
homeConfigurations.jq@qb
homeConfigurations.deck@deck
homeConfigurations.wilton@raket
EOF
}

# Compare incremental vs full evaluation
compare_builds() {
    local base="${1:-HEAD}"

    log "Running build comparison..."
    echo

    # First, run incremental
    log "=== INCREMENTAL TEST ==="
    local incremental_time
    incremental_time=$(time_command "Incremental build" test_incremental "$base")
    echo

    # Then run full build for comparison
    log "=== FULL TEST (for comparison) ==="
    local full_outputs
    full_outputs=$(list_all_outputs)

    local output_array=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && output_array+=("$line")
    done <<< "$full_outputs"

    log "Building all ${#output_array[@]} outputs for comparison..."
    local full_time
    full_time=$(time_command "Full build" build_outputs "${output_array[@]}")
    echo

    # Show comparison
    log "=== COMPARISON ==="
    echo "  Incremental: ${incremental_time}s"
    echo "  Full:        ${full_time}s"

    # Calculate speedup (simple string comparison)
    local inc_int=${incremental_time%.*}
    local full_int=${full_time%.*}
    if [[ $inc_int -gt 0 ]]; then
        local speedup=$((full_int / inc_int))
        success "Speedup: ${speedup}x faster"
    fi
}

# Main command dispatcher
main() {
    local cmd="${1:-test}"
    shift || true

    # Parse flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run|-n)
                DRY_RUN=true
                shift
                ;;
            --eval-only|-e)
                EVAL_ONLY=true
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    local base="${1:-HEAD}"

    case "$cmd" in
        analyze)
            analyze_changes "$base"
            ;;
        test)
            test_incremental "$base"
            ;;
        compare)
            compare_builds "$base"
            ;;
        build)
            shift || true
            build_outputs "$@"
            ;;
        help|--help|-h)
            cat <<EOF

${BLUE}Incremental Flake Testing${NC}
Test only the parts of your flake that changed

${YELLOW}Usage:${NC}
  $0 <command> [flags] [arguments]

${YELLOW}Commands:${NC}
  analyze [base]     Analyze changed files and show affected outputs
  test [base]        Run incremental build/eval test with timing
  compare [base]     Compare incremental vs full build times
  build <outputs...> Build/eval specific outputs
  help               Show this help

${YELLOW}Flags:${NC}
  --dry-run, -n      Show commands without executing
  --eval-only, -e    Only evaluate, don't build (faster)

${YELLOW}Arguments:${NC}
  base              Git ref to compare against (default: HEAD)
                    - HEAD: uncommitted changes
                    - main: all changes on current branch
  outputs           Space-separated output names

${YELLOW}Examples:${NC}
  $0 analyze                                    # Show what changed
  $0 test --eval-only                           # Quick eval of changes
  $0 test main                                  # Test all branch changes
  $0 build nixosConfigurations.desktop          # Build specific host
  $0 test --dry-run                             # See what would be tested

${YELLOW}Environment:${NC}
  DRY_RUN=true       Enable dry-run mode
  EVAL_ONLY=true     Enable eval-only mode

EOF
            exit 0
            ;;
        *)
            error "Unknown command: $cmd"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac
}

main "$@"
