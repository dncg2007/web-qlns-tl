/* Data Contract: dữ liệu mẫu phòng ban và nhân viên cho Sprint 1. */

const PHONG_BAN = [
  {
    MaPB: "PB01",
    TenPB: "Phòng Nhân sự",
    MoTa: "Quản lý tuyển dụng, hồ sơ và chính sách nhân sự.",
    MaTruongPhong: "NV001"
  },
  {
    MaPB: "PB02",
    TenPB: "Phòng Kỹ thuật",
    MoTa: "Phát triển và vận hành các sản phẩm công nghệ.",
    MaTruongPhong: "NV002"
  },
  {
    MaPB: "PB03",
    TenPB: "Phòng Kinh doanh",
    MoTa: "Phụ trách khách hàng, doanh số và phát triển thị trường.",
    MaTruongPhong: "NV003"
  },
  {
    MaPB: "PB04",
    TenPB: "Phòng Tài chính",
    MoTa: "Theo dõi ngân sách, kế toán và báo cáo tài chính.",
    MaTruongPhong: "NV004"
  }
];

const NHAN_VIEN = [
  {
    MaNV: "NV001",
    HoTen: "Nguyễn Thị Mai",
    HinhAnh: "",
    GioiTinh: "Nữ",
    NgaySinh: "1988-04-12",
    CMND: "272000001",
    NgayCap: "2014-05-20",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Đồng Nai",
    DienThoai: "0901000001",
    MaPB: "PB01",
    ChucVu: "Trưởng phòng",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV002",
    HoTen: "Trần Minh Quân",
    HinhAnh: "",
    GioiTinh: "Nam",
    NgaySinh: "1986-09-25",
    CMND: "272000002",
    NgayCap: "2013-10-14",
    NoiCap: "CA Thành phố Hồ Chí Minh",
    QueQuan: "Bình Dương",
    DienThoai: "0901000002",
    MaPB: "PB02",
    ChucVu: "Trưởng phòng",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV003",
    HoTen: "Lê Hoàng Nam",
    HinhAnh: "",
    GioiTinh: "Nam",
    NgaySinh: "1989-02-08",
    CMND: "272000003",
    NgayCap: "2015-08-09",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Đồng Nai",
    DienThoai: "0901000003",
    MaPB: "PB03",
    ChucVu: "Trưởng phòng",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV004",
    HoTen: "Phạm Thu Hằng",
    HinhAnh: "",
    GioiTinh: "Nữ",
    NgaySinh: "1987-11-19",
    CMND: "272000004",
    NgayCap: "2014-12-02",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Bà Rịa - Vũng Tàu",
    DienThoai: "0901000004",
    MaPB: "PB04",
    ChucVu: "Trưởng phòng",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV005",
    HoTen: "Đỗ Minh Anh",
    HinhAnh: "",
    GioiTinh: "Nữ",
    NgaySinh: "1994-01-30",
    CMND: "272000005",
    NgayCap: "2018-02-18",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Đồng Nai",
    DienThoai: "0901000005",
    MaPB: "PB01",
    ChucVu: "Chuyên viên nhân sự",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV006",
    HoTen: "Võ Quốc Bảo",
    HinhAnh: "",
    GioiTinh: "Nam",
    NgaySinh: "1992-06-16",
    CMND: "272000006",
    NgayCap: "2017-07-21",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Long An",
    DienThoai: "0901000006",
    MaPB: "PB02",
    ChucVu: "Lập trình viên",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV007",
    HoTen: "Nguyễn Khánh Linh",
    HinhAnh: "",
    GioiTinh: "Khác",
    NgaySinh: "1995-03-22",
    CMND: "272000007",
    NgayCap: "2019-04-10",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Đồng Nai",
    DienThoai: "0901000007",
    MaPB: "PB03",
    ChucVu: "Chuyên viên kinh doanh",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV008",
    HoTen: "Bùi Thanh Tâm",
    HinhAnh: "",
    GioiTinh: "Nam",
    NgaySinh: "1991-08-03",
    CMND: "272000008",
    NgayCap: "2016-09-15",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Tây Ninh",
    DienThoai: "0901000008",
    MaPB: "PB04",
    ChucVu: "Kế toán viên",
    TrangThai: "DangLam"
  },
  {
    MaNV: "NV009",
    HoTen: "Huỳnh Ngọc Yến",
    HinhAnh: "",
    GioiTinh: "Nữ",
    NgaySinh: "1993-12-11",
    CMND: "272000009",
    NgayCap: "2017-01-26",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Đồng Nai",
    DienThoai: "0901000009",
    MaPB: "PB01",
    ChucVu: "Chuyên viên tuyển dụng",
    TrangThai: "DaNghi"
  },
  {
    MaNV: "NV010",
    HoTen: "Đặng Gia Huy",
    HinhAnh: "",
    GioiTinh: "Nam",
    NgaySinh: "1990-10-27",
    CMND: "272000010",
    NgayCap: "2015-11-30",
    NoiCap: "CA Đồng Nai",
    QueQuan: "Bình Phước",
    DienThoai: "0901000010",
    MaPB: "PB02",
    ChucVu: "Chuyên viên kiểm thử",
    TrangThai: "DaNghi"
  }
];
