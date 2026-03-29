# Don't exit on failure
set +e

process_flake_check() {
  local output="$1"
  local result=""
  local current_output=""
  local current_section=""
  local section_has_issues=0

  while IFS= read -r line; do
    # Track which top-level flake output we're in
    if [[ "$line" =~ ^checking\ flake\ output\ \'([^\']+)\'\.\.\. ]]; then
      # Flush previous section if it had issues
      if [ $section_has_issues -eq 1 ] && [ -n "$current_section" ]; then
        result+="$current_section"$'\n'
      fi
      current_output="${BASH_REMATCH[1]}"
      current_section="[flake output: $current_output]"$'\n'
      section_has_issues=0

    # Sub-items: overlays, apps, NixOS configurations — only add if section later proves interesting
    elif [[ "$line" =~ ^checking\ (overlay|app|NixOS\ configuration)\ \'([^\']+)\'\.\.\. ]]; then
      current_section+="  $line"$'\n'

    # Always suppress these
    elif [[ "$line" =~ ^derivation\ evaluated\ to\  ]] ||
      [[ "$line" =~ lacks\ attribute\ \'meta\. ]]; then
      continue

    # Errors and warnings are always interesting
    elif [[ "$line" =~ ^error|^warning ]]; then
      section_has_issues=1
      current_section+="  $line"$'\n'

    # Catch-all: keep unrecognised lines (e.g. "evaluating flake...")
    else
      result+="$line"$'\n'
    fi
  done <<<"$output"

  # Flush final section
  if [ $section_has_issues -eq 1 ] && [ -n "$current_section" ]; then
    result+="$current_section"$'\n'
  fi

  echo "$result"
}

follow_up_eval() {
  local output_name="$1"
  # Strip the attribute path prefix to get bare output name, e.g. "flakeModule"
  local attr="${output_name##*.}"
  echo "  [follow-up] nix eval .#${attr}:"
  nix eval ".#${attr}" --apply 'builtins.typeOf' 2>&1 | sed 's/^/    /' || true
}

{
  echo "### Phase 1: flake check"

  RAW_CHECK=$(nix flake check --no-build --keep-going 2>&1 || true)
  PROCESSED=$(process_flake_check "$RAW_CHECK")
  echo "$PROCESSED"

  # Collect errored output names in a separate pass — don't re-emit anything
  ERRORED_OUTPUTS=()
  current_output=""
  while IFS= read -r line; do
    if [[ "$line" =~ ^\[flake\ output:\ ([^\]]+)\] ]]; then
      current_output="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^[[:space:]]+error ]] && [ -n "$current_output" ]; then
      ERRORED_OUTPUTS+=("$current_output")
      current_output="" # prevent duplicate if multiple error lines in same section
    fi
  done <<<"$PROCESSED"

  # Now emit follow-ups once per errored output
  for output_name in "${ERRORED_OUTPUTS[@]}"; do
    follow_up_eval "$output_name"
  done
  echo ""
  echo "### Phase 2: host enumeration and eval"

  ALL_HOSTS=$(nix eval --json '.#nixosConfigurations' \
    --apply 'builtins.attrNames' 2>/dev/null |
    tr -d '[]"' | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true)

  if [ -z "$ALL_HOSTS" ]; then
    echo "WARNING: No hosts found in nixosConfigurations"
  fi

  for host in $ALL_HOSTS; do
    SYSTEM=$(nix eval --raw \
      ".#nixosConfigurations.${host}.config.nixpkgs.hostPlatform.system" \
      2>/dev/null ||
      nix eval --raw \
        ".#nixosConfigurations.${host}.config.nixpkgs.system" \
        2>/dev/null ||
      true)

    if [ "$SYSTEM" != "x86_64-linux" ]; then
      echo "--- $host [skipped: ${SYSTEM:-unknown platform}] ---"
      continue
    fi

    echo "--- $host ---"
    HOST_OUT=$(nix eval ".#nixosConfigurations.${host}.config.system.build.toplevel.drvPath" \
      --raw 2>&1)
    EXIT=$?
    if [ $EXIT -eq 0 ]; then
      echo "[OK] $HOST_OUT"
    else
      echo "[FAILED]"
      echo "$HOST_OUT" | tail -50
    fi
    echo ""
  done
} 2>&1
