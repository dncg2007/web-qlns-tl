/* Hàm thuần: xử lý dữ liệu nhân viên độc lập, không truy cập DOM. */

/** Chuyển ký tự nguy hiểm thành thực thể HTML để dữ liệu an toàn khi kết xuất. */
function escapeHTML(chuoi) {
  const giaTri = chuoi === null || chuoi === undefined ? "" : String(chuoi);
  return giaTri.replace(/[&<>"']/g, (kyTu) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[kyTu]));
}

/** Chuẩn hóa tiếng Việt về chữ thường không dấu để tìm kiếm nhất quán. */
function boDauTiengViet(chuoi) {
  const giaTri = chuoi === null || chuoi === undefined ? "" : String(chuoi);
  return giaTri.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/đ/g, "d");
}

/** Định dạng ngày ISO hợp lệ thành dd/mm/yyyy; dữ liệu sai trả dấu gạch. */
function dinhDangNgay(iso) {
  if (typeof iso !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(iso)) return "—";
  const [nam, thang, ngay] = iso.split("-").map(Number);
  const soNgay = [31, (nam % 4 === 0 && nam % 100 !== 0) || nam % 400 === 0 ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (thang < 1 || thang > 12 || ngay < 1 || ngay > soNgay[thang - 1]) return "—";
  return `${String(ngay).padStart(2, "0")}/${String(thang).padStart(2, "0")}/${String(nam).padStart(4, "0")}`;
}

/** Lấy chữ cái đầu của từ đầu và từ cuối trong họ tên. */
function layChuCaiDau(hoTen) {
  const cacTu = typeof hoTen === "string" ? hoTen.trim().split(/\s+/).filter(Boolean) : [];
  if (cacTu.length === 0) return "?";
  return `${cacTu[0].charAt(0)}${cacTu[cacTu.length - 1].charAt(0)}`.toUpperCase();
}

/** Đổi mã trạng thái nghiệp vụ sang nhãn tiếng Việt. */
function nhanTrangThai(ma) {
  return { DangLam: "Đang làm việc", DaNghi: "Đã nghỉ việc" }[ma] || "Không xác định";
}

/** Tìm tên phòng ban theo mã, không tìm thấy thì trả nhãn dự phòng. */
function layTenPhongBan(dsPB, maPB) {
  if (!Array.isArray(dsPB)) return "Chưa phân phòng";
  const phongBan = dsPB.find((phong) => phong && phong.MaPB === maPB);
  return phongBan && typeof phongBan.TenPB === "string" ? phongBan.TenPB : "Chưa phân phòng";
}

/** Lọc theo từ khóa, phòng ban và trạng thái mà không sửa mảng gốc. */
function locNhanVien(dsNV, boLoc) {
  if (!Array.isArray(dsNV)) return [];
  const loc = boLoc && typeof boLoc === "object" ? boLoc : {};
  const tuKhoa = boDauTiengViet(loc.tuKhoa).trim();
  const maPB = typeof loc.maPB === "string" ? loc.maPB.trim() : "";
  const trangThai = typeof loc.trangThai === "string" ? loc.trangThai.trim() : "";
  return dsNV.filter((nhanVien) => {
    if (!nhanVien || typeof nhanVien !== "object") return false;
    const noiDung = [nhanVien.HoTen, nhanVien.MaNV, nhanVien.DienThoai].map(boDauTiengViet).join(" ");
    return (!tuKhoa || noiDung.includes(tuKhoa)) && (!maPB || nhanVien.MaPB === maPB) && (!trangThai || nhanVien.TrangThai === trangThai);
  });
}

/** Đếm tổng quân số và trạng thái bằng reduce. */
function thongKeNhanVien(dsNV) {
  if (!Array.isArray(dsNV)) return { tong: 0, dangLam: 0, daNghi: 0 };
  return dsNV.reduce((ketQua, nhanVien) => {
    if (!nhanVien || typeof nhanVien !== "object") return ketQua;
    ketQua.tong += 1;
    if (nhanVien.TrangThai === "DangLam") ketQua.dangLam += 1;
    if (nhanVien.TrangThai === "DaNghi") ketQua.daNghi += 1;
    return ketQua;
  }, { tong: 0, dangLam: 0, daNghi: 0 });
}

/** Đếm nhân viên theo phòng ban bằng map và filter. */
function demNhanVienTheoPhong(dsNV, dsPB) {
  if (!Array.isArray(dsPB)) return [];
  const danhSachNhanVien = Array.isArray(dsNV) ? dsNV : [];
  return dsPB.map((phongBan) => ({
    MaPB: phongBan && phongBan.MaPB ? phongBan.MaPB : "",
    TenPB: phongBan && typeof phongBan.TenPB === "string" ? phongBan.TenPB : "Chưa phân phòng",
    SoLuong: danhSachNhanVien.filter((nhanVien) => nhanVien && nhanVien.MaPB === (phongBan && phongBan.MaPB)).length
  }));
}

/** Sinh mã nhân viên kế tiếp theo độ rộng mã lớn nhất hiện có. */
/** Suy ra trạng thái hợp đồng tại ngày tham chiếu theo view SQL, không dùng Date. */
function suyRaTrangThai(maNV, dsHopDong, ngayThamChieu) {
  if (typeof maNV !== "string" || !Array.isArray(dsHopDong) || typeof ngayThamChieu !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(ngayThamChieu)) return "DaNghi";
  return dsHopDong.some((hopDong) => hopDong && hopDong.MaNV === maNV && typeof hopDong.TuNgay === "string" && hopDong.TuNgay <= ngayThamChieu && (!hopDong.DenNgay || (typeof hopDong.DenNgay === "string" && hopDong.DenNgay >= ngayThamChieu))) ? "DangLam" : "DaNghi";
}

function sinhMaNhanVien(dsNV) {
  const danhSach = Array.isArray(dsNV) ? dsNV : [];
  const maHopLe = danhSach.map((nv) => nv && typeof nv.MaNV === "string" ? nv.MaNV.match(/^(.*?)(\d+)$/) : null).filter(Boolean);
  const doRong = maHopLe.reduce((max, match) => Math.max(max, match[2].length), 4);
  const soLonNhat = maHopLe.reduce((max, match) => Math.max(max, Number(match[2])), 0);
  return `NV${String(soLonNhat + 1).padStart(doRong, "0")}`;
}

/** Tính tuổi theo ngày tham chiếu bằng phép so sánh chuỗi ISO, không dùng Date. */
function tinhTuoi(ngaySinh, ngayThamChieu) {
  if (typeof ngaySinh !== "string" || typeof ngayThamChieu !== "string") return -1;
  if (!/^\d{4}-\d{2}-\d{2}$/.test(ngaySinh) || !/^\d{4}-\d{2}-\d{2}$/.test(ngayThamChieu)) return -1;
  const [namSinh, thangSinh, ngaySinhSo] = ngaySinh.split("-").map(Number);
  const [namRef, thangRef, ngayRef] = ngayThamChieu.split("-").map(Number);
  let tuoi = namRef - namSinh;
  if (thangRef < thangSinh || (thangRef === thangSinh && ngayRef < ngaySinhSo)) tuoi -= 1;
  return tuoi;
}

/** Kiểm tra ngày theo lịch và giới hạn ngày tham chiếu. */
function laNgayHopLe(iso, ngayThamChieu) {
  return dinhDangNgay(iso) !== "—" && (!ngayThamChieu || iso <= ngayThamChieu);
}

/** Kiểm tra dữ liệu nhân viên mới và trả danh sách lỗi theo trường. */
function kiemTraNhanVien(duLieu, dsNV, dsPB, ngayThamChieu) {
  const duLieuAnToan = duLieu && typeof duLieu === "object" ? duLieu : {};
  const danhSach = Array.isArray(dsNV) ? dsNV : [];
  const phongBan = Array.isArray(dsPB) ? dsPB : [];
  const loi = [];
  const themLoi = (truong, thongBao) => loi.push({ truong, thongBao });
  const hoTen = typeof duLieuAnToan.HoTen === "string" ? duLieuAnToan.HoTen.trim() : "";
  // Regex: ^ bắt đầu, [^\s]+ là từ không có khoảng trắng, \s+ là ít nhất một khoảng trắng, $ kết thúc.
  if (!/^[^\s]{2,}(?:\s+[^\s]{2,})+$/.test(hoTen)) themLoi("HoTen", "Họ tên cần ít nhất 2 từ, mỗi từ tối thiểu 2 ký tự.");
  if (!["Nam", "Nữ", "Khác"].includes(duLieuAnToan.GioiTinh)) themLoi("GioiTinh", "Vui lòng chọn giới tính hợp lệ.");
  if (!laNgayHopLe(duLieuAnToan.NgaySinh, ngayThamChieu) || tinhTuoi(duLieuAnToan.NgaySinh, ngayThamChieu) < 18) themLoi("NgaySinh", "Ngày sinh không hợp lệ hoặc nhân viên chưa đủ 18 tuổi.");
  // Regex: ^\d{9}(\d{3})?$ nghĩa là đúng 9 hoặc 12 chữ số và không có ký tự khác.
  if (typeof duLieuAnToan.CMND !== "string" || !/^\d{9}(\d{3})?$/.test(duLieuAnToan.CMND) || danhSach.some((nv) => nv.CMND === duLieuAnToan.CMND)) themLoi("CMND", "CMND/CCCD phải có 9 hoặc 12 chữ số và không trùng.");
  // Regex: ^0 bắt đầu bằng số 0, \d{9} thêm đúng 9 chữ số, $ kết thúc chuỗi.
  if (typeof duLieuAnToan.DienThoai !== "string" || !/^0\d{9}$/.test(duLieuAnToan.DienThoai) || danhSach.some((nv) => nv.DienThoai === duLieuAnToan.DienThoai)) themLoi("DienThoai", "Số điện thoại phải có 10 chữ số bắt đầu bằng 0 và không trùng.");
  if (!laNgayHopLe(duLieuAnToan.NgayCap, ngayThamChieu) || duLieuAnToan.NgayCap <= duLieuAnToan.NgaySinh) themLoi("NgayCap", "Ngày cấp phải sau ngày sinh và không sau ngày tham chiếu.");
  ["NoiCap", "QueQuan", "ChucVu"].forEach((truong) => { if (typeof duLieuAnToan[truong] !== "string" || !duLieuAnToan[truong].trim()) themLoi(truong, "Trường này không được để trống."); });
  if (!phongBan.some((pb) => pb.MaPB === duLieuAnToan.MaPB)) themLoi("MaPB", "Phòng ban không tồn tại.");
  return loi;
}

/** Thêm nhân viên bằng spread và trả về mảng mới, không sửa mảng đầu vào. */
function themNhanVien(dsNV, nhanVienMoi) {
  return [...(Array.isArray(dsNV) ? dsNV : []), nhanVienMoi && typeof nhanVienMoi === "object" ? { ...nhanVienMoi } : {}];
}

/** Lấy hồ sơ nhân viên, phòng ban, lương và hợp đồng hiện hành. */
function layHoSoNhanVien(maNV, dsNV, dsPB, dsLuong, dsMucLuong, dsHopDong, ngayThamChieu) {
  const nhanVien = Array.isArray(dsNV) ? dsNV.find((nv) => nv && nv.MaNV === maNV) : null;
  if (!nhanVien) return null;
  const hopDong = Array.isArray(dsHopDong) ? dsHopDong.filter((hd) => hd.MaNV === maNV && hd.TuNgay <= ngayThamChieu && (!hd.DenNgay || hd.DenNgay >= ngayThamChieu)).sort((a, b) => b.TuNgay.localeCompare(a.TuNgay))[0] : null;
  return {
    nhanVien: { ...nhanVien },
    TenPB: layTenPhongBan(dsPB, nhanVien.MaPB),
    MucLuong: layLuongHienHanh(maNV, dsLuong, dsMucLuong, ngayThamChieu),
    HopDong: hopDong ? { LoaiHD: hopDong.LoaiHD, TuNgay: hopDong.TuNgay, DenNgay: hopDong.DenNgay || null } : null
  };
}

/** Chọn mức lương có ngày bắt đầu mới nhất còn hiệu lực tại ngày tham chiếu. */
function layLuongHienHanh(maNV, dsLuong, dsMucLuong, ngayThamChieu) {
  if (!Array.isArray(dsLuong) || !Array.isArray(dsMucLuong)) return 0;
  const dongLuong = dsLuong.filter((luong) => luong.MaNV === maNV && luong.NgayBatDau <= ngayThamChieu && (!luong.NgayKetThuc || luong.NgayKetThuc >= ngayThamChieu)).sort((a, b) => b.NgayBatDau.localeCompare(a.NgayBatDau))[0];
  if (!dongLuong) return 0;
  const mucLuong = dsMucLuong.find((muc) => muc.MaMucLuong === dongLuong.MaMucLuong);
  return mucLuong && Number.isFinite(Number(mucLuong.SoTien)) ? Number(mucLuong.SoTien) : 0;
}

/** Tính lương theo ngày công, giới hạn ngày công không vượt chuẩn. */
function tinhLuong(soTienMucLuong, ngayCong, phuCap, ngayCongChuan) {
  const luong = Number(soTienMucLuong);
  const cong = Number(ngayCong);
  const phu = Number(phuCap);
  const chuan = Number(ngayCongChuan);
  if (![luong, cong, phu, chuan].every(Number.isFinite) || luong < 0 || cong < 0 || phu < 0 || chuan <= 0) return 0;
  return Math.round(luong / chuan * Math.min(cong, chuan)) + phu;
}

/** Tạo bảng lương cho nhân viên đang làm có chấm công trong tháng. */
function taoBangLuong(thang, dsNV, dsPB, dsLuong, dsMucLuong, dsChamCong, cauHinh) {
  const ngayCuoi = ngayCuoiThang(thang);
  if (!ngayCuoi || !Array.isArray(dsNV) || !Array.isArray(dsChamCong)) return [];
  return dsNV.filter((nv) => nv.TrangThai === "DangLam").map((nv) => {
    const chamCong = dsChamCong.find((cc) => cc.MaNV === nv.MaNV && cc.Thang === thang);
    if (!chamCong) return null;
    const mucLuong = layLuongHienHanh(nv.MaNV, dsLuong, dsMucLuong, ngayCuoi);
    const ngayCongChuan = cauHinh && cauHinh.NGAY_CONG_CHUAN ? cauHinh.NGAY_CONG_CHUAN : 26;
    return { MaNV: nv.MaNV, HoTen: nv.HoTen, TenPB: layTenPhongBan(dsPB, nv.MaPB), MucLuong: mucLuong, NgayCong: chamCong.NgayCong, PhuCap: chamCong.PhuCap, LuongThucNhan: tinhLuong(mucLuong, chamCong.NgayCong, chamCong.PhuCap, ngayCongChuan) };
  }).filter(Boolean);
}

/** Cộng tổng số nhân viên, quỹ lương và tính lương trung bình. */
function tongQuyLuong(dsBangLuong) {
  const danhSach = Array.isArray(dsBangLuong) ? dsBangLuong : [];
  const tongQuy = danhSach.reduce((tong, dong) => tong + (Number(dong.LuongThucNhan) || 0), 0);
  return { tongNhanVien: danhSach.length, tongQuyLuong: tongQuy, luongTrungBinh: danhSach.length ? tongQuy / danhSach.length : 0 };
}

/** Định dạng tiền Việt Nam; số sai kiểu trả về 0 đ. */
function dinhDangTien(so) {
  const giaTri = Number(so);
  return Number.isFinite(giaTri) && giaTri >= 0 ? `${Math.round(giaTri).toLocaleString("vi-VN")} đ` : "0 đ";
}

/** Tính ngày cuối tháng bằng phép tính số học, không dùng Date. */
function ngayCuoiThang(thang) {
  if (typeof thang !== "string" || !/^\d{4}-(0[1-9]|1[0-2])$/.test(thang)) return null;
  const [nam, soThang] = thang.split("-").map(Number);
  const soNgay = [31, (nam % 4 === 0 && nam % 100 !== 0) || nam % 400 === 0 ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][soThang - 1];
  return `${nam}-${String(soThang).padStart(2, "0")}-${soNgay}`;
}
