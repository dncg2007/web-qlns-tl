/* 01b_Luong.sql: MucLuong, LuongNhanVien, ChamCong. Chạy trên CSDL QLNhanSu đã có 01_CSDL.sql */
USE QLNhanSu;
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
IF OBJECT_ID('dbo.ChamCong') IS NOT NULL DROP TABLE dbo.ChamCong;
IF OBJECT_ID('dbo.LuongNhanVien') IS NOT NULL DROP TABLE dbo.LuongNhanVien;
IF OBJECT_ID('dbo.MucLuong') IS NOT NULL DROP TABLE dbo.MucLuong;
GO

CREATE TABLE dbo.MucLuong (
    MaMucLuong   CHAR(4)       NOT NULL,
    TenMucLuong  NVARCHAR(100) NOT NULL,
    MoTa         NVARCHAR(500) NULL,
    HinhThuc     VARCHAR(5)    NOT NULL CONSTRAINT DF_MucLuong_HinhThuc DEFAULT ('Thang'),
    SoTien       INT           NOT NULL,   -- VND; theo tháng hoặc theo giờ tùy HinhThuc
    CONSTRAINT PK_MucLuong PRIMARY KEY (MaMucLuong),
    CONSTRAINT UQ_MucLuong_Ten UNIQUE (TenMucLuong),
    CONSTRAINT CK_MucLuong_Ma CHECK (MaMucLuong LIKE 'ML[0-9][0-9]'),
    CONSTRAINT CK_MucLuong_HinhThuc CHECK (HinhThuc IN ('Thang', 'Gio')),
    CONSTRAINT CK_MucLuong_SoTien CHECK (SoTien > 0)
);
GO

CREATE TABLE dbo.LuongNhanVien (
    MaLuongNhanVien CHAR(6) NOT NULL,
    MaNV            CHAR(6) NOT NULL,
    MaMucLuong      CHAR(4) NOT NULL,
    NgayBatDau      DATE    NOT NULL,
    NgayKetThuc     DATE    NULL,          -- NULL = dòng lương hiện hành
    CONSTRAINT PK_LuongNhanVien PRIMARY KEY (MaLuongNhanVien),
    CONSTRAINT CK_LuongNV_Ma  CHECK (MaLuongNhanVien LIKE 'LN[0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_LuongNV_Ngay CHECK (NgayBatDau < NgayKetThuc),
    CONSTRAINT UQ_LuongNV_NV_Bd UNIQUE (MaNV, NgayBatDau),
    CONSTRAINT FK_LuongNV_NhanVien FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien (MaNV),
    CONSTRAINT FK_LuongNV_MucLuong FOREIGN KEY (MaMucLuong) REFERENCES dbo.MucLuong (MaMucLuong)
);
GO
-- Mỗi nhân viên tối đa 1 dòng lương hiện hành
CREATE UNIQUE INDEX UX_LuongNV_HienHanh ON dbo.LuongNhanVien (MaNV) WHERE NgayKetThuc IS NULL;
GO

CREATE TABLE dbo.ChamCong (
    MaChamCong CHAR(8)      NOT NULL,
    MaNV       CHAR(6)      NOT NULL,
    Thang      CHAR(7)      NOT NULL,      -- yyyy-mm
    NgayCong   TINYINT      NOT NULL,
    PhuCap     INT          NOT NULL CONSTRAINT DF_ChamCong_PhuCap DEFAULT (0),
    SoGio      DECIMAL(5,1) NULL,          -- chỉ dùng cho lương theo giờ
    CONSTRAINT PK_ChamCong PRIMARY KEY (MaChamCong),
    CONSTRAINT UQ_ChamCong_NV_Thang UNIQUE (MaNV, Thang),
    CONSTRAINT CK_ChamCong_Ma CHECK (MaChamCong LIKE 'CC[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_ChamCong_Thang CHECK (Thang LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'
        AND RIGHT(Thang, 2) BETWEEN '01' AND '12' AND LEFT(Thang, 4) >= '2000'),
    CONSTRAINT CK_ChamCong_NgayCong CHECK (NgayCong BETWEEN 0 AND 26),
    CONSTRAINT CK_ChamCong_PhuCap CHECK (PhuCap >= 0),
    CONSTRAINT CK_ChamCong_SoGio CHECK (SoGio IS NULL OR (SoGio >= 0 AND SoGio <= 744)),
    CONSTRAINT FK_ChamCong_NhanVien FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien (MaNV)
);
GO