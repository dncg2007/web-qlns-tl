USE QLNhanSu;
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/* ===== FUNCTION 1/4 (bảng inline): chi tiết lương 1 người, 1 tháng ===== */
CREATE OR ALTER FUNCTION dbo.fn_ChiTietLuong (@MaNV CHAR(6), @Thang CHAR(7))
RETURNS TABLE
AS RETURN
SELECT cc.MaNV, cc.Thang,
       CAST(x.LuongNgayCong AS BIGINT) AS LuongNgayCong,
       CAST(cc.PhuCap AS BIGINT)       AS PhuCap,
       CAST(y.BaoHiem AS BIGINT)       AS BaoHiem,
       CAST(x.LuongNgayCong + cc.PhuCap - y.BaoHiem AS BIGINT) AS ThucLanh
FROM dbo.ChamCong AS cc
CROSS APPLY (
    SELECT TOP 1 m.SoTien, m.HinhThuc
    FROM dbo.LuongNhanVien AS l
    JOIN dbo.MucLuong AS m ON m.MaMucLuong = l.MaMucLuong
    WHERE l.MaNV = cc.MaNV
      AND l.NgayBatDau <= EOMONTH(TRY_CAST(cc.Thang + '-01' AS DATE))
      AND (l.NgayKetThuc IS NULL OR l.NgayKetThuc >= TRY_CAST(cc.Thang + '-01' AS DATE))
    ORDER BY l.NgayBatDau DESC
) AS m
CROSS APPLY (
    SELECT CASE m.HinhThuc
             WHEN 'Thang' THEN ROUND(CAST(m.SoTien AS DECIMAL(18,2)) * cc.NgayCong / 26, 0)
             ELSE ROUND(CAST(m.SoTien AS DECIMAL(18,2)) * ISNULL(cc.SoGio, 0), 0) END AS LuongNgayCong
) AS x
CROSS APPLY (
    SELECT CASE WHEN m.HinhThuc = 'Thang' THEN ROUND(x.LuongNgayCong * 0.105, 0) ELSE 0 END AS BaoHiem
) AS y
WHERE cc.MaNV = @MaNV AND cc.Thang = @Thang;
GO
/* ===== FUNCTION 2/4 (vô hướng): lương thực lãnh; NULL nếu thiếu chấm công hoặc mức lương ===== */
CREATE OR ALTER FUNCTION dbo.fn_LuongThucLanh (@MaNV CHAR(6), @Thang CHAR(7))
RETURNS BIGINT
AS
BEGIN
    RETURN (SELECT ThucLanh FROM dbo.fn_ChiTietLuong(@MaNV, @Thang));
END;
GO
/* ===== FUNCTION 3/4 (bảng nhiều câu lệnh): mọi cấp dưới (CTE đệ quy) ===== */
CREATE OR ALTER FUNCTION dbo.fn_CapDuoi (@MaNV CHAR(6))
RETURNS @KQ TABLE (MaNV CHAR(6) PRIMARY KEY, HoTen NVARCHAR(100), Cap INT)
AS
BEGIN
    WITH D AS (
        SELECT MaNV, HoTen, 1 AS Cap FROM dbo.NhanVien WHERE MaQuanLyTrucTiep = @MaNV
        UNION ALL
        SELECT n.MaNV, n.HoTen, D.Cap + 1 FROM dbo.NhanVien AS n JOIN D ON n.MaQuanLyTrucTiep = D.MaNV
    )
    INSERT INTO @KQ (MaNV, HoTen, Cap) SELECT MaNV, HoTen, Cap FROM D;
    RETURN;
END;
GO

