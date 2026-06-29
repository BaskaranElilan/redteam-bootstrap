#!/usr/bin/env bash
# shellcheck shell=bash

modules::productivity::run() {
  rtb_section "Productivity Tools"
  rtb_apt_update
  rtb_install_apt_packages "productivity" "${RTB_PRODUCTIVITY_APT_PACKAGES[@]}"
  modules::productivity::install_atuin
  modules::productivity::install_zsh_plugins
  rtb_success "Productivity tools completed."
}

modules::productivity::install_atuin() {
  if rtb_command_exists atuin; then
    rtb_success "atuin already installed."
    return 0
  fi
  if apt-cache show atuin >/dev/null 2>&1; then
    rtb_install_apt_packages "atuin" "atuin"
  else
    rtb_warn "atuin is not available from current APT repositories; skipping remote script installer by policy."
  fi
}

modules::productivity::install_zsh_plugins() {
  if [[ ! -d "${RTB_TARGET_HOME}/.oh-my-zsh/.git" ]]; then
    modules::shell::install_oh_my_zsh
  fi
  local custom="${RTB_TARGET_HOME}/.oh-my-zsh/custom"
  local plugins="${custom}/plugins"
  local themes="${custom}/themes"
  rtb_ensure_dir "${plugins}" "${RTB_TARGET_USER}"
  rtb_ensure_dir "${themes}" "${RTB_TARGET_USER}"

  modules::productivity::clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "${plugins}/zsh-autosuggestions"
  modules::productivity::clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${plugins}/zsh-syntax-highlighting"
  modules::productivity::clone_or_update "https://github.com/zsh-users/zsh-history-substring-search.git" "${plugins}/zsh-history-substring-search"
  modules::productivity::clone_or_update "https://github.com/Aloxaf/fzf-tab.git" "${plugins}/fzf-tab"
  modules::productivity::clone_or_update "https://github.com/romkatv/powerlevel10k.git" "${themes}/powerlevel10k"
}

modules::productivity::clone_or_update() {
  local repo=$1
  local dest=$2
  if [[ "${RTB_OFFLINE}" == "1" ]]; then
    rtb_warn "Offline mode enabled; skipping ${repo}."
    return 0
  fi
  if [[ -d "${dest}/.git" ]]; then
    rtb_run_as_user "git" git -C "${dest}" pull --ff-only
  else
    rtb_run_as_user "git" git clone --depth 1 "${repo}" "${dest}"
  fi
}
