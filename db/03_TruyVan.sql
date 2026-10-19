USE QLNhanSu;
GO
/* ===== ĐƠN GIẢN ===== */
-- Q1. Nhân viên nữ sinh trước năm 1990. Kỳ vọng: NV0002, NV0004, NV0009, NV0011? (kiểm tra theo NgaySinh trong dữ liệu)
SELECT MaNV, HoTen, NgaySinh FROM dbo.NhanVien
WHERE GioiTinh = N'Nữ' AND NgaySinh < '1990-01-01';

-- Q2. Nhân viên thời vụ. Kỳ vọng: NV0005, NV0008, NV0010.
SELECT MaNV, HoTen, ChucVu FROM dbo.NhanVien WHERE LoaiNV = 'ThoiVu';

-- Q3. Nhân viên có chức vụ chứa "Trưởng phòng".
SELECT MaNV, HoTen, ChucVu, MaPB FROM dbo.NhanVien WHERE ChucVu LIKE N'%Trưởng phòng%';

-- Q4 (NL→SQL). Nhân viên thiếu email hoặc số điện thoại. Kỳ vọng: NV0012, NV0013.
SELECT MaNV, HoTen, DienThoai, Email FROM dbo.NhanVien
WHERE Email IS NULL OR DienThoai IS NULL;

/* ===== KẾT NỐI ===== */
-- Q5. Nhân viên kèm tên phòng ban. Kỳ vọng: 16 dòng.
SELECT nv.MaNV, nv.HoTen, pb.TenPB
FROM dbo.NhanVien AS nv JOIN dbo.PhongBan AS pb ON pb.MaPB = nv.MaPB;

-- Q6. Mọi phòng ban kèm số nhân viên (kết ngoài). Kỳ vọng: 10 dòng; PB04, PB07 bằng 0.
SELECT pb.MaPB, pb.TenPB, COUNT(nv.MaNV) AS SoNV
FROM dbo.PhongBan AS pb LEFT JOIN dbo.NhanVien AS nv ON nv.MaPB = pb.MaPB
GROUP BY pb.MaPB, pb.TenPB ORDER BY pb.MaPB;

-- Q7 (NL→SQL). Mỗi nhân viên và tên quản lý trực tiếp (kể cả người không có quản lý). Kỳ vọng: 16 dòng; NV0001 có quản lý NULL.
SELECT nv.MaNV, nv.HoTen, ql.HoTen AS QuanLyTrucTiep
FROM dbo.NhanVien AS nv LEFT JOIN dbo.NhanVien AS ql ON ql.MaNV = nv.MaQuanLyTrucTiep;

/* ===== GOM NHÓM ===== */
-- Q8. Phòng có từ 2 nhân viên đang làm trở lên. Kỳ vọng: PB02 (3), PB03, PB06, PB08, PB10 (2).
SELECT MaPB, TenPB, COUNT(*) AS SoDangLam
FROM dbo.v_NhanVien_TrangThai WHERE TrangThai = 'DangLam'
GROUP BY MaPB, TenPB HAVING COUNT(*) >= 2 ORDER BY SoDangLam DESC, MaPB;

-- Q9. Số nhân viên theo loại và giới tính.
SELECT LoaiNV, GioiTinh, COUNT(*) AS SoNV
FROM dbo.NhanVien GROUP BY LoaiNV, GioiTinh ORDER BY LoaiNV, GioiTinh;

-- Q10 (NL→SQL). Nhân viên có từ 2 hợp đồng trở lên. Kỳ vọng: NV0003, NV0007, NV0009, NV0013 (mỗi người 2).
SELECT nv.MaNV, nv.HoTen, COUNT(*) AS SoHopDong
FROM dbo.NhanVien AS nv JOIN dbo.HopDongLaoDong AS hd ON hd.MaNV = nv.MaNV
GROUP BY nv.MaNV, nv.HoTen HAVING COUNT(*) >= 2 ORDER BY SoHopDong DESC, nv.MaNV;

/* ===== LỒNG ===== */
-- Q11. Phòng ban chưa có nhân viên (NOT EXISTS). Kỳ vọng: PB04, PB07.
SELECT pb.MaPB, pb.TenPB FROM dbo.PhongBan AS pb
WHERE NOT EXISTS (SELECT 1 FROM dbo.NhanVien AS nv WHERE nv.MaPB = pb.MaPB);

-- Q12. Nhân viên từng ký hợp đồng thời vụ (loại 3) (IN). Kỳ vọng: NV0005, NV0008, NV0010.
SELECT MaNV, HoTen FROM dbo.NhanVien
WHERE MaNV IN (SELECT MaNV FROM dbo.HopDongLaoDong WHERE LoaiHD = 3);

