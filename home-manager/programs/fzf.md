# FZF

1. Cách sử dụng "như một Pro"

Sau khi home-manager switch, bạn hãy thử 3 tổ hợp phím sau trong Terminal:

- Ctrl + T: Tìm kiếm file. Khi bạn di chuyển lên xuống, nội dung file sẽ hiện ra bên phải (nhờ bat). Bạn có thể dùng phím Shift + Up/Down để cuộn nội dung trong cửa sổ preview.
- Alt + C: Tìm thư mục. Bên phải sẽ hiện ra cấu trúc cây của thư mục đó (nhờ eza).
- Ctrl + R: Tìm lại lệnh cũ. Nó sẽ lọc cực nhanh dựa trên những gì bạn gõ.

2. Tại sao combo này lại "hủy diệt"?

- Tiết kiệm thời gian: Bạn không cần cat hay hx vào từng file để xem nó chứa gì. Chỉ cần lướt qua bằng Ctrl + T.
- Thông minh: Nó tự động bỏ qua node_modules, giúp bạn không bị "lạc" trong hàng ngàn file thư viện khi đang tìm code của mình.
- Đồng bộ: Màu sắc của FZF, Bat, và Eza đều được cấu hình theo tông Tokyo Night, tạo cảm giác đồng nhất với Ghostty và Helix.

Tổng kết hệ thống của bạn lúc này:
Đến đây, bộ khung Terminal của bạn đã cực kỳ mạnh: Zsh (gợi ý lệnh) + Starship (prompt đẹp) + Tmux/Zellij (chia màn hình) + Fzf/Bat (tìm kiếm có preview).

3. Sự khác biệt giữa fd và các phím tắt FZF

Khi bạn cài đặt fzf và bật enableZshIntegration, các phím tắt này sẽ xuất hiện.
Đây là cách chúng phối hợp với fd:

| Phím tắt | Mục đích                               | Cách nó dùng fd                                                                               |
| -------- | -------------------------------------- | --------------------------------------------------------------------------------------------- |
| Ctrl + T | Tìm Tên File để dán vào dòng lệnh.     | Nó gọi fd để quét nhanh toàn bộ cây thư mục, đưa kết quả vào cửa sổ mờ của fzf để bạn chọn.   |
| Alt + C  | Di chuyển nhanh (CD) vào thư mục.      | Nó gọi fd --type d (chỉ tìm folder). Khi bạn chọn 1 folder, nó tự thực hiện lệnh cd vào đó.   |
| Ctrl + R | Tìm lại Lịch sử lệnh (Reverse search). | Không dùng fd. Nó đọc file ~/.zsh_history để giúp bạn tìm lại những lệnh bạn đã gõ trước đây. |

**Tóm tắt cấu trúc hoạt động**

- fd: Thợ săn (đi tìm dữ liệu trong ổ cứng).
- fzf: Bộ lọc (hiện danh sách cho bạn chọn và preview nội dung).
- Ctrl + T / Alt + C: Lệnh triệu hồi thợ săn và bộ lọc.
