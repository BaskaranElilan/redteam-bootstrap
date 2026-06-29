#!/usr/bin/env bash
# shellcheck shell=bash

rtb_run() {
  local module=$1
  shift
  rtb_log "INFO" "${module}" "Running: $*"
  if [[ "${RTB_DRY_RUN}" == "1" ]]; then
    printf '%s[DRY-RUN]%s %s\n' "${RTB_MAGENTA}" "${RTB_RESET}" "$*"
    return 0
  fi
  if [[ "${RTB_VERBOSE}" == "1" ]]; then
    "$@"
  else
    "$@" >> "${RTB_LOG_FILE}" 2>&1
  fi
}

rtb_run_as_user() {
  local module=$1
  shift
  if [[ "${EUID}" -eq 0 && "${RTB_TARGET_USER}" != "root" ]]; then
    rtb_run "${module}" sudo -u "${RTB_TARGET_USER}" env HOME="${RTB_TARGET_HOME}" "$@"
  else
    rtb_run "${module}" "$@"
  fi
}

rtb_command_exists() {
  command -v "$1" >/dev/null 2>&1
}

rtb_ensure_dir() {
  local path=$1
  local owner=${2:-}
  rtb_run "filesystem" mkdir -p "${path}"
  if [[ -n "${owner}" && "${EUID}" -eq 0 ]]; then
    rtb_run "filesystem" chown -R "${owner}:${owner}" "${path}"
  fi
}

rtb_symlink_or_copy() {
  local source=$1
  local target=$2
  local module=${3:-filesystem}
  rtb_ensure_dir "$(dirname "${target}")" "${RTB_TARGET_USER}"
  if [[ -e "${target}" || -L "${target}" ]]; then
    rtb_backup_path "${target}"
    rtb_run "${module}" rm -rf "${target}"
  fi
  rtb_run "${module}" cp -R "${source}" "${target}"
  if [[ "${EUID}" -eq 0 ]]; then
    rtb_run "${module}" chown -R "${RTB_TARGET_USER}:${RTB_TARGET_USER}" "${target}"
  fi
}

rtb_append_once() {
  local file=$1
  local marker=$2
  local content=$3
  rtb_ensure_dir "$(dirname "${file}")" "${RTB_TARGET_USER}"
  if [[ ! -f "${file}" ]]; then
    rtb_run "filesystem" touch "${file}"
  fi
  if ! grep -Fq "${marker}" "${file}" 2>/dev/null; then
    if [[ "${RTB_DRY_RUN}" == "1" ]]; then
      printf '%s[DRY-RUN]%s append marker %s to %s\n' "${RTB_MAGENTA}" "${RTB_RESET}" "${marker}" "${file}"
    else
      printf '\n%s\n%s\n' "${marker}" "${content}" >> "${file}"
    fi
  fi
  if [[ "${EUID}" -eq 0 ]]; then
    rtb_run "filesystem" chown "${RTB_TARGET_USER}:${RTB_TARGET_USER}" "${file}"
  fi
}

rtb_retry() {
  local attempts=$1
  local module=$2
  shift 2
  local n=1
  until rtb_run "${module}" "$@"; do
    if ((n >= attempts)); then
      rtb_log "ERROR" "${module}" "Failed after ${attempts} attempts: $*"
      return 1
    fi
    rtb_warn "Attempt ${n}/${attempts} failed: $*"
    sleep $((n * 2))
    n=$((n + 1))
  done
}
