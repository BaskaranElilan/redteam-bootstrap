#!/usr/bin/env bash
# shellcheck shell=bash

modules::verify::run() {
  rtb_section "Verify Installation"
  local commands=(
    "git"
    "curl"
    "wget"
    "zsh"
    "tmux"
    "fzf"
    "batcat"
    "eza"
    "fd"
    "rg"
    "jq"
    "yq"
    "btop"
    "htop"
    "ranger"
    "lazygit"
    "docker"
    "go"
    "python3"
    "pipx"
    "rustc"
    "cargo"
    "nmap"
    "masscan"
    "amass"
    "ffuf"
    "feroxbuster"
    "gobuster"
    "nikto"
    "sqlmap"
    "hydra"
    "john"
    "hashcat"
    "responder"
    "evil-winrm"
    "netexec"
    "wireshark"
    "burpsuite"
    "naabu"
    "httpx"
    "subfinder"
    "nuclei"
    "katana"
  )
  local failed=0
  local command_name
  printf '%-28s %-6s %-45s %s\n' "COMMAND" "STATE" "LOCATION" "VERSION"
  for command_name in "${commands[@]}"; do
    rtb_verify_command "${command_name}" --version || failed=$((failed + 1))
  done
  if ((failed > 0)); then
    rtb_warn "Verification completed with ${failed} missing commands."
  else
    rtb_success "Verification completed successfully."
  fi
}
