#!/usr/bin/env bash
# shellcheck shell=bash

rtb_timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

rtb_log() {
  local level=$1
  local module=$2
  local message=$3
  mkdir -p "${RTB_LOG_DIR}"
  printf '[%s] [%s] [%s] %s\n' "$(rtb_timestamp)" "${level}" "${module}" "${message}" >> "${RTB_LOG_FILE}"
}

rtb_info() {
  printf '%s[INFO]%s %s\n' "${RTB_BLUE}" "${RTB_RESET}" "$*"
  rtb_log "INFO" "console" "$*"
}

rtb_success() {
  printf '%s[PASS]%s %s\n' "${RTB_GREEN}" "${RTB_RESET}" "$*"
  rtb_log "SUCCESS" "console" "$*"
}

rtb_warn() {
  printf '%s[WARN]%s %s\n' "${RTB_YELLOW}" "${RTB_RESET}" "$*"
  rtb_log "WARN" "console" "$*"
}

rtb_error() {
  printf '%s[FAIL]%s %s\n' "${RTB_RED}" "${RTB_RESET}" "$*" >&2
  rtb_log "ERROR" "console" "$*"
}

rtb_die() {
  rtb_error "$*"
  exit 1
}

rtb_section() {
  local title=$1
  printf '\n%s==> %s%s\n' "${RTB_BOLD}${RTB_CYAN}" "${title}" "${RTB_RESET}"
  rtb_log "INFO" "section" "Starting ${title}"
}
