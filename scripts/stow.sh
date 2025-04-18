#!/bin/bash

source "$(dirname "$0")/env.sh"

echo "🔗 Symlinking dotfiles..."

stow -d "$HOME_DIR" -t "$HOME" .
stow -d "$CONFIG_DIR" -t "$HOME/.config" .

echo "✅ Dotfiles linked."
