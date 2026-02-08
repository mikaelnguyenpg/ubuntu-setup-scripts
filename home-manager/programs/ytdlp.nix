{ config, pkgs, lib, ... }:

{
  programs.yt-dlp = {
    enable = true;
    # Gói bổ trợ để ghép Video và Audio chất lượng cao (bắt buộc phải có)
    extraPackages = [ pkgs.ffmpeg ]; 
  
    settings = {
      # --- Chất lượng & Định dạng ---
      # Ưu tiên video tốt nhất và audio tốt nhất, ghép lại thành mp4 hoặc mkv
      format = "bestvideo+bestaudio/best";
      merge-output-format = "mp4";

      # --- Lưu trữ & Đặt tên ---
      # Lưu vào thư mục Downloads, tên file: [Ngày] Tên_Video.mp4
      output = "~/Downloads/%(upload_date)s_%(title)s.%(ext)s";
    
      # --- Phụ đề & Metadata ---
      embed-subs = true;          # Nhúng phụ đề vào file
      write-auto-sub = true;      # Nếu không có sub cứng, tự lấy sub auto-gen
      sub-langs = "vi,en,*";      # Ưu tiên Tiếng Việt, Tiếng Anh rồi mới đến các tiếng khác
      embed-metadata = true;      # Nhúng luôn thumbnail và thông tin video vào file
      embed-chapters = true;      # Nhúng các chương (chapters) của video

      # --- Hiệu năng ---
      concurrent-fragments = 5;   # Tải 5 phân đoạn cùng lúc (nhanh hơn)
      continue = true;            # Cho phép tải tiếp nếu bị ngắt quãng
    };
  };
}
