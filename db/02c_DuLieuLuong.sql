USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
SET XACT_ABORT ON;

/* Dọn dữ liệu theo thứ tự phụ thuộc khóa ngoại. */
DELETE FROM dbo.ChamCong;
DELETE FROM dbo.LuongNhanVien;
DELETE FROM dbo.MucLuong;
GO

BEGIN TRY
    BEGIN TRAN;

    /* 1. MucLuong: 10 dòng (9 theo tháng, 1 theo giờ). */
    INSERT INTO dbo.MucLuong (MaMucLuong, TenMucLuong, MoTa, HinhThuc, SoTien)
    VALUES
        ('ML01', N'Thử việc',            NULL,                                   'Thang',  8000000),  -- [CA BIÊN: MoTa NULL]
        ('ML02', N'Nhân viên bậc 1',     N'Nhân viên mới, dưới 2 năm',           'Thang', 12000000),
        ('ML03', N'Nhân viên bậc 2',     N'Nhân viên từ 2 đến 4 năm',            'Thang', 15000000),
        ('ML04', N'Chuyên viên',         N'Chuyên viên nghiệp vụ',               'Thang', 17000000),
        ('ML05', N'Chuyên viên chính',   N'Chuyên viên có kinh nghiệm',          'Thang', 20000000),
        ('ML06', N'Quản lý cấp trung',   N'Trưởng phòng',                        'Thang', 28000000),
        ('ML07', N'Quản lý cấp cao',     N'Kế toán trưởng và tương đương',       'Thang', 30000000),
        ('ML08', N'Chuyên gia',          NULL,                                   'Thang', 22000000),  -- [CA BIÊN: MoTa NULL]
        ('ML09', N'Giám đốc',            N'Điều hành toàn công ty',              'Thang', 45000000),
        ('ML10', N'Thời vụ theo giờ',    N'Đơn giá theo giờ, VND/giờ',           'Gio',      45000);  -- [CA BIÊN: lương theo giờ]

    /* 2. LuongNhanVien: 20 dòng. Dòng sau nối tiếp dòng trước (NgayBatDau = NgayKetThuc + 1). */
    INSERT INTO dbo.LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc)
    VALUES
        ('LN0001', 'NV0001', 'ML09', '2019-01-01', NULL),
        ('LN0002', 'NV0002', 'ML06', '2020-04-01', NULL),
        ('LN0003', 'NV0003', 'ML03', '2022-08-15', '2024-08-14'),
        ('LN0004', 'NV0003', 'ML05', '2024-08-15', NULL),          -- [CA BIÊN: tăng lương nối tiếp]
        ('LN0005', 'NV0004', 'ML07', '2021-07-01', NULL),
        ('LN0006', 'NV0005', 'ML10', '2026-06-01', NULL),          -- [CA BIÊN: thời vụ, lương giờ]
        ('LN0007', 'NV0006', 'ML04', '2021-03-01', '2025-12-31'),  -- [CA BIÊN: đã nghỉ, không còn dòng hiện hành]
        ('LN0008', 'NV0007', 'ML02', '2021-01-01', '2023-12-31'),
        ('LN0009', 'NV0007', 'ML05', '2024-01-01', NULL),          -- [CA BIÊN: tăng lương nối tiếp]
        ('LN0010', 'NV0008', 'ML10', '2024-01-01', '2024-06-30'),  -- [CA BIÊN: thời vụ đã hết hạn]
        ('LN0011', 'NV0009', 'ML03', '2022-01-01', '2024-12-31'),
        ('LN0012', 'NV0009', 'ML08', '2025-01-01', NULL),          -- [CA BIÊN: tăng lương nối tiếp]
        ('LN0013', 'NV0010', 'ML10', '2026-05-01', NULL),          -- [CA BIÊN: thời vụ đang làm]
        ('LN0014', 'NV0011', 'ML05', '2023-01-01', NULL),
        ('LN0015', 'NV0012', 'ML03', '2022-01-01', '2025-12-31'),  -- [CA BIÊN: đã nghỉ]
        ('LN0016', 'NV0013', 'ML02', '2021-01-01', '2023-12-31'),
        ('LN0017', 'NV0013', 'ML04', '2024-01-01', NULL),          -- [CA BIÊN: tăng lương nối tiếp]
        ('LN0018', 'NV0014', 'ML08', '2024-01-01', NULL),
        ('LN0019', 'NV0015', 'ML02', '2025-01-01', NULL),
        ('LN0020', 'NV0016', 'ML03', '2025-01-01', NULL);

    /* 3. ChamCong: 13 nhân viên đang làm x 3 tháng = 39 dòng.
          NV chính thức: SoGio NULL. Thời vụ (NV0005, NV0010): SoGio 120-200. */
    INSERT INTO dbo.ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, SoGio)
    VALUES
        ('CC000001', 'NV0001', '2026-07', 26, 2000000, NULL),
        ('CC000002', 'NV0001', '2026-08', 24, 2000000, NULL),
        ('CC000003', 'NV0001', '2026-09', 26, 2000000, NULL),
        ('CC000004', 'NV0002', '2026-07', 25, 1000000, NULL),
        ('CC000005', 'NV0002', '2026-08', 24, 1000000, NULL),
        ('CC000006', 'NV0002', '2026-09', 26, 1000000, NULL),
        ('CC000007', 'NV0003', '2026-07', 26,  500000, NULL),
        ('CC000008', 'NV0003', '2026-08', 22,  500000, NULL),
        ('CC000009', 'NV0003', '2026-09',  0,       0, NULL),      -- [CA BIÊN: NgayCong = 0, PhuCap = 0]
        ('CC000010', 'NV0004', '2026-07', 25, 1000000, NULL),
        ('CC000011', 'NV0004', '2026-08', 26, 1000000, NULL),
        ('CC000012', 'NV0004', '2026-09', 23, 1000000, NULL),
        ('CC000013', 'NV0005', '2026-07', 20,       0, 150.0),     -- [CA BIÊN: thời vụ, có SoGio]
        ('CC000014', 'NV0005', '2026-08', 22,       0, 168.0),
        ('CC000015', 'NV0005', '2026-09', 18,       0, 140.5),
        ('CC000016', 'NV0007', '2026-07', 24,  800000, NULL),
        ('CC000017', 'NV0007', '2026-08', 25,  800000, NULL),
        ('CC000018', 'NV0007', '2026-09', 26,  800000, NULL),
        ('CC000019', 'NV0009', '2026-07', 26, 1500000, NULL),
        ('CC000020', 'NV0009', '2026-08', 25, 1500000, NULL),
        ('CC000021', 'NV0009', '2026-09', 24, 1500000, NULL),
        ('CC000022', 'NV0010', '2026-07', 20,       0, 130.0),
        ('CC000023', 'NV0010', '2026-08', 24,       0, 176.0),
        ('CC000024', 'NV0010', '2026-09', 21,       0, 160.0),
        ('CC000025', 'NV0011', '2026-07', 25, 1500000, NULL),
        ('CC000026', 'NV0011', '2026-08', 26, 1500000, NULL),
        ('CC000027', 'NV0011', '2026-09', 24, 1500000, NULL),
        ('CC000028', 'NV0013', '2026-07', 24,  300000, NULL),
        ('CC000029', 'NV0013', '2026-08', 25,  300000, NULL),
        ('CC000030', 'NV0013', '2026-09', 26,  300000, NULL),
        ('CC000031', 'NV0014', '2026-07', 26, 1500000, NULL),
        ('CC000032', 'NV0014', '2026-08', 26, 1500000, NULL),
        ('CC000033', 'NV0014', '2026-09', 25, 1500000, NULL),
        ('CC000034', 'NV0015', '2026-07', 23,  300000, NULL),
        ('CC000035', 'NV0015', '2026-08', 24,  300000, NULL),
        ('CC000036', 'NV0015', '2026-09', 26,  300000, NULL),
        ('CC000037', 'NV0016', '2026-07', 25,  300000, NULL),
        ('CC000038', 'NV0016', '2026-08', 26,  300000, NULL),
        ('CC000039', 'NV0016', '2026-09', 22,  300000, NULL);

    COMMIT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
