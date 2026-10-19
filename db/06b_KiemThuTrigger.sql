USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/* ---- T1: 21 dòng lương cho NV0003 (đang có 2, thêm 19) ---- */
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
    SELECT 'LN' + RIGHT('0000' + CAST(9000 + n AS VARCHAR(4)), 4), 'NV0003', 'ML01',
           DATEADD(YEAR, n, '1980-01-01'), DATEADD(DAY, 1, DATEADD(YEAR, n, '1980-01-01'))
    FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM sys.all_objects) AS x WHERE n <= 19;
    COMMIT;
END TRY
BEGIN CATCH PRINT N'T1 quá 20 | Kỳ vọng 50101 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); IF XACT_STATE() <> 0 ROLLBACK; END CATCH;
GO
/* ---- T1: nhật ký đúng khi đổi lương hợp lệ ---- */
BEGIN TRAN;
DECLARE @ln CHAR(6);
EXEC dbo.sp_DoiLuong 'NV0004', 'ML09', '2026-11-01', @ln OUTPUT;
SELECT MaNV, MaMucLuongCu, MaMucLuongMoi FROM dbo.NhatKyLuong WHERE MaNV = 'NV0004';  -- Kỳ vọng: 1 dòng NV0004 | ML07 | ML09
ROLLBACK;
GO
/* ---- T2: chồng chéo với hợp đồng cũ ---- */
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay) VALUES ('HD9001', 'NV0003', 2, '2025-01-01', '2025-12-31');
    COMMIT;
END TRY
BEGIN CATCH PRINT N'T2 chồng hợp đồng cũ | Kỳ vọng 50102 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); IF XACT_STATE() <> 0 ROLLBACK; END CATCH;
GO
/* ---- T2: nhiều dòng, hai dòng mới chồng nhau ---- */
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
    VALUES ('HD9002', 'NV0006', 2, '2026-01-01', '2026-06-30'), ('HD9003', 'NV0006', 2, '2026-06-01', '2026-12-31');
    COMMIT;
END TRY
BEGIN CATCH PRINT N'T2 hai dòng chồng nhau | Kỳ vọng 50102 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); IF XACT_STATE() <> 0 ROLLBACK; END CATCH;
GO
/* ---- T2: ca đúng ---- */
BEGIN TRAN;
INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay) VALUES ('HD9004', 'NV0006', 2, '2026-01-01', '2026-06-30');
SELECT COUNT(*) AS SoHDNV0006 FROM dbo.HopDongLaoDong WHERE MaNV = 'NV0006';   -- Kỳ vọng: 2
ROLLBACK;
GO
/* ---- T3: thời vụ ký hợp đồng loại 1 ---- */
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay) VALUES ('HD9005', 'NV0005', 1, '2028-01-01', NULL);
    COMMIT;
END TRY
BEGIN CATCH PRINT N'T3 thời vụ loại 1 | Kỳ vọng 50103 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); IF XACT_STATE() <> 0 ROLLBACK; END CATCH;
GO
/* ---- T3: nhiều dòng, 1 đúng + 1 sai thì cả câu lệnh bị hủy ---- */
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
    VALUES ('HD9006', 'NV0006', 2, '2026-01-01', '2026-06-30'), ('HD9007', 'NV0008', 2, '2025-01-01', '2025-12-31');
    COMMIT;
END TRY
BEGIN CATCH PRINT N'T3 nhiều dòng | Kỳ vọng 50103 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); IF XACT_STATE() <> 0 ROLLBACK; END CATCH;
SELECT COUNT(*) AS SoHD FROM dbo.HopDongLaoDong;   -- Kỳ vọng: 20
GO
/* ---- T4: đổi LoaiNV của NV0005 (đang có hợp đồng loại 3) ---- */
BEGIN TRY
    BEGIN TRAN;
    UPDATE dbo.NhanVien SET LoaiNV = 'ChinhThuc' WHERE MaNV = 'NV0005';
    COMMIT;
