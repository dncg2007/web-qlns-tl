USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/* ---- Function ---- */
SELECT dbo.fn_LuongThucLanh('NV0001', '2026-09') AS NV0001,
       dbo.fn_LuongThucLanh('NV0002', '2026-09') AS NV0002,
       dbo.fn_LuongThucLanh('NV0003', '2026-09') AS NV0003,
       dbo.fn_LuongThucLanh('NV0004', '2026-09') AS NV0004,
       dbo.fn_LuongThucLanh('NV0005', '2026-09') AS NV0005,
       dbo.fn_LuongThucLanh('NV0006', '2026-09') AS NV0006;
-- Kỳ vọng: 42.275.000 | 26.060.000 | 0 | 24.751.923 | 6.322.500 | NULL (NV0006 không chấm công)
SELECT * FROM dbo.fn_CapDuoi('NV0002') ORDER BY Cap, MaNV;
-- Kỳ vọng: 12 dòng; cấp 1: NV0003, NV0006, NV0016; cấp 2: NV0007; cấp 3: NV0008, NV0009; cấp 4: NV0010; cấp 5: NV0011; cấp 6: NV0012, NV0013; cấp 7: NV0014; cấp 8: NV0015
SELECT * FROM dbo.fn_CapDuoi('NV0004');   -- Kỳ vọng: 1 dòng NV0005, cấp 1
GO
/* ---- SP_NhanVien_Insert: ca đúng (rollback) ---- */
BEGIN TRAN;
DECLARE @MaNV CHAR(6), @MaHD CHAR(6);
EXEC dbo.SP_NhanVien_Insert @HoTen = N'Kiểm Thử Một', @GioiTinh = N'Nam', @NgaySinh = '1999-01-01',
     @CMND = '900000009101', @ChucVu = N'Chuyên viên', @MaPB = 'PB04', @LoaiNV = 'ChinhThuc',
     @LoaiHD = 2, @TuNgay = '2026-10-01', @DenNgay = '2027-09-30', @MaQuanLyTrucTiep = 'NV0001',
     @MaNV = @MaNV OUTPUT, @MaHD = @MaHD OUTPUT;
SELECT @MaNV AS MaNV, @MaHD AS MaHD;   -- Kỳ vọng: NV0017, HD0021
ROLLBACK;
GO
/* ---- SP_NhanVien_Insert: ca sai ---- */
BEGIN TRY
    DECLARE @a CHAR(6), @b CHAR(6);
    EXEC dbo.SP_NhanVien_Insert @HoTen = N'Sai Loại', @GioiTinh = N'Nam', @NgaySinh = '1999-01-01',
         @CMND = '900000009102', @ChucVu = N'Thời vụ', @MaPB = 'PB04', @LoaiNV = 'ThoiVu',
         @LoaiHD = 1, @TuNgay = '2026-10-01', @MaNV = @a OUTPUT, @MaHD = @b OUTPUT;
END TRY
BEGIN CATCH PRINT N'Ca sai 1 | Kỳ vọng 50002 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + N' | ' + ERROR_MESSAGE(); END CATCH;
BEGIN TRY
    EXEC dbo.SP_NhanVien_Insert @HoTen = N'Sai Phòng', @GioiTinh = N'Nam', @NgaySinh = '1999-01-01',
         @CMND = '900000009103', @ChucVu = N'Chuyên viên', @MaPB = 'PB99', @LoaiNV = 'ChinhThuc',
         @LoaiHD = 1, @TuNgay = '2026-10-01', @MaNV = @a OUTPUT, @MaHD = @b OUTPUT;
