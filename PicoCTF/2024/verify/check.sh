#!/usr/bin/env bash
# check.sh
# Usage: ./check_and_decrypt.sh
# Checks all files under ./files for a matching SHA-256 hash and optionally runs ./decrypt.sh on matches.

set -u
EXPECTED="467a10447deb3d4e17634cacc2a68ba6c2bb62a6637dad9145ea673bf0be5e02"
FILES_DIR="files"
DO_DECRYPT=0   # set to 1 to automatically run ./decrypt.sh on matched files
DECRYPT_ARGS="picoctf"   # arguments to pass to ./decrypt.sh after filename (if any)

# Determine available sha256 command
if command -v sha256sum >/dev/null 2>&1; then
  SHA_CMD="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  SHA_CMD="shasum -a 256"
else
  echo "ERROR: neither sha256sum nor shasum is available on this system." >&2
  exit 2
fi

echo "Using checksum tool: $SHA_CMD"
echo "Expected SHA-256: $EXPECTED"
echo "Scanning files in: ./$FILES_DIR"
echo

MATCH_COUNT=0

# Loop over files in the directory (non-recursive). Adjust glob if you want recursion.
for f in "$FILES_DIR"/*; do
  # skip if not a regular file
  [ -f "$f" ] || continue

  # compute the hash; take only the first field (the checksum)
  computed=$($SHA_CMD "$f" 2>/dev/null | awk '{print $1}')

  if [ -z "$computed" ]; then
    echo "WARNING: could not compute hash for $f"
    continue
  fi

  if [ "$computed" = "$EXPECTED" ]; then
    echo "MATCH: $f"
    MATCH_COUNT=$((MATCH_COUNT+1))

    # Show file metadata
    ls -l "$f"
    echo

    if [ "$DO_DECRYPT" -eq 1 ]; then
      echo "Running ./decrypt.sh \"$f\" $DECRYPT_ARGS"
      # inspect decrypt.sh before running? (uncomment inspection if desired)
      # head -n 80 decrypt.sh

      if [ -x "./decrypt.sh" ]; then
        ./decrypt.sh "$f" $DECRYPT_ARGS
      else
        echo "decrypt.sh not executable. Attempting to run with bash:"
        bash ./decrypt.sh "$f" $DECRYPT_ARGS
      fi

      echo "Done decrypt attempt for $f"
      echo
    else
      echo "DECRYPT SKIPPED (DO_DECRYPT=0). To auto-decrypt set DO_DECRYPT=1 in the script."
      echo
    fi
  else
    # Uncomment the next line to print non-matching files (quiet by default)
    # echo "NO: $f -> $computed"
    :
  fi
done

if [ "$MATCH_COUNT" -eq 0 ]; then
  echo "No files matched the expected SHA-256 ($EXPECTED)."
else
  echo "$MATCH_COUNT file(s) matched the expected SHA-256."
fi
