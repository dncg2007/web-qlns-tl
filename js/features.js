/* ==========================================================================
   HRM & Payroll — Lớp kết nối sự kiện và kết xuất DOM (Features)
   Giai đoạn 3: Kết nối toàn bộ 5 trang với khoDuLieu và hoàn thiện CRUD.
   Mọi dữ liệu đưa vào innerHTML đều qua escapeHTML() hoặc textContent.
   ========================================================================== */

document.addEventListener("DOMContentLoaded", () => {
  khoiTaoThuGonSidebar();

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

  if (document.querySelector("#danh-sach-phong-ban")) {
    khoiTaoQuanLyPhongBan();
  }

  if (document.querySelector("#bang-chuc-vu")) {
    khoiTaoQuanLyChucVu();
  }
});

/** Bộ điều khiển thu gọn / mở rộng Sidebar trên toàn bộ hệ thống */
function khoiTaoThuGonSidebar() {
  const nutThuGon = document.querySelector("#nut-thu-gon-sidebar");
  if (!nutThuGon) return;
  const KHOA_SIDEBAR = "hrm-sidebar-collapsed";
  try {
    if (localStorage.getItem(KHOA_SIDEBAR) === "true") {
      document.body.classList.add("sidebar-thu-gon");
      nutThuGon.setAttribute("aria-expanded", "false");
    }
  } catch (e) {}

  nutThuGon.addEventListener("click", () => {
    const isCollapsed = document.body.classList.toggle("sidebar-thu-gon");
    nutThuGon.setAttribute("aria-expanded", String(!isCollapsed));
    try {
      localStorage.setItem(KHOA_SIDEBAR, String(isCollapsed));
    } catch (e) {}
  });
}

/** Trợ giúp mở dialog an toàn trên mọi môi trường (kể cả JSDOM) */
function moDialog(dialogNode) {
  if (!dialogNode) return;
  if (typeof dialogNode.showModal === "function") {
    dialogNode.showModal();
  } else {
    dialogNode.setAttribute("open", "");
  }
}

/** Trợ giúp đóng dialog an toàn */
function dongDialog(dialogNode) {
  if (!dialogNode) return;
  if (typeof dialogNode.close === "function") {
    dialogNode.close();
  } else {
    dialogNode.removeAttribute("open");
  }
}

function ngayThamChieuDashboard() {
  if (typeof CAU_HINH !== "undefined" && CAU_HINH.NGAY_THAM_CHIEU_DEMO) {
    return CAU_HINH.NGAY_THAM_CHIEU_DEMO;
  }
  const homNay = new Date();
  return `${homNay.getFullYear()}-${String(homNay.getMonth() + 1).padStart(2, "0")}-${String(homNay.getDate()).padStart(2, "0")}`;
}

/* ==========================================================================
   1. DASHBOARD (TỔNG QUAN) - HỆ THỐNG ĐA BIỂU ĐỒ (MULTI-CHART SUITE)
   ========================================================================== */
