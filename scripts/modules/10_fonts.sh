#!/usr/bin/env bash
# shellcheck shell=bash

modules::fonts::run() {
  rtb_section "Nerd Fonts"
  rtb_install_apt_packages "fonts" "fontconfig" "unzip" "curl"
  modules::fonts::install_nerd_font "JetBrainsMono" "JetBrainsMono"
  modules::fonts::install_nerd_font "Hack" "Hack"
  modules::fonts::install_nerd_font "FiraCode" "FiraCode"
  rtb_run_as_user "fonts" fc-cache -fv
  rtb_success "Fonts installation completed."
}

modules::fonts::install_nerd_font() {
  local repo_name=$1
  local font_dir_name=$2
  local version="v3.3.0"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${repo_name}.zip"
  local zip_path="${RTB_CACHE_DIR}/fonts/${repo_name}.zip"
  local dest="${RTB_TARGET_HOME}/.local/share/fonts/${font_dir_name}"
  if [[ -d "${dest}" && "${RTB_REPAIR_MODE}" != "1" ]]; then
    rtb_success "${repo_name} Nerd Font already installed."
    return 0
  fi
  rtb_download "${url}" "${zip_path}" "" "fonts"
  rtb_ensure_dir "${dest}" "${RTB_TARGET_USER}"
  if [[ "${RTB_DRY_RUN}" == "1" ]]; then
    printf '%s[DRY-RUN]%s unzip %s to %s\n' "${RTB_MAGENTA}" "${RTB_RESET}" "${zip_path}" "${dest}"
    return 0
  fi
  unzip -o "${zip_path}" -d "${dest}" >> "${RTB_LOG_FILE}" 2>&1
  if [[ "${EUID}" -eq 0 ]]; then
    chown -R "${RTB_TARGET_USER}:${RTB_TARGET_USER}" "${dest}"
  fi
}
