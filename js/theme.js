/* Theme controller: khởi tạo sớm để tránh nháy giao diện trước khi CSS tải xong. */
(function () {
  const khoaTheme = "hrm-theme";
  const docElement = document.documentElement;
  function docTheme() {
    try {
      return localStorage.getItem(khoaTheme);
    } catch (loi) {
      return null;
    }
  }

  /* Giữ đồng bộ với chonGiaoDien trong logic.js: cùng whitelist và fallback hệ điều hành. */
  function chonTheme(giaTriLuu, heThongToi) {
    if (giaTriLuu === "light" || giaTriLuu === "dark") return giaTriLuu;
    return heThongToi ? "dark" : "light";
  }

  function uuTienTheme() {
    const daLuu = docTheme();
    const heThongToi = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
    return chonTheme(daLuu, heThongToi);
  }

  function ganSuKienNut() {
    const nutTheme = document.querySelector("#nut-doi-giao-dien");
    if (!nutTheme) return;
    capNhatNut(docElement.dataset.theme);
    nutTheme.addEventListener("click", () => {
      apDungTheme(docElement.dataset.theme === "dark" ? "light" : "dark", true);
    });
  }

  function capNhatNut(theme) {
    const nutTheme = document.querySelector("#nut-doi-giao-dien");
    if (!nutTheme) return;
    const laToi = theme === "dark";
    nutTheme.setAttribute("aria-pressed", String(laToi));
    nutTheme.setAttribute("aria-label", laToi ? "Chuyển sang giao diện sáng" : "Chuyển sang giao diện tối");
    nutTheme.textContent = laToi ? "Giao diện sáng" : "Giao diện tối";
  }

  function apDungTheme(theme, ghiNho) {
    const themeHopLe = theme === "dark" ? "dark" : "light";
    docElement.dataset.theme = themeHopLe;
    capNhatNut(themeHopLe);
    if (ghiNho) {
      try { localStorage.setItem(khoaTheme, themeHopLe); } catch (loi) { /* Storage bị chặn vẫn không cản giao diện. */ }
    }
  }

  apDungTheme(uuTienTheme(), false);
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", ganSuKienNut, { once: true });
  } else {
    ganSuKienNut();
  }
})();
