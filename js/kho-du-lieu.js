/* Storage layer Sprint 6A: lưu trạng thái quản lý trong localStorage, không sửa hằng Data Contract. */
(function () {
  const KHOA = "hrm-du-lieu";
  const PHIEN_BAN = "1.0";
  let duLieuHienTai = null;

  function saoChep(giaTri) {
    return JSON.parse(JSON.stringify(giaTri));
  }

  function duLieuMau() {
    return {
      phienBan: PHIEN_BAN,
      dsNhanVien: saoChep(NHAN_VIEN),
      dsPhongBan: saoChep(PHONG_BAN),
      dsHopDong: saoChep(HOP_DONG_LAO_DONG),
      dsChucVu: [...new Set(NHAN_VIEN.map((nv) => nv.ChucVu).filter(Boolean))].map((TenChucVu, index) => ({ MaChucVu: `CV${String(index + 1).padStart(2, "0")}`, TenChucVu, MoTa: "" }))
    };
  }

  function khoiPhucMau() {
    duLieuHienTai = duLieuMau();
    try { localStorage.setItem(KHOA, JSON.stringify(duLieuHienTai)); } catch (loi) { console.warn("Kho dữ liệu: không thể lưu dữ liệu mẫu."); }
    return saoChep(duLieuHienTai);
  }

  function layDuLieu() {
    if (duLieuHienTai) return saoChep(duLieuHienTai);
    try {
      const daLuu = JSON.parse(localStorage.getItem(KHOA));
      if (daLuu && daLuu.phienBan === PHIEN_BAN && Array.isArray(daLuu.dsNhanVien) && Array.isArray(daLuu.dsPhongBan)) {
        duLieuHienTai = daLuu;
        return saoChep(duLieuHienTai);
      }
    } catch (loi) { console.warn("Kho dữ liệu: dữ liệu lưu bị lỗi, dùng dữ liệu mẫu."); }
    return khoiPhucMau();
  }

  function luuDuLieu(duLieu) {
    if (!duLieu || typeof duLieu !== "object") return layDuLieu();
    duLieuHienTai = saoChep({ ...duLieu, phienBan: PHIEN_BAN });
    try { localStorage.setItem(KHOA, JSON.stringify(duLieuHienTai)); } catch (loi) { console.warn("Kho dữ liệu: không thể lưu thay đổi."); }
    return saoChep(duLieuHienTai);
  }

  window.khoDuLieu = { layDuLieu, luuDuLieu, khoiPhucMau };
})();
