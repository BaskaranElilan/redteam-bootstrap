#!/usr/bin/env bash
# shellcheck shell=bash

rtb_detect_target_user() {
  if [[ -z "${RTB_TARGET_USER}" || "${RTB_TARGET_USER}" == "root" ]]; then
    RTB_TARGET_USER="${SUDO_USER:-${USER:-root}}"
  fi
  if [[ -z "${RTB_TARGET_HOME}" ]]; then
    RTB_TARGET_HOME="$(getent passwd "${RTB_TARGET_USER}" | cut -d: -f6)"
  fi
  [[ -n "${RTB_TARGET_HOME}" ]] || rtb_die "Could not determine home directory for ${RTB_TARGET_USER}."
  export RTB_TARGET_USER RTB_TARGET_HOME
}

rtb_require_bash() {
  [[ -n "${BASH_VERSION:-}" ]] || rtb_die "This installer requires Bash."
}

rtb_detect_os() {
  [[ -r /etc/os-release ]] || rtb_die "Cannot detect OS because /etc/os-release is missing."
  # shellcheck source=/dev/null
  source /etc/os-release
  RTB_OS_ID="${ID:-unknown}"
  RTB_OS_VERSION_ID="${VERSION_ID:-unknown}"
  RTB_OS_PRETTY_NAME="${PRETTY_NAME:-unknown Linux}"
  export RTB_OS_ID RTB_OS_VERSION_ID RTB_OS_PRETTY_NAME
}

rtb_require_supported_os() {
  case "${RTB_OS_ID}" in
    kali)
      rtb_success "Detected supported OS: ${RTB_OS_PRETTY_NAME}"
      ;;
    debian)
      if [[ " ${RTB_SUPPORTED_VERSIONS_DEBIAN[*]} " == *" ${RTB_OS_VERSION_ID} "* ]]; then
        rtb_warn "Debian ${RTB_OS_VERSION_ID} is supported on a best-effort basis."
      else
        rtb_die "Unsupported Debian version: ${RTB_OS_VERSION_ID}. Supported: ${RTB_SUPPORTED_VERSIONS_DEBIAN[*]}"
      fi
      ;;
    ubuntu)
      if [[ " ${RTB_SUPPORTED_VERSIONS_UBUNTU[*]} " == *" ${RTB_OS_VERSION_ID} "* ]]; then
        rtb_warn "Ubuntu ${RTB_OS_VERSION_ID} is supported on a best-effort basis."
      else
        rtb_die "Unsupported Ubuntu version: ${RTB_OS_VERSION_ID}. Supported: ${RTB_SUPPORTED_VERSIONS_UBUNTU[*]}"
      fi
      ;;
    *)
      rtb_die "Unsupported OS: ${RTB_OS_PRETTY_NAME}. Primary target is Kali Linux."
      ;;
  esac
}

rtb_require_sudo() {
  if [[ "${EUID}" -eq 0 ]]; then
    return 0
  fi
  if ! sudo -n true 2>/dev/null; then
    rtb_warn "Sudo privileges are required for package installation."
    sudo -v
  fi
}
