{ config, pkgs, ... }:

{
  # Khai báo các gói cần thiết ĐI KÈM với fzf
  home.packages = with pkgs; [
    bat  # Dùng để preview nội dung file có màu
    eza  # Dùng để preview thư mục dạng cây
    fd   # Dùng để tìm kiếm file cực nhanh (thay cho find)
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Thiết lập giao diện và phím tắt mặc định
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--color=bg+:#283457,bg:#16161e,spinner:#ff007c,hl:#ff9e64" # Màu chuẩn Tokyo Night
      "--color=fg:#c0caf5,header:#ff007c,info:#7aa2f7,pointer:#7aa2f7"
      "--color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#ff9e64"
    ];

    # 1. Tìm kiếm file (Ctrl + T) có Preview
    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];

    # 2. Tìm kiếm lịch sử lệnh (Ctrl + R) - Hiện lệnh đầy đủ trong cửa sổ nhỏ
    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];

    # 3. Di chuyển thư mục nhanh (Alt + C) có Preview dạng cây (tree)
    changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza --icons --tree --color=always {} | head -200'"
    ];
  };
}
