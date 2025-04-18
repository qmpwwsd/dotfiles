#!/bin/bash
set -e

source "$(dirname "$0")/env.sh"
source "$SCRIPTS_DIR/install_tools.sh"

echo "🚀 Setting up your system..."

OS=$(uname | tr '[:upper:]' '[:lower:]')

for method in apt snap brew; do
  load_and_install "$OS" "$method"
done

# Install dev environments
"$SCRIPTS_DIR/install_dev_envs.sh"

# Link dotfiles
"$SCRIPTS_DIR/stow.sh"

echo "🎉 Setup complete!"
