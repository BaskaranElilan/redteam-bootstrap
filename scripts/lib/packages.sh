#!/usr/bin/env bash
# shellcheck shell=bash

rtb_apt_update() {
  rtb_section "APT Update"
  if [[ "${RTB_OFFLINE}" == "1" ]]; then
    rtb_warn "Offline mode enabled; skipping apt update."
    return 0
  fi
  rtb_retry "${RTB_APT_RETRIES}" "apt" sudo apt-get update
}

rtb_install_apt_packages() {
  local module=$1
  shift
  local packages=("$@")
  local missing=()
  local package
  for package in "${packages[@]}"; do
    if dpkg-query -W -f='${Status}' "${package}" 2>/dev/null | grep -q "install ok installed"; then
      rtb_log "SUCCESS" "${module}" "${package} already installed."
    else
      missing+=("${package}")
    fi
  done
  if ((${#missing[@]} == 0)); then
    rtb_success "${module}: all APT packages already installed."
    return 0
  fi
  if [[ "${RTB_OFFLINE}" == "1" ]]; then
    rtb_warn "${module}: offline mode prevents installing: ${missing[*]}"
    return 0
  fi
  rtb_info "${module}: installing ${#missing[@]} APT packages."
  rtb_retry "${RTB_APT_RETRIES}" "${module}" sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}"
}

rtb_enable_service() {
  local service=$1
  if command -v systemctl >/dev/null 2>&1; then
    rtb_run "service" sudo systemctl enable --now "${service}"
  else
    rtb_warn "systemctl not available; skipping service enable for ${service}."
  fi
}
