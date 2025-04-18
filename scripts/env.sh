#!/bin/bash

# Resolve absolute paths
export DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HOME_DIR="$DOTFILES_ROOT/home"
export CONFIG_DIR="$HOME_DIR/.config"
export SCRIPTS_DIR="$DOTFILES_ROOT/scripts"
export PACKAGES_DIR="$DOTFILES_ROOT/packages"