END CATCH;
GO

/* ===== Truy vấn kiểm chứng (chỉ SELECT) ===== */
-- a. Số dòng: kỳ vọng MucLuong = 10, LuongNhanVien = 20, ChamCong = 39.
SELECT N'MucLuong' AS TenBang, COUNT(*) AS SoDong FROM dbo.MucLuong
UNION ALL SELECT N'LuongNhanVien', COUNT(*) FROM dbo.LuongNhanVien
UNION ALL SELECT N'ChamCong', COUNT(*) FROM dbo.ChamCong;

-- b. NV không có dòng lương: kỳ vọng 0 dòng.
SELECT nv.MaNV FROM dbo.NhanVien AS nv
WHERE NOT EXISTS (SELECT 1 FROM dbo.LuongNhanVien AS l WHERE l.MaNV = nv.MaNV);

-- c. NV đang làm có số dòng lương hiện hành khác 1: kỳ vọng 0 dòng.
SELECT t.MaNV, COUNT(l.MaLuongNhanVien) AS SoDongHienHanh
FROM dbo.v_NhanVien_TrangThai AS t
LEFT JOIN dbo.LuongNhanVien AS l ON l.MaNV = t.MaNV AND l.NgayKetThuc IS NULL
WHERE t.TrangThai = 'DangLam'
GROUP BY t.MaNV HAVING COUNT(l.MaLuongNhanVien) <> 1;

