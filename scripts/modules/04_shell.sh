#!/usr/bin/env bash
# shellcheck shell=bash

modules::shell::run() {
  rtb_section "Shell Configuration"
  rtb_install_apt_packages "shell" "zsh" "git" "curl" "fzf"
  modules::shell::install_oh_my_zsh
  modules::shell::deploy_zshrc
  modules::shell::set_default_shell
  rtb_success "Shell configuration completed."
}

modules::shell::install_oh_my_zsh() {
  local omz="${RTB_TARGET_HOME}/.oh-my-zsh"
  if [[ -d "${omz}" ]]; then
    rtb_run_as_user "oh-my-zsh" git -C "${omz}" pull --ff-only
    return 0
  fi
  if [[ "${RTB_OFFLINE}" == "1" ]]; then
    rtb_warn "Offline mode enabled; cannot clone Oh My Zsh."
    return 0
  fi
  rtb_run_as_user "oh-my-zsh" git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "${omz}"
}

modules::shell::deploy_zshrc() {
  local target="${RTB_TARGET_HOME}/.zshrc"
  rtb_backup_path "${target}"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/zsh/.zshrc" "${target}" "shell"
}

modules::shell::set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  [[ -n "${zsh_path}" ]] || {
    rtb_warn "zsh not found; skipping default shell change."
    return 0
  }
  if [[ "${SHELL:-}" == "${zsh_path}" ]]; then
    rtb_success "Default shell is already zsh."
    return 0
  fi
  if rtb_confirm "Set ${RTB_TARGET_USER}'s default shell to ${zsh_path}?"; then
    rtb_run "shell" sudo chsh -s "${zsh_path}" "${RTB_TARGET_USER}"
  else
    rtb_warn "Default shell unchanged."
  fi
}
