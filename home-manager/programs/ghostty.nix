{ config, pkgs, lib, ... }:

{
  # Zoxide: The smarter 'cd'
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
       # --- Giao diện ---
       theme = "TokyoNight"; # Hoặc tên bất kỳ bạn tìm thấy trong ghostty +list-themes
       background-opacity = 0.85;
       background-blur-radius = 20;
  
       # --- Font chữ ---
       font-family = "JetBrainsMono Nerd Font";
       font-size = 12;
  
       # --- Cursor ---
       cursor-style = "block";
       cursor-style-blink = true;
  
       # --- Cửa sổ ---
       window-decoration = true;
       window-padding-x = 10;
       window-padding-y = 10;
       copy-on-select = true;
  
       # --- Lệnh khởi chạy ---
       command = "${pkgs.zsh}/bin/zsh --login";
  
       # --- Phím tắt ---
       keybind = [
         "ctrl+shift+t=new_tab"
         "ctrl+shift+w=close_tab"
         "ctrl+alt+left=goto_split:left"
         "ctrl+alt+right=goto_split:right"
      ];
    };
  };
}
