{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable                    = true;
    dotDir                    = config.home.homeDirectory;
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
      # --- Nix & Home Manager ---
      hm     = "home-manager";
      hms    = "home-manager switch --show-trace --impure";
      hmsf   = "home-manager switch --show-trace --impure --flake .";
      hmsb   = "home-manager switch -b backup --show-trace --impure";
      pkg    = "pkg_list";

      # --- System Maintenance ---
      update = "sudo apt update && sudo apt upgrade && flatpak update -y";
      cl     = "clear";

      # --- Modern Core Utils (eza & fd) ---
      ls     = "eza --icons";
      la     = "eza -a --icons";
      ll     = "eza -l --icons --git";
      lla    = "eza -la --icons --git";
      lt     = "eza --tree --level=2 --icons --git -I 'node_modules|.git'";
      up     = "cd ..";

      # --- TUI Tools & Terminal Productivity ---
      lzd    = "lazydocker";
      lzg    = "lazygit";
      mx     = "cmatrix";
      yz     = "yazi";
      zj     = "zellij";

      # --- Interactive Search & Edit ---
      # Tìm file nhanh và mở bằng Helix (với preview từ bat)
      hf     = "hx $(fd --type f | fzf --preview 'bat --color=always {}')";

      # --- Docker Management (The "Safe" Zone) ---
      dk-stop   = "docker stop $(docker ps -q)";
      dk-rm     = "docker rm $(docker ps -aq)";
      dk-tidy   = "docker system prune -f";

      # --- Docker Management (The "Danger" Zone) ---
      dk-rmi     = "docker rmi -f $(docker images -q)";
      dk-nuclear = "docker system prune -a --volumes -f";
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