/* ===== PROCEDURE 1/5: thêm nhân viên kèm hợp đồng đầu tiên (QT6: mỗi NV >= 1 hợp đồng) ===== */
CREATE OR ALTER PROCEDURE dbo.SP_NhanVien_Insert
    @HoTen NVARCHAR(100), @GioiTinh NVARCHAR(3), @NgaySinh DATE, @CMND VARCHAR(12),
    @ChucVu NVARCHAR(50), @MaPB CHAR(4), @LoaiNV VARCHAR(10),
    @LoaiHD TINYINT, @TuNgay DATE, @DenNgay DATE = NULL,
    @MaQuanLyTrucTiep CHAR(6) = NULL, @NgayCap DATE = NULL, @NoiCap NVARCHAR(100) = NULL,
    @QueQuan NVARCHAR(100) = NULL, @DienThoai VARCHAR(11) = NULL, @Email VARCHAR(100) = NULL,
    @HinhAnh VARCHAR(260) = NULL,
    @MaNV CHAR(6) OUTPUT, @MaHD CHAR(6) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPB)
        THROW 50001, N'Phòng ban không tồn tại.', 1;
    IF (@LoaiNV = 'ThoiVu' AND @LoaiHD <> 3) OR (@LoaiNV = 'ChinhThuc' AND @LoaiHD NOT IN (1, 2))
        THROW 50002, N'Loại hợp đồng không khớp loại nhân viên (thời vụ: 3; chính thức: 1 hoặc 2).', 1;
    IF @LoaiHD IN (2, 3) AND @DenNgay IS NULL
        THROW 50003, N'Hợp đồng có thời hạn phải có ngày kết thúc.', 1;
    IF @MaQuanLyTrucTiep IS NOT NULL AND NOT EXISTS
        (SELECT 1 FROM dbo.v_NhanVien_TrangThai WHERE MaNV = @MaQuanLyTrucTiep AND TrangThai = 'DangLam')
        THROW 50004, N'Người quản lý không tồn tại hoặc đã nghỉ việc.', 1;
    IF DATEADD(YEAR, 18, @NgaySinh) > @TuNgay
        THROW 50005, N'Nhân viên chưa đủ 18 tuổi tại ngày bắt đầu hợp đồng.', 1;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @SoNV INT = ISNULL((SELECT MAX(CAST(RIGHT(MaNV, 4) AS INT)) FROM dbo.NhanVien WITH (UPDLOCK, HOLDLOCK)), 0) + 1;
        DECLARE @SoHD INT = ISNULL((SELECT MAX(CAST(RIGHT(MaHD, 4) AS INT)) FROM dbo.HopDongLaoDong WITH (UPDLOCK, HOLDLOCK)), 0) + 1;
        SET @MaNV = 'NV' + RIGHT('0000' + CAST(@SoNV AS VARCHAR(4)), 4);
        SET @MaHD = 'HD' + RIGHT('0000' + CAST(@SoHD AS VARCHAR(4)), 4);
        INSERT INTO dbo.NhanVien (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
                                  DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
        VALUES (@MaNV, @HoTen, @HinhAnh, @GioiTinh, @NgaySinh, @CMND, @NgayCap, @NoiCap, @QueQuan,
                @DienThoai, @Email, @LoaiNV, @ChucVu, @MaPB, @MaQuanLyTrucTiep);
        INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
        VALUES (@MaHD, @MaNV, @LoaiHD, @TuNgay, @DenNgay);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO

/* ===== PROCEDURE 2/5: chuyển phòng ban ===== */
CREATE OR ALTER PROCEDURE dbo.sp_ChuyenPhongBan
    @MaNV CHAR(6), @MaPBMoi CHAR(4), @MaQuanLyMoi CHAR(6) = NULL,   -- NULL: giữ quản lý hiện tại
    @LaTruongPhongCu BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @MaPBCu CHAR(4);
    SELECT @MaPBCu = MaPB FROM dbo.v_NhanVien_TrangThai WHERE MaNV = @MaNV AND TrangThai = 'DangLam';
    IF @MaPBCu IS NULL THROW 50011, N'Nhân viên không tồn tại hoặc đã nghỉ việc.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPBMoi) THROW 50012, N'Phòng ban mới không tồn tại.', 1;
    IF @MaPBCu = @MaPBMoi THROW 50013, N'Nhân viên đã thuộc phòng ban này.', 1;
    IF @MaQuanLyMoi IS NOT NULL
    BEGIN
        IF @MaQuanLyMoi = @MaNV OR NOT EXISTS
           (SELECT 1 FROM dbo.v_NhanVien_TrangThai WHERE MaNV = @MaQuanLyMoi AND TrangThai = 'DangLam')
            THROW 50014, N'Người quản lý mới không hợp lệ (trùng chính mình, không tồn tại hoặc đã nghỉ).', 1;
        IF EXISTS (SELECT 1 FROM dbo.fn_CapDuoi(@MaNV) WHERE MaNV = @MaQuanLyMoi)
            THROW 50015, N'Người quản lý mới là cấp dưới của nhân viên, sẽ tạo vòng quản lý.', 1;
    END
    BEGIN TRY
        BEGIN TRAN;
        SET @LaTruongPhongCu = 0;
        IF EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPBCu AND MaTruongPhong = @MaNV)
        BEGIN
            UPDATE dbo.PhongBan SET MaTruongPhong = NULL WHERE MaPB = @MaPBCu;
            SET @LaTruongPhongCu = 1;
        END
        UPDATE dbo.NhanVien
        SET MaPB = @MaPBMoi, MaQuanLyTrucTiep = ISNULL(@MaQuanLyMoi, MaQuanLyTrucTiep)
        WHERE MaNV = @MaNV;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO

