#!/usr/bin/env bash
# shellcheck shell=bash

rtb_verify_command() {
  local command_name=$1
  local version_arg=${2:---version}
  local location version
  if location="$(command -v "${command_name}" 2>/dev/null)"; then
    version="$("${command_name}" "${version_arg}" 2>&1 | head -n 1 || true)"
    printf '%-28s %sPASS%s %-45s %s\n' "${command_name}" "${RTB_GREEN}" "${RTB_RESET}" "${location}" "${version}"
    rtb_log "SUCCESS" "verify" "${command_name}: ${location}: ${version}"
    return 0
  fi
  printf '%-28s %sFAIL%s\n' "${command_name}" "${RTB_RED}" "${RTB_RESET}"
  rtb_log "ERROR" "verify" "${command_name}: missing"
  return 1
}
