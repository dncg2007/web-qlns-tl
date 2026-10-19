USE QLNhanSu;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
SET XACT_ABORT ON;
DELETE FROM dbo.ThanNhan;
GO
INSERT INTO dbo.ThanNhan (MaTN, MaNV, HoTen, GioiTinh, NgaySinh, QuanHe)
VALUES
    ('TN0001', 'NV0001', N'Trần Minh Châu',   N'Nữ',  '2010-03-02', N'Con'),
    ('TN0002', 'NV0001', N'Nguyễn Thị Lan',   N'Nữ',  '1983-07-15', N'Vợ/chồng'),
    ('TN0003', 'NV0002', N'Lê Văn Hải',       N'Nam', '1960-01-10', N'Cha'),
    ('TN0004', 'NV0002', N'Nguyễn Thị Mai',   N'Nữ',  '1962-05-20', N'Mẹ'),
    ('TN0005', 'NV0002', N'Lê Thu Trang',     N'Nữ',  '1992-11-08', N'Chị em'),
    ('TN0006', 'NV0002', N'Phạm Quốc Việt',   N'Nam', '1987-04-04', N'Vợ/chồng'),
    ('TN0007', 'NV0002', N'Phạm Gia Bảo',     N'Nam', '2016-09-12', N'Con'),   -- [CA BIÊN: NV0002 đủ 5 thân nhân]
    ('TN0008', 'NV0004', N'Nguyễn Hoàng Long',N'Nam', '2012-12-01', N'Con'),
    ('TN0009', 'NV0011', N'Lê Hoàng Phúc',    N'Nam', '2019-06-30', N'Con'),
    ('TN0010', 'NV0014', N'Vũ Thảo Nhi',      N'Nữ',  '2020-02-14', N'Con');
GO
SELECT MaNV, COUNT(*) AS SoThanNhan FROM dbo.ThanNhan GROUP BY MaNV ORDER BY MaNV;
-- Kỳ vọng: 10 dòng tổng; NV0001 = 2, NV0002 = 5, NV0004 = 1, NV0011 = 1, NV0014 = 1
GO