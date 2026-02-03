{ config, pkgs, lib, ... }:

let
  # 1. Tải file preset từ GitHub của Starship
  nerdFontSymbols = builtins.fromTOML (builtins.readFile (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/starship/starship/master/docs/public/presets/toml/nerd-font-symbols.toml";
    sha256 = "sha256-MuszO59YVeqvtkabVSeHEGurky9a4bnGqa+Q4vBsn7s="; # Bạn sẽ cần chạy lệnh để lấy mã hash đúng
  }));

  # 2. Định nghĩa danh sách đen (Blacklist) và danh sách trắng (Whitelist)
  # Danh sách các mục gây lỗi (bạn cứ thấy lỗi cái nào thì thêm vào đây)
  unsupportedKeys = [ 
    "fortran" 
    "maven" 
    "xmake" 
  ];

  # Danh sách các OS mà Starship thực sự hỗ trợ (dựa trên lỗi bạn nhận được)
  validOSNames = [
    "NixOS" "Ubuntu" "Windows" "Macos" "Arch" "Debian" "Fedora" 
    "Alpine" "Android" "CentOS" "Gentoo" "Kali" "Linux" "Mint" "Pop"
  ];

  # 3. Làm sạch dữ liệu (Data Transformation)
  # Lọc bỏ fortran và các OS lạ
  cleanedRoot = builtins.removeAttrs nerdFontSymbols unsupportedKeys;

  # Chỉ giữ lại các OS hợp lệ
  # Dùng intersectAttrs để chỉ lấy những key tồn tại trong cả 2 (Gọn hơn filterAttrs)
  filteredOSSymbols = lib.getAttrs validOSNames cleanedRoot.os.symbols;

  # Gộp lại thành bộ symbols hoàn chỉnh
  finalSymbols = cleanedRoot // {
    os = cleanedRoot.os // { symbols = filteredOSSymbols; };
  };
in {
  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableZshIntegration = true;
    # settings = lib.recursiveUpdate nerdFontSymbols {
    settings = finalSymbols // {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
