#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_contains() {
  local file=$1
  local pattern=$2
  if ! grep -Fq "${pattern}" "${ROOT}/${file}"; then
    printf 'Expected %s to contain: %s\n' "${file}" "${pattern}" >&2
    exit 1
  fi
}

assert_contains "install.sh" "set -Eeuo pipefail"
assert_contains "scripts/lib/logging.sh" "rtb_log"
assert_contains "scripts/lib/backup.sh" "rtb_backup_standard_configs"
assert_contains "scripts/modules/13_verify.sh" "rtb_verify_command"
assert_contains "configs/zsh/.zshrc" "zsh-autosuggestions"
assert_contains "configs/tmux/.tmux.conf" "tmux-continuum"
assert_contains "configs/i3/config" "set \$ws7 \"7:proxy\""

printf 'Configuration contract validation passed.\n'
