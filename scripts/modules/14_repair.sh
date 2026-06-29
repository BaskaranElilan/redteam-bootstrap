#!/usr/bin/env bash
# shellcheck shell=bash

modules::repair::run() {
  rtb_section "Repair Mode"
  RTB_REPAIR_MODE=1
  modules::directories::run
  modules::productivity::run
  modules::modern_cli::run
  modules::shell::run
  modules::tmux::run
  modules::python::run
  modules::go::run
  modules::verify::run
  rtb_success "Repair mode completed."
}