END TRY
BEGIN CATCH PRINT N'T4 đổi LoaiNV | Kỳ vọng 50105 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); IF XACT_STATE() <> 0 ROLLBACK; END CATCH;
GO
/* ---- T5: NV0002 đã đủ 5 thân nhân ---- */
BEGIN TRY
    INSERT INTO dbo.ThanNhan (MaTN, MaNV, HoTen, GioiTinh, NgaySinh, QuanHe) VALUES ('TN9001', 'NV0002', N'Thử Một', N'Nam', '2000-01-01', N'Con');
END TRY
BEGIN CATCH PRINT N'T5 vượt 5 | Kỳ vọng 50104 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
/* T5 nhiều dòng: NV0004 thêm 1 (hợp lệ) + NV0002 thêm 1 (vi phạm) thì cả câu bị hủy */
BEGIN TRY
    INSERT INTO dbo.ThanNhan (MaTN, MaNV, HoTen, GioiTinh, NgaySinh, QuanHe)
    VALUES ('TN9002', 'NV0004', N'Thử Hai', N'Nam', '2000-01-01', N'Con'), ('TN9003', 'NV0002', N'Thử Ba', N'Nam', '2000-01-01', N'Con');
END TRY
BEGIN CATCH PRINT N'T5 nhiều dòng | Kỳ vọng 50104 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
SELECT COUNT(*) AS SoThanNhan FROM dbo.ThanNhan;   -- Kỳ vọng: 10
GO
/* T5 ca đúng: NV0004 từ 1 lên 5 */
BEGIN TRAN;
INSERT INTO dbo.ThanNhan (MaTN, MaNV, HoTen, GioiTinh, NgaySinh, QuanHe)
VALUES ('TN9004', 'NV0004', N'A1', N'Nam', '2000-01-01', N'Con'), ('TN9005', 'NV0004', N'A2', N'Nam', '2000-01-01', N'Con'),
       ('TN9006', 'NV0004', N'A3', N'Nam', '2000-01-01', N'Con'), ('TN9007', 'NV0004', N'A4', N'Nam', '2000-01-01', N'Con');
SELECT COUNT(*) AS SoThanNhanNV0004 FROM dbo.ThanNhan WHERE MaNV = 'NV0004';   -- Kỳ vọng: 5
ROLLBACK;
GO
/* ---- GT2 đúng: chuyển PB06 sang PB04 ---- */
BEGIN TRAN;
DECLARE @so INT;
EXEC dbo.sp_ChuyenCaPhong 'PB06', 'PB04', NULL, @so OUTPUT;
SELECT @so AS DaChuyen;   -- Kỳ vọng: 2
SELECT MaPB, COUNT(*) AS SoNV FROM dbo.NhanVien WHERE MaPB IN ('PB04', 'PB06') GROUP BY MaPB;   -- Kỳ vọng: PB04 = 2 (PB06 không còn dòng)
SELECT MaTruongPhong FROM dbo.PhongBan WHERE MaPB = 'PB06';   -- Kỳ vọng: NULL
ROLLBACK;
GO
/* ---- GT2 lỗi: PB08 (NV0013 chuyển trước, rồi NV0011 trùng quản lý mới nên lỗi) thì hoàn tác cả NV0013 ---- */
BEGIN TRY
    DECLARE @s2 INT;
    EXEC dbo.sp_ChuyenCaPhong 'PB08', 'PB04', 'NV0011', @s2 OUTPUT;
END TRY
BEGIN CATCH PRINT N'GT2 ROLLBACK | Kỳ vọng 50014 | Thực tế ' + CAST(ERROR_NUMBER() AS VARCHAR(10)); END CATCH;
SELECT MaNV, MaPB FROM dbo.NhanVien WHERE MaNV IN ('NV0011', 'NV0013');   -- Kỳ vọng: cả hai vẫn PB08
SELECT MaTruongPhong FROM dbo.PhongBan WHERE MaPB = 'PB08';              -- Kỳ vọng: NV0011
GO