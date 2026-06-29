#!/usr/bin/env bash
# shellcheck shell=bash

if [[ -t 1 ]]; then
  RTB_RESET=$'\033[0m'
  RTB_BOLD=$'\033[1m'
  RTB_DIM=$'\033[2m'
  RTB_RED=$'\033[31m'
  RTB_GREEN=$'\033[32m'
  RTB_YELLOW=$'\033[33m'
  RTB_BLUE=$'\033[34m'
  RTB_MAGENTA=$'\033[35m'
  RTB_CYAN=$'\033[36m'
else
  RTB_RESET=""
  RTB_BOLD=""
  RTB_DIM=""
  RTB_RED=""
  RTB_GREEN=""
  RTB_YELLOW=""
  RTB_BLUE=""
  RTB_MAGENTA=""
  RTB_CYAN=""
fi
