/* Kết nối sự kiện và kết xuất DOM cho Sprint 1 và Sprint 2. */

document.addEventListener("DOMContentLoaded", () => {
  const nhanVienHooks = ["#bang-nhan-vien", "#than-bang-nhan-vien", "#form-loc", "#o-tim-kiem", "#loc-phong-ban", "#loc-trang-thai", "#dong-ket-qua"];
  const coHookNhanVien = nhanVienHooks.some((selector) => document.querySelector(selector));
  const coDuHookNhanVien = nhanVienHooks.every((selector) => document.querySelector(selector));
  if (coHookNhanVien && !coDuHookNhanVien) {
    console.warn("features.js: Không tìm thấy đủ phần tử chính của trang nhân viên.");
  }

  const bangNhanVien = document.querySelector("#bang-nhan-vien");
  if (coDuHookNhanVien) {
    khoiTaoTrangNhanVien(bangNhanVien);
  }

  const coBangLuong = document.querySelector("#form-bang-luong");
  if (coBangLuong) {
    khoiTaoTrangBangLuong();
  }

  if (document.querySelector(".trang-tong-quan")) {
    khoiTaoDashboard();
  }
});

function ngayThamChieuDashboard() {
  if (CAU_HINH.NGAY_THAM_CHIEU_DEMO) return CAU_HINH.NGAY_THAM_CHIEU_DEMO;
  const homNay = new Date();
  return `${homNay.getFullYear()}-${String(homNay.getMonth() + 1).padStart(2, "0")}-${String(homNay.getDate()).padStart(2, "0")}`;
}

function khoiTaoDashboard() {
  const ngayThamChieu = ngayThamChieuDashboard();
  const bangLuong = taoBangLuong("2026-10", NHAN_VIEN, PHONG_BAN, LUONG_NHAN_VIEN, MUC_LUONG, CHAM_CONG, CAU_HINH);
  const thongKe = thongKeDashboard(NHAN_VIEN, PHONG_BAN, bangLuong);
  const sapHetHan = hopDongSapHetHan(HOP_DONG_LAO_DONG, NHAN_VIEN, ngayThamChieu, CAU_HINH.SO_NGAY_CANH_BAO_HOP_DONG);
  const capNhat = (id, value) => { const node = document.querySelector(`#${id}`); if (node) node.textContent = value; };
  capNhat("kpi-tong", thongKe.quanSo.tong);
  capNhat("kpi-dang-lam", thongKe.quanSo.dangLam);
  capNhat("kpi-quy-luong", dinhDangTien(thongKe.quyLuong.tongQuyLuong));
  capNhat("kpi-luong-trung-binh", dinhDangTien(thongKe.quyLuong.luongTrungBinh));
  const maxQuanSo = Math.max(...thongKe.theoPhong.map((dong) => dong.SoLuong), 1);
  const bieuDo = document.querySelector("#dashboard-bieu-do");
  if (bieuDo) {
    bieuDo.replaceChildren(...thongKe.theoPhong.map((dong) => {
      const muc = document.createElement("li");
      const ten = document.createElement("span");
      const thanh = document.createElement("span");
      const soLuong = document.createElement("strong");
      ten.textContent = dong.TenPB;
      thanh.className = "thanh";
      thanh.setAttribute("aria-hidden", "true");
      thanh.style.setProperty("--ty-le", `${(dong.SoLuong / maxQuanSo) * 100}%`);
      soLuong.textContent = String(dong.SoLuong);
      muc.append(ten, thanh, soLuong);
      return muc;
    }));
  }
  const theoPhong = document.querySelector("#dashboard-theo-phong");
  if (theoPhong) theoPhong.textContent = `Phân bổ: ${thongKe.theoPhong.map((dong) => `${dong.TenPB}: ${dong.SoLuong}`).join(" · ")}`;
  const hopDongNode = document.querySelector("#dashboard-hop-dong");
  if (hopDongNode) hopDongNode.innerHTML = sapHetHan.length ? sapHetHan.map((hopDong) => `<li data-het-han="true"><span>${escapeHTML(hopDong.HoTen)} (${escapeHTML(hopDong.MaNV)})</span><time datetime="${escapeHTML(hopDong.DenNgay)}">${escapeHTML(dinhDangNgay(hopDong.DenNgay))}</time></li>`).join("") : '<li><span>Không có hợp đồng sắp hết hạn</span></li>';
}

