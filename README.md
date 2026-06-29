# Red Team Workstation Bootstrap

Production-grade Kali Linux workstation bootstrap for authorized red team, security lab, and DevSecOps environments.

This project turns a fresh Kali installation into a repeatable workstation with modern terminal tooling, shell configuration, i3 window manager assets, Docker, Go, Python, fonts, backups, logging, verification, and a curated set of security tools.

## Features

- Interactive menu and command mode.
- Idempotent module design.
- Strict Bash mode with traps and centralized logging.
- Kali-first OS detection with best-effort Debian 12 and Ubuntu 24.04 support.
- Dry-run, verbose, offline, repair, update, backup, restore, and uninstall modes.
- Production-oriented dotfiles for zsh, tmux, i3, polybar, rofi, picom, dunst, kitty, and alacritty.
- Tool verification with PASS, FAIL, version, and location output.
- Basic CI tests for structure, syntax, and configuration contracts.

## Safety And Scope

Use this project only on systems you own or are explicitly authorized to administer. It installs security tools but does not include exploit code, payload logic, credential theft automation, or target-specific offensive workflows.

The installer prefers official repositories. It avoids piping remote shell scripts into Bash. GitHub clones are used for well-known shell plugins and Go tool installation uses `go install` from upstream module paths.

## Supported OS

- Primary: Kali Linux latest.
- Optional best effort: Debian 12, Ubuntu 24.04 and newer 24.x/25.x releases listed in `config.sh`.

Unsupported operating systems exit with a friendly message.

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/BaskaranElilan/redteam-bootstrap.git
cd redteam-bootstrap
chmod +x install.sh tests/*.sh configs/polybar/launch.sh
./install.sh
```

Run the full install non-interactively:

```bash
./install.sh --yes full
```

Preview changes:

```bash
./install.sh --dry-run full
```

Increase output:

```bash
./install.sh --verbose full
```

Use cached assets only:

```bash
./install.sh --offline full
```

## Menu

```text
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
```

## Command Mode

```bash
./install.sh productivity
./install.sh cli
./install.sh shell
./install.sh window-manager
./install.sh redteam
./install.sh docker
./install.sh go
./install.sh python
./install.sh fonts
./install.sh backup
./install.sh restore
./install.sh verify
./install.sh update
./install.sh repair
./install.sh uninstall
```

## Directory Structure

```text
redteam-bootstrap/
  install.sh
  config.sh
  README.md
  LICENSE
  CHANGELOG.md
  VERSION
  logs/
  backups/
  configs/
  scripts/
    lib/
    modules/
  assets/
  wallpapers/
  fonts/
  docs/
  templates/
  tests/
  .github/workflows/
```

The installer also creates:

```text
~/RedTeam/
  Clients/
  Engagements/
  Loot/
  Evidence/
  Payloads/
  Reports/
  Notes/
  Wordlists/
  Tools/
  Scripts/
  Docker/
  Labs/
  Malware/
  OSINT/
  Infrastructure/
  Templates/
```

## Logging

Every module writes to:

```text
logs/install.log
```

Entries include timestamp, severity, module, and message.

## Backups

Before replacing managed configuration, backups are stored under:

```text
backups/
```

The backup module covers `.zshrc`, `.tmux.conf`, and supported `.config` directories.

## Testing

Run all tests:

```bash
bash tests/run_all.sh
```

Run individual checks:

```bash
bash tests/test_structure.sh
bash tests/test_syntax.sh
bash tests/test_config_contracts.sh
```

If ShellCheck is available, `tests/run_all.sh` runs it automatically.

## Screenshots

Add screenshots after installing on a reference Kali VM:

- `docs/screenshots/menu.png`
- `docs/screenshots/i3-desktop.png`
- `docs/screenshots/tmux.png`
- `docs/screenshots/verify.png`

## Troubleshooting

Check logs first:

```bash
less logs/install.log
```

Re-run missing or failed components:

```bash
./install.sh repair
```

Verify installed commands:

```bash
./install.sh verify
```

If Docker group changes do not apply, log out and log back in.

## Contributing

Keep modules single-purpose. Add shared behavior to `scripts/lib/` only when at least two modules need it. Add tests for new module contracts and update documentation when commands, paths, or safety behavior changes.

## License

MIT. See `LICENSE`.