END TRY
BEGIN CATCH PRINT N'Ca sai 2 | Kỳ vọng 50001 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + N' | ' + ERROR_MESSAGE(); END CATCH;
GO
/* ---- sp_ChuyenPhongBan ---- */
BEGIN TRAN;
DECLARE @tp BIT;
EXEC dbo.sp_ChuyenPhongBan @MaNV = 'NV0011', @MaPBMoi = 'PB04', @LaTruongPhongCu = @tp OUTPUT;
SELECT @tp AS LaTruongPhongCu;                                  -- Kỳ vọng: 1
SELECT MaPB, MaTruongPhong FROM dbo.PhongBan WHERE MaPB = 'PB08';  -- Kỳ vọng: MaTruongPhong NULL
ROLLBACK;
GO
BEGIN TRY DECLARE @x BIT; EXEC dbo.sp_ChuyenPhongBan 'NV0006', 'PB04', NULL, @x OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca sai 3 | Kỳ vọng 50011 (đã nghỉ) | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
BEGIN TRY DECLARE @y BIT; EXEC dbo.sp_ChuyenPhongBan 'NV0002', 'PB04', 'NV0003', @y OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca sai 4 | Kỳ vọng 50015 (quản lý là cấp dưới) | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
GO
/* ---- sp_DoiLuong ---- */
BEGIN TRAN;
DECLARE @ln CHAR(6);
EXEC dbo.sp_DoiLuong @MaNV = 'NV0004', @MaMucLuongMoi = 'ML09', @NgayHieuLuc = '2026-11-01', @MaLuongNhanVien = @ln OUTPUT;
SELECT @ln AS MaMoi;   -- Kỳ vọng: LN0021
SELECT MaLuongNhanVien, MaMucLuong, NgayBatDau, NgayKetThuc FROM dbo.LuongNhanVien WHERE MaNV = 'NV0004' ORDER BY NgayBatDau;
-- Kỳ vọng: LN0005 ML07 2021-07-01 -> 2026-10-31; LN0021 ML09 2026-11-01 NULL
ROLLBACK;
GO
BEGIN TRY DECLARE @z CHAR(6); EXEC dbo.sp_DoiLuong 'NV0005', 'ML06', '2026-11-01', @z OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca sai 5 | Kỳ vọng 50035 (thời vụ không dùng mức tháng) | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
BEGIN TRY DECLARE @w CHAR(6); EXEC dbo.sp_DoiLuong 'NV0001', 'ML09', '2026-11-01', @w OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca sai 6 | Kỳ vọng 50034 (trùng mức) | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
GO
/* ---- sp_ThongKePhongBan ---- */
DECLARE @n INT, @t BIGINT;
EXEC dbo.sp_ThongKePhongBan 'PB02', @n OUTPUT, @t OUTPUT; SELECT 'PB02' AS Phong, @n AS SoNV, @t AS TongLuong;  -- 3 | 63.000.000
EXEC dbo.sp_ThongKePhongBan 'PB03', @n OUTPUT, @t OUTPUT; SELECT 'PB03' AS Phong, @n AS SoNV, @t AS TongLuong;  -- 2 | 30.000.000
EXEC dbo.sp_ThongKePhongBan 'PB09', @n OUTPUT, @t OUTPUT; SELECT 'PB09' AS Phong, @n AS SoNV, @t AS TongLuong;  -- 0 | 0
GO
/* ---- sp_TinhLuongThang: ca đúng (ghi thật vào BangLuong) ---- */
DECLARE @so INT, @tong BIGINT;
EXEC dbo.sp_TinhLuongThang @Thang = '2026-09', @MaPB = NULL, @SoNVDaTinh = @so OUTPUT, @TongThucLanh = @tong OUTPUT;
SELECT @so AS SoNVDaTinh, @tong AS TongThucLanh;   -- Kỳ vọng: 13 và tổng bằng SUM(ThucLanh) bên dưới
SELECT COUNT(*) AS SoDong, SUM(ThucLanh) AS Tong FROM dbo.BangLuong WHERE Thang = '2026-09';  -- 13 dòng
SELECT MaNV, ThucLanh FROM dbo.BangLuong WHERE Thang = '2026-09' AND MaNV IN ('NV0001', 'NV0005', 'NV0003');
-- Kỳ vọng: 42.275.000 | 6.322.500 | 0
GO
/* ---- sp_TinhLuongThang: ca lỗi, ROLLBACK toàn bộ ---- */
BEGIN TRY DECLARE @s INT, @g BIGINT; EXEC dbo.sp_TinhLuongThang '2026-13', NULL, @s OUTPUT, @g OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca sai 7 | Kỳ vọng 50040 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
BEGIN TRY EXEC dbo.sp_TinhLuongThang '2026-10', NULL, @s OUTPUT, @g OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca sai 8 | Kỳ vọng 50042 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
GO
-- Dựng ca "lỗi 1 người": NV0001 có lương tháng 05/2026, NV0005 thì chưa (mức lương bắt đầu 2026-06-01)
INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
VALUES ('CC900101', 'NV0001', '2026-05', 20, 0, NULL), ('CC900102', 'NV0005', '2026-05', 20, 0, 150.0);
GO
BEGIN TRY DECLARE @s2 INT, @g2 BIGINT; EXEC dbo.sp_TinhLuongThang '2026-05', NULL, @s2 OUTPUT, @g2 OUTPUT; END TRY
BEGIN CATCH PRINT N'Ca ROLLBACK | Kỳ vọng 50043 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + N' | ' + ERROR_MESSAGE(); END CATCH;
SELECT COUNT(*) AS SoDongBangLuongThang05 FROM dbo.BangLuong WHERE Thang = '2026-05';
-- Kỳ vọng: 0 (NV0001 được tính trước nhưng bị hoàn tác khi NV0005 lỗi)
GO
DELETE FROM dbo.ChamCong WHERE MaChamCong IN ('CC900101', 'CC900102');   -- dọn dữ liệu dựng ca
SELECT COUNT(*) AS ChamCong FROM dbo.ChamCong;   -- Kỳ vọng: 39
GO