/* ===== PROCEDURE 3/5: đổi mức lương (đóng dòng cũ, mở dòng mới) ===== */
CREATE OR ALTER PROCEDURE dbo.sp_DoiLuong
    @MaNV CHAR(6), @MaMucLuongMoi CHAR(4), @NgayHieuLuc DATE, @MaLuongNhanVien CHAR(6) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @LoaiNV VARCHAR(10), @HinhThucMoi VARCHAR(5), @MaMucCu CHAR(4), @BatDauCu DATE;
    SELECT @LoaiNV = nv.LoaiNV FROM dbo.NhanVien AS nv
    JOIN dbo.v_NhanVien_TrangThai AS t ON t.MaNV = nv.MaNV
    WHERE nv.MaNV = @MaNV AND t.TrangThai = 'DangLam';
    IF @LoaiNV IS NULL THROW 50031, N'Nhân viên không tồn tại hoặc đã nghỉ việc.', 1;
    SELECT @HinhThucMoi = HinhThuc FROM dbo.MucLuong WHERE MaMucLuong = @MaMucLuongMoi;
    IF @HinhThucMoi IS NULL THROW 50032, N'Mức lương mới không tồn tại.', 1;
    SELECT @MaMucCu = MaMucLuong, @BatDauCu = NgayBatDau FROM dbo.LuongNhanVien WHERE MaNV = @MaNV AND NgayKetThuc IS NULL;
    IF @MaMucCu IS NULL THROW 50033, N'Nhân viên chưa có dòng lương hiện hành.', 1;
    IF @MaMucCu = @MaMucLuongMoi THROW 50034, N'Mức lương mới trùng mức hiện hành.', 1;
    IF (@LoaiNV = 'ThoiVu' AND @HinhThucMoi <> 'Gio') OR (@LoaiNV = 'ChinhThuc' AND @HinhThucMoi <> 'Thang')
        THROW 50035, N'Hình thức mức lương không khớp loại nhân viên.', 1;
    IF DATEADD(DAY, -1, @NgayHieuLuc) <= @BatDauCu
        THROW 50036, N'Ngày hiệu lực phải sau ngày bắt đầu của dòng lương hiện hành ít nhất 2 ngày.', 1;
    BEGIN TRY
        BEGIN TRAN;
        SET @MaLuongNhanVien = 'LN' + RIGHT('0000' + CAST(ISNULL((SELECT MAX(CAST(RIGHT(MaLuongNhanVien, 4) AS INT))
                               FROM dbo.LuongNhanVien WITH (UPDLOCK, HOLDLOCK)), 0) + 1 AS VARCHAR(4)), 4);
        UPDATE dbo.LuongNhanVien SET NgayKetThuc = DATEADD(DAY, -1, @NgayHieuLuc)
        WHERE MaNV = @MaNV AND NgayKetThuc IS NULL;
        INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
        VALUES (@MaLuongNhanVien, @MaNV, @MaMucLuongMoi, @NgayHieuLuc, NULL);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO

