#!/usr/bin/env bash
# shellcheck shell=bash

modules::directories::run() {
  rtb_section "Red Team Directory Structure"
  local root="${RTB_TARGET_HOME}/${RTB_REDTEAM_ROOT_NAME}"
  local dir
  rtb_ensure_dir "${root}" "${RTB_TARGET_USER}"
  for dir in "${RTB_REDTEAM_DIRS[@]}"; do
    rtb_ensure_dir "${root}/${dir}" "${RTB_TARGET_USER}"
  done
  rtb_success "Created workstation directories under ${root}."
}
