#!/usr/bin/env bash
# shellcheck shell=bash

RTB_VERSION="1.0.0"
RTB_PROJECT_NAME="Red Team Workstation Bootstrap"
RTB_PROJECT_SLUG="redteam-bootstrap"

RTB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTB_LOG_DIR="${RTB_ROOT}/logs"
RTB_BACKUP_DIR="${RTB_ROOT}/backups"
RTB_CONFIG_DIR="${RTB_ROOT}/configs"
RTB_SCRIPT_DIR="${RTB_ROOT}/scripts"
RTB_MODULE_DIR="${RTB_SCRIPT_DIR}/modules"
RTB_LIB_DIR="${RTB_SCRIPT_DIR}/lib"
RTB_TEMPLATE_DIR="${RTB_ROOT}/templates"
RTB_ASSET_DIR="${RTB_ROOT}/assets"
RTB_FONT_DIR="${RTB_ROOT}/fonts"
RTB_CACHE_DIR="${RTB_ROOT}/.cache"

RTB_LOG_FILE="${RTB_LOG_DIR}/install.log"
RTB_STATE_FILE="${RTB_CACHE_DIR}/state.env"

RTB_SUPPORTED_IDS=("kali" "debian" "ubuntu")
RTB_SUPPORTED_VERSIONS_DEBIAN=("12")
RTB_SUPPORTED_VERSIONS_UBUNTU=("24.04" "24.10" "25.04")

RTB_DEFAULT_OWNER="${SUDO_USER:-${USER:-}}"
RTB_TARGET_USER="${RTB_TARGET_USER:-${RTB_DEFAULT_OWNER}}"
RTB_TARGET_HOME="${RTB_TARGET_HOME:-}"

RTB_DRY_RUN="${RTB_DRY_RUN:-0}"
RTB_VERBOSE="${RTB_VERBOSE:-0}"
RTB_OFFLINE="${RTB_OFFLINE:-0}"
RTB_ASSUME_YES="${RTB_ASSUME_YES:-0}"
RTB_REPAIR_MODE="${RTB_REPAIR_MODE:-0}"

RTB_APT_RETRIES="${RTB_APT_RETRIES:-3}"
RTB_DOWNLOAD_RETRIES="${RTB_DOWNLOAD_RETRIES:-3}"
RTB_NETWORK_TIMEOUT="${RTB_NETWORK_TIMEOUT:-30}"

RTB_REDTEAM_ROOT_NAME="RedTeam"
RTB_REDTEAM_DIRS=(
  "Clients"
  "Engagements"
  "Loot"
  "Evidence"
  "Payloads"
  "Reports"
  "Notes"
  "Wordlists"
  "Tools"
  "Scripts"
  "Docker"
  "Labs"
  "Malware"
  "OSINT"
  "Infrastructure"
  "Templates"
)

RTB_PRODUCTIVITY_APT_PACKAGES=(
  "tmux"
  "kitty"
  "alacritty"
  "zsh"
  "fzf"
  "bat"
  "fd-find"
  "ripgrep"
  "jq"
  "btop"
  "htop"
  "tree"
  "tldr"
  "ranger"
  "lazygit"
  "ncdu"
  "xclip"
  "wl-clipboard"
  "ripgrep-all"
  "git"
  "curl"
  "wget"
  "zoxide"
  "direnv"
  "starship"
  "unzip"
  "zip"
  "ca-certificates"
  "gnupg"
  "lsb-release"
  "software-properties-common"
)

RTB_MODERN_CLI_APT_PACKAGES=(
  "eza"
  "duf"
  "dust"
  "yq"
)

RTB_WM_APT_PACKAGES=(
  "i3"
  "sxhkd"
  "polybar"
  "picom"
  "rofi"
  "feh"
  "dunst"
  "flameshot"
  "nitrogen"
  "xss-lock"
  "lightdm"
)

RTB_REDTEAM_APT_PACKAGES=(
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
  "impacket-scripts"
  "evil-winrm"
  "ldapdomaindump"
  "enum4linux-ng"
  "smbmap"
  "wireshark"
  "burpsuite"
  "seclists"
  "wordlists"
  "neo4j"
  "bloodhound"
)

RTB_PYTHON_APT_PACKAGES=(
  "python3"
  "python3-pip"
  "python3-venv"
  "pipx"
  "pipenv"
  "python3-virtualenv"
)

RTB_GO_APT_PACKAGES=("golang-go")
RTB_RUST_APT_PACKAGES=("rustc" "cargo")

RTB_DOCKER_APT_PACKAGES=(
  "docker.io"
  "docker-compose-plugin"
)

RTB_PROJECTDISCOVERY_GO_TOOLS=(
  "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
  "github.com/projectdiscovery/httpx/cmd/httpx@latest"
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
  "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
  "github.com/projectdiscovery/katana/cmd/katana@latest"
)

RTB_OTHER_GO_TOOLS=(
  "github.com/tomnomnom/assetfinder@latest"
  "github.com/RustScan/RustScan@latest"
)

RTB_PIPX_TOOLS=(
  "poetry"
  "netexec"
)

RTB_SECURITY_CONTAINERS=(
  "carlospolop/peass-ng"
  "projectdiscovery/nuclei"
  "instrumentisto/nmap"
)
