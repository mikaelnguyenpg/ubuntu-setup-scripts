## Setup Guidance
sudo apt install -y build-essential curl wget git unzip software-properties-common ubuntu-restricted-extras # Install essences
sudo apt install -y htop gparted net-tools
sudo apt install -y gnome-tweaks gnome-shell-extensions # Install gnome
sudo apt install -y ibus-unikey ibus-chewing # Install keyboards
git config --global user.name "mikaelnguyenpg" && git config --global user.email "mikaelnguyen.pg@gmail.com"
ssh-keygen -t rsa -b 4096 -C "mikaelnguyenpg@gmail.com"

# 3. Cài đặt Flatpak (để cài các App GUI sandbox)
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org

# 4. Cài đặt Podman (Ưu tiên cho Distrobox vì tính năng Rootless)
sudo apt install -y podman

# 5. Cài đặt Docker (Nếu cần cho dự án công ty)
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER  && reboot # Thêm michael vào nhóm docker (cần logout/login để có hiệu lực)

# 6. Cài đặt Distrobox
sudo apt install -y distrobox

# 7. Cài đặt Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
nix --version
nix run nixpkgs#hello
nix run home-manager/master -- init ~/.config/home-manager
nix run home-manager/master -- switch --flake ~/.config/home-manager

# new flake.nix + .envrc("use flake")
direnv allow / direnv deny

home-manager switch: Cập nhật các phần mềm cá nhân và cấu hình dotfiles.
nix flake update: Cập nhật phiên bản các phần mềm trong dự án lên bản mới nhất.
nix-collect-garbage -d: Dọn dẹp các phiên bản cũ, giải phóng ổ cứng (rất quan trọng vì Nix lưu nhiều bản backup).


# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \. "$HOME/.nvm/nvm.sh" && nvm install 24 && node -v &&  npm -v

# sudo apt install -y libwebkit2gtk-4.1-dev build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev # Install essences for Tauri
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Install rust
# npx create-tauri-app@latest

