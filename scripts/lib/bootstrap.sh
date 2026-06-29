#!/usr/bin/env bash
# shellcheck shell=bash

# shellcheck source=scripts/lib/colors.sh
source "${RTB_LIB_DIR}/colors.sh"
# shellcheck source=scripts/lib/logging.sh
source "${RTB_LIB_DIR}/logging.sh"
# shellcheck source=scripts/lib/ui.sh
source "${RTB_LIB_DIR}/ui.sh"
# shellcheck source=scripts/lib/os.sh
source "${RTB_LIB_DIR}/os.sh"
# shellcheck source=scripts/lib/utils.sh
source "${RTB_LIB_DIR}/utils.sh"
# shellcheck source=scripts/lib/packages.sh
source "${RTB_LIB_DIR}/packages.sh"
# shellcheck source=scripts/lib/backup.sh
source "${RTB_LIB_DIR}/backup.sh"
# shellcheck source=scripts/lib/download.sh
source "${RTB_LIB_DIR}/download.sh"
# shellcheck source=scripts/lib/verify.sh
source "${RTB_LIB_DIR}/verify.sh"

for module in "${RTB_MODULE_DIR}"/*.sh; do
  # shellcheck source=/dev/null
  source "${module}"
done

rtb_on_error() {
  local exit_code=$?
  local line_no=${1:-unknown}
  rtb_log "ERROR" "bootstrap" "Command failed at line ${line_no} with exit code ${exit_code}."
  rtb_error "Installation stopped at line ${line_no}. See ${RTB_LOG_FILE}."
  exit "${exit_code}"
}

rtb_bootstrap() {
  trap 'rtb_on_error "${LINENO}"' ERR
  mkdir -p "${RTB_LOG_DIR}" "${RTB_BACKUP_DIR}" "${RTB_CACHE_DIR}"
  : > "${RTB_LOG_FILE}"
  RTB_START_TIME=$(date +%s)
  export RTB_DRY_RUN RTB_VERBOSE RTB_OFFLINE RTB_ASSUME_YES RTB_REPAIR_MODE RTB_START_TIME
  rtb_detect_target_user
  rtb_require_bash
  rtb_detect_os
  rtb_require_supported_os
  rtb_require_sudo
  rtb_log "INFO" "bootstrap" "Started ${RTB_PROJECT_NAME} ${RTB_VERSION} for ${RTB_TARGET_USER} on ${RTB_OS_PRETTY_NAME}."
}
