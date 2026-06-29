#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${ROOT}/tests/test_structure.sh"
"${ROOT}/tests/test_syntax.sh"
"${ROOT}/tests/test_config_contracts.sh"

if command -v shellcheck >/dev/null 2>&1; then
  find "${ROOT}" -type f -name '*.sh' -print0 | xargs -0 shellcheck -x -e SC2034 -e SC2016
else
  printf 'shellcheck not found; skipping ShellCheck validation.\n'
fi

printf 'All tests completed.\n'