function khoiTaoDashboard() {
  const ngayThamChieu = ngayThamChieuDashboard();
  const kho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : { dsNhanVien: NHAN_VIEN, dsPhongBan: PHONG_BAN, dsHopDong: HOP_DONG_LAO_DONG };
  const dsNV = kho.dsNhanVien || NHAN_VIEN;
  const dsPB = kho.dsPhongBan || PHONG_BAN;
  const dsHD = kho.dsHopDong || HOP_DONG_LAO_DONG;

  const bangLuong = taoBangLuong("2026-10", dsNV, dsPB, LUONG_NHAN_VIEN, MUC_LUONG, CHAM_CONG, CAU_HINH);
  const thongKe = thongKeDashboard(dsNV, dsPB, bangLuong);
  const sapHetHan = hopDongSapHetHan(dsHD, dsNV, ngayThamChieu, CAU_HINH.SO_NGAY_CANH_BAO_HOP_DONG);
  const tkGioiTinh = thongKeGioiTinh(dsNV);
  const tkLoaiNV = thongKeLoaiNhanVien(dsNV);
  const tkBacLuong = thongKeBacLuong(dsNV, LUONG_NHAN_VIEN, MUC_LUONG, ngayThamChieu);

  const capNhat = (id, value) => {
    const node = document.querySelector(`#${id}`);
    if (node) node.textContent = value;
  };

  capNhat("kpi-tong", thongKe.quanSo.tong);
  capNhat("kpi-dang-lam", thongKe.quanSo.dangLam);
  capNhat("kpi-quy-luong", dinhDangTien(thongKe.quyLuong.tongQuyLuong));
  capNhat("kpi-luong-trung-binh", dinhDangTien(thongKe.quyLuong.luongTrungBinh));

  // --- CHART 1: Phân bổ quân số theo phòng ban (Thanh ngang) ---
  const maxQuanSo = Math.max(...thongKe.theoPhong.map((dong) => dong.SoLuong), 1);
  const bieuDoPB = document.querySelector("#dashboard-bieu-do");
  if (bieuDoPB) {
    bieuDoPB.replaceChildren(...thongKe.theoPhong.map((dong) => {
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
  if (theoPhong) {
    theoPhong.textContent = `Phân bổ: ${thongKe.theoPhong.map((dong) => `${dong.TenPB}: ${dong.SoLuong}`).join(" · ")}`;
  }

  // --- CHART 2: Cơ cấu Giới tính (Donut SVG) ---
  const bieuDoGT = document.querySelector("#dashboard-bieu-do-gioi-tinh");
  if (bieuDoGT) {
    const tyLeNu = tkGioiTinh.tyLeNu;
    const tyLeNam = tkGioiTinh.tyLeNam;
    bieuDoGT.innerHTML = `
      <div class="bieu-do-donut-wrap">
        <div class="donut-svg-container">
          <svg class="donut-svg" viewBox="0 0 36 36" aria-hidden="true">
            <circle class="donut-bg" cx="18" cy="18" r="15.915" />
            <circle class="donut-segment-nu" cx="18" cy="18" r="15.915" stroke-dasharray="${tyLeNu} ${100 - tyLeNu}" stroke-dashoffset="0" />
            <circle class="donut-segment-nam" cx="18" cy="18" r="15.915" stroke-dasharray="${tyLeNam} ${100 - tyLeNam}" stroke-dashoffset="-${tyLeNu}" />
          </svg>
          <div class="donut-center-text">
            <span class="donut-center-number">${tyLeNu}%</span>
            <span class="donut-center-label">Nữ (${tkGioiTinh.nu})</span>
          </div>
        </div>
        <ul class="donut-legend">
          <li class="donut-legend-item">
            <span class="donut-dot dot-nu" aria-hidden="true"></span>
            <span>Nữ: <strong>${tkGioiTinh.nu}</strong> người (${tyLeNu}%)</span>
          </li>
          <li class="donut-legend-item">
            <span class="donut-dot dot-nam" aria-hidden="true"></span>
            <span>Nam: <strong>${tkGioiTinh.nam}</strong> người (${tyLeNam}%)</span>
          </li>
        </ul>
      </div>
    `;
  }

  // --- CHART 3: Phân loại nhân viên & Trạng thái làm việc (Phân đoạn) ---
  const bieuDoLoai = document.querySelector("#dashboard-bieu-do-loai-nv");
  if (bieuDoLoai) {
    const tongNV = thongKe.quanSo.tong || 1;
    const tyLeDangLam = Math.round((thongKe.quanSo.dangLam / tongNV) * 100);
    const tyLeDaNghi = Math.round((thongKe.quanSo.daNghi / tongNV) * 100);

    bieuDoLoai.innerHTML = `
      <div class="muc-phan-doan">
        <div class="nhan-phan-doan">
          <span>Loại hợp đồng lao động</span>
          <span>Chính thức: ${tkLoaiNV.tyLeChinhThuc}% · Thời vụ: ${tkLoaiNV.tyLeThoiVu}%</span>
        </div>
        <div class="thanh-phan-doan" aria-hidden="true">
          <span class="phan-doan-segment segment-chinh-thuc" style="width: ${tkLoaiNV.tyLeChinhThuc}%"></span>
          <span class="phan-doan-segment segment-thoi-vu" style="width: ${tkLoaiNV.tyLeThoiVu}%"></span>
        </div>
        <div class="chu-thich-hang">
          <span class="donut-legend-item"><span class="donut-dot dot-chinh-thuc" aria-hidden="true"></span>Chính thức: ${tkLoaiNV.chinhThuc} người</span>
          <span class="donut-legend-item"><span class="donut-dot dot-thoi-vu" aria-hidden="true"></span>Thời vụ: ${tkLoaiNV.thoiVu} người</span>
        </div>
      </div>
      <div class="muc-phan-doan">
        <div class="nhan-phan-doan">
          <span>Trạng thái công tác</span>
          <span>Đang làm: ${tyLeDangLam}% · Đã nghỉ: ${tyLeDaNghi}%</span>
        </div>
        <div class="thanh-phan-doan" aria-hidden="true">
          <span class="phan-doan-segment segment-dang-lam" style="width: ${tyLeDangLam}%"></span>
          <span class="phan-doan-segment segment-da-nghi" style="width: ${tyLeDaNghi}%"></span>
        </div>
        <div class="chu-thich-hang">
          <span class="donut-legend-item"><span class="donut-dot dot-dang-lam" aria-hidden="true"></span>Đang làm: ${thongKe.quanSo.dangLam} người</span>
          <span class="donut-legend-item"><span class="donut-dot dot-da-nghi" aria-hidden="true"></span>Đã nghỉ: ${thongKe.quanSo.daNghi} người</span>
        </div>
      </div>
    `;
  }

  // --- CHART 4: Phân bổ nhân sự theo Bậc lương ---
  const bieuDoLuong = document.querySelector("#dashboard-bieu-do-bac-luong");
  if (bieuDoLuong) {
    const maxNguoiBac = Math.max(...tkBacLuong.map((b) => b.SoLuong), 1);
    bieuDoLuong.innerHTML = `
      <ul class="danh-sach-bac-luong" aria-label="Phân bổ bậc lương">
        ${tkBacLuong.map((bac) => {
          const tyLeThanh = Math.round((bac.SoLuong / maxNguoiBac) * 100);
          return `
            <li class="dong-bac-luong">
              <div class="bac-luong-head">
                <span class="ten-bac-luong">${escapeHTML(bac.TenMucLuong)} (${Math.round(bac.SoTien / 1000000)}tr)</span>
                <span class="so-luong-bac-luong">${bac.SoLuong} (${bac.TyLe}%)</span>
              </div>
              <span class="thanh-bac-luong" aria-hidden="true">
                <span class="tien-do-bac-luong" style="width: ${tyLeThanh}%"></span>
              </span>
            </li>
          `;
        }).join("")}
      </ul>
    `;
  }

  // --- Hợp đồng sắp hết hạn ---
  const hopDongNode = document.querySelector("#dashboard-hop-dong");
  if (hopDongNode) {
    hopDongNode.innerHTML = sapHetHan.length
      ? sapHetHan.map((hopDong) => `
          <li data-het-han="true">
            <div class="hop-dong-info">
              <strong>${escapeHTML(hopDong.HoTen)}</strong>
              <small>${escapeHTML(hopDong.MaNV)} · Còn ${escapeHTML(hopDong.SoNgayConLai)} ngày</small>
            </div>
            <time datetime="${escapeHTML(hopDong.DenNgay)}">${escapeHTML(dinhDangNgay(hopDong.DenNgay))}</time>
          </li>
        `).join("")
      : '<li><span>Không có hợp đồng sắp hết hạn trong 60 ngày tới</span></li>';
  }
}

/* ==========================================================================
   2. QUẢN LÝ NHÂN VIÊN
   ========================================================================== */
function khoiTaoTrangNhanVien(bangNhanVien) {
  const thanBangNhanVien = document.querySelector("#than-bang-nhan-vien");
  const formLoc = document.querySelector("#form-loc");
  const oTimKiem = document.querySelector("#o-tim-kiem");
  const locPhongBan = document.querySelector("#loc-phong-ban");
  const locTrangThai = document.querySelector("#loc-trang-thai");
  const dongKetQua = document.querySelector("#dong-ket-qua");
  const thongBao = document.querySelector("#thong-bao-form");

  const dialogThemNV = document.querySelector("#dialog-them-nhan-vien");
  const nutThemNV = document.querySelector("#nut-them-nhan-vien");
  const nutDongThemNV = document.querySelector("#nut-dong-them-nv");

  const dialogSua = document.querySelector("#dialog-sua-nhan-vien");
  const formSua = document.querySelector("#form-sua-nhan-vien");
  const nutDongSua = document.querySelector("#nut-dong-sua-nv");
  const loiDialogSua = document.querySelector("#loi-dialog-sua");

  const dialogNghi = document.querySelector("#dialog-cho-nghi-viec");
  const formNghi = document.querySelector("#form-cho-nghi-viec");
  const nutDongNghi = document.querySelector("#nut-dong-dialog-nghi");
  const moTaNghi = document.querySelector("#mo-ta-cho-nghi-viec");
  const ngayNghiInput = document.querySelector("#ngay-nghi-viec");
  const loiDialogNghi = document.querySelector("#loi-dialog-nghi");

  const dialogKhoiPhuc = document.querySelector("#dialog-xac-nhan-khoi-phuc");
  const formKhoiPhuc = document.querySelector("#form-khoi-phuc-mau");
  const nutKhoiPhucMau = document.querySelector("#nut-khoi-phuc-mau");
  const nutHuyKhoiPhuc = document.querySelector("#nut-huy-khoi-phuc");

  let duLieuKho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : { dsNhanVien: [...NHAN_VIEN], dsPhongBan: [...PHONG_BAN], dsHopDong: [...HOP_DONG_LAO_DONG], dsChucVu: [] };
  let dsNhanVienHienTai = [...duLieuKho.dsNhanVien];
  let dsPhongBanHienTai = [...duLieuKho.dsPhongBan];
  let dsHopDongHienTai = [...duLieuKho.dsHopDong];
  let dsChucVuHienTai = [...(duLieuKho.dsChucVu || [])];
  const ngayThamChieu = "2026-10-18";
  let maNVDangChonNghi = "";

  function luuDuLieuHeThong() {
    if (typeof khoDuLieu !== "undefined") {
      khoDuLieu.luuDuLieu({
        dsNhanVien: dsNhanVienHienTai,
        dsPhongBan: dsPhongBanHienTai,
        dsHopDong: dsHopDongHienTai,
        dsChucVu: dsChucVuHienTai
      });
    }
  }

  function renderBoLoc() {
    const danhSachPhongBan = demNhanVienTheoPhong(dsNhanVienHienTai, dsPhongBanHienTai);
    const luaChonPhongBan = danhSachPhongBan.map((pb) => `<option value="${escapeHTML(pb.MaPB)}">${escapeHTML(pb.TenPB)} (${escapeHTML(pb.SoLuong)})</option>`).join("");
    locPhongBan.innerHTML = `<option value="">Tất cả phòng ban</option>${luaChonPhongBan}`;

    const employeeDepartment = document.querySelector("#employee-department");
    if (employeeDepartment) {
      employeeDepartment.innerHTML = `<option value="">Chọn phòng ban</option>${danhSachPhongBan.map((pb) => `<option value="${escapeHTML(pb.MaPB)}">${escapeHTML(pb.TenPB)}</option>`).join("")}`;
    }

    const editDepartment = document.querySelector("#edit-department");
    if (editDepartment) {
      editDepartment.innerHTML = `<option value="">Chọn phòng ban</option>${danhSachPhongBan.map((pb) => `<option value="${escapeHTML(pb.MaPB)}">${escapeHTML(pb.TenPB)}</option>`).join("")}`;
    }
  }

  function renderThongKe() {
    const thongKe = thongKeNhanVien(dsNhanVienHienTai);
    document.querySelector("#thong-ke-tong").textContent = String(thongKe.tong);
    document.querySelector("#thong-ke-dang-lam").textContent = String(thongKe.dangLam);
    document.querySelector("#thong-ke-da-nghi").textContent = String(thongKe.daNghi);
  }

  function renderAvatar(nhanVien) {
    const hoTen = escapeHTML(nhanVien.HoTen);
    if (nhanVien.HinhAnh) {
      return `<img class="anh-dai-dien" src="${escapeHTML(nhanVien.HinhAnh)}" alt="Ảnh đại diện ${hoTen}" width="48" height="48" loading="lazy">`;
    }
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
        <td data-cot="Phòng ban">${escapeHTML(layTenPhongBan(dsPhongBanHienTai, nhanVien.MaPB))}</td>
        <td data-cot="Điện thoại"><a href="tel:${escapeHTML(nhanVien.DienThoai)}">${escapeHTML(nhanVien.DienThoai || "—")}</a></td>
        <td data-cot="Trạng thái"><span class="nhan nhan-${nhanVien.TrangThai === "DaNghi" ? "da-nghi" : "dang-lam"}">${trangThai}</span></td>
        <td data-cot="Thao tác">
          <div class="nhom-nut-thao-tac">
            <button class="nut nut-nho nut-vien nut-xem-ho-so" type="button" data-ma-nv="${maNV}" aria-label="Xem hồ sơ ${escapeHTML(nhanVien.HoTen)}">Xem</button>
            <button class="nut nut-nho nut-vien nut-sua" type="button" data-ma-nv="${maNV}" aria-label="Sửa hồ sơ ${escapeHTML(nhanVien.HoTen)}">Sửa</button>
            ${nhanVien.TrangThai === "DangLam" ? `<button class="nut nut-nho nut-nguy-hiem nut-nghi-viec" type="button" data-ma-nv="${maNV}" aria-label="Cho nghỉ việc ${escapeHTML(nhanVien.HoTen)}">Nghỉ việc</button>` : ""}
          </div>
        </td>
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
      MaNV: sinhMaNhanVien(dsNhanVienHienTai),
      HoTen: document.querySelector("#full-name").value.trim(),
      HinhAnh: "",
      GioiTinh: checked ? checked.value : "",
      NgaySinh: document.querySelector("#birth-date").value,
      CMND: document.querySelector("#cmnd").value.trim(),
      NgayCap: document.querySelector("#issue-date").value,
      NoiCap: document.querySelector("#issue-place").value.trim(),
      QueQuan: document.querySelector("#hometown").value.trim(),
      DienThoai: document.querySelector("#phone").value.trim(),
      Email: document.querySelector("#email").value.trim(),
      LoaiNV: "ChinhThuc",
      MaPB: document.querySelector("#employee-department").value,
      ChucVu: document.querySelector("#position").value.trim(),
      MaQuanLyTrucTiep: "",
      TrangThai: "DangLam"
    };
  }

  function renderHoSo(maNV) {
    const hoSo = layHoSoNhanVien(maNV, dsNhanVienHienTai, dsPhongBanHienTai, LUONG_NHAN_VIEN, MUC_LUONG, dsHopDongHienTai, ngayThamChieu);
    if (!hoSo) return;
    const nv = hoSo.nhanVien;
    const hopDong = hoSo.HopDong ? `Loại ${hoSo.HopDong.LoaiHD}, từ ${dinhDangNgay(hoSo.HopDong.TuNgay)}${hoSo.HopDong.DenNgay ? ` đến ${dinhDangNgay(hoSo.HopDong.DenNgay)}` : ""}` : "—";
    
    const capNhat = (id, val) => {
      const el = document.querySelector("#" + id);
      if (el) el.textContent = val;
    };

    capNhat("huong-dan-ho-so", "Đang xem hồ sơ được chọn.");
    capNhat("ho-so-ho-ten", nv.HoTen);
    capNhat("ho-so-ma-nv", nv.MaNV);
    capNhat("ho-so-phong-ban", hoSo.TenPB);
    capNhat("ho-so-chuc-vu", nv.ChucVu || "—");
    capNhat("ho-so-gioi-tinh", nv.GioiTinh || "—");
    capNhat("ho-so-ngay-sinh", dinhDangNgay(nv.NgaySinh));
    capNhat("ho-so-dien-thoai", nv.DienThoai || "—");
    capNhat("ho-so-email", nv.Email || "—");
    capNhat("ho-so-cmnd", nv.CMND || "—");
    capNhat("ho-so-ngay-cap", dinhDangNgay(nv.NgayCap));
    capNhat("ho-so-noi-cap", nv.NoiCap || "—");
    capNhat("ho-so-que-quan", nv.QueQuan || "—");
    capNhat("ho-so-muc-luong", dinhDangTien(hoSo.MucLuong));
    capNhat("ho-so-hop-dong", hopDong);

    const dialogXem = document.querySelector("#dialog-xem-ho-so");
    if (dialogXem) {
      moDialog(dialogXem);
    }
  }

  const dialogXemHoSo = document.querySelector("#dialog-xem-ho-so");
  const nutDongXemHoSo = document.querySelector("#nut-dong-xem-ho-so");
  if (nutDongXemHoSo && dialogXemHoSo) {
    nutDongXemHoSo.addEventListener("click", () => dongDialog(dialogXemHoSo));
  }

  /* Xử lý Thêm nhân viên qua Popup Dialog */
  const formNhanVien = document.querySelector("#employee-form form");

  if (nutThemNV) {
    nutThemNV.addEventListener("click", () => {
      formNhanVien.reset();
      document.querySelector("#employee-id").value = sinhMaNhanVien(dsNhanVienHienTai);
      xoaLoiForm();
      moDialog(dialogThemNV);
      const fullNameInput = document.querySelector("#full-name");
      if (fullNameInput) fullNameInput.focus();
    });
  }

  if (nutDongThemNV) {
    nutDongThemNV.addEventListener("click", () => {
      dongDialog(dialogThemNV);
      if (nutThemNV) nutThemNV.focus();
    });
  }

  formNhanVien.addEventListener("submit", (suKien) => {
    suKien.preventDefault();
    const duLieu = docDuLieuForm();
    const cacLoi = kiemTraNhanVien(duLieu, dsNhanVienHienTai, dsPhongBanHienTai, ngayThamChieu);
    if (cacLoi.length) {
      hienThiLoiForm(cacLoi);
      thongBao.textContent = "Chưa thể lưu hồ sơ. Vui lòng kiểm tra các trường được đánh dấu.";
      return;
    }
    dsNhanVienHienTai = themNhanVien(dsNhanVienHienTai, duLieu);
    luuDuLieuHeThong();
    dongDialog(dialogThemNV);
    if (nutThemNV) nutThemNV.focus();
    formNhanVien.reset();
    document.querySelector("#employee-id").value = sinhMaNhanVien(dsNhanVienHienTai);
    xoaLoiForm();
    renderBoLoc();
    renderThongKe();
    capNhatBang();
    thongBao.textContent = `Đã thêm nhân viên ${duLieu.HoTen} thành công.`;
    const hangMoi = thanBangNhanVien.querySelector(`[data-ma-nv="${duLieu.MaNV}"]`);
    if (hangMoi) {
      if (typeof hangMoi.scrollIntoView === "function") hangMoi.scrollIntoView({ block: "center" });
      const nutXem = hangMoi.querySelector(".nut-xem-ho-so");
      if (nutXem) nutXem.focus();
    }
  });

  /* Mở dialog Sửa nhân viên */
  function moSuaNhanVien(maNV) {
    const nv = dsNhanVienHienTai.find((x) => x.MaNV === maNV);
    if (!nv || !dialogSua) return;
    document.querySelector("#edit-employee-id").value = nv.MaNV;
    document.querySelector("#edit-full-name").value = nv.HoTen || "";
    document.querySelector("#edit-birth-date").value = nv.NgaySinh || "";
    document.querySelector("#edit-gender").value = nv.GioiTinh || "Nam";
    document.querySelector("#edit-cmnd").value = nv.CMND || "";
    document.querySelector("#edit-issue-date").value = nv.NgayCap || "";
    document.querySelector("#edit-issue-place").value = nv.NoiCap || "";
    document.querySelector("#edit-hometown").value = nv.QueQuan || "";
    document.querySelector("#edit-phone").value = nv.DienThoai || "";
    document.querySelector("#edit-email").value = nv.Email || "";
    document.querySelector("#edit-department").value = nv.MaPB || "";
    document.querySelector("#edit-position").value = nv.ChucVu || "";
    if (loiDialogSua) loiDialogSua.textContent = "";
    moDialog(dialogSua);
  }

  if (formSua) {
    formSua.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      const maNV = document.querySelector("#edit-employee-id").value;
      const thayDoi = {
        HoTen: document.querySelector("#edit-full-name").value.trim(),
        GioiTinh: document.querySelector("#edit-gender").value,
        NgaySinh: document.querySelector("#edit-birth-date").value,
        CMND: document.querySelector("#edit-cmnd").value.trim(),
        NgayCap: document.querySelector("#edit-issue-date").value,
        NoiCap: document.querySelector("#edit-issue-place").value.trim(),
        QueQuan: document.querySelector("#edit-hometown").value.trim(),
        DienThoai: document.querySelector("#edit-phone").value.trim(),
        Email: document.querySelector("#edit-email").value.trim(),
        MaPB: document.querySelector("#edit-department").value,
        ChucVu: document.querySelector("#edit-position").value.trim()
      };
      // Bỏ qua chính nhân viên đang sửa khi kiểm tra trùng CMND/điện thoại
      const dsKiemTra = dsNhanVienHienTai.filter((x) => x.MaNV !== maNV);
      const cacLoi = kiemTraNhanVien({ ...thayDoi, MaNV: maNV }, dsKiemTra, dsPhongBanHienTai, ngayThamChieu);
      if (cacLoi.length) {
        if (loiDialogSua) loiDialogSua.textContent = cacLoi[0].thongBao;
        return;
      }
      dsNhanVienHienTai = suaNhanVien(dsNhanVienHienTai, maNV, thayDoi);
      luuDuLieuHeThong();
      dongDialog(dialogSua);
      renderBoLoc();
      renderThongKe();
      capNhatBang();
      thongBao.textContent = `Đã cập nhật hồ sơ nhân viên ${thayDoi.HoTen}.`;
    });
  }

  if (nutDongSua) nutDongSua.addEventListener("click", () => dongDialog(dialogSua));

  /* Xử lý Cho nghỉ việc qua Dialog */
  function moXacNhanNghiViec(maNV) {
    const nv = dsNhanVienHienTai.find((x) => x.MaNV === maNV);
    if (!nv || !dialogNghi) return;
    maNVDangChonNghi = maNV;
    if (moTaNghi) moTaNghi.textContent = `Bạn có chắc chắn muốn cho nhân viên ${nv.HoTen} (${nv.MaNV}) thôi việc?`;
    if (ngayNghiInput) ngayNghiInput.value = ngayThamChieu;
    if (loiDialogNghi) loiDialogNghi.textContent = "";
    moDialog(dialogNghi);
  }

  if (formNghi) {
    formNghi.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      const ngayNghi = ngayNghiInput ? ngayNghiInput.value : ngayThamChieu;
      const result = choNghiViec(dsHopDongHienTai, maNVDangChonNghi, ngayNghi);
      if (result.loi) {
        if (loiDialogNghi) loiDialogNghi.textContent = result.loi;
        return;
      }
      dsHopDongHienTai = result.ketQua;
      dsNhanVienHienTai = capNhatTrangThai(dsNhanVienHienTai, dsHopDongHienTai, ngayThamChieu).map((nv) => nv.MaNV === maNVDangChonNghi ? { ...nv, TrangThai: "DaNghi" } : nv);
      luuDuLieuHeThong();
      dongDialog(dialogNghi);
      renderThongKe();
      capNhatBang();
      thongBao.textContent = `Đã cho nhân viên ${maNVDangChonNghi} nghỉ việc từ ngày ${dinhDangNgay(ngayNghi)}.`;
    });
  }

  if (nutDongNghi) nutDongNghi.addEventListener("click", () => dongDialog(dialogNghi));

  /* Khôi phục dữ liệu mẫu */
  if (nutKhoiPhucMau) {
    nutKhoiPhucMau.addEventListener("click", () => moDialog(dialogKhoiPhuc));
  }
  if (formKhoiPhuc) {
    formKhoiPhuc.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      if (typeof khoDuLieu !== "undefined") {
        duLieuKho = khoDuLieu.khoiPhucMau();
        dsNhanVienHienTai = [...duLieuKho.dsNhanVien];
        dsPhongBanHienTai = [...duLieuKho.dsPhongBan];
        dsHopDongHienTai = [...duLieuKho.dsHopDong];
        dsChucVuHienTai = [...duLieuKho.dsChucVu];
        dongDialog(dialogKhoiPhuc);
        renderBoLoc();
        renderThongKe();
        document.querySelector("#employee-id").value = sinhMaNhanVien(dsNhanVienHienTai);
        capNhatBang();
        thongBao.textContent = "Đã khôi phục toàn bộ dữ liệu mẫu ban đầu.";
      }
    });
  }
  if (nutHuyKhoiPhuc) nutHuyKhoiPhuc.addEventListener("click", () => dongDialog(dialogKhoiPhuc));

  /* Event delegation trên bảng */
  thanBangNhanVien.addEventListener("click", (suKien) => {
    const nut = suKien.target.closest("button");
    if (!nut) return;
    const maNV = nut.dataset.maNv;
    if (nut.classList.contains("nut-xem-ho-so")) renderHoSo(maNV);
    if (nut.classList.contains("nut-sua")) moSuaNhanVien(maNV);
    if (nut.classList.contains("nut-nghi-viec")) moXacNhanNghiViec(maNV);
  });

  formLoc.addEventListener("submit", (suKien) => { suKien.preventDefault(); capNhatBang(); });
  formLoc.addEventListener("reset", () => { oTimKiem.value = ""; locPhongBan.value = ""; locTrangThai.value = ""; capNhatBang(); });
  oTimKiem.addEventListener("input", capNhatBang);
  locPhongBan.addEventListener("change", capNhatBang);
  locTrangThai.addEventListener("change", capNhatBang);

  renderBoLoc();
  renderThongKe();
  document.querySelector("#employee-id").value = sinhMaNhanVien(dsNhanVienHienTai);
  capNhatBang();
}

