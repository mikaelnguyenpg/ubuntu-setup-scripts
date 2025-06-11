{ config, pkgs, lib, ... }:

let
  # Constants and external resources
  constants = {
    username = "eagle";
    homeDir = "/home/eagle";
    stateVersion = "24.11";
    lazyvimRepo = "https://github.com/mikaelnguyenpg/nvim-starter.git";
  };

  # Package definitions
  # https://github.com/agarrharr/awesome-cli-apps?tab=readme-ov-file#music
  packages = with pkgs; {
    cliTools = [
      bat
      boxes
      cmatrix
      cowsay
      delta
      fd
      figlet
      fortune
      # btop
      gotop
      # gtop
      httpie
      jq
      lsd
      neofetch
      nodePackages.emoj
      ripgrep
      spice-vdagent # samba # Windows: https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
      tldr
      xclip
    ];
    media = [
      cava
      cmus
      flameshot
      libreoffice
      pritunl-client
      vlc # https://extensions.gnome.org/extension/5624/sound-visualizer/
    ];
    ide = [
      jetbrains.webstorm
    ];
    devTools = [
      # Node
      bun
      charles
      deno
      dprint
      emmet-ls
      eslint
      nodePackages.nodejs
      nodePackages.prettier
      tailwindcss-language-server
      typescript
      typescript-language-server
      vite
      vscode-js-debug
      vscode-langservers-extracted
      yarn
      # Python
      uv
    ];
  };

  unfreePackages = pkg: builtins.elem (lib.getName pkg) [
    "charles"
    "httpie-desktop"
    "pritunl-client"
    "pritunl-client-electron"
    "vscode"
    "webstorm"
  ];

  # Combine all packages into a single list
  allPackages = with packages; cliTools ++ media ++ devTools;

  # Flatpak packages
  flatpakPackages = [
    # Example: { appId = "org.telegram.desktop"; origin = "flathub"; }
    { appId = "app.zen_browser.zen"; origin = "flathub"; }
    { appId = "com.google.Chrome"; origin = "flathub"; }
    { appId = "org.signal.Signal"; origin = "flathub"; }
    { appId = "md.obsidian.Obsidian"; origin = "flathub"; }
    { appId = "com.github.dail8859.NotepadNext"; origin = "flathub"; }
    { appId = "io.httpie.Httpie"; origin = "flathub"; }
    # { appId = "org.libreoffice.LibreOffice"; origin = "flathub"; }
    # { appId = "com.obsproject.Studio"; origin = "flathub"; }
    
    # { appId = "org.gnome.World.Iotas"; origin = "flathub"; }
    { appId = "io.github.mfat.jottr"; origin = "flathub"; }
    # { appId = "org.kde.ghostwriter"; origin = "flathub"; }
    # { appId = "org.gottcode.FocusWriter"; origin = "flathub"; }
    # { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    { appId = "org.kde.kclock"; origin = "flathub"; }
    # { appId = "org.jousse.vincent.Pomodorolm"; origin = "flathub"; }
    # { appId = "com.github.johnfactotum.QuickLookup"; origin = "flathub"; }
    # { appId = "xyz.safeworlds.hiit"; origin = "flathub"; }
  ];

  # Program configurations
  programConfigs = {
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        editor = {
          bufferline = "multiple";
          cursorline = true;
          line-number = "relative";
          rulers = [80];
          true-color = true;
        };
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        editor.indent-guides = {
          character = "╎";
          render = true;
        };
        editor.lsp = {
          auto-signature-help = false;
          display-messages = true;
          display-inlay-hints = true;
        };
        editor.statusline = {
          left = ["mode" "spinner" "version-control" "file-name"];
        };
        editor.end-of-line-diagnostics = "hint";
        editor.inline-diagnostics = {
          cursor-line = "error";
          other-lines = "disable";
        };
        editor.file-picker.hidden = false;
      };

      extraConfig = ''
        [keys.insert]
        esc = ["collapse_selection", "keep_primary_selection", "normal_mode"]

        [keys.normal]
        esc = ["collapse_selection", "keep_primary_selection", "normal_mode"]

        [keys.normal."+"]
        e = [ ":new", ":insert-output yazi", ":buffer-close!", ":redraw", ":reload-all" ]
        g = [ ":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all" ]

        # [keys.normal." "]
        # e = {
        #   f = [ ":new", ":insert-output yazi", ":buffer-close!", ":redraw", ":reload-all" ],
        #   g = [ ":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all" ]
        # }
      '';

      languages = {
        language-server = {
          emmet-ls = {
            command = "emmet-ls";
            args = [ "--stdio" ];
          };
          vscode-html-language-server = {
            command = "vscode-html-language-server";
            args = [ "--stdio" ];
          };
          vscode-css-language-server = {
            command = "vscode-css-language-server";
            args = [ "--stdio" ];
          };
          typescript-language-server = {
            command = "typescript-language-server";
            args = [ "--stdio" ];
            config = {
              typescript.inlayHints = {
                includeInlayEnumMemberValueHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayVariableTypeHints = true;
              };
              javascript.inlayHints = {
                includeInlayEnumMemberValueHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayVariableTypeHints = true;
              };
            };
          };
          tailwindcss-ls = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
          };
          rust-analyzer = {
            command = "rust-analyzer";
            args = [ ];
            config.check.command = "clippy";
          };
        };

        language = [
          {
            name = "html";
            roots = [ ".git" ];
            formatter = { command = "prettier"; args = [ "--parser" "html" ]; };
            language-servers = [ "vscode-html-language-server" "emmet-ls" ];
            auto-format = true;
          }
          {
            name = "css";
            formatter = { command = "prettier"; args = [ "--parser" "css" ]; };
            language-servers = [ "vscode-css-language-server" "tailwindcss-ls" "emmet-ls" ];
            auto-format = true;
          }
          {
            name = "scss";
            formatter = { command = "prettier"; args = [ "--parser" "scss" ]; };
            language-servers = [ "vscode-css-language-server" ];
            auto-format = true;
          }
          {
            name = "javascript";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" ];
            auto-format = true;
          }
          {
            name = "typescript";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" ];
            auto-format = true;
            scope = "source.ts";
            injection-regex = "(ts|typescript)";
            file-types = [ "ts" ]; # "tsx"
            roots = [ "package.json" "tsconfig.json" ];
            debugger = {
              name = "vscode-js-debug";
              transport = "stdio";
              command = "${pkgs.vscode-js-debug}/bin/js-debug-adapter";
              args = [];
              templates = [
                {
                  name = "source";
                  request = "launch";
                  completion = [
                  { name = "main"; completion = "filename"; default = "index.ts"; }
                  ];
                  args = {
                    program = "{0}";
                    runtimeExecutable = "${pkgs.nodePackages.nodejs}/bin/node";
                    sourceMaps = true;
                    outFiles = [ "\${workspaceFolder}/dist/**/*.js" ]; # Adjust based on your build output
                  };
                }
              ];
            };
          }
          {
            name = "jsx";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" "emmet-ls" ];
            auto-format = true;
          }
          {
            name = "tsx";
            formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
            language-servers = [ "typescript-language-server" "emmet-ls" ];
            auto-format = true;
          }
          {
            name = "json";
            formatter = { command = "prettier"; args = [ "--parser" "json" ]; };
            auto-format = true;
          }
          {
            name = "markdown";
            formatter = { command = "prettier"; args = [ "--parser" "markdown" ]; };
            auto-format = true;
          }
        ];
      };
    };

    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      historyLimit = 100000;
      prefix = "C-a";
      shortcut = "a";
      baseIndex = 1;
      plugins = with pkgs; [
        tmuxPlugins.fzf-tmux-url
        { plugin = tmuxPlugins.tmux-floax; extraConfig = "set -g @floax-bind 'C-p'"; }
        { plugin = tmuxPlugins.tokyo-night-tmux; extraConfig = ''
          set -g @tokyo-night-tmux_theme storm
          set -g @tokyo-night-tmux_transparent 1
          set -g @tokyo-night-tmux_window_id_style digital
          set -g @tokyo-night-tmux_pane_id_style hsquare
          set -g @tokyo-night-tmux_zoom_id_style dsquare
          set -g @tokyo-night-tmux_terminal_icon 
          set -g @tokyo-night-tmux_active_terminal_icon 
          set -g @tokyo-night-tmux_window_tidy_icons 0
          set -g @tokyo-night-tmux_show_music 1
          set -g @tokyo-night-tmux_show_battery_widget 1
          set -g @tokyo-night-tmux_battery_name "BAT1"
          set -g @tokyo-night-tmux_battery_low_threshold 21
        ''; }
        { plugin = tmuxPlugins.vim-tmux-navigator; }
        { plugin = tmuxPlugins.session-wizard; }
        { plugin = tmuxPlugins.resurrect; extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        ''; }
        # { plugin = tmuxPlugins.continuum; extraConfig = ''
        #   set -g @continuum-restore 'on'
        #   set -g @continuum-boot 'off'
        #   set -g @continuum-save-interval '10'
        # ''; }
      ];
      extraConfig = ''
        # Terminal settings for Ghostty
        set-option -g terminal-overrides ',xterm-256color:RGB'

        # Pane splitting
        unbind %
        bind | split-window -h -c "#{pane_current_path}"
        unbind '"'
        bind - split-window -v -c "#{pane_current_path}"

        # Pane navigation (vim-tmux-navigator handles h,j,k,l)
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind h select-pane -L

        # Pane resizing
        bind Down resize-pane -D 5
        bind Up resize-pane -U 5
        bind Right resize-pane -R 5
        bind Left resize-pane -L 5

        # Clipboard and VI mode
        set -g set-clipboard on
        set -g mouse on
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        unbind -T copy-mode-vi MouseDragEnd1Pane

        # Reload config
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        # Keybindings reference
        # prefix [: enter copy mode
        # prefix I: Install session
        # prefix r: Reload Tmux config
        # prefix s: liSt sessions
        # prefix C-s: Save session
        # prefix C-r: Restore session
        # prefix D: Detach session
        # prefix &: kill current session
        # prefix $: rename session
        # prefix N/): Next session
        # prefix P/(: Previous session
        # prefix c: Create new window
        # prefix ,: Rename window
        # prefix n: Next window
        # prefix p: Previous window
        # prefix number: switch window by number
        # prefix z: toggle pane Zoom
        # prefix x: close pane
        # ref: https://defkey.com/tmux-shortcuts
      '';
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;

      userSettings = {
        # General settings
        "editor.fontSize" = 14;
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
        "window.zoomLevel" = 1;
        "terminal.integrated.shell" = "${pkgs.zsh}/bin/zsh"; # Use zsh as the integrated terminal shell
        "terminal.integrated.defaultProfile.linux" = "zsh";

        # Theme (matching your tmux tokyo-night theme)
        "workbench.colorTheme" = "Tokyo Night Storm";

        # Vim keybindings (optional, since you use vim-tmux-navigator)
        "vim.easymotion" = true;
        "vim.handleKeys" = {
          "<C-a>" = false;
          "<C-f>" = false;
          "<C-p>" = false;
        };
        "vim.leader" = "<space>";
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            "before" = ["ctrl" "w"];
            "commands" = ["workbench.action.files.save"];
          }
        ];
        "vim.useSystemClipboard" = true;

        # Disable telemetry
        "telemetry.telemetryLevel" = "off";

        "turboConsoleLog.includeFilename" = true;
        "turboConsoleLog.includeLineNum" = true;
        "turboConsoleLog.insertEnclosingClass" = true;
        "turboConsoleLog.insertEnclosingFunction" = true;
      };

      # Manage keybindings
      keybindings = [
        {
          "key" = "ctrl+shift+t";
          "command" = "workbench.action.terminal.toggleTerminal";
          "when" = "editorTextFocus";
        }
        {
          "key" = "ctrl+alt+t";
          "command" = "workbench.action.terminal.new";
          "when" = "terminalFocus";
        }
      ];

      # Install extensions
      extensions = with pkgs.vscode-extensions; [
        # attilabuti.vscode-mjml
        # britesnow.vscode-toggle-quotes
        # burkeholland.simple-react-snippets
        # chakrounanas.turbo-console-log
        # dsznajder.es7-react-js-snippets
        # exodiusstudios.comment-anchors
        # george-alisson.html-preview-vscode
        # jasew.vscode-helix-emulation # optional
        # ms-vscode.vscode-typescript-next
        # pkief.material-icon-theme # optional
        # steoates.autoimport
        # wallabyjs.console-ninja # optional
        adpyke.codesnap
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        dracula-theme.theme-dracula
        eamodio.gitlens
        ecmel.vscode-html-css
        # Tokyo Night theme (matching your tmux theme)
        enkia.tokyo-night
        esbenp.prettier-vscode
        grapecity.gc-excelviewer
        jnoortheen.nix-ide
        meganrogge.template-string-converter
        mikestead.dotenv
        ms-python.python
        oderwat.indent-rainbow
        vscode-icons-team.vscode-icons
        # Vim extension (optional, for vim keybindings)
        vscodevim.vim
        wix.vscode-import-cost
        yoavbls.pretty-ts-errors
        zainchen.json
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # {
        #   name = "remote-ssh";
        #   publisher = "ms-vscode-remote";
        #   version = "0.102.0"; # Use a specific version compatible with nixpkgs
        #   sha256 = "sha256-0h0+0h0+0h0+0h0+0h0+0h0+0h0+0h0+0h0+0h0+0h0="; # Replace with actual sha256
        # }
      ];

      # Enable mutable settings (optional)
      mutableExtensionsDir = true; # Set to true if you want to allow manual extension installations
    };

    zellij = {
      enable = true;
      # enableZshIntegration = true;
      # settings = {
      #   default_shell = "zsh";
      # };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        package = pkgs.oh-my-zsh;
        plugins = ["git"];
      };

      # Shell aliases (minimal, most in aliases.zsh)
      shellAliases = {
        hm = "home-manager";
        pkg = "pkg_list";
        update = "sudo nala update && sudo nala upgrade && flatpak update -y";
      };

      # History settings
      history = {
        size = 100000;
        save = 100000;
        path = "${config.home.homeDirectory}/.zsh_history";
        ignoreDups = true;
        share = true;
        extended = true;
      };

      initExtra = ''
        # Initialize zoxide
        eval "$(zoxide init zsh)"

        # Source fzf
        source <(fzf --zsh)

        # Source custom aliases and functions
        source ~/.config/zsh/aliases.zsh
        source ~/.config/zsh/functions.zsh

        # Basic prompt (replace with Starship if enabled)
        PROMPT='%F{blue}%n@%m%f %F{green}%~%f $ '
      '';
    };

    starship = {
      enable = true;
      package = pkgs.starship;
      enableZshIntegration = true;
      settings = {
        add_newline = false;

        aws = {
          symbol = "  ";
        };

        buf = {
          symbol = " ";
        };

        bun = {
          symbol = " ";
        };

        c = {
          symbol = " ";
        };

        cpp = {
          symbol = " ";
        };

        cmake = {
          symbol = " ";
        };

        conda = {
          symbol = " ";
        };

        crystal = {
          symbol = " ";
        };

        dart = {
          symbol = " ";
        };

        deno = {
          symbol = " ";
        };

        directory = {
          read_only = " 󰌾";
        };

        docker_context = {
          symbol = " ";
        };

        elixir = {
          symbol = " ";
        };

        elm = {
          symbol = " ";
        };

        fennel = {
          symbol = " ";
        };

        fossil_branch = {
          symbol = " ";
        };

        gcloud = {
          symbol = "  ";
        };

        git_branch = {
          symbol = " ";
        };

        git_commit = {
          tag_symbol = "  ";
        };

        golang = {
          symbol = " ";
        };

        guix_shell = {
          symbol = " ";
        };

        haskell = {
          symbol = " ";
        };

        haxe = {
          symbol = " ";
        };

        hg_branch = {
          symbol = " ";
        };

        hostname = {
          ssh_symbol = " ";
        };

        java = {
          symbol = " ";
        };

        julia = {
          symbol = " ";
        };

        kotlin = {
          symbol = " ";
        };

        lua = {
          symbol = " ";
        };

        memory_usage = {
          symbol = "󰍛 ";
        };

        meson = {
          symbol = "󰔷 ";
        };

        nim = {
          symbol = "󰆥 ";
        };

        nix_shell = {
          symbol = " ";
        };

        nodejs = {
          symbol = " ";
        };

        ocaml = {
          symbol = " ";
        };

        os = {
          symbols = {
            Alpaquita = " ";
            Alpine = " ";
            AlmaLinux = " ";
            Amazon = " ";
            Android = " ";
            Arch = " ";
            Artix = " ";
            CachyOS = " ";
            CentOS = " ";
            Debian = " ";
            DragonFly = " ";
            Emscripten = " ";
            EndeavourOS = " ";
            Fedora = " ";
            FreeBSD = " ";
            Garuda = "󰛓 ";
            Gentoo = " ";
            HardenedBSD = "󰞌 ";
            Illumos = "󰈸 ";
            Kali = " ";
            Linux = " ";
            Mabox = " ";
            Macos = " ";
            Manjaro = " ";
            Mariner = " ";
            MidnightBSD = " ";
            Mint = " ";
            NetBSD = " ";
            NixOS = " ";
            Nobara = " ";
            OpenBSD = "󰈺 ";
            openSUSE = " ";
            OracleLinux = "󰌷 ";
            Pop = " ";
            Raspbian = " ";
            Redhat = " ";
            RedHatEnterprise = " ";
            RockyLinux = " ";
            Redox = "󰀘 ";
            Solus = "󰠳 ";
            SUSE = " ";
            Ubuntu = " ";
            Unknown = " ";
            Void = " ";
            Windows = "󰍲 ";
          };
        };

        package = {
          symbol = "󰏗 ";
        };

        perl = {
          symbol = " ";
        };

        php = {
          symbol = " ";
        };

        pijul_channel = {
          symbol = " ";
        };

        pixi = {
          symbol = "󰏗 ";
        };

        python = {
          symbol = " ";
        };

        rlang = {
          symbol = "󰟔 ";
        };

        ruby = {
          symbol = " ";
        };

        rust = {
          symbol = "󱘗 ";
        };

        scala = {
          symbol = " ";
        };

        swift = {
          symbol = " ";
        };

        zig = {
          symbol = " ";
        };

        gradle = {
          symbol = " ";
        };
      };
    };
  };

