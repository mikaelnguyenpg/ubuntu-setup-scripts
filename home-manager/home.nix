{ config, pkgs, lib, nixGL, ... }:

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
      delta        # diff đẹp hơn
      jq           # xử lý JSON
      httpie       # curl thân thiện
      tldr         # hướng dẫn lệnh ngắn gọn
      lsd          # ls đẹp hơn
      xclip        # clipboard CLI
      # Cài nerdfont
      nerd-fonts.fira-code
      nerd-fonts.comic-shanns-mono
      nerd-fonts.symbols-only # (Tùy chọn) Thêm các symbol bổ trợ
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
      # btop
      gotop
      # gtop
    ];

    # ────────────────────────────────────────────────────────────────
    # 3. Editors / IDEs / code editors
    # ────────────────────────────────────────────────────────────────
    editors = [
      helix
      jetbrains.webstorm
    ];

    # ────────────────────────────────────────────────────────────────
    # 4. Development tools (Node, Rust, Python, C++, etc.)
    # ────────────────────────────────────────────────────────────────
    dev = [
      # Node ecosystem
      bun
      deno
      nodePackages.nodejs
      yarn
      vite
      typescript
      eslint
      vscode-js-debug

      # Python
      uv

      # Rust
      rustup

      # C/C++
      clang
      cmake

      # Others
      marksman           # Markdown LSP
      bazel              # cho Mediapipe hoặc build lớn
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
    # 7. NixGL wrapped apps (cần chạy GUI với nixGL)
    # ────────────────────────────────────────────────────────────────
    nixGLApps = [
      (config.lib.nixGL.wrap ghostty)
      (config.lib.nixGL.wrap neovide)
      # (config.lib.nixGL.wrap notepadqq)
      # (config.lib.nixGL.wrap jetbrains.webstorm)
    ];

    # ────────────────────────────────────────────────────────────────
    # Tổng hợp tất cả (dễ comment/uncomment từng nhóm)
    # ────────────────────────────────────────────────────────────────
    all = coreCli
       ++ funTerminal
       ++ editors
       ++ dev
       ++ media
       ++ officeUtils
       ++ nixGLApps;
  };

  # ---------------------------------------------------------------------------
  # FLATPAK APPLICATIONS
  # ---------------------------------------------------------------------------
  flatpakPackages = [
    # Example: { appId = "org.telegram.desktop"; origin = "flathub"; }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    { appId = "app.zen_browser.zen"; origin = "flathub"; }
    { appId = "com.google.Chrome"; origin = "flathub"; }
    { appId = "org.signal.Signal"; origin = "flathub"; }
    { appId = "md.obsidian.Obsidian"; origin = "flathub"; }
    { appId = "com.github.dail8859.NotepadNext"; origin = "flathub"; }
    { appId = "io.httpie.Httpie"; origin = "flathub"; }
    { appId = "org.libreoffice.LibreOffice"; origin = "flathub"; }
    { appId = "com.obsproject.Studio"; origin = "flathub"; }
    { appId = "org.keepassxc.KeePassXC"; origin = "flathub"; }
    { appId = "io.github.dvlv.boxbuddyrs"; origin = "flathub"; }
    
    # { appId = "org.gnome.World.Iotas"; origin = "flathub"; }
    { appId = "io.github.mfat.jottr"; origin = "flathub"; }
    { appId = "org.kde.kclock"; origin = "flathub"; }
    # { appId = "org.jousse.vincent.Pomodorolm"; origin = "flathub"; }
    # { appId = "com.github.johnfactotum.QuickLookup"; origin = "flathub"; }
    # { appId = "xyz.safeworlds.hiit"; origin = "flathub"; }
  ];
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
    ./programs/fzf.nix
    ./programs/helix.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
    ./programs/zellij.nix
    # Thêm các file module khác tại đây
  ];

  # =============================================================================
  #                            GRAPHICS & DRIVERS
  # =============================================================================
  nixGL = {
    packages = nixGL.packages; # Import nixGL package set
    defaultWrapper = "mesa"; # Use Mesa for Intel/AMD or Nouveau
    installScripts = ["mesa"]; # Install nixGLMesa script
    # defaultWrapper = "nvidia"; # Use Nvidia proprietary driver
    # nvidiaVersion = "570.133.07"; # Matches your nvidia-smi output
    # installScripts = [ "nvidia" ]; # Install nixGLNvidia script
  };

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

    # Dùng fd để tìm file nhanh hơn và bỏ qua file ẩn/git
    # FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    # FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
    # Use eza to preview directories when using zoxide's interactive mode
    _ZO_FZF_OPTS = "--preview 'eza --tree --color=always --level=2 {} | head -200'";

    # Chrome (Flatpak)
    CHROME_EXECUTABLE = "~/.local/share/flatpak/app/com.google.Chrome/current/active/files/bin/chrome";

    # Flutter / Android
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_AVD_HOME = "$HOME/.var/app/com.google.AndroidStudio/config/.android/avd/";

    # Nix profile (giữ nguyên)
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
  };

  # =============================================================================
  #                            ACTIVATION SCRIPTS
  # =============================================================================
  home.activation = {
    initialize-nvim = lib.hm.dag.entryAfter ["installPackages"] ''
      echo "Initializing LazyVim configuration..."
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

    # Enable Flatpak management
    flatpak = {
      enable = true;
      remotes = [
        { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
      ];
      # Optional: Add Flatpak apps here (see "How to Use" below)
      packages = flatpakPackages;
      uninstallUnmanaged = false; # true: Remove apps not in package list; false: Keep existed
    };
  };

  fonts.fontconfig.enable = true;

  # Dotfiles
  home.file = {
    # ".config/ghostty/config" = {
    #   text = ''
    #     theme = catppuccin-mocha
    #     font-family = FiraCode Nerd Font
    #     ...
    #     '';
    # };
  };

  # =============================================================================
  #                            PROGRAM ENABLERS
  # =============================================================================
  programs = {
    home-manager.enable = true;
    direnv.enable = true;

    cmus.enable = true;

    git.enable = true; # version control
    lazygit.enable = true;
    lf.enable = true;
    neovim.enable = true;
    ripgrep.enable = true; # grep nhanh hơn
    vim.enable = true;
    yazi.enable = true;
    # yt-dlp.enable = true;
  };
}
