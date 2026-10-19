USE QLNhanSu;
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
IF OBJECT_ID('dbo.BangLuong')    IS NOT NULL DROP TABLE dbo.BangLuong;
IF OBJECT_ID('dbo.NhatKyLuong')  IS NOT NULL DROP TABLE dbo.NhatKyLuong;
IF OBJECT_ID('dbo.ThanNhan')     IS NOT NULL DROP TABLE dbo.ThanNhan;
GO

CREATE TABLE dbo.ThanNhan (
    MaTN     CHAR(6)       NOT NULL,
    MaNV     CHAR(6)       NOT NULL,
    HoTen    NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(3)   NOT NULL,
    NgaySinh DATE          NULL,
    QuanHe   NVARCHAR(30)  NOT NULL,
    CONSTRAINT PK_ThanNhan PRIMARY KEY (MaTN),
    CONSTRAINT CK_ThanNhan_Ma CHECK (MaTN LIKE 'TN[0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_ThanNhan_GioiTinh CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    CONSTRAINT CK_ThanNhan_HoTen CHECK (LEN(LTRIM(RTRIM(HoTen))) > 0),
    CONSTRAINT CK_ThanNhan_QuanHe CHECK (LEN(LTRIM(RTRIM(QuanHe))) > 0),
    CONSTRAINT CK_ThanNhan_NgaySinh CHECK (NgaySinh IS NULL OR NgaySinh <= GETDATE()),
    CONSTRAINT UQ_ThanNhan_NV_HoTen UNIQUE (MaNV, HoTen),
    CONSTRAINT FK_ThanNhan_NhanVien FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien (MaNV)
);
GO

CREATE TABLE dbo.NhatKyLuong (          -- trigger ở M3 sẽ ghi vào đây
    MaNhatKy       INT IDENTITY(1,1) NOT NULL,
    MaNV           CHAR(6)      NOT NULL,
    MaMucLuongCu   CHAR(4)      NULL,
    MaMucLuongMoi  CHAR(4)      NOT NULL,
    NgayDoi        DATETIME2(0) NOT NULL CONSTRAINT DF_NhatKyLuong_NgayDoi DEFAULT (SYSDATETIME()),
    NguoiDoi       SYSNAME      NOT NULL CONSTRAINT DF_NhatKyLuong_NguoiDoi DEFAULT (SUSER_SNAME()),
    CONSTRAINT PK_NhatKyLuong PRIMARY KEY (MaNhatKy),
    CONSTRAINT FK_NhatKyLuong_NhanVien FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien (MaNV),
    CONSTRAINT FK_NhatKyLuong_MucCu  FOREIGN KEY (MaMucLuongCu)  REFERENCES dbo.MucLuong (MaMucLuong),
    CONSTRAINT FK_NhatKyLuong_MucMoi FOREIGN KEY (MaMucLuongMoi) REFERENCES dbo.MucLuong (MaMucLuong)
);
GO

CREATE TABLE dbo.BangLuong (            -- kết quả của sp_TinhLuongThang
    MaBangLuong    INT IDENTITY(1,1) NOT NULL,
    MaNV           CHAR(6)  NOT NULL,
    Thang          CHAR(7)  NOT NULL,
    LuongNgayCong  BIGINT   NOT NULL,
    PhuCap         BIGINT   NOT NULL,
    BaoHiem        BIGINT   NOT NULL,
    ThucLanh       BIGINT   NOT NULL,
    NgayTinh       DATETIME2(0) NOT NULL CONSTRAINT DF_BangLuong_NgayTinh DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_BangLuong PRIMARY KEY (MaBangLuong),
    CONSTRAINT UQ_BangLuong_NV_Thang UNIQUE (MaNV, Thang),
    CONSTRAINT CK_BangLuong_Thang CHECK (Thang LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]'
        AND RIGHT(Thang, 2) BETWEEN '01' AND '12'),
    CONSTRAINT CK_BangLuong_SoTien CHECK (LuongNgayCong >= 0 AND PhuCap >= 0 AND BaoHiem >= 0 AND ThucLanh >= 0),
    CONSTRAINT FK_BangLuong_NhanVien FOREIGN KEY (MaNV) REFERENCES dbo.NhanVien (MaNV)
);
GO