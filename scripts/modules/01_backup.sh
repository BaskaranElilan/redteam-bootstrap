#!/usr/bin/env bash
# shellcheck shell=bash

modules::backup::run() {
  rtb_section "Backup Configurations"
  rtb_backup_standard_configs
  rtb_success "Configuration backup pass completed."
}

modules::restore::run() {
  rtb_section "Restore Configurations"
  local latest
  latest="$(find "${RTB_BACKUP_DIR}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -n 1 || true)"
  [[ -n "${latest}" ]] || rtb_die "No backups found in ${RTB_BACKUP_DIR}."
  rtb_confirm "Restore latest backup ${latest} into / ?" || {
    rtb_warn "Restore cancelled."
    return 0
  }
  rtb_run "restore" sudo cp -a "${latest}/." /
  rtb_success "Restored latest backup: ${latest}"
}
