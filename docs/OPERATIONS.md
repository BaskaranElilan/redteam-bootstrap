# Operations Guide

## First Run

Run from a fresh Kali installation:

```bash
chmod +x install.sh tests/*.sh configs/polybar/launch.sh
./install.sh --yes full
```

After completion, log out and back in if Docker group membership or default shell changes were applied.

## Dry Run

```bash
./install.sh --dry-run full
```

Dry-run mode logs intended actions without making changes.

## Offline Mode

```bash
./install.sh --offline full
```

Offline mode skips network package updates, Git clones, Go installs, Docker pulls, and downloads unless cached files are already present.

## Repair Mode

```bash
./install.sh repair
```

Repair mode reruns core workstation setup and verification. It is useful after a failed install or manual package removal.

## Updating

```bash
./install.sh update
```

This updates APT packages and refreshes managed plugin and language-tool installations.

## Restoring Backups

```bash
./install.sh restore
```

The restore command copies the latest backup snapshot back to `/`. Review `backups/` before restoring on shared systems.

## Extending Modules

Add a new module under `scripts/modules/NN_name.sh`:

```bash
#!/usr/bin/env bash
# shellcheck shell=bash

modules::name::run() {
  rtb_section "Name"
  rtb_success "Name completed."
}
```

Then add it to `install.sh` menu or command dispatch.

## Adding Packages

Prefer appending to package arrays in `config.sh`. If a package is only available on Kali, detect availability with `apt-cache show` in the module before installing.

## Logs

The primary log is:

```text
logs/install.log
```

Use verbose mode to stream command output to the terminal:

```bash
./install.sh --verbose full
```
