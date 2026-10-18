USE QLNhanSu;
GO
/* ===== VIEW 2/3: nhân viên đang làm có lương tháng hiện hành thấp nhất ===== */
CREATE OR ALTER VIEW dbo.v_NhanVien_LuongThapNhat AS
SELECT t.MaNV, t.HoTen, t.MaPB, m.TenMucLuong, m.SoTien
FROM dbo.v_NhanVien_TrangThai AS t
JOIN dbo.LuongNhanVien AS l ON l.MaNV = t.MaNV AND l.NgayKetThuc IS NULL
JOIN dbo.MucLuong AS m ON m.MaMucLuong = l.MaMucLuong
WHERE t.TrangThai = 'DangLam' AND m.HinhThuc = 'Thang'
  AND m.SoTien = (SELECT MIN(m2.SoTien)
                  FROM dbo.LuongNhanVien AS l2
                  JOIN dbo.MucLuong AS m2 ON m2.MaMucLuong = l2.MaMucLuong
                  JOIN dbo.v_NhanVien_TrangThai AS t2 ON t2.MaNV = l2.MaNV
                  WHERE l2.NgayKetThuc IS NULL AND t2.TrangThai = 'DangLam' AND m2.HinhThuc = 'Thang');
GO
/* ===== VIEW 3/3: hồ sơ nhân viên, ẩn lương, CMND, quê quán (cấp cho NhanSu/TruongPhong ở Chương 8) ===== */
CREATE OR ALTER VIEW dbo.v_NhanVien_AnLuong AS
SELECT MaNV, HoTen, GioiTinh, NgaySinh, DienThoai, Email, LoaiNV, ChucVu,
       MaPB, TenPB, MaQuanLyTrucTiep, TenQuanLyTrucTiep, NgayVaoLam, TrangThai
FROM dbo.v_NhanVien_TrangThai;
GO

SELECT * FROM dbo.v_NhanVien_LuongThapNhat;
-- Kỳ vọng: 1 dòng, NV0015, mức ML02, 12.000.000
SELECT COUNT(*) AS SoDong FROM dbo.v_NhanVien_AnLuong;
-- Kỳ vọng: 16
GO

/* ===== Q21. Nhân viên đang làm, lương tháng hiện hành cao hơn trung bình phòng (OVER PARTITION) ===== */
WITH L AS (
    SELECT t.MaNV, t.HoTen, t.MaPB, m.SoTien,
           AVG(CAST(m.SoTien AS FLOAT)) OVER (PARTITION BY t.MaPB) AS TBPhong
    FROM dbo.v_NhanVien_TrangThai AS t
    JOIN dbo.LuongNhanVien AS l ON l.MaNV = t.MaNV AND l.NgayKetThuc IS NULL
    JOIN dbo.MucLuong AS m ON m.MaMucLuong = l.MaMucLuong
    WHERE t.TrangThai = 'DangLam' AND m.HinhThuc = 'Thang'
)
SELECT MaNV, HoTen, MaPB, SoTien, TBPhong FROM L WHERE SoTien > TBPhong ORDER BY MaPB;
-- Kỳ vọng: NV0002 (PB02, TB 21.000.000), NV0011 (PB08, TB 18.500.000), NV0014 (PB10, TB 17.000.000)
GO