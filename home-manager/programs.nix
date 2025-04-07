{ pkgs, lib }:
{
  helix = {
    enable = true;
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
        "A-x" = "extend_to_line_bounds";
        "X" = "select_line_above";
      };
      keys.select = {
        "A-x" = "extend_to_line_bounds";
        "X" = "select_line_above";
      };
    };
    languages.language-server.typescript-language-server = with pkgs.nodePackages; {
      command = "${typescript-language-server}/bin/typescript-language-server";
      args = ["--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"];
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
      '';
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
      init_pyenv() {
        export PYENV_ROOT="$HOME/.pyenv"
          [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
          eval "$(pyenv init --path)"
            eval "$(pyenv init -)"
            eval "$(pyenv virtualenv-init -)"
      }
    init_pyenv
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
}
