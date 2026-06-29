#!/usr/bin/env bash
# shellcheck shell=bash

modules::uninstall::run() {
  rtb_section "Uninstall Project-Managed Files"
  rtb_warn "This removes project-managed dotfiles but does not purge installed packages."
  rtb_confirm "Continue with uninstall cleanup?" || {
    rtb_warn "Uninstall cancelled."
    return 0
  }
  local paths=(
    "${RTB_TARGET_HOME}/.zshrc"
    "${RTB_TARGET_HOME}/.tmux.conf"
    "${RTB_TARGET_HOME}/.config/i3"
    "${RTB_TARGET_HOME}/.config/polybar"
    "${RTB_TARGET_HOME}/.config/picom"
    "${RTB_TARGET_HOME}/.config/rofi"
    "${RTB_TARGET_HOME}/.config/dunst"
    "${RTB_TARGET_HOME}/.config/kitty"
    "${RTB_TARGET_HOME}/.config/alacritty"
  )
  local path
  for path in "${paths[@]}"; do
    if [[ -e "${path}" || -L "${path}" ]]; then
      rtb_backup_path "${path}"
      rtb_run "uninstall" rm -rf "${path}"
    fi
  done
  rtb_success "Uninstall cleanup completed. Backups remain in ${RTB_BACKUP_DIR}."
}
