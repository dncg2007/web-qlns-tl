USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
SET XACT_ABORT ON;

/* Dọn dữ liệu theo thứ tự phụ thuộc khóa ngoại để script có thể chạy lại. */
UPDATE dbo.PhongBan SET MaTruongPhong = NULL;
DELETE FROM dbo.HopDongLaoDong;
UPDATE dbo.NhanVien SET MaQuanLyTrucTiep = NULL;
DELETE FROM dbo.NhanVien;
DELETE FROM dbo.PhongBan;
GO

BEGIN TRY
    BEGIN TRAN;

    /* 1. PhongBan: nạp trước, chưa gán trưởng phòng để đóng vòng tham chiếu sau. */
    INSERT INTO dbo.PhongBan (MaPB, TenPB, MoTa, MaTruongPhong)
    VALUES
        ('PB01', N'Ban Giám đốc', N'Điều hành chung và định hướng chiến lược', NULL),
        ('PB02', N'Phòng Nhân sự', N'Tuyển dụng, hồ sơ nhân sự và đào tạo', NULL),
        ('PB03', N'Phòng Kế toán', N'Kế toán, thuế và tính lương', NULL),
        ('PB04', N'Phòng Kinh doanh', N'Phát triển khách hàng và doanh số', NULL), -- [CA BIÊN: Chưa có dòng NhanVien nào]
        ('PB05', N'Phòng Kỹ thuật', N'Phát triển và vận hành hệ thống', NULL), -- [CA BIÊN: Có nhân viên nhưng chưa có trưởng phòng]
        ('PB06', N'Phòng Marketing', NULL, NULL), -- [CA BIÊN: MoTa NULL; có 1 nhân viên làm trưởng phòng]
        ('PB07', N'Phòng Mua hàng', NULL, NULL), -- [CA BIÊN: Chưa có dòng NhanVien nào; MoTa NULL]
        ('PB08', N'Phòng Hành chính', N'Văn thư, lưu trữ và quản trị văn phòng', NULL),
        ('PB09', N'Phòng Pháp chế', N'Tư vấn pháp lý và soạn thảo hợp đồng', NULL), -- [CA BIÊN: Chỉ có nhân viên đã nghỉ]
        ('PB10', N'Phòng Chăm sóc khách hàng', N'Hỗ trợ và giải đáp khách hàng', NULL);

    /* 2. NhanVien: người quản lý được nạp trước người được quản lý. */
    INSERT INTO dbo.NhanVien
        (MaNV, HoTen, HinhAnh, GioiTinh, NgaySinh, CMND, NgayCap, NoiCap, QueQuan,
         DienThoai, Email, LoaiNV, ChucVu, MaPB, MaQuanLyTrucTiep)
    VALUES
        ('NV0001', N'Trần Minh Khoa', 'img/nhan-vien/NV0001.jpg', N'Nam', '1980-05-12', '900000000001', '2000-05-12', N'Cục Cảnh sát QLHC về TTXH', N'Hà Nội', '0900000001', 'khoa.tran@example.com', 'ChinhThuc', N'Giám đốc', 'PB01', NULL),
        ('NV0002', N'Lê Thu Hà', 'img/nhan-vien/NV0002.jpg', N'Nữ', '1988-09-23', '900000000002', '2003-09-23', N'Cục Cảnh sát QLHC về TTXH', N'Hải Phòng', '0900000002', 'ha.le@example.com', 'ChinhThuc', N'Trưởng phòng', 'PB02', 'NV0001'),
        ('NV0003', N'Phạm Quốc Bảo', 'img/nhan-vien/NV0003.jpg', N'Nam', '1995-02-14', '900000000003', '2010-02-14', N'Cục Cảnh sát QLHC về TTXH', N'Đà Nẵng', '0900000003', 'bao.pham@example.com', 'ChinhThuc', N'Chuyên viên', 'PB02', 'NV0002'),
        ('NV0004', N'Nguyễn Ngọc Lan', 'img/nhan-vien/NV0004.jpg', N'Nữ', '1985-11-30', '900000000004', '2000-11-30', N'Cục Cảnh sát QLHC về TTXH', N'Thừa Thiên Huế', '0900000004', 'lan.nguyen@example.com', 'ChinhThuc', N'Kế toán trưởng', 'PB03', 'NV0001'),
        ('NV0005', N'Võ Thanh Tùng', 'img/nhan-vien/NV0005.jpg', N'Nam', '2001-07-08', '900000000005', '2016-07-08', N'Cục Cảnh sát QLHC về TTXH', N'Quảng Nam', '0900000005', 'tung.vo@example.com', 'ThoiVu', N'Nhân viên thời vụ', 'PB03', 'NV0004'),
        ('NV0006', N'Đặng Hoài Nam', 'img/nhan-vien/NV0006.jpg', N'Nam', '1993-12-03', '900000000006', '2008-12-03', N'Cục Cảnh sát QLHC về TTXH', N'Đồng Nai', '0900000006', 'nam.dang@example.com', 'ChinhThuc', N'Chuyên viên', 'PB02', 'NV0002'),
        ('NV0007', N'Đỗ Minh Anh', 'img/nhan-vien/NV0007.jpg', N'Nữ', '1990-03-10', '900000000007', '2005-03-10', N'Cục Cảnh sát QLHC về TTXH', N'Bình Dương', '0900000007', 'do.anh@example.com', 'ChinhThuc', N'Kỹ sư phần mềm', 'PB05', 'NV0003'),
        ('NV0008', N'Bùi Thanh Tâm', NULL, N'Nam', '2002-08-03', '900000000008', '2017-08-03', N'Cục Cảnh sát QLHC về TTXH', N'Tây Ninh', '0900000008', 'bui.tam@example.com', 'ThoiVu', N'Nhân viên thời vụ', 'PB05', 'NV0007'), -- [CA BIÊN: ThoiVu đã hết hạn; HinhAnh NULL]
        ('NV0009', N'Trương Ngọc Hà', 'img/nhan-vien/NV0009.jpg', N'Nữ', '1989-06-18', '900000000009', '2004-06-18', N'Cục Cảnh sát QLHC về TTXH', N'Quảng Ninh', '0900000009', 'truong.ha@example.com', 'ChinhThuc', N'Trưởng phòng Marketing', 'PB06', 'NV0007'), -- [CA BIÊN: trưởng phòng PB06]
        ('NV0010', N'Dương Hải Yến', 'img/nhan-vien/NV0010.jpg', N'Nữ', '2000-10-27', '900000000010', '2015-10-27', N'Cục Cảnh sát QLHC về TTXH', N'Bình Phước', '0900000010', 'duong.yen@example.com', 'ThoiVu', N'Nhân viên thời vụ', 'PB06', 'NV0009'), -- [CA BIÊN: ThoiVu đang làm]
        ('NV0011', N'Lê Hoàng Vân', 'img/nhan-vien/NV0011.jpg', N'Nữ', '1991-01-22', '900000000011', '2006-01-22', N'Cục Cảnh sát QLHC về TTXH', N'Khánh Hòa', '0900000011', 'le.van@example.com', 'ChinhThuc', N'Trưởng phòng Hành chính', 'PB08', 'NV0010'), -- [CA BIÊN: trưởng phòng PB08]
        ('NV0012', N'Phan Thị Hương', NULL, N'Nữ', '1998-04-16', '900000000012', NULL, NULL, N'Nam Định', NULL, 'phan.huong@example.com', 'ChinhThuc', N'Chuyên viên pháp chế', 'PB09', 'NV0011'), -- [CA BIÊN: đã nghỉ; DienThoai/NgayCap/NoiCap NULL; PB09 không còn NV đang làm]
        ('NV0013', N'Nguyễn Thảo Vy', NULL, N'Nữ', '1994-07-29', '900000000013', '2009-07-29', N'Cục Cảnh sát QLHC về TTXH', N'Vĩnh Long', '0900000013', NULL, 'ChinhThuc', N'Chuyên viên hành chính', 'PB08', 'NV0011'), -- [CA BIÊN: Email NULL; nhân viên có nhiều hợp đồng nối tiếp]
        ('NV0014', N'Vũ Minh Khôi', 'img/nhan-vien/NV0014.jpg', N'Nam', '1987-03-05', '900000000014', '2002-03-05', N'Cục Cảnh sát QLHC về TTXH', N'Bà Rịa - Vũng Tàu', '0900000014', 'vu.khoi@example.com', 'ChinhThuc', N'Trưởng phòng Chăm sóc khách hàng', 'PB10', 'NV0013'), -- [CA BIÊN: trưởng phòng PB10]
        ('NV0015', N'Đặng Quốc Hưng', 'img/nhan-vien/NV0015.jpg', N'Nam', '1999-09-14', '900000000015', '2014-09-14', N'Cục Cảnh sát QLHC về TTXH', N'Long An', '0900000015', 'dang.hung@example.com', 'ChinhThuc', N'Chuyên viên chăm sóc khách hàng', 'PB10', 'NV0014'),
        ('NV0016', N'Phạm Thị Quế', 'img/nhan-vien/NV0016.jpg', N'Nữ', '1996-12-20', '900000000016', '2011-12-20', N'Cục Cảnh sát QLHC về TTXH', N'Bắc Ninh', '0900000016', 'pham.que@example.com', 'ChinhThuc', N'Chuyên viên nhân sự', 'PB02', 'NV0002');

    /* 3. Gán trưởng phòng sau khi NhanVien đã tồn tại. */
    UPDATE pb
    SET pb.MaTruongPhong = x.MaTruongPhong
    FROM dbo.PhongBan AS pb
    JOIN (VALUES
        ('PB01', 'NV0001'),
        ('PB02', 'NV0002'),
        ('PB03', 'NV0004'),
        ('PB06', 'NV0009'),
        ('PB08', 'NV0011'),
        ('PB10', 'NV0014')
    ) AS x(MaPB, MaTruongPhong) ON x.MaPB = pb.MaPB;

    /* 4. HopDongLaoDong: đúng 20 dòng; cột Ghi chú trong Contract chỉ được giữ bằng comment vì DDL không có cột này. */
    INSERT INTO dbo.HopDongLaoDong (MaHD, MaNV, LoaiHD, TuNgay, DenNgay)
    VALUES
        ('HD0001', 'NV0001', 1, '2019-01-01', NULL),
        ('HD0002', 'NV0002', 1, '2020-04-01', NULL),
        ('HD0003', 'NV0003', 2, '2022-08-15', '2024-08-14'), -- Hợp đồng đầu, đã hết hạn
        ('HD0004', 'NV0003', 1, '2024-08-15', NULL), -- Gia hạn nối tiếp: [CA BIÊN: 2 hợp đồng]
        ('HD0005', 'NV0004', 1, '2021-07-01', NULL),
        ('HD0006', 'NV0005', 3, '2026-06-01', '2027-05-31'), -- [CA BIÊN: thời vụ đang làm]
        ('HD0007', 'NV0006', 2, '2021-03-01', '2025-12-31'), -- [CA BIÊN: đã nghỉ việc]
        ('HD0008', 'NV0007', 2, '2021-01-01', '2023-12-31'),
        ('HD0009', 'NV0007', 1, '2024-01-01', NULL), -- [CA BIÊN: 2 hợp đồng nối tiếp]
        ('HD0010', 'NV0008', 3, '2024-01-01', '2024-06-30'), -- [CA BIÊN: thời vụ đã hết hạn]
        ('HD0011', 'NV0009', 2, '2022-01-01', '2024-12-31'),
        ('HD0012', 'NV0009', 1, '2025-01-01', NULL), -- [CA BIÊN: trưởng phòng có 2 hợp đồng nối tiếp]
        ('HD0013', 'NV0010', 3, '2026-05-01', '2027-05-31'), -- [CA BIÊN: thời vụ đang làm]
        ('HD0014', 'NV0011', 1, '2023-01-01', NULL),
        ('HD0015', 'NV0012', 1, '2022-01-01', '2025-12-31'), -- [CA BIÊN: ChinhThuc nghỉ từ hợp đồng LoaiHD 1]
        ('HD0016', 'NV0013', 2, '2021-01-01', '2023-12-31'),
        ('HD0017', 'NV0013', 1, '2024-01-01', NULL), -- [CA BIÊN: 2 hợp đồng nối tiếp]
        ('HD0018', 'NV0014', 2, '2024-01-01', '2027-12-31'),
        ('HD0019', 'NV0015', 2, '2025-01-01', '2027-12-31'),
        ('HD0020', 'NV0016', 2, '2025-01-01', '2027-12-31');

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;
    THROW;
