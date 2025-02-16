cd ~/.config && pwd

# Nix: Install
if ! command -v nix >/dev/null 2>&1; then
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
else
  echo " - Nix already exists"
fi

# Nix: Enable experimental features
if [ ! -f nix/nix.conf ]; then
  sudo mkdir -p nix
  echo "experimental-features = nix-command flakes" | sudo tee -a nix/nix.conf
else
  echo " - nix.conf already exists"
fi

# Nix: Install Home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
if [ ! -f home-manager/home.nix ]; then
  nix-shell '<home-manager>' -A install
else
  echo " - home-manager/home.nix already exists"
fi

# Nix: Generate flake.nix & home.nix
home-manager init
# wget https://gist.github.com/mikaelnguyenpg/73b0b6ff679f44bea01e075b8aa7eb92/raw -O home-manager/home.nix
cp ~/.config/ubuntu-setup-scripts/home.nix ~/.config/home-manager/home.nix
# sed -i "s/eagle/$1/g" home-manager/home.nix

# Nix: Setup system
home-manager build
home-manager switch
