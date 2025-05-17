{ config, pkgs, lib, ... }:

let
  # Constants and external resources
  constants = {
    username = "eagle";
    homeDir = "/home/eagle";
    stateVersion = "24.11";
    starshipTomlUrl = "https://starship.rs/presets/toml/nerd-font-symbols.toml";
    lazyvimRepo = "https://github.com/mikaelnguyenpg/nvim-starter.git";
  };

  # Package definitions
  packages = with pkgs; {
    cliTools = [
      boxes
      btop
      cowsay
      figlet
      httpie
      # samba
      spice-vdagent
      # Windows: https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
      tldr
      xclip
    ];
    media = [ vlc flameshot ];
    devTools = [
      bun
      deno
      dprint
      emmet-ls
      eslint
      nodePackages.prettier
      nodejs_23
      tailwindcss-language-server
      typescript
      typescript-language-server
      uv
      vite
      vscode-js-debug
      vscode-langservers-extracted
      yarn
    ];
  };

  # Combine all packages into a single list
  allPackages = with packages; cliTools ++ media ++ devTools;

  # Program configurations
  programConfigs = {
    ghostty = {
      # enable = true;
      settings = {
        theme = "catppuccin-mocha";
        font-size = 14;
        mouse-hide-while-typing = true;
        window-decoration = true;
        background-opacity = 0.8;
        background-blur-radius = 20;
        window-width = 800;
        window-height = 600;
        quick-terminal-position = "center";
        # maximize = true;
      };
    };

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
        keys.normal = {
          esc = ["collapse_selection" "keep_primary_selection"];
          "X" = "select_line_above";
          # "C-g" = [":new" ":insert-output" ":buffer-close!" ":redraw"];
        };
        keys.select = {
          "X" = "select_line_above";
        };
      };

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
                    runtimeExecutable = "${pkgs.nodejs_23}/bin/node";
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
      # terminal = "xterm-256color";
      # terminal = "xterm-ghostty";
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
        { plugin = tmuxPlugins.continuum; extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        ''; }
      ];
      extraConfig = ''
        set-option -g default-terminal 'screen-256color'
        set-option -g terminal-overrides ',xterm-256color:RGB'
        unbind %
        bind | split-window -h -c "#{pane_current_path}"
        unbind '"'
        bind - split-window -v -c "#{pane_current_path}"
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind h select-pane -L
        bind Down resize-pane -D 5
        bind Up resize-pane -U 5
        bind Right resize-pane -R 5
        bind Left resize-pane -L 5
        set -g set-clipboard on
        set -g mouse on
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        unbind -T copy-mode-vi MouseDragEnd1Pane
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf
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

    zellij = {
      enable = true;
      # enableZshIntegration = true;
      settings = {
        default_shell = "zsh";
      };
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
      initExtra = ''
        alias cd="z"
        alias ..="cd .."
        alias ...="cd ../.."
        alias ....="cd ../../.."
        alias .....="cd ../../../.."
        alias ......="cd ../../../../.."
        alias ls="eza --icons"
        alias lsa="eza --icons -a"
        alias l="eza -l --icons --git -a"
        alias lt="eza --tree --level=2 --long --icons --git"
        alias ltree="eza --tree --level=3 --icons --git"
        cx() { cd "$@" && lsa; }
        fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
        f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; }
        fv() { nvi "$(find . -type f -not -path '*/.*' | fzf)"; }
        update() { sudo apt update && sudo apt upgrade }
        ytdlvideo() { yt-dlp --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" "$@" && lsa; }
        ytdlaudio() { yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 "$@" && lsa; }
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

  # Packages
  home.packages = allPackages;

  # Dotfiles
  home.file = {};

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
    initialize-starship = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Initializing Starship configuration..."
      if [ ! -d "$HOME/.config/starship.toml" ]; then
        /usr/bin/curl -L "${constants.starshipTomlUrl}" -o "$HOME/.config/starship.toml"
        sed -i '1i add_newline = false' "$HOME/.config/starship.toml"
      else
        echo "starship.toml config already exist!"
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
