#!/usr/bin/env bash
# shellcheck shell=bash

modules::redteam::run() {
  rtb_section "Red Team Tools"
  rtb_apt_update
  modules::redteam::install_available_apt_tools
  modules::redteam::install_rustscan
  modules::redteam::install_wordlists
  rtb_success "Red team tools installation completed."
}

modules::redteam::install_available_apt_tools() {
  local available=()
  local package
  for package in "${RTB_REDTEAM_APT_PACKAGES[@]}"; do
    if apt-cache show "${package}" >/dev/null 2>&1; then
      available+=("${package}")
    else
      rtb_warn "${package} is unavailable from configured APT repositories."
    fi
  done
  if ((${#available[@]} > 0)); then
    rtb_install_apt_packages "redteam" "${available[@]}"
  fi
}

modules::redteam::install_rustscan() {
  if rtb_command_exists rustscan; then
    rtb_success "rustscan already installed."
    return 0
  fi
  if apt-cache show rustscan >/dev/null 2>&1; then
    rtb_install_apt_packages "rustscan" "rustscan"
  else
    rtb_warn "rustscan package not found; use the Go/Rust environment or upstream release workflow manually."
  fi
}

modules::redteam::install_wordlists() {
  local src="/usr/share/seclists"
  local dest="${RTB_TARGET_HOME}/${RTB_REDTEAM_ROOT_NAME}/Wordlists/SecLists"
  if [[ -d "${src}" && ! -e "${dest}" ]]; then
    rtb_ensure_dir "$(dirname "${dest}")" "${RTB_TARGET_USER}"
    rtb_run "redteam" ln -s "${src}" "${dest}"
  fi
}