/* ==========================================================================
   3. BẢNG LƯƠNG
   ========================================================================== */
function khoiTaoTrangBangLuong() {
  const form = document.querySelector("#form-bang-luong");
  const inputThang = document.querySelector("#salary-month");
  const locPhongBan = document.querySelector("#salary-department");
  const thanBang = document.querySelector("#than-bang-luong");
  const tongDong = document.querySelector("#tong-bang-luong");
  const ketQua = document.querySelector("#salary-result");

  const kho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : { dsNhanVien: NHAN_VIEN, dsPhongBan: PHONG_BAN };
  const dsPB = kho.dsPhongBan || PHONG_BAN;
  const dsNV = kho.dsNhanVien || NHAN_VIEN;

  locPhongBan.innerHTML = '<option value="">Tất cả phòng ban</option>';
  dsPB.forEach((pb) => {
    locPhongBan.insertAdjacentHTML("beforeend", `<option value="${escapeHTML(pb.MaPB)}">${escapeHTML(pb.TenPB)}</option>`);
  });

  function render() {
    const bangLuong = taoBangLuong(inputThang.value, dsNV.filter((nv) => !locPhongBan.value || nv.MaPB === locPhongBan.value), dsPB, LUONG_NHAN_VIEN, MUC_LUONG, CHAM_CONG, CAU_HINH);
    const tong = tongQuyLuong(bangLuong);
    if (!bangLuong.length) {
      thanBang.innerHTML = '<tr><td colspan="7" data-cot="Kết quả" class="khong-co-du-lieu">Chưa có dữ liệu chấm công tháng này</td></tr>';
      ketQua.textContent = "Chưa có dữ liệu chấm công tháng này";
    } else {
      thanBang.innerHTML = bangLuong.map((dong) => `<tr>
        <td data-cot="Mã NV">${escapeHTML(dong.MaNV)}</td>
        <td data-cot="Họ và tên">${escapeHTML(dong.HoTen)}</td>
        <td data-cot="Phòng ban">${escapeHTML(dong.TenPB)}</td>
        <td data-cot="Ngày công">${escapeHTML(dong.NgayCong)}</td>
        <td class="so-tien" data-cot="Mức lương">${escapeHTML(dinhDangTien(dong.MucLuong))}</td>
        <td class="so-tien" data-cot="Phụ cấp">${escapeHTML(dinhDangTien(dong.PhuCap))}</td>
        <td class="so-tien" data-cot="Thực lĩnh">${escapeHTML(dinhDangTien(dong.LuongThucNhan))}</td>
      </tr>`).join("");
      ketQua.textContent = `Có ${tong.tongNhanVien} nhân viên trong bảng lương.`;
    }
    const oTong = tongDong.querySelector("td");
    if (oTong) oTong.textContent = dinhDangTien(tong.tongQuyLuong);
  }

  form.addEventListener("submit", (suKien) => { suKien.preventDefault(); render(); });
  inputThang.addEventListener("change", render);
  locPhongBan.addEventListener("change", render);
  render();
}

