# Motion — Giai đoạn 2D

Giai đoạn 2D bổ sung chuyển động có kiểm soát cho các component, không thay đổi layout 2B và chưa dùng JavaScript. Animate.css được nạp từ CDN để minh họa các animation xuất hiện khi tải trang.

## Bảng chuyển động

| Phần tử | Hiệu ứng | Công cụ | Thuộc tính chuyển động | Thời lượng | Easing |
|---|---|---|---|---|---|
| `.nut` | Nâng nhẹ khi hover, nén khi active | `transition` | `transform`, `box-shadow`, `background-color`, `border-color` | `0.3s` | `--duong-cong` |
| `.the-tuong-tac` | Nâng thẻ khi hover | `transition` | `transform`, `box-shadow` | `0.3s` | `--duong-cong` |
| `nav a` | Đổi trạng thái mục điều hướng | `transition` | `background-color`, `color` | `0.2s` | `--duong-cong` |
| `input`, `select`, `textarea` | Làm rõ focus | `transition` | `border-color`, `box-shadow` | `0.2s` | `--duong-cong` |
| Hàng `tbody tr` | Đổi nền khi hover | `transition` | `background-color` | `0.2s` | `--duong-cong` |
| Thanh biểu đồ `.thanh` | Mọc từ trái sang phải | `@keyframes moc-thanh` | `transform: scaleX()` | `0.6s` | `--duong-cong` |
| `.vong-quay` | Quay khi đang tải | `@keyframes quay` | `transform: rotate()` | `0.8s` | `linear`, lặp vô hạn |
| `h1` | Xuất hiện từ phía trên | Animate.css `fadeInDown` | `transform`, `opacity` | CDN `--animate-duration` | Animate.css |
| Card KPI | Xuất hiện từ phía dưới | Animate.css `fadeInUp` | `transform`, `opacity` | CDN `--animate-duration` | Animate.css |
| Card biểu đồ | Mờ dần khi xuất hiện | Animate.css `fadeIn` | `opacity` | CDN `--animate-duration` | Animate.css |
| Hồ sơ nhanh/phiếu lương | Xuất hiện từ bên phải | Animate.css `fadeInRight` | `transform`, `opacity` | CDN `--animate-duration` | Animate.css |

## Quy tắc chuyển động

1. Ưu tiên `transform` và `opacity` vì chúng phù hợp với compositing và không làm thay đổi dòng chảy layout.
2. Chỉ transition các thuộc tính cụ thể; không dùng `transition: all`.
3. Không animate `width`, `height`, `top`, `left`, `right`, `bottom`, `margin` hoặc `padding`.
4. Chuyển động nhỏ cần thời lượng từ `0.2s` đến `0.4s`; animation tải dữ liệu có thể dài hơn một chút nhưng không quá `0.8s` nếu không lặp.
5. Luôn hỗ trợ `prefers-reduced-motion`; spinner là ngoại lệ duy nhất được lặp vô hạn và phải đứng yên khi người dùng giảm chuyển động.

## Vì sao spinner dùng `linear`?

Spinner biểu thị một vòng quay liên tục. `linear` giữ tốc độ góc ổn định, tránh cảm giác tăng/giảm tốc ở mỗi vòng. `ease-in-out` phù hợp với chuyển động vào/ra một lần nhưng làm spinner bị chậm ở đầu và cuối vòng, nên không phù hợp với trạng thái đang tải.

## Kiểm tra bằng DevTools

1. Mở DevTools và dùng **Rendering → Emulate CSS media feature `prefers-reduced-motion: reduce`** để xác nhận mọi animation/transition dừng lại nhưng nội dung vẫn hiển thị.
2. Bật **Paint flashing** để quan sát hover card, button và hàng bảng; chuyển động nên giới hạn ở phần tử nhỏ.
3. Trong tab **Computed**, kiểm tra transition chỉ liệt kê thuộc tính cụ thể và không có `transition: all`.
4. Gỡ `hidden` khỏi `.trang-thai-tai` trong Inspector để xem spinner; chữ “Đang tính lương…” phải hiển thị cùng vòng quay.
5. Tải lại trang và xác nhận thanh biểu đồ mọc bằng `transform`, không làm thay đổi chiều rộng layout.
