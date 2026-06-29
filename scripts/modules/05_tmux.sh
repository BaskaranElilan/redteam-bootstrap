#!/usr/bin/env bash
# shellcheck shell=bash

modules::tmux::run() {
  rtb_section "tmux"
  rtb_install_apt_packages "tmux" "tmux" "git"
  modules::tmux::install_tpm
  modules::tmux::deploy_config
  rtb_success "tmux configuration completed."
}

modules::tmux::install_tpm() {
  local tpm="${RTB_TARGET_HOME}/.tmux/plugins/tpm"
  rtb_ensure_dir "$(dirname "${tpm}")" "${RTB_TARGET_USER}"
  if [[ -d "${tpm}/.git" ]]; then
    rtb_run_as_user "tmux" git -C "${tpm}" pull --ff-only
  elif [[ "${RTB_OFFLINE}" == "1" ]]; then
    rtb_warn "Offline mode enabled; cannot clone TPM."
  else
    rtb_run_as_user "tmux" git clone --depth 1 https://github.com/tmux-plugins/tpm "${tpm}"
  fi
}

modules::tmux::deploy_config() {
  local target="${RTB_TARGET_HOME}/.tmux.conf"
  rtb_backup_path "${target}"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/tmux/.tmux.conf" "${target}" "tmux"
}
