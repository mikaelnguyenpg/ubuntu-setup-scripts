{ config, pkgs, lib, ... }:

# =============================================================================
#                                 PREAMBLE
# =============================================================================
let
  # Constants and external resources
  constants = import ./constants.nix { inherit config pkgs lib; };

  # ---------------------------------------------------------------------------
  # PACKAGE SETS DEFINITION
  # https://github.com/agarrharr/awesome-cli-apps?tab=readme-ov-file#music
  # ---------------------------------------------------------------------------
  packages = with pkgs; rec {
    # ────────────────────────────────────────────────────────────────
    # 1. Core CLI & productivity tools (luôn dùng hàng ngày)
    # ────────────────────────────────────────────────────────────────
    coreCli = [
      delta          # diff đẹp hơn
      jq             # xử lý JSON
      httpie         # curl thân thiện
      tldr           # hướng dẫn lệnh ngắn gọn
      lsd            # ls đẹp hơn
      xclip          # clipboard CLI

      duf
      ncdu
    ];

    nerdFonts = [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.comic-shanns-mono
      nerd-fonts.symbols-only # (Tùy chọn) Thêm các symbol bổ trợ
    ];

    dockerTools = [
      docker-compose # Bản plugin hỗ trợ docker tốt hơn
      docker-slim    # Giúp bạn soi và tối ưu các Image build ra
      lazydocker     # Giao diện TUI quản lý container
    ];

    qemuTools = [
      qemu        # Phiên bản QEMU mới nhất từ Nix
      quickemu    # Tool cực hay để tạo nhanh máy ảo Linux/Windows/macOS
      virt-viewer # Để xem màn hình máy ảo
      # IMPORTANT: MÁY ẢO cần cài thêm
      # `sudo apt install spice-vdagent`
      # `sudo systemctl restart spice-vdagent`
      # Hoặc download `spice-guest-tools-latest.exe` từ `https://www.spice-space.org/download/binaries/spice-guest-tools/`
    ];

    # ────────────────────────────────────────────────────────────────
    # 2. Fun / terminal eye-candy (không cần thiết nhưng vui)
    # ────────────────────────────────────────────────────────────────
    funTerminal = [
      cmatrix
      cowsay
      figlet
      fortune
      boxes
      neofetch
      btop
      gotop
      gtop
    ];

    # ────────────────────────────────────────────────────────────────
    # 3. Editors / IDEs / code editors
    # ────────────────────────────────────────────────────────────────
    editors = [
      # jetbrains.webstorm
    ];

    # ────────────────────────────────────────────────────────────────
    # 4. Development tools (Node, Rust, Python, C++, etc.)
    # ────────────────────────────────────────────────────────────────
    dev = [
      # Node ecosystem
      # bun
      # deno
      # nodePackages.nodejs
      # yarn
      # vite
      # typescript
      # eslint
      # vscode-js-debug

      # Python
      uv

      # Rust
      # rustup
      # wasm-pack
      # nix-ld

      # C/C++
      clang
      cmake

      # Others
      marksman           # Markdown LSP
      # bazel              # cho Mediapipe hoặc build lớn
      # dprint           # code formatter
      # flutter          # nếu dùng Flutter
      # dart
      # jdk17

      # LLMs
      # ollama
    ];

    # ────────────────────────────────────────────────────────────────
    # 5. Media & multimedia
    # ────────────────────────────────────────────────────────────────
    media = [
      cava
      cmus
      vlc
      # yt-dlp
    ];

    # ────────────────────────────────────────────────────────────────
    # 6. Office / screenshot / utilities
    # ────────────────────────────────────────────────────────────────
    officeUtils = [
      flameshot
    ];

    # ────────────────────────────────────────────────────────────────
    # Tổng hợp tất cả (dễ comment/uncomment từng nhóm)
    # ────────────────────────────────────────────────────────────────
    all = coreCli
      ++ nerdFonts
      ++ dockerTools
      ++ qemuTools
      ++ funTerminal
      ++ editors
      ++ dev
      ++ media
      ++ officeUtils;
  };
in {
  # =============================================================================
  #                            HOME-MANAGER CORE
  # =============================================================================
  home = {
    username      = constants.username;
    homeDirectory = constants.homeDir;
    stateVersion  = constants.stateVersion;
    packages      = packages.all;
  };

  # =============================================================================
  #                            SYSTEM CONFIGURATION
  # =============================================================================
  nixpkgs.config = {
    # Tôi biết đây là phần mềm đóng, nhưng tôi vẫn muốn dùng nó
    allowUnfree = true;
    # Tôi biết gói này không an toàn, nhưng hãy cứ cho phép tôi cài nó để chạy WebStorm
    permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];
  };

  # Imported programs
  imports = [
    ./programs/eza.nix
    ./programs/flatpak.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/ghostty.nix
    ./programs/helix.nix
    ./programs/nixGL.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    # ./programs/ytdlp.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
    ./programs/zellij.nix
    # Thêm các file module khác tại đây
  ];

  # =============================================================================
  #                            ENVIRONMENT & PATH
  # =============================================================================
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "hx";

    # Use eza to preview directories when using zoxide's interactive mode
    _ZO_FZF_OPTS = "--preview 'eza --tree --color=always --level=2 {} | head -200'";

    # Chrome (Flatpak)
    CHROME_EXECUTABLE = "~/.local/share/flatpak/app/com.google.Chrome/current/active/files/bin/chrome";

    # Flutter / Android
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_AVD_HOME = "$HOME/.var/app/com.google.AndroidStudio/config/.android/avd/";
  };

  # =============================================================================
  #                            ACTIVATION SCRIPTS
  # =============================================================================
  home.activation = {
    initializeNvim = lib.hm.dag.entryAfter ["installPackages"] ''
      echo " - Initializing LazyVim Configuration..."
      if [ ! -d "$HOME/.config/nvim" ]; then
        ${pkgs.git}/bin/git clone --depth=1 "${constants.lazyvimRepo}" "$HOME/.config/nvim"
      else
        echo "Nvim config already exist!"
      fi
    '';
  };

  # =============================================================================
  #                            SERVICES & DAEMONS
  # =============================================================================
  services = {
    flameshot.enable = true;
    # - add to Ubuntu Settings > Keyboard > Keyboard Shortcuts > Custom Shortcuts > +
    # Name: Flameshot
    # Command: bash -c -- "flameshot gui > /dev/null"
    # Shortcut: Fn + screenshot
  };

  fonts.fontconfig.enable = true;

  # Dotfiles
  home.file = {
  };

  # =============================================================================
  #                            PROGRAM ENABLERS
  # =============================================================================
  programs = {
    home-manager.enable = true;
    direnv = {
      enable            = true; # tự động nạp env params
      nix-direnv.enable = true; # tự động nạp env
    };
    # nix-ld.enable  = true;

    cmus.enable    = true;

    lazygit.enable = true;
    lf.enable      = true;
    neovim.enable  = true;
    ripgrep.enable = true; # grep nhanh hơn
    vim.enable     = true;
    yazi.enable    = true;
    # yt-dlp.enable = true;
  };
}
