USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
SET XACT_ABORT ON;

/* Mỗi ca chạy trong một transaction riêng; lỗi được in ra rồi rollback. */

-- Ca 1: CK_PhongBan_MaPB, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.PhongBan (MaPB, TenPB, MoTa, MaTruongPhong)
    VALUES ('PB1', N'Phòng kiểm thử 01', N'Dữ liệu kiểm thử', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 1 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 2: UQ_PhongBan_TenPB, kỳ vọng lỗi 2627.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.PhongBan (MaPB, TenPB, MoTa, MaTruongPhong)
    VALUES ('PB11', N'Phòng Nhân sự', N'Dữ liệu kiểm thử', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 2 | Kỳ vọng 2627 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 3: FK_PhongBan_TruongPhong, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    UPDATE dbo.PhongBan SET MaTruongPhong = 'NV9999' WHERE MaPB = 'PB04';
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 3 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 4: UX_PhongBan_TruongPhong, kỳ vọng lỗi 2601.
BEGIN TRY
    BEGIN TRAN;
    UPDATE dbo.PhongBan SET MaTruongPhong = 'NV0002' WHERE MaPB = 'PB04';
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 4 | Kỳ vọng 2601 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 5: CK_NhanVien_GioiTinh, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9001', N'Kiểm thử giới tính', NULL, CONVERT(NVARCHAR(3), N'Khác'), '1990-01-01', '900000009001', '2005-01-01', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '0900999001', 'kiem.thu.gioitinh@example.com', 'ChinhThuc', N'Kiểm thử', 'PB01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 5 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 6: FK_NhanVien_PhongBan, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9002', N'Kiểm thử phòng ban', NULL, N'Nam', '1990-01-01', '900000009002', '2005-01-01', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '0900999002', 'kiem.thu.phong@example.com', 'ChinhThuc', N'Kiểm thử', 'PB99', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 6 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 7: CK_NhanVien_KhongTuQuanLy, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    UPDATE dbo.NhanVien SET MaQuanLyTrucTiep = 'NV0003' WHERE MaNV = 'NV0003';
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 7 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 8: UQ_NhanVien_CMND, kỳ vọng lỗi 2627.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9003', N'Kiểm thử trùng CMND', NULL, N'Nam', '1990-01-01', '900000000001', '2005-01-01', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '0900999003', 'kiem.thu.cmnd@example.com', 'ChinhThuc', N'Kiểm thử', 'PB01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 8 | Kỳ vọng 2627 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 9: UX_NhanVien_Email, kỳ vọng lỗi 2601.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9004', N'Kiểm thử trùng Email', NULL, N'Nam', '1990-01-01', '900000009004', '2005-01-01', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '0900999004', 'khoa.tran@example.com', 'ChinhThuc', N'Kiểm thử', 'PB01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 9 | Kỳ vọng 2601 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 10: CK_NhanVien_LoaiNV, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9005', N'Kiểm thử loại nhân viên', NULL, N'Nam', '1990-01-01', '900000009005', '2005-01-01', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '0900999005', 'kiem.thu.loainv@example.com', 'TamThoi', N'Kiểm thử', 'PB01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 10 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 11: CK_NhanVien_DienThoai, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9006', N'Kiểm thử điện thoại', NULL, N'Nam', '1990-01-01', '900000009006', '2005-01-01', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '12345', 'kiem.thu.dienthoai@example.com', 'ChinhThuc', N'Kiểm thử', 'PB01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 11 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 12: CK_NhanVien_NgaySinh, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV9007', N'Kiểm thử ngày sinh tương lai', NULL, N'Nam', '2099-01-01', '900000009007', NULL, NULL, N'Hà Nội', '0900999007', 'kiem.thu.ngaysinh@example.com', 'ChinhThuc', N'Kiểm thử', 'PB01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 12 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 13: CK_HopDong_Ngay, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
    VALUES ('HD9001', 'NV0001', 1, '2026-05-01', '2026-04-01');
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 13 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 14: CK_HopDong_LoaiHD, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
    VALUES ('HD9002', 'NV0001', 4, '2026-05-01', '2026-06-01');
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 14 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 15: FK_HopDong_NhanVien, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
    VALUES ('HD9003', 'NV9999', 1, '2026-05-01', NULL);
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 15 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

-- Ca 16: FK_NhanVien_PhongBan khi xóa phòng còn nhân viên tham chiếu, kỳ vọng lỗi 547.
BEGIN TRY
    BEGIN TRAN;
    DELETE FROM dbo.PhongBan WHERE MaPB = 'PB02';
    COMMIT;
END TRY
BEGIN CATCH
    PRINT N'Ca 16 | Kỳ vọng 547 | Thực tế ' + CONVERT(varchar(10), ERROR_NUMBER()) + N' | ' + ERROR_MESSAGE();
    IF XACT_STATE() <> 0 ROLLBACK;
END CATCH;
GO

/* Đếm lại sau toàn bộ ca: dữ liệu phải giữ nguyên 10 / 16 / 20. */
SELECT N'PhongBan' AS TenBang, COUNT(*) AS SoDong FROM dbo.PhongBan
UNION ALL
SELECT N'NhanVien', COUNT(*) FROM dbo.NhanVien
UNION ALL
SELECT N'HopDongLaoDong', COUNT(*) FROM dbo.HopDongLaoDong;
GO
