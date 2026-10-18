/* Hàm thuần: xử lý dữ liệu nhân viên độc lập, không truy cập DOM. */

/**
 * Chuyển ký tự nguy hiểm thành thực thể HTML để dữ liệu an toàn khi kết xuất.
 * Giá trị null, undefined và số được chuyển thành chuỗi trước khi xử lý.
 */
function escapeHTML(chuoi) {
  const giaTri = chuoi === null || chuoi === undefined ? "" : String(chuoi);
  return giaTri.replace(/[&<>"']/g, (kyTu) => {
    const thucThe = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#39;"
    };
    return thucThe[kyTu];
  });
}

/**
 * Chuẩn hóa chuỗi tiếng Việt về chữ thường không dấu để tìm kiếm nhất quán.
 * Chuỗi sai kiểu được xem như chuỗi rỗng và chữ đ được đổi thành d.
 */
function boDauTiengViet(chuoi) {
  const giaTri = chuoi === null || chuoi === undefined ? "" : String(chuoi);
  return giaTri
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d");
}

/**
 * Định dạng ngày ISO hợp lệ thành ngày Việt Nam dd/mm/yyyy.
 * Ngày rỗng hoặc không đúng mẫu ISO được trả về dấu gạch ngang.
 */
function dinhDangNgay(iso) {
  if (typeof iso !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(iso)) {
    return "—";
  }
  const [nam, thang, ngay] = iso.split("-").map(Number);
  const soNgayTheoThang = [31, (nam % 4 === 0 && nam % 100 !== 0) || nam % 400 === 0 ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (thang < 1 || thang > 12 || ngay < 1 || ngay > soNgayTheoThang[thang - 1]) {
    return "—";
  }
  return `${String(ngay).padStart(2, "0")}/${String(thang).padStart(2, "0")}/${String(nam).padStart(4, "0")}`;
}

/**
 * Lấy chữ cái đầu của từ đầu và từ cuối trong họ tên.
 * Tên thiếu hoặc chỉ có khoảng trắng được trả về dấu hỏi.
 */
function layChuCaiDau(hoTen) {
  const cacTu = typeof hoTen === "string" ? hoTen.trim().split(/\s+/).filter(Boolean) : [];
  if (cacTu.length === 0) {
    return "?";
  }
  const tuDau = cacTu[0].charAt(0);
  const tuCuoi = cacTu[cacTu.length - 1].charAt(0);
  return `${tuDau}${tuCuoi}`.toUpperCase();
}

/**
 * Đổi mã trạng thái nghiệp vụ sang nhãn tiếng Việt hiển thị cho người dùng.
 * Mã không được biết sẽ hiển thị là trạng thái không xác định.
 */
function nhanTrangThai(ma) {
  const nhan = {
    DangLam: "Đang làm việc",
    DaNghi: "Đã nghỉ việc"
  };
  return nhan[ma] || "Không xác định";
}

/**
 * Tìm tên phòng ban theo mã trong Data Contract.
 * Danh sách sai kiểu hoặc mã không tồn tại đều trả về nhãn dự phòng.
 */
function layTenPhongBan(dsPB, maPB) {
  if (!Array.isArray(dsPB)) {
    return "Chưa phân phòng";
  }
  const phongBan = dsPB.find((phong) => phong && phong.MaPB === maPB);
  return phongBan && typeof phongBan.TenPB === "string" ? phongBan.TenPB : "Chưa phân phòng";
}

/**
 * Lọc nhân viên theo từ khóa, phòng ban và trạng thái mà không sửa mảng đầu vào.
 * Từ khóa được tìm trong họ tên, mã nhân viên và số điện thoại không dấu.
 */
function locNhanVien(dsNV, boLoc) {
  if (!Array.isArray(dsNV)) {
    return [];
  }
  const loc = boLoc && typeof boLoc === "object" ? boLoc : {};
  const tuKhoa = boDauTiengViet(loc.tuKhoa).trim();
  const maPB = typeof loc.maPB === "string" ? loc.maPB.trim() : "";
  const trangThai = typeof loc.trangThai === "string" ? loc.trangThai.trim() : "";

  return dsNV.filter((nhanVien) => {
    if (!nhanVien || typeof nhanVien !== "object") {
      return false;
    }
    const noiDungTimKiem = [nhanVien.HoTen, nhanVien.MaNV, nhanVien.DienThoai]
      .map((giaTri) => boDauTiengViet(giaTri))
      .join(" ");
    const khopTuKhoa = !tuKhoa || noiDungTimKiem.includes(tuKhoa);
    const khopPhongBan = !maPB || nhanVien.MaPB === maPB;
    const khopTrangThai = !trangThai || nhanVien.TrangThai === trangThai;
    return khopTuKhoa && khopPhongBan && khopTrangThai;
  });
}

/**
 * Đếm tổng số, số đang làm và số đã nghỉ bằng reduce.
 * Dữ liệu không phải mảng hoặc bản ghi thiếu trạng thái vẫn được xử lý an toàn.
 */
function thongKeNhanVien(dsNV) {
  if (!Array.isArray(dsNV)) {
    return { tong: 0, dangLam: 0, daNghi: 0 };
  }
  return dsNV.reduce((ketQua, nhanVien) => {
    if (!nhanVien || typeof nhanVien !== "object") {
      return ketQua;
    }
    ketQua.tong += 1;
    if (nhanVien.TrangThai === "DangLam") {
      ketQua.dangLam += 1;
    }
    if (nhanVien.TrangThai === "DaNghi") {
      ketQua.daNghi += 1;
    }
    return ketQua;
  }, { tong: 0, dangLam: 0, daNghi: 0 });
}

/**
 * Đếm nhân viên theo từng phòng ban bằng map kết hợp filter.
 * Phòng ban không có nhân viên vẫn được giữ lại với SoLuong bằng 0.
 */
function demNhanVienTheoPhong(dsNV, dsPB) {
  if (!Array.isArray(dsPB)) {
    return [];
  }
  const danhSachNhanVien = Array.isArray(dsNV) ? dsNV : [];
  return dsPB.map((phongBan) => {
    const maPB = phongBan && phongBan.MaPB ? phongBan.MaPB : "";
    const soLuong = danhSachNhanVien.filter((nhanVien) => nhanVien && nhanVien.MaPB === maPB).length;
    return {
      MaPB: maPB,
      TenPB: phongBan && typeof phongBan.TenPB === "string" ? phongBan.TenPB : "Chưa phân phòng",
      SoLuong: soLuong
    };
  });
}
