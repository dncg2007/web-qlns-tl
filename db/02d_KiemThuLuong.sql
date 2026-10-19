USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
SET XACT_ABORT ON;

-- Ca 1: CK_MucLuong_Ma, kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.MucLuong (MaMucLuong, TenMucLuong, MoTa, HinhThuc, SoTien)
    VALUES ('ML1', N'Kiểm thử mã', NULL, 'Thang', 1000000);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 1 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 2: CK_MucLuong_HinhThuc, kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.MucLuong (MaMucLuong, TenMucLuong, MoTa, HinhThuc, SoTien)
    VALUES ('ML91', N'Kiểm thử hình thức', NULL, 'Tuan', 1000000);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 2 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 3: CK_MucLuong_SoTien, kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.MucLuong (MaMucLuong, TenMucLuong, MoTa, HinhThuc, SoTien)
    VALUES ('ML92', N'Kiểm thử số tiền', NULL, 'Thang', 0);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 3 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 4: CK_LuongNV_Ngay (NgayBatDau >= NgayKetThuc), kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
    VALUES ('LN9001', 'NV0001', 'ML01', '2020-01-01', '2020-01-01');
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 4 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 5: UX_LuongNV_HienHanh (NV0001 đã có dòng hiện hành), kỳ vọng 2601.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
    VALUES ('LN9002', 'NV0001', 'ML01', '2030-01-01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 5 | Kỳ vọng 2601 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 6: FK_LuongNV_NhanVien, kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
    VALUES ('LN9003', 'NV9999', 'ML01', '2020-01-01', '2020-12-31');
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 6 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 7: FK_LuongNV_MucLuong, kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
    VALUES ('LN9004', 'NV0001', 'ML99', '2031-01-01', '2031-12-31');
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 7 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 8: CK_ChamCong_Thang (tháng 13), kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
    VALUES ('CC900001', 'NV0001', '2026-13', 20, 0, NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 8 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 9: CK_ChamCong_NgayCong (27), kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
    VALUES ('CC900002', 'NV0001', '2026-10', 27, 0, NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 9 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 10: CK_ChamCong_PhuCap (-1), kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
    VALUES ('CC900003', 'NV0001', '2026-10', 20, -1, NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 10 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 11: UQ_ChamCong_NV_Thang (trùng NV0001, 2026-07), kỳ vọng 2627.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
    VALUES ('CC900004', 'NV0001', '2026-07', 20, 0, NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 11 | Kỳ vọng 2627 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 12: CK_ChamCong_SoGio (800), kỳ vọng 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
    VALUES ('CC900005', 'NV0005', '2026-10', 20, 0, 800);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 12 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

/* Đếm lại: kỳ vọng MucLuong 10, LuongNhanVien 20, ChamCong 39. */
SELECT N'MucLuong' AS TenBang, COUNT(*) AS SoDong FROM dbo.MucLuong
UNION ALL SELECT N'LuongNhanVien', COUNT(*) FROM dbo.LuongNhanVien
UNION ALL SELECT N'ChamCong', COUNT(*) FROM dbo.ChamCong;
GO