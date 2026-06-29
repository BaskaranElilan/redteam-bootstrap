#!/usr/bin/env bash
# shellcheck shell=bash

rtb_banner() {
  cat <<'BANNER'
 ____          _   _____
|  _ \ ___  __| | |_   _|__  __ _ _ __ ___
| |_) / _ \/ _` |   | |/ _ \/ _` | '_ ` _ \
|  _ <  __/ (_| |   | |  __/ (_| | | | | | |
|_| \_\___|\__,_|   |_|\___|\__,_|_| |_| |_|

Workstation Bootstrap
BANNER
}

rtb_confirm() {
  local prompt=$1
  if [[ "${RTB_ASSUME_YES}" == "1" ]]; then
    return 0
  fi
  read -r -p "${prompt} [y/N]: " response
  [[ "${response}" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]
}

rtb_spinner() {
  local pid=$1
  local message=$2
  local spin='-\|/'
  local i=0
  printf '%s ' "${message}"
  while kill -0 "${pid}" 2>/dev/null; do
    i=$(((i + 1) % 4))
    printf '\r%s %s' "${message}" "${spin:${i}:1}"
    sleep 0.1
  done
  printf '\r%s done\n' "${message}"
}

rtb_progress_bar() {
  local current=$1
  local total=$2
  local label=${3:-Progress}
  local width=30
  local percent=$((current * 100 / total))
  local filled=$((current * width / total))
  local empty=$((width - filled))
  printf '\r%s [' "${label}"
  printf '%*s' "${filled}" '' | tr ' ' '#'
  printf '%*s' "${empty}" '' | tr ' ' '-'
  printf '] %s%%' "${percent}"
  if ((current == total)); then
    printf '\n'
  fi
}

rtb_finish_timer() {
  local end_time elapsed
  end_time=$(date +%s)
  elapsed=$((end_time - RTB_START_TIME))
  rtb_success "Completed in ${elapsed}s. Log: ${RTB_LOG_FILE}"
}
