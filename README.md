# Website Quản lý Nhân sự & Tiền lương (HRM & Payroll)

Dự án môn **Thiết kế Web**, lớp **25CT114**, tập trung xây dựng giao diện front-end cho hệ thống quản lý nhân sự và tiền lương. Giai đoạn 1 đặt nền tảng cấu trúc, hợp đồng dữ liệu và kiến trúc trang; chưa triển khai trang trí giao diện hoặc logic nghiệp vụ.

## Thành viên

- Họ và tên: ____________________
- Mã sinh viên: ____________________
- Vai trò: ____________________

## Công nghệ

- HTML5 semantic
- CSS3
- JavaScript thuần (Vanilla JavaScript)
- Không sử dụng framework, thư viện ngoài hoặc backend

## Mục tiêu chức năng

- Tìm kiếm và lọc danh sách nhân viên.
- Thêm, sửa, xóa nhân viên kèm validation dữ liệu.
- Tính lương theo ngày công và các khoản phụ cấp.
- Dashboard thống kê các chỉ số nhân sự, quỹ lương và hợp đồng sắp hết hạn.

## Cấu trúc thư mục

```text
.
├── index.html                 # Trang tổng quan và dashboard
├── nhan-vien.html             # Trang quản lý nhân viên
├── bang-luong.html            # Trang bảng lương
├── css/
│   └── styles.css             # Reset và khung CSS nền tảng
├── js/
│   ├── data.js                # Data Contract
│   ├── logic.js               # Hàm thuần, không đụng DOM
│   └── features.js            # Sự kiện và kết xuất DOM
├── assets/
│   └── images/
│       └── .gitkeep           # Giữ thư mục hình ảnh trong Git
├── db/
│   └── .gitkeep               # Dành cho dữ liệu mô phỏng về sau
├── docs/
│   ├── sitemap.md             # Sơ đồ chức năng và điều hướng
│   └── dom-tree.md            # Cây DOM định hướng triển khai
├── prompt_log.md              # Nhật ký yêu cầu và định dạng đầu ra
└── .gitignore
```

## Quy ước Git

- Nhánh chính: `main`.
- Nhánh phát triển tính năng: `feature/*`.
- Commit dùng định dạng: `[Loại]: mô tả`.
- Một số loại commit đề xuất: `[HTML]`, `[CSS]`, `[JS]`, `[DOCS]`, `[CHORE]`.
- Tạo Pull Request từ nhánh `feature/*` vào `main` sau khi hoàn tất và tự kiểm tra.

## Cách chạy

Mở trực tiếp tệp `index.html` bằng trình duyệt. Có thể mở các trang `nhan-vien.html` và `bang-luong.html` từ menu điều hướng.

## Link demo

- Demo: ____________________
