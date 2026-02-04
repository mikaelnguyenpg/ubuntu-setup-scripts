{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable                    = true;
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;

    # 1. Quản lý Plugins thông minh hơn
    oh-my-zsh = {
      enable  = true;
      package = pkgs.oh-my-zsh;
      plugins = [
        "git"
        "docker"
        "sudo" # Nhấn Esc 2 lần để thêm sudo vào lệnh trước đó
        "extract" # Lệnh 'extract' giải nén mọi loại file (.zip, .tar.gz, .rar...)
      ];
    };

    # 2. Shell aliases (minimal, most in aliases.zsh)
    shellAliases = {
      hm     = "home-manager";
      hms    = "home-manager switch --show-trace --impure";
      hmsf   = "home-manager switch --show-trace --impure --flake .";
      hmsb   = "home-manager switch -b backup --show-trace --impure";
      update = "sudo apt update && sudo apt upgrade && flatpak update -y";
      pkg    = "pkg_list";

      # General
      cl  = "clear";
      ls  = "eza --icons";
      la  = "eza -a --icons";
      ll  = "eza -l --icons --git";
      lla = "eza -la --icons --git";
      # Tree view: Level 2 is usually more useful than Level 1
      lt  = "eza --tree --level=2 --icons --git -I 'node_modules|.git'";

      # Pro Navigation: Instead of ... use a smart "Up" command
      # This allows: 'up 3' to go up 3 levels
      up = "cd .."; 

      # Advanced
      lg = "lazygit";
      yz = "yazi";
      zj = "zellij";
      # Tìm file bằng fd và mở ngay bằng helix
      hf = "hx $(fd --type f | fzf --preview 'bat --color=always {}')";
    };

    # 3. Cấu hình History
    history = {
      size       = 100000;
      save       = 100000;
      path       = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      share      = true;
      extended   = true;
    };

    # 4. Phần tùy chỉnh bổ sung
    initContent = ''
      # Source custom aliases and functions
      # source ~/.config/zsh/functions.zsh
      source ${./functions.zsh}

      # Đảm bảo biến SHELL luôn đúng trong mọi phiên làm việc zsh
      export SHELL=$(which zsh)
    '';
  };
}
