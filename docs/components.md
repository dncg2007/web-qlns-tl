# Components — Giai đoạn 2C

Các component chỉ dùng CSS và markup semantic hiện có. Giai đoạn 2D bổ sung transition/keyframes có kiểm soát; chưa có JavaScript.

## Bảng thành phần

| Thành phần/class | Dùng ở đâu | Hook `data-*` / `aria-*` liên quan | Hover/focus/disabled |
|---|---|---|---|
| `header` | Khung đầu trang của cả ba trang | `#che-do-toi`, label `for="che-do-toi"` | Sticky; checkbox dùng `:focus-visible` chung |
| `nav` | Điều hướng chính | `aria-label`, `a[aria-current="page"]` | Mục hiện tại dùng nền chính nhạt và màu chính |
| `.the` | KPI, biểu đồ, hợp đồng, công cụ, form, hồ sơ nhanh, phiếu lương | Kết hợp với `aria-labelledby` của section/aside | Nền thẻ, viền, bo góc, bóng |
| `.the-tuong-tac` | KPI, biểu đồ và hợp đồng sắp hết hạn | Không cần data hook riêng | Hover nâng thẻ bằng transform và bóng nổi |
| `.nut` | Button và liên kết hành động | Có thể kết hợp `.nut-vien`, `.nut-nguy-hiem`, `.nut-nho` | `:hover`, `:focus-visible`, `[disabled]` |
| `.nut-vien` | Link lối tắt, nút Nhập lại và thao tác phụ | Không cần data hook riêng | Nền trong; hover dùng nền chính nhạt |
| `.nut-nguy-hiem` | Nút Xóa trong bảng | Không cần data hook riêng | Dùng màu lỗi; chữ vẫn có nội dung văn bản |
| `.nut-nho` | Nút tìm kiếm và thao tác trong bảng | Không cần data hook riêng | Kích thước nhỏ hơn; vẫn có focus rõ |
| `.thong-bao-loi` | Vùng thông báo trống dưới họ tên, email, điện thoại | `aria-describedby="loi-ho-ten"`, `loi-email`, `loi-dien-thoai` | Màu lỗi, cỡ chữ nhỏ; nội dung sẽ được bổ sung ở giai đoạn logic |
| `.so-tien` | Ô lương, phụ cấp, thực lĩnh và tổng quỹ | `data-cot` giữ nhãn responsive | Căn phải và dùng tabular numerals |
| `.nhan` | Trạng thái và loại hợp đồng | `[data-trang-thai]`, `[data-loai-hd]` | Nền/chữ theo vai trò trạng thái |
| `.bieu-do-cot` | Biểu đồ quỹ lương trên trang Tổng quan | `.ty-le-10` đến `.ty-le-100`, `--ty-le` | Thanh dùng màu chính và rãnh màu chính nhạt |
| `.ho-so-nhanh` | Hồ sơ nhân viên | `aria-labelledby="quick-profile-heading"` | Ảnh tròn, `details/summary` có con trỏ |
| `.phieu-luong` | Phiếu lương cá nhân | `aria-labelledby="payslip-heading"` | Thực lĩnh nổi bật; nút In căn cuối |
| `.ds-hop-dong` | Danh sách hợp đồng sắp hết hạn | `[data-het-han="true"]` | Hàng Flexbox, viền trái cảnh báo và viền dưới |

## Quy tắc đặt tên class

1. Dùng tên tiếng Việt không dấu, phản ánh vai trò hoặc ngữ nghĩa của thành phần, ví dụ `.ho-so-nhanh` và `.phieu-luong`.
2. Dùng class component chung trước, sau đó mới dùng biến thể, ví dụ `.nut nut-nguy-hiem`.
3. Dùng tiền tố theo vùng đã có của layout khi class thuộc một khu vực, ví dụ `.khu-kpi`, `.khu-bang`, `.khu-bieu-mau`.
4. Không đặt tên class theo màu trực tiếp; màu phải được lấy từ token vai trò trong Design System.
5. Hook dữ liệu dùng `data-*`, trạng thái trợ năng dùng `aria-*`, còn class dành cho kiểu hiển thị và vai trò giao diện.
