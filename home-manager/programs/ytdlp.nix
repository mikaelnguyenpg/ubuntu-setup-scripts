{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.ffmpeg
    # Thêm trình chạy JS khác để dự phòng cho deno
    # pkgs.phantomjs2
  ];

  programs.yt-dlp = {
    enable = true;
  
    settings = {
      # --- Chất lượng & Định dạng ---
      # Ưu tiên video tốt nhất và audio tốt nhất, ghép lại thành mp4 hoặc mkv
      format = "bestvideo+bestaudio/best";
      merge-output-format = "mp4";

      # 2. Ép dùng client Web để tránh lỗi "GVS PO Token" của Android
      extractor-args = "youtube:player-client=web,android";
      # 3. Thêm tham số chống bị chặn (Throttling)
      # Giảm tốc độ yêu cầu một chút để YouTube không khóa IP
      sleep-subtitles = 2; # Nghỉ 2 giây giữa mỗi lần tải sub
      # 4. Giả lập trình duyệt sạch
      user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36";

      # --- Lưu trữ & Đặt tên ---
      # Lưu vào thư mục Downloads, tên file: [Ngày] Tên_Video.mp4
      output = "~/Downloads/%(upload_date)s_%(title)s.%(ext)s";
    
      # --- Phụ đề & Metadata ---
      embed-subs = true;          # Nhúng phụ đề vào file
      write-auto-sub = true;      # Nếu không có sub cứng, tự lấy sub auto-gen
      sub-langs = "vi,en";      # Ưu tiên Tiếng Việt, Tiếng Anh rồi mới đến các tiếng khác
      embed-metadata = true;      # Nhúng luôn thumbnail và thông tin video vào file
      embed-chapters = true;      # Nhúng các chương (chapters) của video

      # --- Hiệu năng ---
      concurrent-fragments = 5;   # Tải 5 phân đoạn cùng lúc (nhanh hơn)
      continue = true;            # Cho phép tải tiếp nếu bị ngắt quãng
    };
  };
}
