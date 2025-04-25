#!/bin/bash

source "$(dirname "$0")/env.sh"

echo "🔗 Symlinking dotfiles..."

cd "$DOTFILES_ROOT"
stow -v --adopt -d "$DOTFILES_ROOT" -t "$HOME" home

echo "✅ Dotfiles linked."
