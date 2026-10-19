USE QLNhanSu;
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/* T1: ghi nhật ký đổi lương, một nhân viên tối đa 20 dòng lương (AFTER INSERT) */
CREATE OR ALTER TRIGGER dbo.trg_LuongNV_NhatKy ON dbo.LuongNhanVien AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.LuongNhanVien AS l
               WHERE l.MaNV IN (SELECT MaNV FROM inserted)
               GROUP BY l.MaNV HAVING COUNT(*) > 20)
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50101, N'Một nhân viên không được đổi lương quá 20 lần.', 1;
    END
    INSERT INTO dbo.NhatKyLuong (MaNV, MaMucLuongCu, MaMucLuongMoi)
    SELECT i.MaNV, p.MaMucLuong, i.MaMucLuong
    FROM inserted AS i
    OUTER APPLY (SELECT TOP 1 l.MaMucLuong FROM dbo.LuongNhanVien AS l
                 WHERE l.MaNV = i.MaNV AND l.NgayBatDau < i.NgayBatDau
                 ORDER BY l.NgayBatDau DESC) AS p;
END;
GO
/* T2: chặn hợp đồng chồng chéo (AFTER INSERT, UPDATE); xét cả chồng chéo giữa các dòng cùng câu lệnh */
CREATE OR ALTER TRIGGER dbo.trg_HopDong_ChongCheo ON dbo.HopDongLaoDong AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted AS i
               JOIN dbo.HopDongLaoDong AS h ON h.MaNV = i.MaNV AND h.MaHD <> i.MaHD
                AND h.TuNgay <= ISNULL(i.DenNgay, '9999-12-31')
                AND i.TuNgay <= ISNULL(h.DenNgay, '9999-12-31'))
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50102, N'Hợp đồng chồng chéo thời gian với hợp đồng khác của cùng nhân viên.', 1;
    END
END;
GO
/* T3: LoaiHD khớp LoaiNV (thời vụ: 3; chính thức: 1 hoặc 2) (AFTER INSERT, UPDATE) */
CREATE OR ALTER TRIGGER dbo.trg_HopDong_LoaiNV ON dbo.HopDongLaoDong AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted AS i JOIN dbo.NhanVien AS nv ON nv.MaNV = i.MaNV
               WHERE (nv.LoaiNV = 'ThoiVu' AND (i.LoaiHD <> 3 OR i.DenNgay IS NULL))
                  OR (nv.LoaiNV = 'ChinhThuc' AND i.LoaiHD NOT IN (1, 2))
                  OR (i.LoaiHD IN (2, 3) AND i.DenNgay IS NULL))
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50103, N'Loại hợp đồng không khớp loại nhân viên hoặc thiếu ngày kết thúc.', 1;
    END
END;
GO
/* T4: đổi LoaiNV phải khớp các hợp đồng đã có (AFTER UPDATE) */
CREATE OR ALTER TRIGGER dbo.trg_NhanVien_LoaiNV ON dbo.NhanVien AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(LoaiNV) AND EXISTS (
        SELECT 1 FROM inserted AS i JOIN dbo.HopDongLaoDong AS h ON h.MaNV = i.MaNV
        WHERE (i.LoaiNV = 'ThoiVu' AND h.LoaiHD <> 3) OR (i.LoaiNV = 'ChinhThuc' AND h.LoaiHD NOT IN (1, 2)))
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50105, N'Không thể đổi loại nhân viên: có hợp đồng không khớp loại mới.', 1;
    END
END;
GO
/* T5: tối đa 5 thân nhân mỗi nhân viên (INSTEAD OF INSERT); một dòng vi phạm thì cả câu lệnh bị hủy */
CREATE OR ALTER TRIGGER dbo.trg_ThanNhan_Toida5 ON dbo.ThanNhan INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM (SELECT MaNV, COUNT(*) AS Them FROM inserted GROUP BY MaNV) AS i
               WHERE i.Them + (SELECT COUNT(*) FROM dbo.ThanNhan AS t WHERE t.MaNV = i.MaNV) > 5)
        THROW 50104, N'Một nhân viên chỉ được có tối đa 5 thân nhân.', 1;
    INSERT INTO dbo.ThanNhan (MaTN, MaNV, HoTen, GioiTinh, NgaySinh, QuanHe)
    SELECT MaTN, MaNV, HoTen, GioiTinh, NgaySinh, QuanHe FROM inserted;
END;
GO
/* ===== GT2: chuyển cả phòng ban; một người lỗi thì hoàn tác toàn bộ ===== */
CREATE OR ALTER PROCEDURE dbo.sp_ChuyenCaPhong
    @MaPBCu CHAR(4), @MaPBMoi CHAR(4), @MaQuanLyMoi CHAR(6) = NULL, @SoNVDaChuyen INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPBCu) THROW 50061, N'Phòng ban nguồn không tồn tại.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.PhongBan WHERE MaPB = @MaPBMoi) THROW 50062, N'Phòng ban đích không tồn tại.', 1;
    IF @MaPBCu = @MaPBMoi THROW 50063, N'Phòng nguồn và đích trùng nhau.', 1;
    CREATE TABLE #DS (STT INT IDENTITY(1,1) PRIMARY KEY, MaNV CHAR(6) NOT NULL);
    INSERT INTO #DS (MaNV)
    SELECT MaNV FROM dbo.v_NhanVien_TrangThai WHERE MaPB = @MaPBCu AND TrangThai = 'DangLam' ORDER BY MaNV DESC;
    DECLARE @Tong INT = (SELECT COUNT(*) FROM #DS), @i INT = 1, @MaNV CHAR(6), @tp BIT;
    IF @Tong = 0 THROW 50064, N'Phòng nguồn không có nhân viên đang làm.', 1;
    BEGIN TRY
        BEGIN TRAN;
        SET @SoNVDaChuyen = 0;
        WHILE @i <= @Tong
        BEGIN
            SELECT @MaNV = MaNV FROM #DS WHERE STT = @i;
            EXEC dbo.sp_ChuyenPhongBan @MaNV = @MaNV, @MaPBMoi = @MaPBMoi,
                 @MaQuanLyMoi = @MaQuanLyMoi, @LaTruongPhongCu = @tp OUTPUT;
            SET @SoNVDaChuyen += 1;
            SET @i += 1;
        END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        SET @SoNVDaChuyen = 0;
        THROW;
    END CATCH;
END;
GO