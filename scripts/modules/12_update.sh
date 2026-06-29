#!/usr/bin/env bash
# shellcheck shell=bash

modules::update::run() {
  rtb_section "Update Everything"
  rtb_apt_update
  rtb_retry "${RTB_APT_RETRIES}" "update" sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
  modules::productivity::install_zsh_plugins
  modules::python::install_pipx_tools
  modules::go::install_tools
  rtb_success "Update completed."
}
