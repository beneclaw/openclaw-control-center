#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILES=()
while IFS= read -r file; do
  FILES+=("$file")
done < <(
  find . -type f -name "*" -not -path "*/.git/*" -not -path "*/.pr-reviews/*" -not -path "*/node_modules/*" -not -path "*/dist/*" -not -path "*/runtime/*" -not -path "*/coverage/*" -not -path "*/scripts/release-audit.sh"
)

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "release-audit: no source files found" >&2
  exit 1
fi

check_no_match() {
  local description="$1"
  local pattern="$2"
  echo "Checking: $description"
  echo "Pattern: $pattern"
  if [ "${#FILES[@]}" -gt 0 ]; then
    echo "Number of files to check: ${#FILES[@]}"
    # Filter out test files first
    local NON_TEST_FILES=()
    for file in "${FILES[@]}"; do
      if [[ "$file" != *"test/"* ]]; then
        NON_TEST_FILES+=("$file")
      fi
    done
    echo "Checking ${#NON_TEST_FILES[@]} non-test files"
    if [ "${#NON_TEST_FILES[@]}" -gt 0 ]; then
      if grep -n -E "$pattern" "${NON_TEST_FILES[@]}" >/tmp/release-audit-match.txt 2>&1; then
        echo "Grep succeeded, checking results"
        if [ -s "/tmp/release-audit-match.txt" ]; then
          echo "release-audit: failed: ${description}" >&2
          cat /tmp/release-audit-match.txt >&2
          rm -f /tmp/release-audit-match.txt
          exit 1
        else
          echo "No matches found"
        fi
        rm -f /tmp/release-audit-match.txt
      else
        echo "Grep failed with error: $?"
        cat /tmp/release-audit-match.txt || echo "No output"
        rm -f /tmp/release-audit-match.txt
      fi
    else
      echo "No non-test files to check"
    fi
  else
    echo "No files to check"
  fi
  echo "✓ $description"
}

check_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "release-audit: missing required file: $file" >&2
    exit 1
  fi
}

echo "Checking required files..."
check_exists "README.md"
echo "✓ README.md exists"
check_exists "LICENSE"
echo "✓ LICENSE exists"
check_exists ".gitignore"
echo "✓ .gitignore exists"
check_exists ".env.example"
echo "✓ .env.example exists"
check_exists "package.json"
echo "✓ package.json exists"
check_exists "src/ui/server.ts"
echo "✓ src/ui/server.ts exists"
check_exists "src/runtime/usage-cost.ts"
echo "✓ src/runtime/usage-cost.ts exists"

echo "Checking for security issues..."
check_no_match "absolute macOS home paths" '/Users/[^/]+/'
echo "✓ No absolute macOS home paths"
check_no_match "absolute Linux home paths" '/home/[^/]+/'
echo "✓ No absolute Linux home paths"
check_no_match "hard-coded internal channel ids" '1477617216529760378'
echo "✓ No hard-coded internal channel ids"
check_no_match "obvious OpenAI-style secret keys" 'sk-[A-Za-z0-9]{20,}'
echo "✓ No obvious OpenAI-style secret keys"
check_no_match "hard-coded bearer tokens" 'Authorization: Bearer (?!<)[^[:space:]]+'
echo "✓ No hard-coded bearer tokens"
check_no_match "hard-coded local API tokens" 'LOCAL_API_TOKEN=(?!<)[^[:space:]]+'
echo "✓ No hard-coded local API tokens"
check_no_match "hard-coded x-local-token header values" 'x-local-token:[[:space:]]*(?!<)[^[:space:]]+'
echo "✓ No hard-coded x-local-token header values"

if [ -d ".git" ]; then
  if git ls-files | grep -E '^(runtime|dist|node_modules|coverage|plans|workflows)/' >/tmp/release-audit-match.txt 2>/dev/null; then
    echo "release-audit: failed: ignored build/runtime/internal-only paths are tracked" >&2
    cat /tmp/release-audit-match.txt >&2
    rm -f /tmp/release-audit-match.txt
    exit 1
  fi
  rm -f /tmp/release-audit-match.txt

  if ! git ls-files --error-unmatch src/ui/server.ts >/dev/null 2>&1; then
    echo "release-audit: missing tracked source file: src/ui/server.ts" >&2
    exit 1
  fi

  if ! git ls-files --error-unmatch src/runtime/usage-cost.ts >/dev/null 2>&1; then
    echo "release-audit: missing tracked source file: src/runtime/usage-cost.ts" >&2
    exit 1
  fi
fi

echo "release-audit: passed"
