#!/usr/bin/env bash
# shellcheck shell=bash

rtb_download() {
  local url=$1
  local output=$2
  local sha256=${3:-}
  local module=${4:-download}
  if [[ "${RTB_OFFLINE}" == "1" ]]; then
    [[ -f "${output}" ]] || rtb_die "Offline mode: cached file missing: ${output}"
    return 0
  fi
  rtb_ensure_dir "$(dirname "${output}")"
  if [[ -f "${output}" && -n "${sha256}" ]]; then
    if printf '%s  %s\n' "${sha256}" "${output}" | sha256sum -c - >/dev/null 2>&1; then
      rtb_success "${module}: cached download verified: ${output}"
      return 0
    fi
  elif [[ -f "${output}" ]]; then
    rtb_success "${module}: using cached download: ${output}"
    return 0
  fi
  rtb_retry "${RTB_DOWNLOAD_RETRIES}" "${module}" curl -fsSL --connect-timeout "${RTB_NETWORK_TIMEOUT}" --retry 3 -o "${output}" "${url}"
  if [[ -n "${sha256}" ]]; then
    printf '%s  %s\n' "${sha256}" "${output}" | sha256sum -c - >/dev/null
  else
    rtb_warn "${module}: no SHA256 was provided for ${url}; source trust relies on TLS and package origin."
  fi
}