END CATCH;
GO

/* ===== Truy vấn kiểm chứng dữ liệu mẫu (chỉ SELECT) ===== */
-- 1. Số dòng từng bảng: kỳ vọng PhongBan = 10, NhanVien = 16, HopDongLaoDong = 20.
SELECT N'PhongBan' AS TenBang, COUNT(*) AS SoDong FROM dbo.PhongBan
UNION ALL
SELECT N'NhanVien', COUNT(*) FROM dbo.NhanVien
UNION ALL
SELECT N'HopDongLaoDong', COUNT(*) FROM dbo.HopDongLaoDong;

-- 2. NhanVien không có hợp đồng nào: kỳ vọng 0 dòng.
SELECT nv.MaNV, nv.HoTen
FROM dbo.NhanVien AS nv
LEFT JOIN dbo.HopDongLaoDong AS hd ON hd.MaNV = nv.MaNV
WHERE hd.MaHD IS NULL;

-- 3. Hợp đồng chồng chéo của cùng một NhanVien: kỳ vọng 0 dòng.
SELECT h1.MaNV, h1.MaHD AS MaHD1, h2.MaHD AS MaHD2
FROM dbo.HopDongLaoDong AS h1
JOIN dbo.HopDongLaoDong AS h2
    ON h2.MaNV = h1.MaNV
   AND h2.MaHD > h1.MaHD
   AND h1.TuNgay <= ISNULL(h2.DenNgay, '9999-12-31')
   AND h2.TuNgay <= ISNULL(h1.DenNgay, '9999-12-31');