/* ===== PROCEDURE 4/5: thống kê phòng ban ===== */
CREATE OR ALTER PROCEDURE dbo.sp_ThongKePhongBan
    @MaPB CHAR(4), @SoNVDangLam INT OUTPUT, @TongLuongThang BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPB)
        THROW 50051, N'Phòng ban không tồn tại.', 1;
    SELECT @SoNVDangLam = COUNT(*) FROM dbo.v_NhanVien_TrangThai WHERE MaPB = @MaPB AND TrangThai = 'DangLam';
    SELECT @TongLuongThang = ISNULL(SUM(CAST(m.SoTien AS BIGINT)), 0)
    FROM dbo.v_NhanVien_TrangThai AS t
    JOIN dbo.LuongNhanVien AS l ON l.MaNV = t.MaNV AND l.NgayKetThuc IS NULL
    JOIN dbo.MucLuong AS m ON m.MaMucLuong = l.MaMucLuong
    WHERE t.MaPB = @MaPB AND t.TrangThai = 'DangLam' AND m.HinhThuc = 'Thang';
END;
GO

/* ===== PROCEDURE 5/5: tính lương tháng; giao tác: lỗi 1 người thì ROLLBACK toàn bộ ===== */
CREATE OR ALTER PROCEDURE dbo.sp_TinhLuongThang
    @Thang CHAR(7), @MaPB CHAR(4) = NULL,   -- NULL: mọi phòng
    @SoNVDaTinh INT OUTPUT, @TongThucLanh BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Thang NOT LIKE '[0-9][0-9][0-9][0-9]-[0-1][0-9]' OR RIGHT(@Thang, 2) NOT BETWEEN '01' AND '12'
        THROW 50040, N'Tháng phải có dạng yyyy-mm hợp lệ.', 1;
    IF @MaPB IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPB)
        THROW 50041, N'Phòng ban không tồn tại.', 1;
    CREATE TABLE #DS (STT INT IDENTITY(1,1) PRIMARY KEY, MaNV CHAR(6) NOT NULL);
    INSERT INTO #DS (MaNV)
    SELECT cc.MaNV FROM dbo.ChamCong AS cc JOIN dbo.NhanVien AS nv ON nv.MaNV = cc.MaNV
    WHERE cc.Thang = @Thang AND (@MaPB IS NULL OR nv.MaPB = @MaPB) ORDER BY cc.MaNV;
    DECLARE @Tong INT = (SELECT COUNT(*) FROM #DS);
    IF @Tong = 0 THROW 50042, N'Không có dữ liệu chấm công cho tháng/phòng đã chọn.', 1;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @i INT = 1, @MaNV CHAR(6), @LNC BIGINT, @PC BIGINT, @BH BIGINT, @TL BIGINT, @Msg NVARCHAR(200);
        SET @SoNVDaTinh = 0; SET @TongThucLanh = 0;
        WHILE @i <= @Tong
        BEGIN
            SELECT @MaNV = MaNV FROM #DS WHERE STT = @i;
            SELECT @LNC = LuongNgayCong, @PC = PhuCap, @BH = BaoHiem, @TL = ThucLanh
            FROM dbo.fn_ChiTietLuong(@MaNV, @Thang);
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Msg = N'Chưa có mức lương hiệu lực trong tháng cho nhân viên ' + @MaNV;
                THROW 50043, @Msg, 1;
            END
            IF EXISTS (SELECT 1 FROM dbo.BangLuong WHERE MaNV = @MaNV AND Thang = @Thang)
                UPDATE dbo.BangLuong SET LuongNgayCong = @LNC, PhuCap = @PC, BaoHiem = @BH, ThucLanh = @TL,
                                         NgayTinh = SYSDATETIME()
                WHERE MaNV = @MaNV AND Thang = @Thang;
            ELSE
                INSERT INTO dbo.BangLuong (MaNV, Thang, LuongNgayCong, PhuCap, BaoHiem, ThucLanh)
                VALUES (@MaNV, @Thang, @LNC, @PC, @BH, @TL);
            SET @SoNVDaTinh += 1;
            SET @TongThucLanh += @TL;
            SET @i += 1;
        END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        SET @SoNVDaTinh = 0; SET @TongThucLanh = 0;
        THROW;
    END CATCH;
END;
GO