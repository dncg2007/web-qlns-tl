# Website Quản lý Nhân sự & Tiền lương (HRM & Payroll)

Dự án front-end cho môn Thiết kế Web lớp 25CT114. Hệ thống mô phỏng quản lý nhân viên, hồ sơ nhanh, thống kê quân số và bảng lương theo dữ liệu mẫu front-end.

## Công nghệ

- HTML5 Semantic
- CSS3 Design System, Mobile First, Grid/Flexbox
- JavaScript ES6 thuần
- Không backend trong phạm vi front-end

## Cấu trúc thư mục

```text
.
├── index.html
├── nhan-vien.html
├── bang-luong.html
├── css/
│   └── styles.css
├── js/
│   ├── data.js
│   ├── features.js
│   ├── logic.js
│   └── theme.js
├── assets/images/
├── db/
├── docs/
└── prompt_log.md
```

## Cách chạy

Mở trực tiếp `index.html` bằng trình duyệt. Không cần cài package hay chạy backend.

## Link demo

https://dncg2007.github.io/web-qlns-tl/

<!-- TODO: Cập nhật sau khi bật GitHub Pages trên repository. -->

## Chức năng đã thực hiện

### Tổng quan — `index.html`

- KPI tổng nhân viên, đang làm, đã nghỉ.
- Quỹ lương và lương trung bình từ Data Contract.
- Quân số theo phòng ban.
- Biểu đồ thanh CSS thuần có số liệu bằng chữ.
- Danh sách hợp đồng sắp hết hạn.
- Lối tắt đến trang Nhân viên và Bảng lương.
- Chuyển giao diện Sáng/Tối, lưu lựa chọn bằng `localStorage` và tôn trọng thiết lập hệ điều hành.

### Nhân viên — `nhan-vien.html`

- Tìm kiếm không dấu theo họ tên, mã và điện thoại.
- Lọc theo phòng ban và trạng thái.
- Thống kê quân số toàn bộ danh sách.
- Form thêm nhân viên có validation thuần JavaScript.
- Hồ sơ nhanh và nút Xem hồ sơ.
- Bảng responsive mobile card.

### Bảng lương — `bang-luong.html`

- Chọn tháng và phòng ban.
- Tính lương theo mức lương, ngày công và phụ cấp.
- Tổng quỹ lương và số nhân viên có chấm công.
- Bảng responsive theo Data Contract front-end.

## Data Contract v1.1

| Thực thể | Khóa chính / liên kết | Ghi chú |
|---|---|---|
| `PhongBan` | `MaPB`, `MaTruongPhong` | Phòng ban và trưởng phòng |
| `NhanVien` | `MaNV`, `MaPB` | Mã theo định dạng SQL `NV0001` |
| `MucLuong` | `MaMucLuong` | Mức tiền lương |
| `LuongNhanVien` | `MaLuongNhanVien`, `MaNV`, `MaMucLuong` | `NgayKetThuc = NULL` là dòng hiện hành |
| `HopDongLaoDong` | `MaHD`, `MaNV` | `LoaiHD` thuộc 1, 2, 3 |
| `ChamCong` | `MaChamCong`, `MaNV`, `Thang` | Một dòng cho mỗi nhân viên/tháng |

`TrangThai` (`DangLam`/`DaNghi`) là trường mô phỏng dẫn xuất từ view `dbo.v_NhanVien_TrangThai`, không phải cột SQL lưu trực tiếp.

## Giới hạn đã biết

- Dữ liệu thêm mới chỉ nằm trong bộ nhớ; tải lại trang sẽ mất dữ liệu.
- Nhân viên thêm mới chưa có hợp đồng/lương/chấm công nên chưa xuất hiện trong bảng lương.
- `MaLuongNhanVien` đang dùng định dạng front-end `L####`, chờ xác nhận triển khai vật lý từ AI Database.
- Chưa có backend hoặc kết nối SQL Server trong phạm vi front-end.

## Thành viên nhóm

| Họ tên | MSSV | Vai trò |
|---|---|---|
| ____________________ | ____________________ | ____________________ |
| ____________________ | ____________________ | ____________________ |

## Quy ước Git

- Nhánh tính năng: `feature/*`.
- Commit: `[Loại]: mô tả`.
- Loại đề xuất: `[Feat]`, `[Fix]`, `[Style]`, `[Docs]`, `[Refactor]`.
- Mỗi tính năng mở Pull Request về `main`.
