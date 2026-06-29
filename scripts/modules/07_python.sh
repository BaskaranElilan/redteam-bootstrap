#!/usr/bin/env bash
# shellcheck shell=bash

modules::python::run() {
  rtb_section "Python Environment"
  rtb_apt_update
  rtb_install_apt_packages "python" "${RTB_PYTHON_APT_PACKAGES[@]}"
  modules::python::ensure_pipx_path
  modules::python::install_pipx_tools
  rtb_success "Python environment completed."
}

modules::python::ensure_pipx_path() {
  if rtb_command_exists pipx; then
    rtb_run_as_user "python" pipx ensurepath
  fi
}

modules::python::install_pipx_tools() {
  rtb_command_exists pipx || {
    rtb_warn "pipx not found; skipping pipx tools."
    return 0
  }
  local tool
  for tool in "${RTB_PIPX_TOOLS[@]}"; do
    if rtb_run_as_user "python" pipx list | grep -q "package ${tool} "; then
      rtb_run_as_user "python" pipx upgrade "${tool}"
    else
      rtb_run_as_user "python" pipx install "${tool}"
    fi
  done
}
