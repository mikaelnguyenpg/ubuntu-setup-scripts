{ config, pkgs, lib, ... }:

let
  starshipTomlUrl = "https://starship.rs/presets/toml/nerd-font-symbols.toml";
  # lazyvimRepo = "https://github.com/LazyVim/starter";
  lazyvimRepo = "https://github.com/mikaelnguyenpg/nvim-starter.git";
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eagle";
  home.homeDirectory = "/home/eagle";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside yhttps://www.youtube.com/watch?v=foHfWg3GsC4our
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    httpie
    xclip

    vlc
    btop
    cowsay
    figlet
    boxes
    tldr
    flameshot
    # flatpak

    nodejs_23
    bun
    yarn
    # Language servers
    typescript
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    # Other tools (optional)
    dprint
    nodePackages.prettier
    eslint
    deno
    emmet-ls
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    # ".config/starship".source = ~/dotfiles/starship;
  };


  home.activation.initialize-nvim = lib.hm.dag.entryAfter ["installPackages"] ''
    echo "Initializing LazyVim configuration..."
    if [ ! -d "$HOME/.config/nvim" ]; then
      ${pkgs.git}/bin/git clone --depth=1 "${lazyvimRepo}" "$HOME/.config/nvim"
    else
      echo "Nvim config already exist!"
    fi
  '';

  # home.activation.initialize-starship = lib.hm.dag.entryAfter [ "install-oh-my-zsh-plugins" ] ''
  home.activation.initialize-starship = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Initializing Starship configuration..."
    if [ ! -d "$HOME/.config/starship.toml" ]; then
      /usr/bin/curl -L "${starshipTomlUrl}" -o "$HOME/.config/starship.toml"
      # Insert a setting
      sed -i '1i add_newline = false' "$HOME/.config/starship.toml"
    else
      echo "starship.toml config already exist!"
    fi
    # Setup shell to use Starship
    # if ! grep -Fxq 'eval "$(starship init bash)"' ~/.bashrc; then
    #   echo 'eval "$(starship init bash)"' >> ~/.bashrc
    # fi
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/falcon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Run in startup
  services = {
    flameshot.enable = true;
    # - add to Ubuntu Settings > Keyboard > Keyboard Shortcuts > Custom Shortcuts > +
    # Name: Flameshot
    # Command: bash -c -- "flameshot gui > /dev/null"
    # Shortcut: Fn + screenshot

    # flatpak = {
    #   enable = true;
    #   remotes = [
    #     { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    #   ];
    #   packages = [
    #     "org.jousse.vincent.Pomodorolm"
    #   ];
    # };
  };

  # Let Home Manager install and manage itself.
  programs = {
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

    # ghostty.enable = true;
    # https://theari.dev/blog/enhanced-helix-config/
    # https://dev.to/morlinbrot/configure-helix-for-typescript-eslint-prettierdprint-582c
    helix = {
      enable = true;
      settings = {
        editor = {
          # Show currently open buffers, only when more than one exists.
          bufferline = "multiple";
          # Highlight all lines with a cursor
          cursorline = true;
          # Use relative line numbers
          line-number = "relative";
          # Show a ruler at column 80
          rulers = [80];
          # Force the theme to show colors
          true-color = true;
          # shell = ["zsh", "-c"];
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
          # Disable automatically popups of signature parameter help
          auto-signature-help = false;
          # Show LSP messages in the status line
          display-messages = true;
        };
        editor.statusline = {
          left = ["mode" "spinner" "version-control" "file-name"];
        };
# Minimum severity to show a diagnostic after the end of a line
        editor = {
          end-of-line-diagnostics = "hint";
        };
        editor.inline-diagnostics = {
          cursor-line = "error"; # Show inline diagnostics when the cursor is on the line
          other-lines = "disable"; # Don't expand diagnostics unless the cursor is on the line
        };
        editor.file-picker = {
          hidden = false;
        };
        keys.normal = {
          esc = [ "collapse_selection" "keep_primary_selection" ];
          A-x = "extend_to_line_bounds";
          X = "select_line_above";
        };
        keys.select = {
          A-x = "extend_to_line_bounds";
          X = "select_line_above";
        };
      };
      languages = {
        language-server.typescript-language-server = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];
        };
      };
    };

    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 100000;
      prefix = "C-a";
      shortcut = "a";
      baseIndex = 1;
      plugins = with pkgs;
        [
          tmuxPlugins.fzf-tmux-url
          # tmuxPlugins.sensible
          {
            plugin = tmuxPlugins.tmux-floax;
            extraConfig = ''
              set -g @floax-bind 'C-p' # Setting the main key to toggle the floating pane on and off
            '';
          }
          {
            plugin = tmuxPlugins.tokyo-night-tmux;
            extraConfig = ''
              set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
              set -g @tokyo-night-tmux_transparent 1  # 1 or 0
              set -g @tokyo-night-tmux_window_id_style digital
              set -g @tokyo-night-tmux_pane_id_style hsquare
              set -g @tokyo-night-tmux_zoom_id_style dsquare
              # Icon styles
              set -g @tokyo-night-tmux_terminal_icon 
              set -g @tokyo-night-tmux_active_terminal_icon 
              # No extra spaces between icons
              set -g @tokyo-night-tmux_window_tidy_icons 0
              set -g @tokyo-night-tmux_show_music 1
              set -g @tokyo-night-tmux_show_battery_widget 1
              set -g @tokyo-night-tmux_battery_name "BAT1"  # some linux distro have 'BAT0'
              set -g @tokyo-night-tmux_battery_low_threshold 21 # default
            '';
          }
          {
            plugin = tmuxPlugins.vim-tmux-navigator;
          }
          {
            plugin = tmuxPlugins.session-wizard;
            extraConfig = ''
            '';
          }
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-vim 'session'
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-boot 'on'
              set -g @continuum-save-interval '10'
            '';
          }
        ];
      extraConfig = ''
        # Key Bindings for Pane Management
        unbind %
        bind | split-window -h -c "#{pane_current_path}"
        unbind '"'
        bind - split-window -v -c "#{pane_current_path}"
        # Key Bindings for Pane Navigation
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind h select-pane -L
        # Key Bindings for Pane Resizing
        bind Down resize-pane -D 5
        bind Up resize-pane -U 5
        bind Right resize-pane -R 5
        bind Left resize-pane -L 5
        # Mouse and Clipboard Settings
        set -g set-clipboard on
        set -g mouse on
        set-window-option -g mode-keys vi
        # Copy Mode Key Bindings
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        unbind -T copy-mode-vi MouseDragEnd1Pane
        # Reload Configuration
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

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;       # Enable Oh My Zsh (optional)
        package = pkgs.oh-my-zsh;   # Ensure the latest Zsh package is used
        plugins = [ "git" ];  # Example plugins (optional): "zsh-autosuggestions" "zsh-syntax-highlighting"
      };
      # shellAliases = { };
      initExtra = ''
        # Init Pyenv
        init_pyenv() {
          export PYENV_ROOT="$HOME/.pyenv"
          [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
          eval "$(pyenv init --path)"
          # Load pyenv automatically
          eval "$(pyenv init -)"
          # Load pyenv-virtualenv automatically by adding the following to ~/.bashrc:
          eval "$(pyenv virtualenv-init -)"
        }
        init_pyenv

        # Navigation Aliases
        alias cd="z"
        alias ..="cd .."
        alias ...="cd ../.."
        alias ....="cd ../../.."
        alias .....="cd ../../../.."
        alias ......="cd ../../../../.."
        # Eza Aliases
        alias ls="eza --icons"
        alias lsa="eza --icons -a"
        alias l="eza -l --icons --git -a"
        alias lt="eza --tree --level=2 --long --icons --git"
        alias ltree="eza --tree --level=3 --icons --git"
        # Custom Functions
        cx() { cd "$@" && lsa; }
        fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
        f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; }
        fv() { nvi "$(find . -type f -not -path '*/.*' | fzf)"; }
        update() { sudo apt update && sudo apt upgrade }
        ytdlvideo() { yt-dlp --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" "$@" && lsa; }
        ytdlaudio() { yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 "$@" && lsa; }
      '';
    };
  };
}
