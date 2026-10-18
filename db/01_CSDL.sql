USE master;
GO
IF DB_ID(N'QLNhanSu') IS NOT NULL
BEGIN
    ALTER DATABASE QLNhanSu SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QLNhanSu;
END
GO
CREATE DATABASE QLNhanSu;
GO
USE QLNhanSu;
GO
SET QUOTED_IDENTIFIER ON;   -- bắt buộc cho chỉ mục lọc (filtered index)
SET ANSI_NULLS ON;
GO

/* ===== 1. PHONGBAN (chưa gắn FK MaTruongPhong vì NHANVIEN chưa tồn tại) ===== */
CREATE TABLE dbo.PhongBan (
    MaPB          CHAR(4)       NOT NULL,
    TenPB         NVARCHAR(100) NOT NULL,
    MoTa          NVARCHAR(500) NULL,
    MaTruongPhong CHAR(6)       NULL,
    CONSTRAINT PK_PhongBan       PRIMARY KEY (MaPB),
    CONSTRAINT UQ_PhongBan_TenPB UNIQUE (TenPB),
    CONSTRAINT CK_PhongBan_MaPB  CHECK (MaPB LIKE 'PB[0-9][0-9]'),
    CONSTRAINT CK_PhongBan_TenPB CHECK (LEN(LTRIM(RTRIM(TenPB))) > 0)
);
GO

