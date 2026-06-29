#!/usr/bin/env bash
# shellcheck shell=bash

modules::modern_cli::run() {
  rtb_section "Modern CLI Tools"
  rtb_apt_update
  local available=()
  local package
  for package in "${RTB_MODERN_CLI_APT_PACKAGES[@]}"; do
    if apt-cache show "${package}" >/dev/null 2>&1; then
      available+=("${package}")
    else
      rtb_warn "${package} is not available in configured APT repositories."
    fi
  done
  if ((${#available[@]} > 0)); then
    rtb_install_apt_packages "modern-cli" "${available[@]}"
  fi
  rtb_success "Modern CLI tools completed."
}
