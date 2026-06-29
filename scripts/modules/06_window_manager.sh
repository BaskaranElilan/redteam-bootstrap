#!/usr/bin/env bash
# shellcheck shell=bash

modules::window_manager::run() {
  rtb_section "Window Manager"
  rtb_apt_update
  rtb_install_apt_packages "window-manager" "${RTB_WM_APT_PACKAGES[@]}"
  modules::window_manager::deploy_configs
  rtb_success "Window manager configuration completed."
}

modules::window_manager::deploy_configs() {
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/i3" "${RTB_TARGET_HOME}/.config/i3" "window-manager"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/polybar" "${RTB_TARGET_HOME}/.config/polybar" "window-manager"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/picom" "${RTB_TARGET_HOME}/.config/picom" "window-manager"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/rofi" "${RTB_TARGET_HOME}/.config/rofi" "window-manager"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/dunst" "${RTB_TARGET_HOME}/.config/dunst" "window-manager"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/kitty" "${RTB_TARGET_HOME}/.config/kitty" "window-manager"
  rtb_symlink_or_copy "${RTB_CONFIG_DIR}/alacritty" "${RTB_TARGET_HOME}/.config/alacritty" "window-manager"
}
