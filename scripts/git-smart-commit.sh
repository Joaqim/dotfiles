#!/usr/bin/env bash
# Smart git commit that auto-fixes formatting and retries on linting failures
# Usage: ./scripts/git-smart-commit.sh [git commit args...]
#   or: git config alias.sc '!bash scripts/git-smart-commit.sh'
#   then: git sc -m "message"

set +e  # Don't exit on error

MAX_ATTEMPTS=3
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "📝 Commit attempt $ATTEMPT/$MAX_ATTEMPTS..."

    # Try to commit with all passed arguments
    git commit "$@"
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        echo "✅ Commit successful!"
        exit 0
    fi

    # Check if it was a formatting failure (exit code 1 from pre-commit hooks)
    if [ $EXIT_CODE -eq 1 ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
        echo "⚠️  Pre-commit hooks modified files. Auto-restaging and retrying..."

        # Re-stage any modified Nix files in the working directory
        MODIFIED_FILES=$(git diff --name-only | grep '\.nix$' || true)
        if [ -n "$MODIFIED_FILES" ]; then
            echo "$MODIFIED_FILES" | xargs git add
            echo "✓ Re-staged formatted files: $(echo "$MODIFIED_FILES" | wc -l) file(s)"
        else
            echo "⚠️  No modified .nix files to re-stage. Check for other issues."
            exit $EXIT_CODE
        fi

        ATTEMPT=$((ATTEMPT + 1))
    else
        if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
            echo "❌ Commit failed after $MAX_ATTEMPTS attempts"
        fi
        exit $EXIT_CODE
    fi
done
