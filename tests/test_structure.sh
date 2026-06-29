#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(
  "install.sh"
  "config.sh"
  "README.md"
  "LICENSE"
  "CHANGELOG.md"
  "VERSION"
  "scripts/lib/bootstrap.sh"
  "scripts/modules/00_directories.sh"
  "scripts/modules/15_uninstall.sh"
  "configs/zsh/.zshrc"
  "configs/tmux/.tmux.conf"
  "configs/i3/config"
  "configs/polybar/config.ini"
  "configs/polybar/launch.sh"
  "configs/picom/picom.conf"
  "configs/rofi/config.rasi"
  "configs/dunst/dunstrc"
  "configs/kitty/kitty.conf"
  "configs/alacritty/alacritty.toml"
  "docs/ARCHITECTURE.md"
  "docs/OPERATIONS.md"
  ".github/workflows/ci.yml"
)

missing=0
for item in "${required[@]}"; do
  if [[ ! -e "${ROOT}/${item}" ]]; then
    printf 'Missing required path: %s\n' "${item}" >&2
    missing=$((missing + 1))
  fi
done

if ((missing > 0)); then
  exit 1
fi

printf 'Structure validation passed.\n'