/* ==========================================================================
   4. QUẢN LÝ PHÒNG BAN
   ========================================================================== */
function khoiTaoQuanLyPhongBan() {
  const container = document.querySelector("#danh-sach-phong-ban");
  const thongBao = document.querySelector("#phong-ban-thong-bao");
  const nutThem = document.querySelector("#nut-them-phong-ban");
  const dialogPB = document.querySelector("#dialog-phong-ban");
  const formPB = document.querySelector("#form-phong-ban");
  const nutDongPB = document.querySelector("#nut-dong-dialog-pb");
  const tieuDeDialog = document.querySelector("#tieu-de-dialog-pb");
  const maInput = document.querySelector("#pb-ma");
  const tenInput = document.querySelector("#pb-ten");
  const moTaInput = document.querySelector("#pb-mo-ta");
  const truongPhongSelect = document.querySelector("#pb-truong-phong");
  const loiDialogPB = document.querySelector("#loi-dialog-pb");

  const dialogXoa = document.querySelector("#dialog-xoa-phong-ban");
  const formXoa = document.querySelector("#form-xoa-phong-ban");
  const nutDongXoa = document.querySelector("#nut-dong-dialog-xoa-pb");
  const moTaXoa = document.querySelector("#mo-ta-xoa-pb");
  const loiDialogXoa = document.querySelector("#loi-dialog-xoa-pb");

  let kho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : { dsNhanVien: [...NHAN_VIEN], dsPhongBan: [...PHONG_BAN] };
  let dangSuaMaPB = null;
  let dangXoaMaPB = null;

  function capNhatGiaoDien() {
    kho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : kho;
    const dsPB = kho.dsPhongBan || [];
    const dsNV = kho.dsNhanVien || [];

    // Cập nhật thống kê
    const tongPB = document.querySelector("#thong-ke-tong-pb");
    const tongNV = document.querySelector("#thong-ke-tong-nv-pb");
    const lonNhat = document.querySelector("#thong-ke-pb-lon-nhat");

    const demNV = demNhanVienTheoPhong(dsNV, dsPB);
    const pbMax = demNV.length ? [...demNV].sort((a, b) => b.SoLuong - a.SoLuong)[0] : null;

    if (tongPB) tongPB.textContent = String(dsPB.length);
    if (tongNV) tongNV.textContent = String(dsNV.filter((x) => x.MaPB).length);
    if (lonNhat) lonNhat.textContent = pbMax ? `${pbMax.TenPB} (${pbMax.SoLuong})` : "—";
    if (thongBao) thongBao.textContent = `Có ${dsPB.length} phòng ban trong hệ thống.`;

    // Render danh sách thẻ
    if (!container) return;
    if (!dsPB.length) {
      container.innerHTML = '<p class="khong-co-du-lieu">Chưa có phòng ban nào trong danh mục.</p>';
      return;
    }

    container.innerHTML = dsPB.map((pb) => {
      const soNV = dsNV.filter((nv) => nv.MaPB === pb.MaPB).length;
      const truongPhong = dsNV.find((nv) => nv.MaNV === pb.MaTruongPhong);
      const tenTruongPhong = truongPhong ? truongPhong.HoTen : "Chưa phân công";

      return `<article class="the the-phong-ban" data-ma-pb="${escapeHTML(pb.MaPB)}">
        <header>
          <h3>${escapeHTML(pb.TenPB)}</h3>
          <span class="nhan">${escapeHTML(pb.MaPB)}</span>
        </header>
        <p>${escapeHTML(pb.MoTa || "Chưa có mô tả.")}</p>
        <p><strong>Quân số:</strong> ${soNV} nhân viên</p>
        <p><strong>Trưởng phòng:</strong> ${escapeHTML(tenTruongPhong)}</p>
        <div class="thao-tac">
          <button class="nut nut-nho nut-sua-pb" type="button" data-ma-pb="${escapeHTML(pb.MaPB)}" aria-label="Sửa phòng ban ${escapeHTML(pb.TenPB)}">Sửa</button>
          <button class="nut nut-nho nut-nguy-hiem nut-xoa-pb" type="button" data-ma-pb="${escapeHTML(pb.MaPB)}" aria-label="Xóa phòng ban ${escapeHTML(pb.TenPB)}">Xóa</button>
        </div>
      </article>`;
    }).join("");
  }

  function napSelectTruongPhong(maPB) {
    if (!truongPhongSelect) return;
    const dsNV = (kho.dsNhanVien || []).filter((nv) => !maPB || nv.MaPB === maPB);
    truongPhongSelect.innerHTML = '<option value="">Chưa phân công</option>' +
      dsNV.map((nv) => `<option value="${escapeHTML(nv.MaNV)}">${escapeHTML(nv.HoTen)} (${escapeHTML(nv.MaNV)})</option>`).join("");
  }

  function moThemPB() {
    dangSuaMaPB = null;
    if (tieuDeDialog) tieuDeDialog.textContent = "Thêm phòng ban mới";
    if (maInput) maInput.value = sinhMaPhongBan(kho.dsPhongBan || []);
    if (tenInput) tenInput.value = "";
    if (moTaInput) moTaInput.value = "";
    if (loiDialogPB) loiDialogPB.textContent = "";
    napSelectTruongPhong("");
    moDialog(dialogPB);
  }

  function moSuaPB(maPB) {
    const pb = (kho.dsPhongBan || []).find((x) => x.MaPB === maPB);
    if (!pb) return;
    dangSuaMaPB = maPB;
    if (tieuDeDialog) tieuDeDialog.textContent = `Sửa phòng ban ${pb.TenPB}`;
    if (maInput) maInput.value = pb.MaPB;
    if (tenInput) tenInput.value = pb.TenPB;
    if (moTaInput) moTaInput.value = pb.MoTa || "";
    if (loiDialogPB) loiDialogPB.textContent = "";
    napSelectTruongPhong(pb.MaPB);
    if (truongPhongSelect) truongPhongSelect.value = pb.MaTruongPhong || "";
    moDialog(dialogPB);
  }

  if (nutThem) nutThem.addEventListener("click", moThemPB);
  if (nutDongPB) nutDongPB.addEventListener("click", () => dongDialog(dialogPB));
  if (nutDongXoa) nutDongXoa.addEventListener("click", () => dongDialog(dialogXoa));

  if (formPB) {
    formPB.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      const maPB = maInput.value.trim();
      const tenPB = tenInput.value.trim();
      const moTa = moTaInput.value.trim();
      const maTruongPhong = truongPhongSelect.value;
      const duLieu = { MaPB: maPB, TenPB: tenPB, MoTa: moTa, MaTruongPhong: maTruongPhong };

      const cacLoi = kiemTraPhongBan(duLieu, kho.dsPhongBan || [], kho.dsNhanVien || []);
      if (cacLoi.length) {
        if (loiDialogPB) loiDialogPB.textContent = cacLoi[0].thongBao;
        return;
      }

      let dsMoi;
      if (dangSuaMaPB) {
        dsMoi = suaPhongBan(kho.dsPhongBan, dangSuaMaPB, duLieu);
      } else {
        dsMoi = themPhongBan(kho.dsPhongBan, duLieu);
      }

      kho.dsPhongBan = dsMoi;
      if (typeof khoDuLieu !== "undefined") khoDuLieu.luuDuLieu(kho);
      dongDialog(dialogPB);
      capNhatGiaoDien();
    });
  }

  // Xóa phòng ban
  if (container) {
    container.addEventListener("click", (suKien) => {
      const nut = suKien.target.closest("button");
      if (!nut) return;
      const maPB = nut.dataset.maPb;
      if (nut.classList.contains("nut-sua-pb")) moSuaPB(maPB);
      if (nut.classList.contains("nut-xoa-pb")) {
        const kiemTra = xoaPhongBan(kho.dsPhongBan, kho.dsNhanVien, maPB);
        if (kiemTra.loi) {
          if (thongBao) thongBao.textContent = `Không thể xóa: ${kiemTra.loi}. Vui lòng chuyển nhân viên sang phòng khác trước.`;
          return;
        }
        dangXoaMaPB = maPB;
        const pb = kho.dsPhongBan.find((x) => x.MaPB === maPB);
        if (moTaXoa) moTaXoa.textContent = `Bạn có chắc chắn muốn xóa phòng ban "${pb ? pb.TenPB : maPB}"?`;
        if (loiDialogXoa) loiDialogXoa.textContent = "";
        moDialog(dialogXoa);
      }
    });
  }

  if (formXoa) {
    formXoa.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      const result = xoaPhongBan(kho.dsPhongBan, kho.dsNhanVien, dangXoaMaPB);
      if (result.loi) {
        if (loiDialogXoa) loiDialogXoa.textContent = result.loi;
        return;
      }
      kho.dsPhongBan = result.ketQua;
      if (typeof khoDuLieu !== "undefined") khoDuLieu.luuDuLieu(kho);
      dongDialog(dialogXoa);
      capNhatGiaoDien();
    });
  }

  capNhatGiaoDien();
}

