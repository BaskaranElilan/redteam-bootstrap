#!/usr/bin/env bash
# shellcheck shell=bash

modules::go::run() {
  rtb_section "Go Environment"
  rtb_apt_update
  rtb_install_apt_packages "go" "${RTB_GO_APT_PACKAGES[@]}"
  modules::go::configure_environment
  modules::go::install_tools
  rtb_success "Go environment completed."
}

modules::go::configure_environment() {
  rtb_ensure_dir "${RTB_TARGET_HOME}/go/bin" "${RTB_TARGET_USER}"
  rtb_append_once "${RTB_TARGET_HOME}/.profile" "# redteam-bootstrap go environment" 'export GOPATH="${HOME}/go"
export PATH="${PATH}:${GOPATH}/bin"'
}

modules::go::install_tools() {
  rtb_command_exists go || {
    rtb_warn "go not found; skipping Go tools."
    return 0
  }
  local tool
  for tool in "${RTB_PROJECTDISCOVERY_GO_TOOLS[@]}" "${RTB_OTHER_GO_TOOLS[@]}"; do
    if [[ "${RTB_OFFLINE}" == "1" ]]; then
      rtb_warn "Offline mode enabled; skipping ${tool}."
      continue
    fi
    rtb_run_as_user "go" env GOPATH="${RTB_TARGET_HOME}/go" go install "${tool}"
  done
}