function khoiTaoTrangNhanVien(bangNhanVien) {
  const thanBangNhanVien = document.querySelector("#than-bang-nhan-vien");
  const formLoc = document.querySelector("#form-loc");
  const oTimKiem = document.querySelector("#o-tim-kiem");
  const locPhongBan = document.querySelector("#loc-phong-ban");
  const locTrangThai = document.querySelector("#loc-trang-thai");
  const dongKetQua = document.querySelector("#dong-ket-qua");
  const thongBao = document.querySelector("#thong-bao-form");
  let dsNhanVienHienTai = [...NHAN_VIEN];
  const ngayThamChieu = "2026-10-18";

  function renderBoLoc() {
    const danhSachPhongBan = demNhanVienTheoPhong(dsNhanVienHienTai, PHONG_BAN);
    const luaChonPhongBan = danhSachPhongBan.map((phongBan) => `<option value="${escapeHTML(phongBan.MaPB)}">${escapeHTML(phongBan.TenPB)} (${escapeHTML(phongBan.SoLuong)})</option>`).join("");
    locPhongBan.innerHTML = `<option value="">Tất cả phòng ban</option>${luaChonPhongBan}`;
    const employeeDepartment = document.querySelector("#employee-department");
    if (employeeDepartment) employeeDepartment.innerHTML = `<option value="">Chọn phòng ban</option>${danhSachPhongBan.map((phongBan) => `<option value="${escapeHTML(phongBan.MaPB)}">${escapeHTML(phongBan.TenPB)}</option>`).join("")}`;
  }

  function renderThongKe() {
    const thongKe = thongKeNhanVien(dsNhanVienHienTai);
    document.querySelector("#thong-ke-tong").textContent = String(thongKe.tong);
    document.querySelector("#thong-ke-dang-lam").textContent = String(thongKe.dangLam);
    document.querySelector("#thong-ke-da-nghi").textContent = String(thongKe.daNghi);
  }

  function renderAvatar(nhanVien) {
    const hoTen = escapeHTML(nhanVien.HoTen);
    if (nhanVien.HinhAnh) return `<img class="anh-dai-dien" src="${escapeHTML(nhanVien.HinhAnh)}" alt="Ảnh đại diện ${hoTen}" width="48" height="48" loading="lazy">`;
    return `<span class="avatar-chu" aria-hidden="true">${escapeHTML(layChuCaiDau(nhanVien.HoTen))}</span>`;
  }

  function renderBangNhanVien(dsNhanVien, maMoi = "") {
    if (!dsNhanVien.length) {
      thanBangNhanVien.innerHTML = '<tr><td class="khong-co-du-lieu" data-cot="Kết quả" colspan="9">Không tìm thấy nhân viên phù hợp</td></tr>';
      return;
    }
    thanBangNhanVien.innerHTML = dsNhanVien.map((nhanVien) => {
      const trangThai = escapeHTML(nhanTrangThai(nhanVien.TrangThai));
      const maNV = escapeHTML(nhanVien.MaNV);
      return `<tr data-ma-nv="${maNV}"${nhanVien.MaNV === maMoi ? ' class="hang-moi"' : ''}>
        <td data-cot="Ảnh đại diện"><span class="avatar">${renderAvatar(nhanVien)}</span></td>
        <td data-cot="Mã NV">${maNV}</td>
        <td data-cot="Họ và tên"><span class="ten-nhan-vien"><strong>${escapeHTML(nhanVien.HoTen)}</strong><small>${escapeHTML(nhanVien.ChucVu)}</small></span></td>
        <td data-cot="Giới tính">${escapeHTML(nhanVien.GioiTinh)}</td>
        <td data-cot="Ngày sinh"><time datetime="${escapeHTML(nhanVien.NgaySinh)}">${escapeHTML(dinhDangNgay(nhanVien.NgaySinh))}</time></td>
        <td data-cot="Phòng ban">${escapeHTML(layTenPhongBan(PHONG_BAN, nhanVien.MaPB))}</td>
        <td data-cot="Điện thoại"><a href="tel:${escapeHTML(nhanVien.DienThoai)}">${escapeHTML(nhanVien.DienThoai || "—")}</a></td>
        <td data-cot="Trạng thái"><span class="nhan nhan-${nhanVien.TrangThai === "DaNghi" ? "da-nghi" : "dang-lam"}">${trangThai}</span></td>
        <td data-cot="Thao tác"><button class="nut nut-nho nut-xem-ho-so" type="button" data-ma-nv="${maNV}" aria-label="Xem hồ sơ ${escapeHTML(nhanVien.HoTen)}">Xem hồ sơ</button></td>
      </tr>`;
    }).join("");
  }

  function capNhatBang() {
    const boLoc = { tuKhoa: oTimKiem.value, maPB: locPhongBan.value, trangThai: locTrangThai.value };
    const danhSachLoc = locNhanVien(dsNhanVienHienTai, boLoc);
    renderBangNhanVien(danhSachLoc);
    dongKetQua.textContent = `Tìm thấy ${danhSachLoc.length} / ${dsNhanVienHienTai.length} nhân viên`;
  }

  function xoaLoiForm() {
    document.querySelectorAll("#employee-form .thong-bao-loi").forEach((vungLoi) => { vungLoi.textContent = ""; });
    document.querySelectorAll("#employee-form [aria-invalid]").forEach((control) => { control.removeAttribute("aria-invalid"); });
  }

  function hienThiLoiForm(cacLoi) {
    const idLoi = { HoTen: "loi-ho-ten", NgaySinh: "loi-ngay-sinh", GioiTinh: "loi-gioi-tinh", CMND: "loi-cmnd", NgayCap: "loi-ngay-cap", NoiCap: "loi-noi-cap", QueQuan: "loi-que-quan", DienThoai: "loi-dien-thoai", MaPB: "loi-phong-ban", ChucVu: "loi-chuc-vu" };
    xoaLoiForm();
    cacLoi.forEach(({ truong, thongBao: noiDung }) => {
      const control = document.querySelector(`#employee-form [name="${truong}"]`) || document.querySelector(`#employee-form [name="${truong}"]:checked`);
      const vungLoi = document.querySelector(`#${idLoi[truong] || "loi-ma-nv"}`);
      if (control) control.setAttribute("aria-invalid", "true");
      if (vungLoi) vungLoi.textContent = noiDung;
    });
    const loiDau = cacLoi[0];
    const controlDau = loiDau ? document.querySelector(`#employee-form [name="${loiDau.truong}"]`) : null;
    if (controlDau) controlDau.focus();
  }

  function docDuLieuForm() {
    const checked = document.querySelector("#employee-form input[name=\"GioiTinh\"]:checked");
    return {
      MaNV: sinhMaNhanVien(dsNhanVienHienTai), HoTen: document.querySelector("#full-name").value.trim(), HinhAnh: "", GioiTinh: checked ? checked.value : "", NgaySinh: document.querySelector("#birth-date").value, CMND: document.querySelector("#cmnd").value.trim(), NgayCap: document.querySelector("#issue-date").value, NoiCap: document.querySelector("#issue-place").value.trim(), QueQuan: document.querySelector("#hometown").value.trim(), DienThoai: document.querySelector("#phone").value.trim(), Email: document.querySelector("#email").value.trim(), LoaiNV: "ChinhThuc", MaPB: document.querySelector("#employee-department").value, ChucVu: document.querySelector("#position").value.trim(), MaQuanLyTrucTiep: "", TrangThai: "DangLam"
    };
  }

  function renderHoSo(maNV) {
    const hoSo = layHoSoNhanVien(maNV, dsNhanVienHienTai, PHONG_BAN, LUONG_NHAN_VIEN, MUC_LUONG, HOP_DONG_LAO_DONG, ngayThamChieu);
    if (!hoSo) return;
    const nv = hoSo.nhanVien;
    const hopDong = hoSo.HopDong ? `Loại ${hoSo.HopDong.LoaiHD}, từ ${dinhDangNgay(hoSo.HopDong.TuNgay)}${hoSo.HopDong.DenNgay ? ` đến ${dinhDangNgay(hoSo.HopDong.DenNgay)}` : ""}` : "—";
    document.querySelector("#huong-dan-ho-so").textContent = "Đang xem hồ sơ được chọn.";
    document.querySelector("#ho-so-ho-ten").textContent = nv.HoTen;
    document.querySelector("#ho-so-ma-nv").textContent = nv.MaNV;
    document.querySelector("#ho-so-phong-ban").textContent = hoSo.TenPB;
    document.querySelector("#ho-so-cmnd").textContent = nv.CMND || "—";
    document.querySelector("#ho-so-ngay-cap").textContent = dinhDangNgay(nv.NgayCap);
    document.querySelector("#ho-so-noi-cap").textContent = nv.NoiCap || "—";
    document.querySelector("#ho-so-que-quan").textContent = nv.QueQuan || "—";
    document.querySelector("#ho-so-muc-luong").textContent = dinhDangTien(hoSo.MucLuong);
    document.querySelector("#ho-so-hop-dong").textContent = hopDong;
  }

  const formNhanVien = document.querySelector("#employee-form form");
  formNhanVien.addEventListener("submit", (suKien) => {
    suKien.preventDefault();
    const duLieu = docDuLieuForm();
    const cacLoi = kiemTraNhanVien(duLieu, dsNhanVienHienTai, PHONG_BAN, ngayThamChieu);
    if (cacLoi.length) {
      hienThiLoiForm(cacLoi);
      thongBao.textContent = "Chưa thể lưu hồ sơ. Vui lòng kiểm tra các trường được đánh dấu.";
      return;
    }
    dsNhanVienHienTai = themNhanVien(dsNhanVienHienTai, duLieu);
    formNhanVien.reset();
    document.querySelector("#employee-id").value = sinhMaNhanVien(dsNhanVienHienTai);
    xoaLoiForm();
    renderBoLoc();
    renderThongKe();
    capNhatBang();
    thongBao.textContent = `Đã thêm nhân viên ${duLieu.HoTen}.`;
    const hangMoi = thanBangNhanVien.querySelector(`[data-ma-nv="${duLieu.MaNV}"]`);
    if (hangMoi) {
      if (typeof hangMoi.scrollIntoView === "function") hangMoi.scrollIntoView({ block: "center" });
      hangMoi.querySelector(".nut-xem-ho-so").focus();
    }
  });

  formLoc.addEventListener("submit", (suKien) => { suKien.preventDefault(); capNhatBang(); });
  formLoc.addEventListener("reset", () => { oTimKiem.value = ""; locPhongBan.value = ""; locTrangThai.value = ""; capNhatBang(); });
  oTimKiem.addEventListener("input", capNhatBang);
  locPhongBan.addEventListener("change", capNhatBang);
  locTrangThai.addEventListener("change", capNhatBang);
  thanBangNhanVien.addEventListener("click", (suKien) => { const nut = suKien.target.closest(".nut-xem-ho-so"); if (nut) renderHoSo(nut.dataset.maNv); });

  renderBoLoc(); renderThongKe(); document.querySelector("#employee-id").value = sinhMaNhanVien(dsNhanVienHienTai); capNhatBang();
}

