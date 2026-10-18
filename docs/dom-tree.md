# DOM Tree

## Khung chung

```text
body (grid, không bọc div)
├── header
│   ├── a (tên hệ thống)
│   ├── form[role="search"]
│   ├── input[type="checkbox"]#che-do-toi
│   └── label[for="che-do-toi"] (Chế độ tối)
├── nav[aria-label]
│   └── ul
│       └── li × 3
│           └── a
├── main
└── footer
    ├── p
    └── address
```

## `index.html`

```text
main
├── h1
├── section[aria-labelledby] KPI
│   └── article × 4
├── section[aria-labelledby] biểu đồ cột
│   └── article
│       └── figure
│           └── figcaption
├── section[aria-labelledby] hợp đồng sắp hết hạn
│   └── article
│       └── ul
│           └── li
│               └── time
└── aside[aria-labelledby] lối tắt
```

## `nhan-vien.html`

```text
main
├── h1
├── section[aria-labelledby] form tìm kiếm
│   ├── input[type="search"]
│   ├── select
│   ├── fieldset (radio)
│   └── button (Thêm)
├── section[aria-labelledby] danh sách nhân viên
│   └── div (bọc bảng để cuộn ngang)
│       └── table
├── section[aria-labelledby] form nhân viên
│   └── form
│       └── fieldset × 4
└── aside[aria-labelledby] hồ sơ nhanh
    └── article
        ├── figure
        ├── h2
        ├── dl
        └── details
```

## `bang-luong.html`

```text
main
├── h1
├── section[aria-labelledby] form chọn tháng
│   ├── input[type="month"]
│   └── button
├── section[aria-labelledby] bảng chấm công và lương
│   └── div (bọc bảng để cuộn ngang)
│       └── table
│           ├── input[type="number"] (ngày công)
│           └── tfoot (tổng quỹ)
└── aside[aria-labelledby] phiếu lương
    └── article
        ├── h2
        ├── dl
        ├── p
        └── button (In)
```