in {
  # Core Home Manager settings
  home.username = constants.username;
  home.homeDirectory = constants.homeDir;
  home.stateVersion = constants.stateVersion;

  # Allow specific unfree packages
  nixpkgs.config = {
    allowUnfreePredicate = unfreePackages;
  };

  # Packages
  home.packages = allPackages;

  # Dotfiles
  home.file = {
    ".config/ghostty/config" = {
      text = ''
        theme = catppuccin-mocha
        # font-family = FiraCode Nerd Font
        font-size = 14
        mouse-hide-while-typing = true
        window-decoration = true
        background-opacity = 0.8
        background-blur-radius = 20
        maximize = false
        window-width = 800
        window-height = 600
        quick-terminal-position = center
        '';
    };

    # Link functions.zsh and aliases.zsh from ~/.config/home-manager
    ".config/zsh/functions.zsh".source = ./functions.zsh;
    ".config/zsh/aliases.zsh".source = ./aliases.zsh;
  };

  # Activation scripts
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

  # Environment variables
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Services
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
      uninstallUnmanaged = true; # true: Remove apps not in package list; false: Keep existed
    };
  };

  # Programs
  programs = programConfigs // {
    home-manager.enable = true;
    direnv.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    lf.enable = true;
    ripgrep.enable = true;
    yazi.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    git.enable = true;
    vim.enable = true;
    neovim.enable = true;
    cmus.enable = true;
    yt-dlp.enable = true;
  };
}