/* ===== 2. NHANVIEN ===== */
CREATE TABLE dbo.NhanVien (
    MaNV             CHAR(6)       NOT NULL,
    HoTen            NVARCHAR(100) NOT NULL,
    HinhAnh          VARCHAR(260)  NULL,           -- đường dẫn ảnh, không lưu nhị phân
    GioiTinh         NVARCHAR(3)   NOT NULL,
    NgaySinh         DATE          NOT NULL,
    CMND             VARCHAR(12)   NOT NULL,       -- CMND 9 số hoặc CCCD 12 số
    NgayCap          DATE          NULL,
    NoiCap           NVARCHAR(100) NULL,
    QueQuan          NVARCHAR(100) NULL,
    DienThoai        VARCHAR(11)   NULL,
    Email            VARCHAR(100)  NULL,
    LoaiNV           VARCHAR(10)   NOT NULL
        CONSTRAINT DF_NhanVien_LoaiNV DEFAULT ('ChinhThuc'),
    ChucVu           NVARCHAR(50)  NOT NULL,
    MaPB             CHAR(4)       NOT NULL,
    MaQuanLyTrucTiep CHAR(6)       NULL,
    CONSTRAINT PK_NhanVien PRIMARY KEY (MaNV),
    CONSTRAINT UQ_NhanVien_CMND UNIQUE (CMND),
    CONSTRAINT CK_NhanVien_MaNV      CHECK (MaNV LIKE 'NV[0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NhanVien_HoTen     CHECK (LEN(LTRIM(RTRIM(HoTen))) > 0),
    CONSTRAINT CK_NhanVien_GioiTinh  CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    CONSTRAINT CK_NhanVien_NgaySinh  CHECK (NgaySinh >= '1900-01-01' AND NgaySinh <= GETDATE()),
    CONSTRAINT CK_NhanVien_CMND      CHECK (CMND NOT LIKE '%[^0-9]%' AND LEN(CMND) IN (9, 12)),
    CONSTRAINT CK_NhanVien_NgayCap   CHECK (NgayCap IS NULL OR (NgayCap > NgaySinh AND NgayCap <= GETDATE())),
    CONSTRAINT CK_NhanVien_DienThoai CHECK (DienThoai IS NULL
        OR (DienThoai NOT LIKE '%[^0-9]%' AND DienThoai LIKE '0%' AND LEN(DienThoai) IN (10, 11))),
    CONSTRAINT CK_NhanVien_Email     CHECK (Email IS NULL OR (Email LIKE '_%@_%._%' AND Email NOT LIKE '% %')),
    CONSTRAINT CK_NhanVien_LoaiNV    CHECK (LoaiNV IN ('ChinhThuc', 'ThoiVu')),
    CONSTRAINT CK_NhanVien_ChucVu    CHECK (LEN(LTRIM(RTRIM(ChucVu))) > 0),
    CONSTRAINT CK_NhanVien_KhongTuQuanLy CHECK (MaQuanLyTrucTiep IS NULL OR MaQuanLyTrucTiep <> MaNV),
    CONSTRAINT FK_NhanVien_PhongBan FOREIGN KEY (MaPB) REFERENCES dbo.PhongBan (MaPB),
    CONSTRAINT FK_NhanVien_QuanLy   FOREIGN KEY (MaQuanLyTrucTiep) REFERENCES dbo.NhanVien (MaNV)  -- đệ quy
);
GO
-- UNIQUE thường chỉ cho phép 1 giá trị NULL, nên dùng chỉ mục lọc để cho phép nhiều NV chưa có email
CREATE UNIQUE INDEX UX_NhanVien_Email ON dbo.NhanVien (Email) WHERE Email IS NOT NULL;
GO

/* ===== 3. Đóng vòng tham chiếu: PHONGBAN.MaTruongPhong → NHANVIEN.MaNV ===== */
ALTER TABLE dbo.PhongBan
    ADD CONSTRAINT FK_PhongBan_TruongPhong FOREIGN KEY (MaTruongPhong) REFERENCES dbo.NhanVien (MaNV);
GO
-- Một nhân viên chỉ làm trưởng phòng của tối đa một phòng
CREATE UNIQUE INDEX UX_PhongBan_TruongPhong ON dbo.PhongBan (MaTruongPhong) WHERE MaTruongPhong IS NOT NULL;
GO

/* ===== 4. HOPDONGLAODONG (theo đề thi mẫu; nguồn của TrangThai) ===== */
CREATE TABLE dbo.HopDongLaoDong (
    MaHD    CHAR(6) NOT NULL,
    MaNV    CHAR(6) NOT NULL,
    LoaiHD  TINYINT NOT NULL,      -- 1: không xác định thời hạn, 2: xác định thời hạn, 3: thời vụ
    TuNgay  DATE    NOT NULL,
    DenNgay DATE    NULL,          -- NULL: chưa có ngày kết thúc
    CONSTRAINT PK_HopDongLaoDong PRIMARY KEY (MaHD),
    CONSTRAINT CK_HopDong_MaHD CHECK (MaHD LIKE 'HD[0-9][0-9][0-9][0-9]'),
    CONSTRAINT FK_HopDong_NhanVien FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien (MaNV)
);
GO
-- Bổ sung ràng buộc bằng ALTER TABLE (Chương 3.4; Câu 2 đề thi mẫu)
-- TuNgay < DenNgay: khi DenNgay NULL, biểu thức là UNKNOWN nên CHECK vẫn cho qua
ALTER TABLE dbo.HopDongLaoDong ADD CONSTRAINT CK_HopDong_Ngay   CHECK (TuNgay < DenNgay);
ALTER TABLE dbo.HopDongLaoDong ADD CONSTRAINT CK_HopDong_LoaiHD CHECK (LoaiHD IN (1, 2, 3));
GO

/* ===== 5. VIEW: xử lý trường dẫn xuất TrangThai ===== */
CREATE OR ALTER VIEW dbo.v_NhanVien_TrangThai
AS
SELECT
    nv.MaNV, nv.HoTen, nv.GioiTinh, nv.NgaySinh, nv.DienThoai, nv.Email,
    nv.LoaiNV, nv.ChucVu,
    nv.MaPB, pb.TenPB,
    nv.MaQuanLyTrucTiep, ql.HoTen AS TenQuanLyTrucTiep,
    hd.NgayVaoLam,
    CASE WHEN hd.SoHDHieuLuc > 0 THEN 'DangLam' ELSE 'DaNghi' END AS TrangThai,
    CASE WHEN hd.SoHDHieuLuc > 0 THEN NULL ELSE hd.NgayKetThucCuoi END AS NgayNghiViec
FROM dbo.NhanVien AS nv
JOIN dbo.PhongBan AS pb ON pb.MaPB = nv.MaPB
LEFT JOIN dbo.NhanVien AS ql ON ql.MaNV = nv.MaQuanLyTrucTiep
OUTER APPLY (
    SELECT MIN(h.TuNgay)  AS NgayVaoLam,
           MAX(h.DenNgay) AS NgayKetThucCuoi,
           SUM(CASE WHEN h.TuNgay <= CAST(GETDATE() AS DATE)
                     AND (h.DenNgay IS NULL OR h.DenNgay >= CAST(GETDATE() AS DATE))
                    THEN 1 ELSE 0 END) AS SoHDHieuLuc
    FROM dbo.HopDongLaoDong AS h
    WHERE h.MaNV = nv.MaNV
) AS hd;
GO