-- d. NV đã nghỉ còn dòng lương hiện hành: kỳ vọng 0 dòng.
SELECT t.MaNV FROM dbo.v_NhanVien_TrangThai AS t
JOIN dbo.LuongNhanVien AS l ON l.MaNV = t.MaNV AND l.NgayKetThuc IS NULL
WHERE t.TrangThai = 'DaNghi';

-- e. Dòng lương chồng chéo của cùng NV: kỳ vọng 0 dòng.
SELECT a.MaNV, a.MaLuongNhanVien AS Ma1, b.MaLuongNhanVien AS Ma2
FROM dbo.LuongNhanVien AS a
JOIN dbo.LuongNhanVien AS b ON b.MaNV = a.MaNV AND b.MaLuongNhanVien > a.MaLuongNhanVien
 AND a.NgayBatDau <= ISNULL(b.NgayKetThuc, '9999-12-31')
 AND b.NgayBatDau <= ISNULL(a.NgayKetThuc, '9999-12-31');

-- f. ThoiVu không dùng mức Gio, hoặc ChinhThuc dùng mức Gio: kỳ vọng 0 dòng.
SELECT nv.MaNV, nv.LoaiNV, m.HinhThuc
FROM dbo.LuongNhanVien AS l
JOIN dbo.NhanVien AS nv ON nv.MaNV = l.MaNV
JOIN dbo.MucLuong AS m ON m.MaMucLuong = l.MaMucLuong
WHERE (nv.LoaiNV = 'ThoiVu' AND m.HinhThuc <> 'Gio')
   OR (nv.LoaiNV = 'ChinhThuc' AND m.HinhThuc <> 'Thang');

-- g. Chấm công ngoài thời gian hợp đồng (hợp đồng phải phủ cả tháng): kỳ vọng 0 dòng.
SELECT cc.MaChamCong, cc.MaNV, cc.Thang FROM dbo.ChamCong AS cc
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.HopDongLaoDong AS h
    WHERE h.MaNV = cc.MaNV
      AND h.TuNgay <= CAST(cc.Thang + '-01' AS DATE)
      AND (h.DenNgay IS NULL OR h.DenNgay >= EOMONTH(CAST(cc.Thang + '-01' AS DATE))));

-- h. SoGio NULL với ThoiVu, hoặc khác NULL với ChinhThuc: kỳ vọng 0 dòng.
SELECT cc.MaChamCong, nv.LoaiNV, cc.SoGio
FROM dbo.ChamCong AS cc JOIN dbo.NhanVien AS nv ON nv.MaNV = cc.MaNV
WHERE (nv.LoaiNV = 'ThoiVu' AND cc.SoGio IS NULL)
   OR (nv.LoaiNV = 'ChinhThuc' AND cc.SoGio IS NOT NULL);
GO