/* ==========================================================================
   5. QUẢN LÝ CHỨC VỤ
   ========================================================================== */
function khoiTaoQuanLyChucVu() {
  const thanBang = document.querySelector("#than-bang-chuc-vu");
  const thongBao = document.querySelector("#chuc-vu-thong-bao");
  const nutThem = document.querySelector("#nut-them-chuc-vu");
  const dialogCV = document.querySelector("#dialog-chuc-vu");
  const formCV = document.querySelector("#form-chuc-vu");
  const nutDongCV = document.querySelector("#nut-dong-dialog-cv");
  const tieuDeDialog = document.querySelector("#tieu-de-dialog-cv");
  const maInput = document.querySelector("#cv-ma");
  const tenInput = document.querySelector("#cv-ten");
  const moTaInput = document.querySelector("#cv-mo-ta");
  const loiDialogCV = document.querySelector("#loi-dialog-cv");

  const dialogXoa = document.querySelector("#dialog-xoa-chuc-vu");
  const formXoa = document.querySelector("#form-xoa-chuc-vu");
  const nutDongXoa = document.querySelector("#nut-dong-dialog-xoa-cv");
  const moTaXoa = document.querySelector("#mo-ta-xoa-cv");
  const loiDialogXoa = document.querySelector("#loi-dialog-xoa-cv");

  let kho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : { dsNhanVien: [...NHAN_VIEN], dsChucVu: [] };
  let dangSuaMaCV = null;
  let dangXoaMaCV = null;

  function capNhatGiaoDien() {
    kho = typeof khoDuLieu !== "undefined" ? khoDuLieu.layDuLieu() : kho;
    const dsCV = kho.dsChucVu || [];
    const dsNV = kho.dsNhanVien || [];
    const danhSachDem = demChucVu(dsNV, dsCV);

    // Cập nhật thống kê
    const tongCV = document.querySelector("#thong-ke-tong-cv");
    const tongNV = document.querySelector("#thong-ke-tong-nv-cv");
    const phoBien = document.querySelector("#thong-ke-cv-pho-bien");

    const maxCV = danhSachDem.length ? [...danhSachDem].sort((a, b) => b.SoLuong - a.SoLuong)[0] : null;

    if (tongCV) tongCV.textContent = String(dsCV.length);
    if (tongNV) tongNV.textContent = String(danhSachDem.reduce((t, x) => t + x.SoLuong, 0));
    if (phoBien) phoBien.textContent = maxCV ? `${maxCV.TenChucVu} (${maxCV.SoLuong})` : "—";
    if (thongBao) thongBao.textContent = `Có ${dsCV.length} chức vụ trong hệ thống.`;

    if (!thanBang) return;
    if (!dsCV.length) {
      thanBang.innerHTML = '<tr><td colspan="5" data-cot="Kết quả" class="khong-co-du-lieu">Chưa có chức vụ nào trong danh mục.</td></tr>';
      return;
    }

    thanBang.innerHTML = danhSachDem.map((cv) => {
      const goc = dsCV.find((x) => x.MaChucVu === cv.MaChucVu) || {};
      return `<tr>
        <td data-cot="Mã CV">${escapeHTML(cv.MaChucVu)}</td>
        <td data-cot="Tên chức vụ"><strong>${escapeHTML(cv.TenChucVu)}</strong></td>
        <td data-cot="Mô tả">${escapeHTML(goc.MoTa || "Chưa có mô tả.")}</td>
        <td data-cot="Số lượng nhân viên">${escapeHTML(cv.SoLuong)} người</td>
        <td data-cot="Thao tác">
          <button class="nut nut-nho nut-sua-cv" type="button" data-ma-cv="${escapeHTML(cv.MaChucVu)}" aria-label="Sửa chức vụ ${escapeHTML(cv.TenChucVu)}">Sửa</button>
          <button class="nut nut-nho nut-nguy-hiem nut-xoa-cv" type="button" data-ma-cv="${escapeHTML(cv.MaChucVu)}" aria-label="Xóa chức vụ ${escapeHTML(cv.TenChucVu)}">Xóa</button>
        </td>
      </tr>`;
    }).join("");
  }

  function moThemCV() {
    dangSuaMaCV = null;
    if (tieuDeDialog) tieuDeDialog.textContent = "Thêm chức vụ mới";
    if (maInput) maInput.value = sinhMaChucVu(kho.dsChucVu || []);
    if (tenInput) tenInput.value = "";
    if (moTaInput) moTaInput.value = "";
    if (loiDialogCV) loiDialogCV.textContent = "";
    moDialog(dialogCV);
  }

  function moSuaCV(maCV) {
    const cv = (kho.dsChucVu || []).find((x) => x.MaChucVu === maCV);
    if (!cv) return;
    dangSuaMaCV = maCV;
    if (tieuDeDialog) tieuDeDialog.textContent = `Sửa chức vụ ${cv.TenChucVu}`;
    if (maInput) maInput.value = cv.MaChucVu;
    if (tenInput) tenInput.value = cv.TenChucVu;
    if (moTaInput) moTaInput.value = cv.MoTa || "";
    if (loiDialogCV) loiDialogCV.textContent = "";
    moDialog(dialogCV);
  }

  if (nutThem) nutThem.addEventListener("click", moThemCV);
  if (nutDongCV) nutDongCV.addEventListener("click", () => dongDialog(dialogCV));
  if (nutDongXoa) nutDongXoa.addEventListener("click", () => dongDialog(dialogXoa));

  if (formCV) {
    formCV.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      const maCV = maInput.value.trim();
      const tenCV = tenInput.value.trim();
      const moTa = moTaInput.value.trim();
      const duLieu = { MaChucVu: maCV, TenChucVu: tenCV, MoTa: moTa };

      const cacLoi = kiemTraChucVu(duLieu, kho.dsChucVu || []);
      if (cacLoi.length) {
        if (loiDialogCV) loiDialogCV.textContent = cacLoi[0].thongBao;
        return;
      }

      if (dangSuaMaCV) {
        const result = suaChucVu(kho.dsChucVu, kho.dsNhanVien, dangSuaMaCV, duLieu);
        kho.dsChucVu = result.danhSach;
        kho.dsNhanVien = result.nhanVien;
      } else {
        kho.dsChucVu = themChucVu(kho.dsChucVu, duLieu);
      }

      if (typeof khoDuLieu !== "undefined") khoDuLieu.luuDuLieu(kho);
      dongDialog(dialogCV);
      capNhatGiaoDien();
    });
  }

  if (thanBang) {
    thanBang.addEventListener("click", (suKien) => {
      const nut = suKien.target.closest("button");
      if (!nut) return;
      const maCV = nut.dataset.maCv;
      if (nut.classList.contains("nut-sua-cv")) moSuaCV(maCV);
      if (nut.classList.contains("nut-xoa-cv")) {
        const kiemTra = xoaChucVu(kho.dsChucVu, kho.dsNhanVien, maCV);
        if (kiemTra.loi) {
          if (thongBao) thongBao.textContent = `Không thể xóa: ${kiemTra.loi}. Vui lòng chuyển vị trí công tác của nhân viên trước.`;
          return;
        }
        dangXoaMaCV = maCV;
        const cv = kho.dsChucVu.find((x) => x.MaChucVu === maCV);
        if (moTaXoa) moTaXoa.textContent = `Bạn có chắc chắn muốn xóa chức vụ "${cv ? cv.TenChucVu : maCV}"?`;
        if (loiDialogXoa) loiDialogXoa.textContent = "";
        moDialog(dialogXoa);
      }
    });
  }

  if (formXoa) {
    formXoa.addEventListener("submit", (suKien) => {
      suKien.preventDefault();
      const result = xoaChucVu(kho.dsChucVu, kho.dsNhanVien, dangXoaMaCV);
      if (result.loi) {
        if (loiDialogXoa) loiDialogXoa.textContent = result.loi;
        return;
      }
      kho.dsChucVu = result.ketQua;
      if (typeof khoDuLieu !== "undefined") khoDuLieu.luuDuLieu(kho);
      dongDialog(dialogXoa);
      capNhatGiaoDien();
    });
  }

  capNhatGiaoDien();
}
