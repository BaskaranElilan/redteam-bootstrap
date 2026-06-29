#!/usr/bin/env bash
# shellcheck shell=bash

set -Eeuo pipefail
IFS=$'\n\t'

RTB_ENTRYPOINT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${RTB_ENTRYPOINT_DIR}/config.sh"
# shellcheck source=scripts/lib/bootstrap.sh
source "${RTB_LIB_DIR}/bootstrap.sh"

usage() {
  cat <<USAGE
${RTB_PROJECT_NAME} ${RTB_VERSION}

Usage:
  ./install.sh [options] [command]

Commands:
  full                 Run the complete workstation bootstrap.
  productivity         Install productivity tools.
  cli                  Install modern CLI tools.
  shell                Configure zsh, Oh My Zsh, plugins, prompt, aliases.
  window-manager       Install and configure i3, polybar, rofi, picom, dunst.
  redteam              Install red team tools.
  docker               Install Docker and useful containers.
  go                   Install Go tooling and Go-based tools.
  python               Install Python tooling.
  fonts                Install Nerd Fonts.
  backup               Backup workstation configuration.
  restore              Restore latest workstation backup.
  verify               Verify installed tools.
  update               Update OS packages and managed tools.
  repair               Re-run checks and reinstall missing components.
  uninstall            Remove project-managed files after confirmation.
  menu                 Show the interactive menu. Default.

Options:
  -y, --yes            Assume yes for prompts.
  -n, --dry-run        Print actions without changing the system.
  -v, --verbose        Show command output.
  --offline            Use cached assets only where possible.
  -h, --help           Show this help.
USAGE
}

parse_args() {
  RTB_COMMAND="menu"
  while (($#)); do
    case "$1" in
      -y|--yes)
        RTB_ASSUME_YES=1
        ;;
      -n|--dry-run)
        RTB_DRY_RUN=1
        ;;
      -v|--verbose)
        RTB_VERBOSE=1
        ;;
      --offline)
        RTB_OFFLINE=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      full|productivity|cli|shell|window-manager|redteam|docker|go|python|fonts|backup|restore|verify|update|repair|uninstall|menu)
        RTB_COMMAND="$1"
        ;;
      *)
        rtb_die "Unknown argument: $1"
        ;;
    esac
    shift
  done
}

run_full_installation() {
  rtb_section "Full Installation"
  modules::directories::run
  modules::backup::run
  modules::productivity::run
  modules::modern_cli::run
  modules::shell::run
  modules::tmux::run
  modules::window_manager::run
  modules::python::run
  modules::go::run
  modules::docker::run
  modules::fonts::run
  modules::redteam::run
  modules::verify::run
  rtb_success "Full installation completed."
}

run_command() {
  case "${RTB_COMMAND}" in
    full) run_full_installation ;;
    productivity) modules::productivity::run ;;
    cli) modules::modern_cli::run ;;
    shell) modules::shell::run ;;
    window-manager) modules::window_manager::run ;;
    redteam) modules::redteam::run ;;
    docker) modules::docker::run ;;
    go) modules::go::run ;;
    python) modules::python::run ;;
    fonts) modules::fonts::run ;;
    backup) modules::backup::run ;;
    restore) modules::restore::run ;;
    verify) modules::verify::run ;;
    update) modules::update::run ;;
    repair) RTB_REPAIR_MODE=1 modules::repair::run ;;
    uninstall) modules::uninstall::run ;;
    menu) show_menu ;;
    *) rtb_die "Unhandled command: ${RTB_COMMAND}" ;;
  esac
}

show_menu() {
  while true; do
    clear || true
    rtb_banner
    cat <<MENU
========================================
${RTB_PROJECT_NAME}
========================================

1  Full Installation
2  Productivity Tools
3  Modern CLI Tools
4  Shell Configuration
5  Window Manager
6  Red Team Tools
7  Docker
8  Go Environment
9  Python Environment
10 Fonts
11 Backup Configurations
12 Restore Configurations
13 Verify Installation
14 Update Everything
15 Repair Mode
16 Uninstall Project Files
0  Exit

MENU
    read -r -p "Select an option: " choice
    case "${choice}" in
      1) run_full_installation ;;
      2) modules::productivity::run ;;
      3) modules::modern_cli::run ;;
      4) modules::shell::run ;;
      5) modules::window_manager::run ;;
      6) modules::redteam::run ;;
      7) modules::docker::run ;;
      8) modules::go::run ;;
      9) modules::python::run ;;
      10) modules::fonts::run ;;
      11) modules::backup::run ;;
      12) modules::restore::run ;;
      13) modules::verify::run ;;
      14) modules::update::run ;;
      15) RTB_REPAIR_MODE=1 modules::repair::run ;;
      16) modules::uninstall::run ;;
      0) rtb_info "Goodbye."; exit 0 ;;
      *) rtb_warn "Invalid selection: ${choice}" ;;
    esac
    echo
    read -r -p "Press Enter to continue..." _
  done
}

main() {
  parse_args "$@"
  rtb_bootstrap
  run_command
  rtb_finish_timer
}

main "$@"