function khoiTaoTrangBangLuong() {
  const form = document.querySelector("#form-bang-luong");
  const inputThang = document.querySelector("#salary-month");
  const locPhongBan = document.querySelector("#salary-department");
  const thanBang = document.querySelector("#than-bang-luong");
  const tongDong = document.querySelector("#tong-bang-luong");
  const ketQua = document.querySelector("#salary-result");
  PHONG_BAN.forEach((phongBan) => { locPhongBan.insertAdjacentHTML("beforeend", `<option value="${escapeHTML(phongBan.MaPB)}">${escapeHTML(phongBan.TenPB)}</option>`); });

  function render() {
    const bangLuong = taoBangLuong(inputThang.value, NHAN_VIEN.filter((nv) => !locPhongBan.value || nv.MaPB === locPhongBan.value), PHONG_BAN, LUONG_NHAN_VIEN, MUC_LUONG, CHAM_CONG, CAU_HINH);
    const tong = tongQuyLuong(bangLuong);
    if (!bangLuong.length) {
      thanBang.innerHTML = '<tr><td colspan="7" data-cot="Kết quả" class="khong-co-du-lieu">Chưa có dữ liệu chấm công tháng này</td></tr>';
      ketQua.textContent = "Chưa có dữ liệu chấm công tháng này";
    } else {
      thanBang.innerHTML = bangLuong.map((dong) => `<tr><td data-cot="Mã NV">${escapeHTML(dong.MaNV)}</td><td data-cot="Họ và tên">${escapeHTML(dong.HoTen)}</td><td data-cot="Phòng ban">${escapeHTML(dong.TenPB)}</td><td data-cot="Ngày công">${escapeHTML(dong.NgayCong)}</td><td class="so-tien" data-cot="Mức lương">${escapeHTML(dinhDangTien(dong.MucLuong))}</td><td class="so-tien" data-cot="Phụ cấp">${escapeHTML(dinhDangTien(dong.PhuCap))}</td><td class="so-tien" data-cot="Thực lĩnh">${escapeHTML(dinhDangTien(dong.LuongThucNhan))}</td></tr>`).join("");
      ketQua.textContent = `Có ${tong.tongNhanVien} nhân viên trong bảng lương.`;
    }
    tongDong.querySelector("td").textContent = dinhDangTien(tong.tongQuyLuong);
  }

  form.addEventListener("submit", (suKien) => { suKien.preventDefault(); render(); });
  inputThang.addEventListener("change", render);
  locPhongBan.addEventListener("change", render);
  render();
}
