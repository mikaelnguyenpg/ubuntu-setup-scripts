{ pkgs }:
let
  # 1. NHÓM THƯ VIỆN ĐỒ HỌA & GIAO DIỆN (UI/UX)
  # Tauri dùng WebView của hệ thống để hiển thị giao diện Web (Next.js)
  ui-libs = with pkgs; [
    gtk3              # Thư viện cửa sổ phổ biến nhất trên Linux
    webkitgtk_4_1     # Trình duyệt lõi (Engine) để render giao diện Tauri 2
    cairo             # Vẽ đồ họa 2D (GTK cần cái này)
    pango             # Xử lý văn bản và font chữ
    harfbuzz          # Sắp xếp các ký tự đồ họa (text shaping)
    gdk-pixbuf        # Hỗ trợ hiển thị các định dạng ảnh (png, jpg)
    librsvg           # Hỗ trợ hiển thị ảnh Vector (.svg) - rất quan trọng cho Icon
  ];

  # 2. NHÓM KẾT NỐI & HỆ THỐNG (System Services)
  # Giúp App giao tiếp với các thành phần khác của hệ điều hành
  system-libs = with pkgs; [
    libsoup_3         # Thư viện HTTP client (Tauri 2 dùng bản v3 để call API)
    glib              # Thư viện lõi của GNOME, quản lý bộ nhớ và cấu trúc dữ liệu C
    at-spi2-atk       # Hỗ trợ các tính năng hỗ trợ người khuyết tật (Accessibility)
    atkmm             # Bản bọc C++ cho ATK (đôi khi webkit yêu cầu)
    openssl           # Xử lý bảo mật, mã hóa HTTPS/SSL
  ];

  # Tổng hợp tất cả thư viện runtime
  libraries = ui-libs ++ system-libs;

in {
  # 3. NHÓM CÔNG CỤ BIÊN DỊCH (Build Tools)
  # Những thứ này chỉ dùng lúc bạn gõ lệnh 'cargo tauri build/dev'
  packages = with pkgs; [
    # rustup            # Trình quản lý Rust (cargo, rustc...)
    rustc             # Trình biên dịch Rust
    cargo             # Trình quản lý package của Rust
    rust-analyzer     # LSP cho soạn thảo code
    clippy            # Công cụ check lỗi logic/style
    rustfmt           # Công cụ format code

    pkg-config        # CỰC KỲ QUAN TRỌNG: Giúp trình biên dịch tìm thấy các thư viện C ở trên
    dbus              # Cho phép ứng dụng gửi thông báo (notifications) hệ thống
    glib-networking   # Hỗ trợ kết nối mạng an toàn qua GLib (cần cho soup3)
    # cargo-tauri       # Lệnh CLI 'tauri' bản gốc của đội ngũ Tauri
    # tauri-cli
  ] ++ libraries;     # Gộp tất cả thư viện ở trên vào môi trường

  # 4. CẤU HÌNH BIẾN MÔI TRƯỜNG (Environment Variables)
  shellHook = ''
    # Nói cho trình biên dịch biết file .so (thư viện chạy) nằm ở đâu
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH

    # Nói cho pkg-config biết file .pc (thông tin compile) nằm ở đâu
    export PKG_CONFIG_PATH=${pkgs.lib.makeSearchPath "lib/pkgconfig" libraries}:$PKG_CONFIG_PATH
    
    # Sửa lỗi một số app không kết nối được TLS/SSL trên môi trường Nix
    export GIO_MODULE_DIR=${pkgs.glib-networking}/lib/gio/modules/
    
    echo "✅ Tauri 2 Dev Environment: Ready!"
  '';
}
