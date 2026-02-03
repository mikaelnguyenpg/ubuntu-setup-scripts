{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    # terminal = "screen-256color";
    terminal = "tmux-256color";
    historyLimit = 100000;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible              # Fix các lỗi delay phím cơ bản
      fzf-tmux-url          # Mở nhanh URL trong terminal
      vim-tmux-navigator    # Di chuyển mượt giữa Tmux và Neovim
      session-wizard        # Quản lý session cực nhanh

      {
        plugin = tmux-floax;
        extraConfig = "set -g @floax-bind 'C-p'";
      }
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
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
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      # { plugin = continuum; extraConfig = ''
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
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      set -g set-clipboard on
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
}
