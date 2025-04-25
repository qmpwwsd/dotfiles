#!/bin/bash

source "$(dirname "$0")/env.sh"

install_or_update_tool() {
  local name="$1"
  local method="$2"
  local version="$3"
  local flags="$4"

  case "$method" in
    apt)
      if ! dpkg -s "$name" &>/dev/null; then
        echo "📦 Installing $name via APT..."
        sudo apt install -y "$name"
      else
        echo "✅ $name already installed (APT)"
      fi
      ;;
    snap)
      if ! snap list "$name" &>/dev/null; then
        echo "📦 Installing $name via Snap..."
        sudo snap install "$name" $flags
      else
        echo "🔁 Refreshing $name via Snap..."
        sudo snap refresh "$name"
      fi
      ;;
    brew)
      if ! command -v brew &>/dev/null; then
        echo "🍺 Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      fi

      if ! brew list "$name" &>/dev/null; then
        echo "🍺 Installing $name via Homebrew..."
        brew install "$name"
      else
        echo "🔁 Updating $name via Homebrew..."
        brew upgrade "$name"
      fi
      ;;
  esac
}

load_and_install() {
  local os="$1"
  local method="$2"
  local file="$PACKAGES_DIR/${os}/${method}.yaml"

  if [ -f "$file" ]; then
    local count=$(yq e '. | length' "$file")
    for i in $(seq 0 $((count - 1))); do
      name=$(yq e ".[$i].name" "$file")
      version=$(yq e ".[$i].version" "$file")
      flags=""
      [ "$method" = "snap" ] && [ "$(yq e ".[$i].classic" "$file")" = "true" ] && flags="--classic"

      install_or_update_tool "$name" "$method" "$version" "$flags"
    done
  fi

  # Download antigen to your dotfiles
  curl -L git.io/antigen > ~/dotfiles/home/.config/zsh/plugins/antigen.zsh
}