-- 4. Trưởng phòng không thuộc đúng phòng mình làm trưởng: kỳ vọng 0 dòng.
SELECT pb.MaPB, pb.MaTruongPhong, nv.MaPB AS MaPBNhanVien
FROM dbo.PhongBan AS pb
JOIN dbo.NhanVien AS nv ON nv.MaNV = pb.MaTruongPhong
WHERE nv.MaPB <> pb.MaPB;

-- 5. LoaiNV không khớp toàn bộ LoaiHD của nhân viên: kỳ vọng 0 dòng.
SELECT nv.MaNV, nv.LoaiNV
FROM dbo.NhanVien AS nv
JOIN dbo.HopDongLaoDong AS hd ON hd.MaNV = nv.MaNV
GROUP BY nv.MaNV, nv.LoaiNV
HAVING (nv.LoaiNV = 'ThoiVu' AND SUM(CASE WHEN hd.LoaiHD <> 3 THEN 1 ELSE 0 END) > 0)
    OR (nv.LoaiNV = 'ChinhThuc' AND SUM(CASE WHEN hd.LoaiHD NOT IN (1, 2) THEN 1 ELSE 0 END) > 0);

-- 6. Phòng ban không có dòng NhanVien nào: kỳ vọng đúng PB04 và PB07.
SELECT pb.MaPB, pb.TenPB
FROM dbo.PhongBan AS pb
LEFT JOIN dbo.NhanVien AS nv ON nv.MaPB = pb.MaPB
WHERE nv.MaNV IS NULL
ORDER BY pb.MaPB;

-- 7. Số NhanVien đang làm theo từng phòng; PB09 phải bằng 0.
SELECT pb.MaPB, pb.TenPB,
       COUNT(CASE WHEN tt.TrangThai = 'DangLam' THEN 1 END) AS SoNVDangLam
FROM dbo.PhongBan AS pb
LEFT JOIN dbo.v_NhanVien_TrangThai AS tt ON tt.MaPB = pb.MaPB
GROUP BY pb.MaPB, pb.TenPB
ORDER BY pb.MaPB;

-- 8. Đối chiếu trạng thái NV0001-NV0006 tại ngày chạy; kỳ vọng ổn định trong khoảng 2026-10-18 đến 2027-03-31.
SELECT MaNV, TrangThai, NgayVaoLam, NgayNghiViec
FROM dbo.v_NhanVien_TrangThai
WHERE MaNV BETWEEN 'NV0001' AND 'NV0006'
ORDER BY MaNV;
GO
