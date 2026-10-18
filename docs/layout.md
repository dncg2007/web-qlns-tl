# Layout và Responsive — Giai đoạn 2B

Layout được triển khai theo hướng **Mobile First**. Chỉ có hai mốc media query cố định: `768px` và `1024px`, vì CSS media query không dùng được giá trị từ `var()`.

## Các mốc responsive

| Mốc | Khung chung | Tổng quan | Nhân viên | Bảng lương |
|---|---|---|---|---|
| Mobile `< 768px` | `body` là Grid một cột; nav là tab cố định ở đáy; header sticky; main/footer xếp dọc; body chừa khoảng cho nav đáy | Một cột; `.khu-kpi` dùng `repeat(auto-fit, minmax(10rem, 1fr))` | Công cụ Flexbox wrap; bảng chuyển thành các thẻ hàng; form một cột; hồ sơ nhanh nằm sau form | Bộ chọn tháng Flexbox wrap; bảng chuyển thành các thẻ hàng; phiếu lương nằm sau bảng |
| `>= 768px` | `body` là Grid hai cột với sidebar nav rộng `var(--rong-nav)`; nav sticky cao `100vh`; bỏ padding đáy | Vẫn giữ dòng chảy một cột của nội dung | Bảng trở lại dạng bảng thật; wrapper bảng cho phép cuộn ngang; mỗi fieldset và form dùng 2 cột | Bảng trở lại dạng bảng thật; wrapper bảng cho phép cuộn ngang |
| `>= 1024px` | `--rong-nav` đổi thành `15rem`; main giới hạn bởi `--rong-noi-dung` | Bento 4 cột: KPI và tiêu đề trải 4 cột; biểu đồ/hợp đồng mỗi khối 2 cột; lối tắt trải 4 cột | Master-detail 2 cột, hồ sơ nhanh sticky rộng `20rem` | Master-detail 2 cột, phiếu lương sticky rộng `20rem` |

## Sơ đồ Grid Areas

### Khung chung từ `768px`

```text
body
├── nav    │ header
├── nav    │ main
└── nav    │ footer
```

### `index.html` từ `1024px`

```text
trang-tong-quan
├── tieu-de  tieu-de  tieu-de  tieu-de
├── kpi      kpi      kpi      kpi
├── bieu-do  bieu-do  het-han  het-han
└── loi-tat  loi-tat  loi-tat  loi-tat
```

### `nhan-vien.html` từ `1024px`

```text
trang-nhan-vien
├── tieu-de    tieu-de
├── cong-cu    cong-cu
├── danh-sach  ho-so
└── bieu-mau   ho-so
```

### `bang-luong.html` từ `1024px`

```text
trang-bang-luong
├── tieu-de    tieu-de
├── chon-thang chon-thang
└── bang       phieu
```

## Kỹ thuật bảng trên mobile

Dưới `768px`, `thead` được ẩn về mặt hiển thị bằng kỹ thuật tương đương `.sr-only` nhưng vẫn tồn tại trong DOM để trình đọc màn hình tiếp cận. Mỗi `tr` trở thành một khối, mỗi `td` dùng Flexbox và nhãn cột được dựng bằng `td::before { content: attr(data-cot); }`.

Từ `768px`, CSS khôi phục `table`, `table-row-group`, `table-row` và `table-cell`. Chỉ wrapper `.bang-cuon` được phép cuộn ngang để bảng không làm tràn toàn trang.
