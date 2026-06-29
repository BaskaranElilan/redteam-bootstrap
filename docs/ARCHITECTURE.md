# Architecture

## Design Goals

The project is organized as a maintainable Bash application rather than one large script. The entrypoint parses flags, performs bootstrap checks, loads shared libraries, loads modules, and dispatches to either the interactive menu or a command.

Core goals:

- Safe reruns.
- Clear logs.
- Centralized package and download handling.
- Single-responsibility modules.
- No hidden remote shell execution.
- Minimal assumptions about the target user.

## Main Flow

1. `install.sh` parses arguments.
2. `config.sh` defines version, paths, package lists, and feature flags.
3. `scripts/lib/bootstrap.sh` loads all shared libraries and modules.
4. Bootstrap detects the target user, OS, sudo access, and log path.
5. The selected command runs one or more `modules::<name>::run` functions.
6. Verification reports installed tool status.

## Shared Libraries

- `colors.sh`: terminal color variables.
- `logging.sh`: timestamped log and console helpers.
- `ui.sh`: banner, confirmation, spinner, progress bar, timer.
- `os.sh`: OS and target-user detection.
- `utils.sh`: dry-run aware command execution, retry, directory helpers.
- `packages.sh`: APT update, APT install, service enablement.
- `backup.sh`: project backup functions.
- `download.sh`: retrying downloads and optional SHA256 verification.
- `verify.sh`: command verification output.

## Modules

- `00_directories.sh`: creates `~/RedTeam`.
- `01_backup.sh`: backup and restore.
- `02_productivity.sh`: productivity packages, Oh My Zsh plugin dependencies.
- `03_modern_cli.sh`: modern CLI tools when available from APT.
- `04_shell.sh`: Oh My Zsh and `.zshrc`.
- `05_tmux.sh`: TPM and `.tmux.conf`.
- `06_window_manager.sh`: i3 ecosystem and configuration deployment.
- `07_python.sh`: Python, pipx, poetry, NetExec.
- `08_go.sh`: Go environment and Go tools.
- `09_docker.sh`: Docker service, group membership, container pulls.
- `10_fonts.sh`: Nerd Fonts.
- `11_redteam.sh`: security tooling from configured repositories.
- `12_update.sh`: package and managed-tool updates.
- `13_verify.sh`: installation verification.
- `14_repair.sh`: reruns critical modules in repair mode.
- `15_uninstall.sh`: removes project-managed config files after backup.

## Idempotency Model

APT packages are skipped when installed. Git repositories are pulled when present and cloned when missing. Configuration files are backed up before replacement. Directories are created with `mkdir -p`.

## Safety Model

The installer exits on unsupported operating systems. Remote shell execution is intentionally avoided. Downloads support SHA256 verification when checksums are available, and warnings are logged when no checksum is configured.
