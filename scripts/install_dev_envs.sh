#!/bin/bash
set -e

source "$(dirname "$0")/env.sh"

echo "🔧 Installing asdf version manager..."

# Install asdf if not already installed
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.16.0
fi

# Add to shell config if missing
if ! grep -q 'asdf.sh' "$HOME/.zshrc"; then
  echo -e '\n. "$HOME/.asdf/asdf.sh"' >> "$HOME/.zshrc"
  echo '. "$HOME/.asdf/completions/asdf.bash"' >> "$HOME/.zshrc"
fi

sudo apt update && sudo apt install -y \
  libbz2-dev \
  libreadline-dev \
  libssl-dev \
  libncursesw5-dev \
  libsqlite3-dev \
  libffi-dev \
  zlib1g-dev \
  liblzma-dev \
  tk-dev \
  uuid-dev \
  build-essential

# Source for current session
. "$HOME/.asdf/asdf.sh"

echo "📦 Installing language environments via asdf..."

# Check if .tool-versions exists in dotfiles/home/
if [ ! -f "$HOME/.tool-versions" ]; then
  echo "⚠️ .tool-versions file not found in $HOME, aborting."
  exit 1
fi

# Declare tools and versions based on .tool-versions
while IFS=" " read -r plugin version; do
  if [ -n "$plugin" ] && [ -n "$version" ]; then
    # Add plugin if not already present
    if ! asdf plugin list | grep -q "^$plugin$"; then
      echo "➕ Adding plugin: $plugin"
      asdf plugin add "$plugin"
    fi

    echo "⬇️ Installing $plugin $version"
    asdf install "$plugin" "$version"
    asdf global "$plugin" "$version"
  fi
done < "$HOME/.tool-versions"

echo "✅ Development environments are set up!"
