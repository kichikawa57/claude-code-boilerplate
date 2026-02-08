#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(".env" ".pem" "secret" "credential")
LOCK_FILES=("package-lock.json" "yarn.lock" "pnpm-lock.yaml" "bun.lockb")

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'" >&2
    exit 2
  fi
done

for lock in "${LOCK_FILES[@]}"; do
  if [[ "$FILE_PATH" == *"$lock"* ]]; then
    echo "Blocked: Direct editing of lock file '$lock' is not allowed" >&2
    exit 2
  fi
done

exit 0
