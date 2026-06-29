#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

while IFS= read -r file; do
  printf 'bash -n %s\n' "${file#"${ROOT}"/}"
  if ! bash -n "${file}"; then
    failures=$((failures + 1))
  fi
done < <(find "${ROOT}" -type f -name '*.sh' | sort)

if ((failures > 0)); then
  printf 'Syntax validation failed: %s file(s)\n' "${failures}" >&2
  exit 1
fi

printf 'Syntax validation passed.\n'
