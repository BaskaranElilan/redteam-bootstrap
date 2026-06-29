#!/usr/bin/env bash
# shellcheck shell=bash

modules::docker::run() {
  rtb_section "Docker"
  rtb_apt_update
  rtb_install_apt_packages "docker" "${RTB_DOCKER_APT_PACKAGES[@]}"
  rtb_enable_service docker
  modules::docker::add_user_to_group
  modules::docker::pull_security_containers
  rtb_success "Docker installation completed. Log out and back in for group membership to apply."
}

modules::docker::add_user_to_group() {
  if id -nG "${RTB_TARGET_USER}" | tr ' ' '\n' | grep -qx docker; then
    rtb_success "${RTB_TARGET_USER} is already in docker group."
  else
    rtb_run "docker" sudo usermod -aG docker "${RTB_TARGET_USER}"
  fi
}

modules::docker::pull_security_containers() {
  rtb_command_exists docker || {
    rtb_warn "docker not found; skipping container pulls."
    return 0
  }
  if [[ "${RTB_OFFLINE}" == "1" ]]; then
    rtb_warn "Offline mode enabled; skipping container pulls."
    return 0
  fi
  local image
  for image in "${RTB_SECURITY_CONTAINERS[@]}"; do
    rtb_run "docker" sudo docker pull "${image}"
  done
}
