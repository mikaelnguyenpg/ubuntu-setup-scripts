## Setup Guidance
sudo apt install -y build-essential curl wget git unzip software-properties-common ubuntu-restricted-extras
sudo apt install -y htop gparted net-tools
sudo apt install -y gnome-tweaks gnome-shell-extensions
sudo apt install -y ibus-unikey ibus-chewing
git config --global user.name "mikaelnguyenpg" && git config --global user.email "mikaelnguyen.pg@gmail.com"
ssh-keygen -t rsa -b 4096 -C "mikaelnguyenpg@gmail.com"
sudo apt install -y docker.io docker-compose && sudo usermod -aG docker $USER && reboot
sudo apt install -y zsh && sh -c "$(curl -fsSL https://raw.githubusercontent.com)"

# sudo apt install -y python3-pip python3-venv

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \. "$HOME/.nvm/nvm.sh" && nvm install 24 && node -v &&  npm -v

sudo apt install -y libwebkit2gtk-4.1-dev build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
npx create-tauri-app@latest

