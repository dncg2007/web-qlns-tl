/* Kết nối sự kiện và kết xuất DOM cho trang quản lý nhân viên Sprint 1. */

document.addEventListener("DOMContentLoaded", () => {
  const bangNhanVien = document.querySelector("#bang-nhan-vien");
  const thanBangNhanVien = document.querySelector("#than-bang-nhan-vien");
  const formLoc = document.querySelector("#form-loc");
  const oTimKiem = document.querySelector("#o-tim-kiem");
  const locPhongBan = document.querySelector("#loc-phong-ban");
  const locTrangThai = document.querySelector("#loc-trang-thai");
  const dongKetQua = document.querySelector("#dong-ket-qua");

  if (!bangNhanVien || !thanBangNhanVien || !formLoc || !oTimKiem || !locPhongBan || !locTrangThai || !dongKetQua) {
    const coHookNhanVien = bangNhanVien || thanBangNhanVien || formLoc || oTimKiem || locPhongBan || locTrangThai || dongKetQua;
    if (coHookNhanVien) {
      console.warn("features.js: Không tìm thấy đủ phần tử chính của trang nhân viên.");
    }
    return;
  }

  const thongKeTong = document.querySelector("#thong-ke-tong");
  const thongKeDangLam = document.querySelector("#thong-ke-dang-lam");
  const thongKeDaNghi = document.querySelector("#thong-ke-da-nghi");
  const tongNhanVien = Array.isArray(NHAN_VIEN) ? NHAN_VIEN.length : 0;

  /** Đổ danh sách phòng ban kèm số lượng nhân viên hiện có. */
  function renderBoLoc() {
    const thongKePhongBan = demNhanVienTheoPhong(NHAN_VIEN, PHONG_BAN);
    const luaChonPhongBan = thongKePhongBan.map((phongBan) => {
      return `<option value="${escapeHTML(phongBan.MaPB)}">${escapeHTML(phongBan.TenPB)} (${escapeHTML(phongBan.SoLuong)})</option>`;
    }).join("");
    locPhongBan.insertAdjacentHTML("beforeend", luaChonPhongBan);
  }

  /** Hiển thị ba chỉ số quân số của toàn bộ danh sách nhân viên. */
  function renderThongKe(dsNhanVien) {
    const thongKe = thongKeNhanVien(dsNhanVien);
    if (thongKeTong) {
      thongKeTong.textContent = String(thongKe.tong);
    }
    if (thongKeDangLam) {
      thongKeDangLam.textContent = String(thongKe.dangLam);
    }
    if (thongKeDaNghi) {
      thongKeDaNghi.textContent = String(thongKe.daNghi);
    }
  }

  /** Tạo nội dung một ô ảnh đại diện, dùng chữ cái đầu khi không có ảnh. */
  function renderAvatar(nhanVien) {
    const hoTen = escapeHTML(nhanVien.HoTen);
    if (typeof nhanVien.HinhAnh === "string" && nhanVien.HinhAnh.trim()) {
      return `<img class="anh-dai-dien" src="${escapeHTML(nhanVien.HinhAnh)}" alt="Ảnh đại diện ${hoTen}" width="48" height="48" loading="lazy">`;
    }
    return `<span class="avatar-chu" aria-hidden="true">${escapeHTML(layChuCaiDau(nhanVien.HoTen))}</span>`;
  }

  /** Render bảng bằng map/join, chỉ đưa dữ liệu đã escape vào innerHTML. */
  function renderBangNhanVien(dsNhanVien) {
    const danhSachAnToan = Array.isArray(dsNhanVien) ? dsNhanVien.filter(Boolean) : [];
    if (danhSachAnToan.length === 0) {
      thanBangNhanVien.innerHTML = '<tr><td class="khong-co-du-lieu" data-cot="Kết quả" colspan="8">Không tìm thấy nhân viên phù hợp</td></tr>';
      return;
    }

    thanBangNhanVien.innerHTML = danhSachAnToan.map((nhanVien) => {
      const trangThai = nhanTrangThai(nhanVien.TrangThai);
      const maTrangThai = nhanVien.TrangThai === "DaNghi" ? "da-nghi" : "dang-lam";
      const maNV = escapeHTML(nhanVien.MaNV);
      const hoTen = escapeHTML(nhanVien.HoTen);
      const chucVu = escapeHTML(nhanVien.ChucVu);
      const gioiTinh = escapeHTML(nhanVien.GioiTinh);
      const ngaySinh = escapeHTML(dinhDangNgay(nhanVien.NgaySinh));
      const ngaySinhIso = escapeHTML(nhanVien.NgaySinh);
      const tenPhongBan = escapeHTML(layTenPhongBan(PHONG_BAN, nhanVien.MaPB));
      const dienThoai = escapeHTML(nhanVien.DienThoai);
      const nhanTrangThaiAnToan = escapeHTML(trangThai);

      return `<tr>
        <td data-cot="Ảnh đại diện"><span class="avatar">${renderAvatar(nhanVien)}</span></td>
        <td data-cot="Mã NV">${maNV}</td>
        <td data-cot="Họ và tên"><span class="ten-nhan-vien"><strong>${hoTen}</strong><small>${chucVu}</small></span></td>
        <td data-cot="Giới tính">${gioiTinh}</td>
        <td data-cot="Ngày sinh"><time datetime="${ngaySinhIso}">${ngaySinh}</time></td>
        <td data-cot="Phòng ban">${tenPhongBan}</td>
        <td data-cot="Điện thoại"><a href="tel:${dienThoai}">${dienThoai}</a></td>
        <td data-cot="Trạng thái"><span class="nhan nhan-${maTrangThai}">${nhanTrangThaiAnToan}</span></td>
      </tr>`;
    }).join("");
  }

  /** Đọc form, lọc dữ liệu và cập nhật bảng, thống kê cùng dòng kết quả. */
  function capNhatGiaoDien() {
    const boLoc = {
      tuKhoa: oTimKiem.value,
      maPB: locPhongBan.value,
      trangThai: locTrangThai.value
    };
    const danhSachLoc = locNhanVien(NHAN_VIEN, boLoc);
    renderBangNhanVien(danhSachLoc);
    dongKetQua.textContent = `Tìm thấy ${danhSachLoc.length} / ${tongNhanVien} nhân viên`;
  }

  renderBoLoc();
  renderThongKe(NHAN_VIEN);
  capNhatGiaoDien();

  oTimKiem.addEventListener("input", capNhatGiaoDien);
  locPhongBan.addEventListener("change", capNhatGiaoDien);
  locTrangThai.addEventListener("change", capNhatGiaoDien);
  formLoc.addEventListener("submit", (suKien) => {
    suKien.preventDefault();
    capNhatGiaoDien();
  });
  formLoc.addEventListener("reset", () => {
    oTimKiem.value = "";
    locPhongBan.value = "";
    locTrangThai.value = "";
    capNhatGiaoDien();
  });
});
