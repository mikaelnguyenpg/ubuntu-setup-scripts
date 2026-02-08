{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Tự động chạy Zellij khi mở Zsh (tùy chọn)

    settings = {
      theme = "catppuccin-mocha";     # hoặc "default", "wasmer", "gruvbox-dark",...
      # default-shell = "${pkgs.zsh}/bin/zsh";          # hoặc "bash", "fish", "nu",...
      default-shell = "zsh";          # hoặc "bash", "fish", "nu",...

      pane_frames = false;            # tắt viền pane → nhìn sạch sẽ hơn
      scroll_buffer_size = 10000;
      scrollback-editor = "hx";       # hoặc "vim", "nano", "helix",...
      scrollback_lines_to_skip = 1;   # scroll mượt hơn
      # simplified_ui = true;           # giao diện gọn

      default_layout = "compact";     # hoặc "default", "strider",...

      keybinds = {
        locked = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Normal"; };

          "bind \"Ctrl h\"" = { MoveFocusOrTab = "Left"; };
          "bind \"Ctrl l\"" = { MoveFocusOrTab = "Right"; };
          "bind \"Ctrl k\"" = { MoveFocus = "Up"; };
          "bind \"Ctrl j\"" = { MoveFocus = "Down"; };

          "bind \"Alt f\"" = { ToggleFloatingPanes = []; };

          "bind \"Alt z\"" = { ToggleFocusFullscreen = []; };
          "bind \"Alt w\"" = { NewPane = []; };
        };

        normal = {
          "bind \"Ctrl h\"" = { MoveFocusOrTab = "Left"; };
          "bind \"Ctrl l\"" = { MoveFocusOrTab = "Right"; };
          "bind \"Ctrl k\"" = { MoveFocus = "Up"; };
          "bind \"Ctrl j\"" = { MoveFocus = "Down"; };
        };
      };
    };
  };
}
