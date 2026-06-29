#!/usr/bin/env bash
# shellcheck shell=bash

rtb_backup_stamp() {
  date +"%Y%m%d-%H%M%S"
}

rtb_backup_path() {
  local path=$1
  [[ -e "${path}" || -L "${path}" ]] || return 0
  local stamp dest parent
  stamp="$(rtb_backup_stamp)"
  parent="$(dirname "${path}")"
  dest="${RTB_BACKUP_DIR}/${stamp}${path}"
  rtb_ensure_dir "$(dirname "${dest}")"
  rtb_info "Backing up ${path}"
  if [[ "${RTB_DRY_RUN}" == "1" ]]; then
    printf '%s[DRY-RUN]%s backup %s to %s\n' "${RTB_MAGENTA}" "${RTB_RESET}" "${path}" "${dest}"
    return 0
  fi
  if [[ -d "${path}" && ! -L "${path}" ]]; then
    mkdir -p "${dest}"
    cp -a "${path}/." "${dest}/"
  else
    cp -a "${path}" "${dest}"
  fi
  rtb_log "SUCCESS" "backup" "Backed up ${path} from ${parent} to ${dest}."
}

rtb_backup_standard_configs() {
  local paths=(
    "${RTB_TARGET_HOME}/.zshrc"
    "${RTB_TARGET_HOME}/.tmux.conf"
    "${RTB_TARGET_HOME}/.config/i3"
    "${RTB_TARGET_HOME}/.config/kitty"
    "${RTB_TARGET_HOME}/.config/alacritty"
    "${RTB_TARGET_HOME}/.config/rofi"
    "${RTB_TARGET_HOME}/.config/polybar"
    "${RTB_TARGET_HOME}/.config/picom"
    "${RTB_TARGET_HOME}/.config/dunst"
  )
  local path
  for path in "${paths[@]}"; do
    rtb_backup_path "${path}"
  done
}