-- Q13 (NL→SQL, câu "tất cả"). Phòng có nhân viên nhưng không còn ai đang làm. Kỳ vọng: PB09.
SELECT pb.MaPB, pb.TenPB FROM dbo.PhongBan AS pb
WHERE EXISTS (SELECT 1 FROM dbo.NhanVien AS nv WHERE nv.MaPB = pb.MaPB)
  AND NOT EXISTS (SELECT 1 FROM dbo.v_NhanVien_TrangThai AS t
                  WHERE t.MaPB = pb.MaPB AND t.TrangThai = 'DangLam');

-- Q14 (ALL). Nhân viên vào làm sớm hơn tất cả nhân viên Phòng Kế toán (PB03).
-- Kỳ vọng: NV0001, NV0002, NV0006, NV0007, NV0013.
SELECT MaNV, HoTen, NgayVaoLam FROM dbo.v_NhanVien_TrangThai
WHERE NgayVaoLam < ALL (SELECT NgayVaoLam FROM dbo.v_NhanVien_TrangThai WHERE MaPB = 'PB03')
ORDER BY NgayVaoLam;

/* ===== TẬP HỢP ===== */
-- Q15. UNION: nhân viên thời vụ hoặc đã nghỉ. Kỳ vọng: NV0005, NV0006, NV0008, NV0010, NV0012.
SELECT MaNV, HoTen FROM dbo.NhanVien WHERE LoaiNV = 'ThoiVu'
UNION
SELECT MaNV, HoTen FROM dbo.v_NhanVien_TrangThai WHERE TrangThai = 'DaNghi';

-- Q16. EXCEPT: nhân viên đã nghỉ nhưng không phải thời vụ. Kỳ vọng: NV0006, NV0012.
SELECT MaNV, HoTen FROM dbo.v_NhanVien_TrangThai WHERE TrangThai = 'DaNghi'
EXCEPT
SELECT MaNV, HoTen FROM dbo.NhanVien WHERE LoaiNV = 'ThoiVu';

/* ===== CTE ===== */
-- Q17. CTE đệ quy: cây quản lý từ cấp cao nhất. Kỳ vọng: 16 dòng, NV0001 cấp 1, tối đa 4-5 cấp.
WITH CayQL AS (
    SELECT MaNV, HoTen, 1 AS Cap, CAST(HoTen AS NVARCHAR(1000)) AS Duong
    FROM dbo.NhanVien WHERE MaQuanLyTrucTiep IS NULL
    UNION ALL
    SELECT n.MaNV, n.HoTen, c.Cap + 1, CAST(c.Duong + N' > ' + n.HoTen AS NVARCHAR(1000))
    FROM dbo.NhanVien AS n JOIN CayQL AS c ON n.MaQuanLyTrucTiep = c.MaNV
)
SELECT MaNV, HoTen, Cap, Duong FROM CayQL ORDER BY Duong
OPTION (MAXRECURSION 100);

-- Q18. CTE: phòng có số nhân viên đang làm cao hơn trung bình các phòng có người đang làm.
WITH SoLam AS (
    SELECT MaPB, TenPB, COUNT(*) AS SoDangLam
    FROM dbo.v_NhanVien_TrangThai WHERE TrangThai = 'DangLam' GROUP BY MaPB, TenPB
)
SELECT MaPB, TenPB, SoDangLam FROM SoLam
WHERE SoDangLam > (SELECT AVG(CAST(SoDangLam AS FLOAT)) FROM SoLam);

/* ===== RANKING ===== */
-- Q19 (NL→SQL). Chia nhân viên đang làm thành 4 nhóm thâm niên (NTILE). Kỳ vọng: 13 dòng, 4 nhóm cỡ 4/3/3/3.
SELECT MaNV, HoTen, NgayVaoLam,
       NTILE(4) OVER (ORDER BY NgayVaoLam) AS NhomThamNien
FROM dbo.v_NhanVien_TrangThai WHERE TrangThai = 'DangLam';

-- Q20. Xếp hạng thâm niên trong từng phòng (DENSE_RANK, ROW_NUMBER).
SELECT MaPB, MaNV, HoTen, NgayVaoLam,
       ROW_NUMBER() OVER (PARTITION BY MaPB ORDER BY NgayVaoLam) AS STT,
       DENSE_RANK() OVER (PARTITION BY MaPB ORDER BY NgayVaoLam) AS HangThamNien
FROM dbo.v_NhanVien_TrangThai ORDER BY MaPB, STT;
GO

/* ===== VIEW 1/3: nhân viên đã nghỉ việc ===== */
CREATE OR ALTER VIEW dbo.v_NhanVien_DaNghi AS
SELECT MaNV, HoTen, ChucVu, MaPB, TenPB, LoaiNV, NgayVaoLam, NgayNghiViec
FROM dbo.v_NhanVien_TrangThai WHERE TrangThai = 'DaNghi';
GO
SELECT * FROM dbo.v_NhanVien_DaNghi;  -- kỳ vọng: NV0006, NV0008, NV0012