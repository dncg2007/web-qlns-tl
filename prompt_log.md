# Prompt Log

## Mục mẫu

- **Bối cảnh:** Xây dựng nền tảng front-end cho Website Quản lý Nhân sự & Tiền lương trong môn Thiết kế Web, lớp 25CT114.
- **Yêu cầu:** Tạo cấu trúc semantic HTML5, tách CSS/JavaScript/tài liệu và chưa triển khai giao diện hoặc logic nghiệp vụ.
- **Định dạng:** Bàn giao theo danh sách tệp, release note, lệnh Git và giải thích các lựa chọn cấu trúc.
**Nghiên cứu đề tài và hướng phát triển ban đầu**
  ## Prompt #01 — GĐ1 · Lộ trình tổng thể
**Bối cảnh:** Tôi làm dự án "Website Quản lý Nhân sự & Tiền lương (HRM & Payroll)" (đề tài số 7)
cho môn Thiết kế Web, lớp 25CT114. Tôi chỉ làm Front-end (HTML5, CSS3, JavaScript thuần);
phần CSDL do bên khác đảm nhiệm.
**Yêu cầu:** Đề xuất lộ trình theo 4 giai đoạn của học phần (GĐ1 Nền tảng, GĐ2 Giao diện &
Responsive, GĐ3 JavaScript, GĐ4 PBL Sprint & Showcase). Mỗi giai đoạn nêu việc cần làm và
tiêu chí hoàn thành. Kèm Data Contract JSON mẫu (nhân viên, phòng ban, hợp đồng, chấm công).
**Định dạng đầu ra:** Tiếng Việt; bám đề cương và rubric giữa kỳ; Semantic HTML5, Grid/Flexbox,
Mobile First; tách data.js / logic.js / features.js; có hàm thuần mẫu tính lương.

## Prompt #02 — Đề xuất tiếp theo · Khóa Data Contract
**Bối cảnh:** Đã có Data Contract v0.1 (CAU_HINH, PHONG_BAN, NHAN_VIEN, HOP_DONG, CHAM_CONG)
cho dự án HRM & Payroll.
**Yêu cầu:** Sinh file data.js hoàn chỉnh gồm 4 phòng ban, 12 nhân viên (đa dạng phòng ban,
phụ cấp, 2 người trạng thái "nghiViec"), hợp đồng và chấm công tháng 2026-10 tương ứng,
có vài trường hợp biên (ngayCong = 0 và 31).
**Định dạng đầu ra:** Một file data.js, giữ nguyên tên khóa của v0.1, có comment giải thích từng
khối, tiền là số nguyên VND, ngày dạng ISO.

## Prompt #02 — GĐ1 · Chốt khởi động dự án
**Bối cảnh:** Dự án HRM & Payroll (Front-end) đã có repo private dncg2007/web-qlns-tl; chưa dựng Kanban.
**Yêu cầu:** (1) ghi nhận repo và các lưu ý; (2) hướng dẫn dựng Kanban 4 cột kèm task và Assignee;
(3) chốt sitemap theo gợi ý; (4) đề xuất thêm các mẫu DOM Tree thịnh hành phù hợp dự án;
(5) ghi lại cấu trúc và thông tin CSDL thành tài liệu để AI khác tự sinh SQL.
**Định dạng đầu ra:** Tiếng Việt; Data Contract v0.2 khớp tài liệu CSDL; prompt cho AI Z kèm lệnh Git.

## Prompt #03 — GĐ1 · Khởi tạo khung dự án và HTML Semantic (AI Z)
(Dán nguyên văn khối prompt ở mục "Prompt cho AI Z" khi chạy.)

## Prompt #04 — GĐ1 · Kiểm tra kết quả và chuẩn bị GĐ2
**Bối cảnh:** AI Z đã dựng khung dự án và 3 trang HTML semantic, đã push nhánh feature/html-structure
(13 file, 1 commit). Remote hiện chỉ có một nhánh.
**Yêu cầu:** Kiểm tra lại Giai đoạn 1 theo tiêu chí hoàn thành, chỉ ra việc còn thiếu, và đề xuất
hướng đi chi tiết cho Giai đoạn 2 (Design System, Responsive, hiệu ứng).
**Định dạng đầu ra:** Tiếng Việt; bảng kiểm tra; lộ trình các nhánh; prompt cho AI Z kèm lệnh Git.

## Prompt #05 — GĐ2A · Design System và chế độ Sáng/Tối (AI Z)
(Dán nguyên văn khối prompt ở mục "Prompt cho AI Z (bước 2A)" khi chạy.)

## Prompt #06 — GĐ2A · Kiểm tra kết quả và chuẩn bị 2B
**Bối cảnh:** AI Z đã xong Design System và chế độ Sáng/Tối bằng CSS thuần (nhánh feature/design-system):
0 mã màu cứng ngoài :root, 0 !important, 3 trang có checkbox #che-do-toi.
**Yêu cầu:** Kiểm tra báo cáo 2A, chỉ ra việc cần tự xác minh, rồi đề xuất hướng đi và prompt cho
bước 2B (layout Grid/Flexbox và responsive Mobile First).
**Định dạng đầu ra:** Tiếng Việt; bảng kiểm tra; bảng 3 mốc responsive; prompt cho AI Z kèm lệnh Git.

## Prompt #07 — GĐ2B · Layout và Responsive (AI Z)
(Dán nguyên văn khối prompt ở mục "Prompt cho AI Z (bước 2B)" khi chạy.)

## Prompt #08 — GĐ2B · Kiểm tra kết quả và chuẩn bị 2C
**Bối cảnh:** AI Z đã xong layout Grid/Flexbox Mobile First (nhánh feature/layout-responsive):
2 mốc min-width 768/1024, 0 float, 0 !important, 0 mã màu cứng, 53 ô td đều có data-cot.
**Yêu cầu:** Kiểm tra báo cáo 2B, chỉ ra các điểm layout dễ hỏng cần tự xác minh bằng DevTools,
rồi đề xuất hướng đi và prompt cho bước 2C (thành phần giao diện: thẻ, nút, form, bảng, badge, biểu đồ).
**Định dạng đầu ra:** Tiếng Việt; bảng kiểm tra; bảng nhóm thành phần; prompt cho AI Z kèm lệnh Git.

## Prompt #09 — GĐ2C · Thành phần giao diện (AI Z)
(Dán nguyên văn khối prompt ở mục "Prompt cho AI Z (bước 2C)" khi chạy.)

## Prompt #10 — GĐ2C · Kiểm tra kết quả và chuẩn bị 2D
**Bối cảnh:** AI Z đã xong components (nhánh feature/components): 0 mã màu cứng, 0 !important,
0 transition, 7 cặp tương phản đạt từ 4.5:1, badge có hook data-trang-thai và data-loai-hd.
**Yêu cầu:** Kiểm tra báo cáo 2C, chỉ ra lỗi và điểm cần xác minh (aria-invalid đặt sẵn, nhãn loại hợp đồng,
viền ô nhập), rồi đề xuất hướng đi và prompt cho bước 2D (hiệu ứng: transition, keyframes, Animate.css).
**Định dạng đầu ra:** Tiếng Việt; bảng kiểm tra; bảng nhóm hiệu ứng; prompt cho AI Z kèm lệnh Git.

## Prompt #11 — GĐ2D · Hiệu ứng chuyển động (AI Z)
(Dán nguyên văn khối prompt ở mục "Prompt cho AI Z (bước 2D)" khi chạy.)

**Bố cục phát triển chính (MAIN)**
## Prompt #01 | Sprint 1: Lộ trình, Data Contract, Prompt cho AI Z
- Ngày: 17/10/2026
- Công cụ: Claude (vai trò Technical Lead)
- Repo: dncg2007/web-qlns-tl

### Nội dung prompt (bản tối ưu theo 3 thành phần: Làm gì – Ở đâu – Ra sao)
**Bối cảnh:** Dự án "Website Quản lý Nhân sự & Tiền lương (HRM & Payroll)" môn Thiết kế Web. Đã khởi tạo skeleton Semantic HTML5 (index.html, nhan-vien.html, bang-luong.html, css/, js/) và đẩy lên GitHub dncg2007/web-qlns-tl. Phần CSDL do AI khác phụ trách, bên Front-end chỉ định nghĩa Data Contract.

**Yêu cầu (Sprint 1):**
1. Tổng hợp ngắn gọn lộ trình phát triển giao diện Front-end cho dự án, dựa trên 4 giai đoạn của môn học.
2. Đề xuất Data Contract (JSON) cốt lõi cho 2 thực thể "NhanVien" và "PhongBan", để AI Database dựa vào sinh API/dữ liệu mẫu.
3. Tạo Prompt chi tiết cho AI Z (AI Code) để: đọc và phân tích HTML/CSS hiện có trên repo; viết JavaScript render dữ liệu mẫu từ Data Contract ra cây DOM trang Quản lý Nhân viên; báo cáo rõ các file thay đổi; chuẩn bị sẵn lệnh `git add .` và `git commit` để lưu vết lên GitHub.

**Định dạng đầu ra:** Trả lời theo thứ tự 1 → 2 → 3, có giải thích ngắn lý do phù hợp với môn học và có Prompt Log ở cuối.

### Kết quả mong đợi
- Bảng lộ trình theo 4 giai đoạn, kèm phạm vi Sprint 1 (3 User Story).
- Data Contract PhongBan + NhanVien, bám tên cột SQL.
- Prompt hoàn chỉnh cho AI Z (data.js, logic.js, features.js, nhan-vien.html, css) kèm yêu cầu changelog, báo cáo mã nguồn và lệnh git.

## Prompt #02 | Sprint 1: Review kết quả AI Z và hotfix
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/render-nhan-vien

### Bối cảnh
AI Z đã hoàn thành Sprint 1 (data.js, logic.js, features.js, nhan-vien.html, css/styles.css). Review phát hiện: form lọc bị ghép sai cặp nhãn - ô nhập ở >=768px, avatar có aria-label sai chỗ, thống kê đổi theo bộ lọc, chưa kiểm chứng biến CSS và trình duyệt.

### Yêu cầu gửi AI Z (hotfix, không đổi Data Contract v1.0)
1. Bọc cặp label + control trong div.truong-loc, nút trong div.hang-nut-loc; sửa CSS Mobile First (1 cột, từ 768px 3 cột, nút Flexbox), xóa selector cũ.
2. renderThongKe chỉ gọi một lần với toàn bộ NHAN_VIEN; đổi tiêu đề thành "Thống kê quân số".
3. Avatar chữ cái đầu dùng aria-hidden="true", bỏ aria-label.
4. Kiểm toán mọi var(--...) trong CSS Sprint 1, bổ sung biến thiếu vào :root, thay màu viết cứng.
5. Footer đổi 2025 thành 2026.
Kiểm thử: node --check, git diff --check, 12 dòng console.log, chụp màn hình 375/768/1280 nếu có trình duyệt, không tuyên bố đã kiểm tra nếu không chạy được.

### Định dạng đầu ra
Tóm tắt, changelog bảng, chỉ code đoạn đã sửa, bảng kiểm toán biến CSS, kết quả kiểm thử, lệnh git ([Fix]: ...).

### Kết quả mong đợi
Form lọc đúng cặp nhãn - ô nhập ở cả 3 mốc, thống kê cố định theo toàn bộ dữ liệu, không biến CSS thiếu, Console sạch, sẵn sàng mở Pull Request về main.

## Prompt #03 | Sprint 1: Review kết quả hotfix của AI Z
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/render-nhan-vien

### Bối cảnh
AI Z đã hoàn thành hotfix theo Prompt #02: bọc .truong-loc và .hang-nut-loc cho form lọc, cố định thống kê theo toàn bộ NHAN_VIEN, avatar aria-hidden, kiểm toán biến CSS, footer 2026. Báo cáo ghi rõ chưa kiểm chứng bằng trình duyệt.

### Yêu cầu gửi Claude
Review báo cáo hotfix: đối chiếu 5 việc với yêu cầu, tìm lỗi còn sót, nêu việc sinh viên phải tự kiểm chứng trước khi merge (Console, thử tay, responsive 375/768/1280, W3C, Lighthouse), kèm mẫu prompt dự phòng nếu phát hiện lỗi.

### Kết quả
- Code đạt 4/5 việc, riêng kiểm toán biến CSS cần tự đối chiếu bằng lệnh grep.
- Chưa merge cho tới khi hoàn tất 6 bước kiểm chứng bằng trình duyệt.
- Sau khi merge: chuyển sang Sprint 2.

## Prompt #04 | Sprint 1: Giao AI Z tự kiểm thử và tự sửa
- Công cụ: Claude (Technical Lead) viết prompt, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/render-nhan-vien

### Bối cảnh
Sau hotfix, AI Z báo chưa kiểm chứng bằng trình duyệt vì môi trường không có Chromium. Sinh viên hỏi vì sao không để AI Z tự test và fix luôn.

### Yêu cầu
Cho phép AI Z cài công cụ kiểm thử (jsdom, Playwright, html-validate/vnu, Lighthouse) ở thư mục tạm ngoài repo; tự kiểm biến CSS, chạy test logic và DOM, chụp màn hình 375/768/1280, đo cuộn ngang, kiểm Console và 404, validate DOM đã render, chạy Lighthouse; chỉ sửa lỗi thật sự tìm thấy; báo cáo kèm bằng chứng, nói rõ phần chưa chạy được.

### Kết quả mong đợi
Bảng kết quả có log và ảnh làm bằng chứng, danh sách lỗi (nếu có) đã sửa tối thiểu, sinh viên chỉ cần xem ảnh, thử điện thoại thật rồi mở Pull Request.

## Prompt #05 | Sprint 1: Review kết quả AI Z tự kiểm thử
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
AI Z đã tự kiểm thử bằng jsdom (16/16 PASS), Playwright 375/768/1280, html-validate và Lighthouse (100/100/96/100). Z tìm và sửa lỗi reset form trong js/features.js. Báo cáo ghi working tree sạch và branch hiện tại là "db".

### Yêu cầu gửi Claude
Review báo cáo: xác định mâu thuẫn (đã sửa code nhưng tree sạch, sai nhánh), đánh giá từng bằng chứng, nêu việc sinh viên phải tự xác minh (git log, ảnh chụp, 768px, W3C chính thức, điện thoại thật), kèm prompt dự phòng cho AI Z.

### Kết quả
- Kết quả kiểm thử đáng tin, nhưng chưa merge cho tới khi xác minh bản sửa reset nằm đúng nhánh feature/render-nhan-vien.
- Cần đo lại cuộn ngang quanh mốc 768px nhiều lần.
- Sau khi đạt: mở Pull Request về main, rồi chuyển sang Sprint 2.

## Prompt #06 | Sprint 1: Review kết quả truy vết nhánh Git và đo overflow của AI Z
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
Z báo bản sửa reset không có trong lịch sử, tạo nhánh feature/render-nhan-vien từ 8760ca6, áp lại bản sửa, đo 15 lượt (760/768/800/820/1024px) và sửa overflow bằng minmax(18rem,20rem) + overflow:hidden trên .ho-so-nhanh. Log git cho thấy commit [Database] f447948 có sửa js/features.js (+4 -1).

### Yêu cầu gửi Claude
Review báo cáo: đối chiếu log git, đánh giá chẩn đoán overflow, nêu rủi ro dùng chung thư mục giữa hai AI, sửa lệnh git, và viết prompt để Z truy nguyên nguyên nhân thật.

### Kết quả
- Bản sửa reset gần như chắc chắn đã bị commit nhầm vào f447948 do git add . khi hai AI dùng chung thư mục.
- Chẩn đoán overflow chưa thuyết phục; nghi do animation fadeInRight. Cần đo theo thời gian và hoàn tác từng thay đổi để chứng minh.
- Lệnh push phải có -u; không dùng git add .; tách 2 commit; dùng git worktree để tách thư mục hai AI.
- Chưa merge cho tới khi hoàn tất prompt #06, W3C chính thức và thử điện thoại thật.

## Prompt #07 | Sprint 1: Review kết quả truy nguyên overflow và nhánh Git
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/render-nhan-vien

### Bối cảnh
Z đã chạy git show f447948 (chỉ sửa SQL, không đụng js/features.js), truy nguyên animation, đo overflow theo thời gian (30 lượt), hoàn tác từng thay đổi và sửa lại tối thiểu: overflow-x: clip cho .ho-so-nhanh, min-width/overflow-wrap cho .so-kpi, guard cảnh báo features.js, reset handler. Lighthouse 98/100/96/100, jsdom 16/16.

### Yêu cầu gửi Claude
Review báo cáo, đối chiếu với giả thuyết ở Prompt #06, kết luận mức sẵn sàng merge và danh sách việc người học tự xác minh.

### Kết quả
- Giả thuyết "reset bị commit nhầm vào f447948" sai: stat trong log là của file SQL. Bản sửa reset chỉ là thay đổi chưa commit.
- Nguyên nhân overflow là animate__fadeInRight trên article con; minmax(18rem,20rem) không cần thiết và đã hoàn tác.
- Việc tiếp: đọc git diff, 2 commit (không git add .), push -u, W3C chính thức, thử điện thoại thật, mở Pull Request về main, sau đó Sprint 2.

## Prompt #08 | Sprint 2: Form validation, hồ sơ nhanh, Data Contract v1.1, bảng lương
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) viết prompt, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint2-form-luong (tách từ main sau khi merge Sprint 1)

### Bối cảnh
Sprint 1 đã merge. Báo cáo cuối kỳ 06/11/2026. Log AI Database cho thấy mã nhân viên dạng NV0003 trong khi data.js dùng NV001: cần đối chiếu db/02_DuLieuMau.sql (chỉ đọc) và nâng Data Contract lên v1.1.

### Yêu cầu
1. Lộ trình: Sprint 2 (form + hồ sơ nhanh + bảng lương), Sprint 3 (Dark Mode, dashboard, README, GitHub Pages), thời gian đệm đến 06/11.
2. Data Contract v1.1: thêm MucLuong, LuongNhanVien, HopDongLaoDong, ChamCong (đề xuất Front-end, chuyển AI Database).
3. Prompt cho AI Z: đối chiếu SQL; data.js mở rộng; logic.js thêm hàm thuần (sinhMaNhanVien, kiemTraNhanVien, themNhanVien, layHoSoNhanVien, layLuongHienHanh, tinhLuong, taoBangLuong, tongQuyLuong, dinhDangTien, ngayCuoiThang); features.js xử lý form có validation, ủy quyền sự kiện cho hồ sơ nhanh, render bảng lương; tự kiểm thử có bằng chứng; commit tách module, không git add .

### Định dạng đầu ra
Báo cáo hiện trạng, changelog bảng, code, bảng kiểm thử có bằng chứng, giải thích hàm, việc chuyển cho AI Database, phần chưa kiểm chứng, lệnh git.

### Kết quả mong đợi
Thêm nhân viên có kiểm tra dữ liệu, xem hồ sơ nhanh, bảng lương theo tháng tính động, Data Contract v1.1 khớp CSDL, Console sạch, sẵn sàng Pull Request.

## Prompt #09 | Sprint 2: Sửa lỗi lệnh git khi chuẩn bị nhánh
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead)
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
Sau khi merge Sprint 1, sinh viên chạy lệnh chuẩn bị Sprint 2 trong Windows PowerShell 5: "&&" không hợp lệ nên checkout/pull main không chạy; nhánh feature/sprint2-form-luong được tạo từ nhánh cũ; lệnh "git branch --merged main" báo "malformed object name main" do local chưa có nhánh main.

### Yêu cầu
Giải thích nguyên nhân và đưa chuỗi lệnh PowerShell đúng để: fetch, xác nhận Sprint 1 đã có trên origin/main, checkout main, pull, xóa và tạo lại nhánh Sprint 2 từ main mới, rồi mới chạy prompt #08.

### Kết quả
- Dùng từng lệnh một dòng thay cho "&&" trong PowerShell 5.
- Nhánh Sprint 2 phải tách từ main đã cập nhật.

## Prompt #10 | Sprint 2: Xác nhận main đã gộp Sprint 1 + db, tạo lại nhánh Sprint 2
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead)
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
Log git sau fetch: origin/main (5c0d0d4) gộp PR #2 (feature/render-nhan-vien, Sprint 1) và PR #1 (db). Nhánh local feature/sprint2-form-luong đang trỏ 732cbf9 (cũ), local chưa có nhánh main.

### Yêu cầu
Xác nhận trạng thái và đưa chuỗi lệnh PowerShell: tạo main local theo origin/main, xóa và tạo lại feature/sprint2-form-luong từ main, kiểm tra nhánh/log, dọn nhánh đã merge, tách worktree cho nhánh db.

### Kết quả
- Nhánh Sprint 2 tách từ 5c0d0d4, có sẵn db/02_DuLieuMau.sql để Z đối chiếu.
- Sẵn sàng chạy prompt #08.

## Prompt #11 | Sprint 2: Review kết quả AI Z (form validation, hồ sơ nhanh, bảng lương)
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint2-form-luong

### Bối cảnh
Z hoàn thành Sprint 2: Data Contract v1.1 (đổi mã NV0001–NV0016 theo SQL, thêm MucLuong, LuongNhanVien, HopDongLaoDong, ChamCong), 12 hàm thuần mới, form validation, hồ sơ nhanh, bảng lương theo tháng. Test: 23 logic, Playwright 4 mốc, Lighthouse 99–100. Chưa commit.

### Yêu cầu gửi Claude
Review báo cáo, chỉ ra mâu thuẫn, nêu việc sinh viên tự xác minh, soạn nội dung chuyển cho AI Database.

### Kết quả
- Kết quả tốt; cần kiểm git status (không add db/), thử nhân viên mới ở hồ sơ nhanh, đổi tháng bảng lương, bàn phím, W3C chính thức, điện thoại thật.
- Dữ liệu lương/chấm công sinh theo công thức, nên chuyển sang bản ghi cố định.
- Chuyển AI Database: MucLuong, LuongNhanVien (MaLuong hay MaLuongNhanVien), ChamCong, TrangThai là cột hay view.
- Sau khi đạt: commit 3 module, push, Pull Request về main, rồi Sprint 3 (Dark Mode, dashboard, README, GitHub Pages).

## Prompt #12 | Sprint 2: Chốt tên cột Data Contract v1.1 theo AI Database
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) viết prompt, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint2-form-luong

### Bối cảnh
AI Database trả lời tên cột cuối cùng dựa trên db/01_CSDL.sql và db/02_DuLieuMau.sql: MucLuong (MaMucLuong, TenMucLuong, MoTa, SoTien); LuongNhanVien (MaLuongNhanVien, MaNV, MaMucLuong, NgayBatDau, NgayKetThuc); ChamCong (MaChamCong, MaNV, Thang, NgayCong, PhuCap, UNIQUE (MaNV, Thang)); TrangThai là cột dẫn xuất từ view dbo.v_NhanVien_TrangThai.

### Yêu cầu gửi AI Z
1. Đổi MaLuong thành MaLuongNhanVien ở mọi nơi, grep xác nhận.
2. Chú thích TrangThai là trường mô phỏng dẫn xuất từ view.
3. Thêm hàm thuần suyRaTrangThai theo quy tắc hợp đồng hiệu lực (chỉ dùng kiểm thử).
4. Kiểm tra nhất quán TrangThai với hợp đồng, chỉ báo lệch không tự sửa.
Kiểm thử: node --check, jsdom (Sprint 1 + 23 test + test mới), Playwright 375/1280. Commit tách module, không git add .

### Kết quả mong đợi
Tên khóa khớp SQL, báo cáo nhất quán dữ liệu mẫu, sẵn sàng commit và Pull Request Sprint 2.

## Prompt #13 | Sprint 2: Review hotfix MaLuongNhanVien và suyRaTrangThai
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint2-form-luong

### Bối cảnh
Z đã đổi MaLuong thành MaLuongNhanVien (2 chỗ trong data.js), thêm comment TrangThai, thêm hàm suyRaTrangThai, đối chiếu TrangThai với hợp đồng (MISMATCHES []), Playwright 375/1280 sạch. Báo cáo chỉ đưa 2 commit cho data.js và logic.js.

### Yêu cầu gửi Claude
Review báo cáo hotfix và kiểm tra xem lệnh commit có đủ file Sprint 2 hay không.

### Kết quả
- Code hotfix đạt.
- Lệnh commit của Z có thể bỏ sót features.js, nhan-vien.html, bang-luong.html, css/styles.css; phải kiểm git status và git log rồi commit đủ 3 module.
- Việc còn: thử tay, W3C chính thức, điện thoại thật, hỏi AI Database định dạng mã MaLuongNhanVien, mở Pull Request về main, sau đó Sprint 3.

## Prompt #14 | Sprint 3: Dark Mode, dashboard dùng chung dữ liệu, README, GitHub Pages
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) viết prompt, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint3-darkmode-dashboard (tách từ main sau khi merge Sprint 2)

### Bối cảnh
Sprint 1 và Sprint 2 đã merge. Báo cáo cuối kỳ 06/11/2026. Data Contract v1.1 đã khóa theo schema SQL (MaLuongNhanVien, TrangThai dẫn xuất từ view dbo.v_NhanVien_TrangThai).

### Yêu cầu
1. Dark Mode: bộ biến :root sáng/tối, data-theme, theme.js nạp trong head, lưu localStorage trong try/catch, nút chuyển có aria-pressed ở cả 3 trang, không màu cứng ngoài :root, đo tương phản.
2. Dashboard index.html: số liệu từ dữ liệu (quân số, quỹ lương, quân số theo phòng, hợp đồng sắp hết hạn); hàm thuần soNgayTuMoc, hopDongSapHetHan, thongKeDashboard, chonGiaoDien; biểu đồ HTML/CSS thuần.
3. README.md đúng cấu trúc Chương 9 §4.3 và prompt_log.md; kiểm tra đường dẫn để chạy trên GitHub Pages, mô phỏng đường dẫn con.
Tự kiểm thử: jsdom, Playwright 3 trang x 4 mốc x 2 chế độ, tương phản, audit CSS, html-validate, Lighthouse, mô phỏng Pages. Commit tách module, không git add .

### Kết quả mong đợi
Giao diện sáng/tối hoạt động và nhớ lựa chọn, dashboard khớp dữ liệu, tài liệu đầy đủ, sẵn sàng Pull Request rồi bật GitHub Pages.

## Prompt #15 | Sprint 3: Review Dark Mode, dashboard, README
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint3-darkmode-dashboard

### Bối cảnh
Z hoàn thành Dark Mode (data-theme, theme.js), dashboard dùng dữ liệu thật, 4 hàm thuần mới, README. Lighthouse Performance tụt (68/59/81), chưa commit.

### Yêu cầu gửi Claude
Review báo cáo, chỉ ra vấn đề trước khi commit.

### Kết quả
- Cần: tìm nguyên nhân Performance tụt, chuyển dữ liệu hợp đồng sang bản ghi viết tay, đồng bộ chonTheme/chonGiaoDien, sửa nhãn biểu đồ, kiểm git status, rồi commit, push, Pull Request, bật GitHub Pages.

## Prompt #16 | Sprint 3: Review hotfix hiệu năng và dữ liệu hợp đồng
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint3-darkmode-dashboard

### Bối cảnh
Z đã đổi hợp đồng sang bản ghi viết tay (thêm HD0017, HD0018), đồng bộ comment theme, sửa nhãn biểu đồ. Lighthouse 3 lần bị treo nên chưa có nguyên nhân Performance 59. Báo cáo không in lại MISMATCHES.

### Yêu cầu
Review và soạn prompt hotfix: kiểm tra mâu thuẫn hợp đồng/TrangThai, chạy Lighthouse bằng một server, tách biến cho nhan-vien.html.

### Kết quả
- Chưa commit cho tới khi MISMATCHES rỗng và có số đo hiệu năng.
- Sau đó: commit từng file, push, Pull Request, bật GitHub Pages.

## Prompt #17 | Sprint 3: Review hotfix cuối (hợp đồng, Lighthouse), chuẩn bị merge
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint3-darkmode-dashboard

### Bối cảnh
Z đã sửa dữ liệu hợp đồng (kết thúc hợp đồng cũ NV0005/NV0010 trước hợp đồng mới), MISMATCHES [] và ACTIVE_DUPLICATES [] , chạy Lighthouse 3 lần x 3 trang bằng một server: median Performance 84/84/97, CLS 0.313 ổn định. Thí nghiệm tách biến không chạy được (exit code 127).

### Yêu cầu gửi Claude
Review báo cáo, kết luận mức sẵn sàng commit và merge, nêu việc còn lại.

### Kết quả
- Sẵn sàng commit 4 module, push, Pull Request, bật GitHub Pages.
- Ghi nhận: CLS 0.313 cần sửa nhỏ sau; dữ liệu hợp đồng mẫu vẫn sinh theo công thức.
- Việc còn: W3C chính thức, điện thoại thật, README, định dạng mã MaLuongNhanVien, slide và luyện pitching cho báo cáo 06/11/2026.

## Prompt #18 | Sprint 3: Kiểm tra git status trước khi push
- Ngày: 18/10/2026
- Công cụ: Claude (Technical Lead)
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint3-darkmode-dashboard

### Bối cảnh
git status: không còn file sửa chưa commit; nhánh local ahead origin 1 commit; hai file db/02c_DuLieuLuong.sql, db/02d_KiemThuLuong.sql untracked (việc của AI Database).

### Yêu cầu
Xác nhận trạng thái, hướng dẫn kiểm tra commit chưa push, xử lý file db/ untracked, push, mở Pull Request, merge và bật GitHub Pages.

### Kết quả
- Kiểm tra bằng git log origin..HEAD --stat rồi git push.
- Không add db/ vào nhánh Front-end; mở 02c_DuLieuLuong.sql để đối chiếu định dạng MaLuongNhanVien.
- Sau merge: bật Pages và kiểm tra link live.

## Prompt #19 | Sprint 3: Phát hiện chạy lệnh git sai thư mục
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
Sinh viên chạy git log ở thư mục Exam\HRM-DB\db (nhánh db) thay vì Exam\Final (nhánh feature/sprint3-darkmode-dashboard). Log cho thấy AI Database đã commit và push 02c_DuLieuLuong.sql, 02d_KiemThuLuong.sql cùng bảng BangLuong, 2 view, thủ tục.

### Yêu cầu
Chỉ ra sai thư mục, hướng dẫn quay lại đúng nhánh Front-end, đối chiếu MaLuongNhanVien và công thức lương với SQL.

### Kết quả
- Chạy lại git log trong thư mục Final, push, mở Pull Request về main.
- Đối chiếu định dạng MaLuongNhanVien và công thức tính lương giữa Front-end và db/05_ThuTucHam.sql.

## Prompt #20 | Chuyển thư mục làm việc chính sang HRM-DB (bản clone)
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
Sinh viên đã git clone dự án về thư mục Exam\HRM-DB và dùng làm thư mục chính, thay cho Exam\Final. Final có thể còn 1 commit chưa push; HRM-DB đang ở nhánh db.

### Yêu cầu
Hướng dẫn kiểm tra và push commit còn lại ở Final, xác định Sprint 3 đã merge vào main chưa, đưa HRM-DB về main, tách thư mục cho AI Front-end và AI Database bằng git worktree, và nêu các việc Front-end tiếp theo.

### Kết quả
- Push từ Final trước khi bỏ; fetch, checkout main, pull trong HRM-DB; worktree HRM-DB-db cho nhánh db.
- Việc tiếp: đồng bộ MaLuongNhanVien, đối chiếu công thức lương với db/05_ThuTucHam.sql, sửa CLS.

## Prompt #21 | Phát hiện commit [Database] lạc nhánh Front-end, xác nhận Sprint 3 chưa merge
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)
- Repo: dncg2007/web-qlns-tl

### Bối cảnh
Thư mục Final: nhánh feature/sprint3-darkmode-dashboard ahead origin 1 commit (bf631d9, [Database], của AI Database). HRM-DB: origin/main mới có PR #3 (Sprint 2), chưa có Sprint 3.

### Yêu cầu
Xác định commit lạc nhánh, tránh push nhầm, xác minh nhánh Sprint 3 trên remote, đưa Sprint 3 vào main, tách thư mục hai AI bằng git worktree.

### Kết quả
- Không push từ Final; kiểm tra bf631d9 trên origin/db, nếu thiếu thì chuyển bằng git format-patch/git am.
- Kiểm tra git log origin/main..origin/feature/sprint3-darkmode-dashboard rồi mở PR, merge.
- Sau merge: checkout main, pull, worktree HRM-DB-db cho nhánh db.

## Prompt #22 | Làm rõ thư mục db/ và nhánh db trong repo HRM-DB
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Sinh viên cho rằng phần db đã có thư mục riêng trong HRM-DB nên không cần tách thêm. Thực tế db/ là thư mục con của cùng repo, còn nhánh db và nhánh Front-end vẫn dùng chung một working tree.

### Kết quả
- Phân biệt thư mục db/ và nhánh db.
- Quy tắc: mỗi lần một AI, phân quyền git add theo đường dẫn, không dùng git add .
- Việc tiếp: kiểm tra origin/db, nhánh Sprint 3 trên remote, rồi merge Sprint 3.

## Prompt #23 | Xác nhận cấu trúc thư mục HRM-DB từ ảnh chụp
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Sinh viên gửi ảnh thư mục HRM-DB: có assets, css, db, docs, js, 3 file HTML, README.md, prompt_log.md, .gitignore. Thư mục db có ngày sửa cũ hơn (9:26 SA) so với phần còn lại (12:11 SA).

### Yêu cầu
Xác nhận HRM-DB là bản clone đầy đủ, kiểm tra nhánh hiện tại, sự hiện diện của js/theme.js, và trạng thái nhánh Sprint 3 và origin/db.

### Kết quả
- Chạy 5 lệnh git (nhánh, status, theme.js, nhánh Sprint 3 so với main, origin/db) rồi gửi kết quả.
- Không xóa Final, không push từ Final, không git add db/ khi làm Front-end.

## Prompt #24 | Xác nhận nhánh Sprint 3 trên remote sạch, kế hoạch merge
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Kết quả git: HRM-DB đang ở nhánh db; origin/feature/sprint3-darkmode-dashboard có đúng 4 commit Front-end (26cd38d, 78a6ab8, 900d64c, 3d41354); bf631d9 chưa có trên origin/db; hai file db/06_Trigger.sql, db/06b_KiemThuTrigger.sql untracked.

### Kết quả
- Mở PR Sprint 3 về main, kiểm tra Files changed không có db/, merge.
- AI Database commit file trigger trước khi chuyển nhánh; chuyển bf631d9 bằng format-patch/am.
- Sau merge: checkout main, pull, Test-Path js\theme.js, bật GitHub Pages.

## Prompt #25 | Sprint 3 đã merge, git pull ở Final bị chặn bởi file untracked
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
origin/main lên f74dcd4 (Sprint 3 đã merge). Ở thư mục Final, git pull báo file untracked db/02c_DuLieuLuong.sql và db/02d_KiemThuLuong.sql sẽ bị ghi đè; pull abort, chưa mất gì. HRM-DB là thư mục chính.

### Kết quả
- Không sửa Final; giữ làm dự phòng; cứu bf631d9 bằng git format-patch.
- Ở HRM-DB: AI Database commit file trigger, rồi checkout main, pull, Test-Path js\theme.js.
- Bật GitHub Pages, kiểm tra link live, rồi Sprint 4 (đối chiếu MaLuongNhanVien và công thức lương với db/02c, db/05; sửa CLS; slide pitching).

## Prompt #26 | Sprint 4: Đồng bộ Front-end với CSDL thật, sửa CLS, chuẩn bị báo cáo
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead) viết prompt, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint4-dong-bo-csdl (tách từ main sau khi merge Sprint 3)

### Bối cảnh
Sprint 1-3 đã merge. AI Database đã có MucLuong, LuongNhanVien, ChamCong, BangLuong, view, hàm, thủ tục, trigger. Front-end cần khớp công thức lương và định dạng mã với SQL. CLS đang 0.313. Báo cáo cuối kỳ 06/11/2026.

### Yêu cầu
1. Đọc db/ (chỉ đọc), lập bảng đối chiếu, trích công thức lương SQL, so sánh với tinhLuong, đối chiếu số liệu 5+ nhân viên.
2. Đồng bộ data.js và logic.js theo SQL, dữ liệu viết tay.
3. Đo và sửa CLS, có số đo trước/sau.
4. Viết docs/doi-chieu-csdl.md và cập nhật README.
Tự kiểm thử: jsdom, Playwright 3 trang x 4 mốc x 2 chế độ, Lighthouse 3 lần median, html-validate, audit CSS, mô phỏng Pages. Commit tách module, không git add .

### Kết quả mong đợi
Số lương khớp SQL, CLS <= 0.1, tài liệu đối chiếu làm bằng chứng, sẵn sàng Pull Request.

## Prompt #27 | Xác minh Front-end đã đồng bộ với db/ chưa
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Báo cáo Sprint 4 của Z ghi branch main, đo ở thư mục Final, không tìm thấy 01b/01c/02e/04/05. Sinh viên hỏi Front-end đã kết nối với db/ chưa.

### Kết quả
- Front-end không kết nối runtime với SQL Server; chỉ sao chép dữ liệu vào data.js.
- Z làm nhầm thư mục Final (thiếu Sprint 3 và file db/ mới); kết quả công thức lương không đáng tin.
- Việc tiếp: lưu patch từ Final, AI Database merge db vào main, tạo nhánh Sprint 4 trong HRM-DB, chạy lại prompt #26 kèm cảnh báo, tự đối chiếu 39 dòng chấm công và 3 kết quả lương với SQL.

## Prompt #28 | Có nên dùng SQL trong db/ làm nguồn dữ liệu cho Front-end
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Sinh viên hỏi vì sao không dùng thẳng SQL trong db/ để Front-end và CSDL phát triển song song.

### Kết quả
- Gọi thẳng SQL Server từ trình duyệt không khả thi (cần API, ngoài đề cương, GitHub Pages chỉ tĩnh).
- Chọn hướng: SQL là nguồn sự thật, xuất JSON bằng FOR JSON PATH, đóng gói thành js/data.js, kể cả bảng lương tính bởi SQL.
- Việc tiếp: merge db vào main, AI Database viết db/07_XuatJSON.sql, Z đổi sang dùng dữ liệu xuất và đối chiếu.

## Prompt #29 | Cân nhắc dùng XAMPP để kết nối Front-end với CSDL
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Sinh viên đề xuất dùng XAMPP thay vì API riêng để Front-end dùng trực tiếp CSDL.

### Kết quả
- XAMPP dùng MariaDB/MySQL và PHP; SQL Server T-SQL hiện có không chạy trên đó, phải viết lại hoặc cài driver sqlsrv.
- PHP không chạy trên GitHub Pages và nằm ngoài đề cương Thiết kế Web.
- Giữ hướng: SQL là nguồn sự thật, xuất JSON (FOR JSON PATH) thành js/data.js; khi demo đối chiếu số liệu với SSMS.

## Prompt #30 | Chốt hướng trang tĩnh, SQL xuất JSON thành data.js
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Quyết định
Giữ trang tĩnh (chạy trên GitHub Pages). SQL Server là nguồn sự thật; AI Database viết db/07_XuatJSON.sql (FOR JSON PATH) và script sinh js/data.js, gồm BANG_LUONG_SQL. AI Z chỉ đối chiếu, không sửa db/ hay gõ tay data.js.

### Việc tiếp
Dọn nền (patch Final, cứu bf631d9, merge db vào main), AI Database xuất dữ liệu, AI Z chạy Sprint 4 đối chiếu, kiểm tra tay 3 nhân viên với SSMS, bật Pages, slide.

## Prompt #31 | Xác định vị trí hiện tại và lộ trình tiếp theo
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Báo cáo Sprint 4 gửi lại trùng với bản cũ của Z (thư mục Final, branch main, thiếu file db/ mới). Chưa có kết quả mới.

### Kết quả
- Không dùng, không commit bản cũ.
- Thứ tự: cất patch từ Final, cứu bf631d9, AI Database merge db vào main, HRM-DB về main, AI Database xuất data.js từ SQL, Z chạy lại Sprint 4 trong HRM-DB.
- Song song: bật Pages, W3C, README, slide.

## Prompt #32 | HRM-DB đã về main đủ Sprint 3 và db/
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Kết quả
- Đã cất patch từ Final và bf631d9; HRM-DB ở main, theme.js và 05_ThuTucHam.sql đều có.
- File db/06_*.sql vẫn untracked (việc của AI Database), không add.
- Tiếp: AI Database commit 06, xử lý patch bf631d9, viết 07_XuatJSON.sql và tools/xuat-data.ps1; bạn bật Pages, W3C, điền README, làm slide; sau đó tạo nhánh Sprint 4 và chạy lại prompt #26.

## Prompt #33 | Prompt tiếp theo sau khi push
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Kết quả
- Kiểm tra origin/main có db/07_XuatJSON.sql và tools/xuat-data.ps1 chưa.
- Chưa có: gửi Prompt A cho AI Database (xuất FOR JSON PATH, sinh data.js gồm BANG_LUONG_SQL).
- Đã có: tạo nhánh feature/sprint4-dong-bo-csdl, gửi Prompt B cho AI Z (đối chiếu taoBangLuong với BANG_LUONG_SQL, không sửa tay data.js, không sửa db/).

## Prompt #34 | Z vẫn làm nhầm thư mục Final
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead)

### Bối cảnh
Z báo branch main nền Sprint 2, thiếu hopDongSapHetHan và 05_ThuTucHam.sql, trong khi HRM-DB main đã có theme.js và 05_ThuTucHam.sql.

### Kết quả
- Mở Z trong workspace HRM-DB, xác nhận bằng 4 lệnh, tạo nhánh feature/sprint4-dong-bo-csdl.
- Chạy prompt #26 với cảnh báo bỏ kết quả cũ; không áp patch từ Final; không add db/.

## Prompt #35 | Sprint 5: Định hướng thiết kế lại giao diện (Calm Enterprise)
- Ngày: 19/10/2026
- Công cụ: Claude (Technical Lead) viết prompt, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint5-ui-redesign (tách từ main sau Sprint 4)

### Bối cảnh
Sinh viên gửi ảnh dashboard và trang nhân viên trên GitHub Pages, yêu cầu thiết kế giao diện hoàn chỉnh, đẹp, chuẩn xu hướng, bám kiến thức đã học. Lỗi nhìn thấy: số tiền KPI bị ngắt dòng, tiêu đề "Chỉ số chính" chiếm cột riêng, bảng nhân viên bị cắt chữ, topbar lộn xộn, sidebar không icon, tiêu đề biểu đồ lặp.

### Yêu cầu
Hướng thiết kế "Calm Enterprise": khung ứng dụng Grid (sidebar, topbar, main), icon SVG inline, thẻ KPI, bảng thead dính, hồ sơ nhanh dính từ 1280px, dark mode có bề mặt nổi, Mobile First 768/1024, hiệu ứng transform/opacity, không thêm thư viện hay font ngoài. Chỉ đổi giao diện, giữ id, dữ liệu, hàm. Kiểm thử Playwright nhiều mốc, Lighthouse, W3C, Pages. Commit tách module, không git add .

### Kết quả mong đợi
Giao diện admin hiện đại, đọc rõ ở 375 đến 1920px, sáng và tối, không chữ bị cắt, không tràn ngang, Lighthouse Performance >= 80 và CLS <= 0.1.

## Prompt #36 | Đề xuất mở rộng chức năng: Nhân viên, Phòng ban, Chức vụ, Chấm công, Dashboard
- Ngày: 20/10/2026
- Công cụ: Claude (Technical Lead) đề xuất, AI Z thực thi
- Repo: dncg2007/web-qlns-tl, nhánh feature/sprint6a-quan-ly

### Bối cảnh
Sinh viên muốn phát triển thêm Quản lý nhân viên, Phòng ban, Chức vụ, Chấm công, biểu đồ Dashboard, chấp nhận vượt phạm vi đã học để có báo cáo hoàn chỉnh. Ảnh giao diện cho thấy 3 lỗi: cột ảnh bị bóp, logo lặp, caption bảng thành tiêu đề.

### Quyết định
- Giữ web tĩnh; thêm kho-du-lieu.js lưu localStorage, có nút khôi phục dữ liệu mẫu.
- Sprint 6A: sửa/nghỉ việc nhân viên, CRUD phòng ban và chức vụ. Sprint 6B: chấm công, biểu đồ SVG, xuất CSV, in phiếu lương. Đóng băng tính năng 02/11.
- Nghỉ việc = đặt HopDongLaoDong.DenNgay, giữ khớp view v_NhanVien_TrangThai.
- Data Contract v1.2 đề xuất (ChucVu) chờ AI Database xác nhận.

### Kết quả mong đợi
Hệ thống HRM đủ module, dữ liệu sống qua F5, không phá test Sprint 1-5, Lighthouse Performance >= 80, sẵn sàng demo 06/11/2026.

## Prompt #37 | Review báo cáo Sprint 6A (chưa hoàn tất)
- Ngày: 20/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi

### Bối cảnh
Z làm đúng thư mục HRM-DB nhưng tạo nhánh feature/sprint6a-quan-ly từ nhánh Sprint 5 đang có thay đổi chưa commit. Đã có kho-du-lieu.js, 2 trang mới, hàm thuần, CSS dialog; chưa có dialog, CRUD thật, khôi phục mẫu, Playwright. Đã đổi mô hình hai lần giữa phiên.

### Kết quả
- Không commit. Cất patch và file mới.
- Hoàn tất Sprint 4, 5 và merge trước; nhánh 6A tách từ main.
- Chia prompt 6A thành 3 phần nhỏ, mỗi phần một commit.

## Prompt #38 | Review báo cáo Sprint 6A (lần 2)
- Ngày: 21/10/2026
- Công cụ: Claude (Technical Lead) review, AI Z thực thi

### Bối cảnh
Z báo đã hoàn tất redesign và CRUD phòng ban, chức vụ, sửa và nghỉ việc nhân viên, khôi phục dữ liệu. Test: html-validate 0 lỗi, logic 33/33, jsdom 45/45. Lệnh commit gộp một lần, thông điệp sai định dạng, trạng thái git có MM/AM.

### Kết quả
- Chưa commit: kiểm git status, thử tay trên trình duyệt, gửi ảnh 5 trang.
- Tách 3 commit theo module; nếu Sprint 4, 5 chưa merge thì một Pull Request ghi rõ nội dung.
- Z chạy Playwright, luồng thật và Lighthouse; không thêm tính năng.

**Bổ Sung Phần 2 - Prompt Log**
### Prompt 01 — Lập plan các chức năng nhân sự mở rộng (Sprint planning)

[Bối cảnh]
Dự án "Website Quản lý Nhân sự & Tiền lương (HRM & Payroll)" — HTML/CSS/JS thuần, repo dncg2007/web-qlns-tl. Phần SQL Server do AI khác đảm nhiệm; phía Front-end chỉ định nghĩa Data Contract (JSON) khớp các bảng NhanVien, PhongBan, MucLuong, HopDongLaoDong.

[Yêu cầu]
Lập plan phát triển các chức năng:
1. Chấm công.
2. Chi tiết nhân viên: trình độ, chuyên môn, bằng cấp.
3. Làm lại (rebuild) phần Thêm nhân viên.
4. Khen thưởng & Kỷ luật.
5. Quản lý hợp đồng.
6. Tuyển chọn và sàng lọc.

[Định dạng đầu ra]
- Plan chi tiết từng module + lộ trình Agile (Sprint) + User Stories.
- Data Contract JSON chung cho cả dự án.
- Prompt hoàn chỉnh cho AI Z (Sprint 1) kèm Changelog, khối lệnh git add/commit, báo cáo mã nguồn.
- Giải thích ngắn + Prompt Log.

### Prompt 02 — Xác nhận Bước 0 và chốt Data Contract v2.0 (Sprint 1/3)

[Bối cảnh]
AI Z đã khảo sát repo web-qlns-tl (cấu trúc phẳng ở thư mục gốc, có kho-du-lieu.js, theme.js, db/01-06) nhưng do prompt trước chưa dán Data Contract nên đã tự tổng hợp một bản lệch tên thuộc tính/enum.

[Yêu cầu]
- Chốt Data Contract v2.0 chính thức, sửa các điểm lệch (nghiViec, khóa trình độ, maBC, xepLoai, THAM_SO, bỏ ngày hiện tại hard-code, không trỏ ảnh không tồn tại).
- Giữ cấu trúc phẳng, tái sử dụng kho-du-lieu.js, theme.js, token CSS hiện có.
- Migrate các trang đang dùng schema cũ, thêm khóa schemaVersion cho localStorage.
- Đối chiếu db/01-06 với contract (chỉ báo cáo).

[Định dạng đầu ra]
Thực hiện Phase P1 rồi dừng; xuất CHANGELOG, bảng migrate, bảng chênh lệch CSDL, báo cáo mã nguồn, khối lệnh git add/commit/push (nhánh feature/nhan-vien-ho-so).

### Prompt 03 — Chốt Data Contract v2.0 (nhúng sẵn) và bắt đầu Phase P1 (Sprint 1/3)

[Bối cảnh]
AI Z đã khảo sát repo và từ chối tự đặt schema vì placeholder Data Contract bị bỏ trống 2 lần. Repo hiện có CHAM_CONG tổng hợp tháng (bang-luong.html), CHUC_VU, PHONG_BAN (maTruongPhong, moTa) và SQL ràng buộc giới tính 2 giá trị.

[Yêu cầu]
- Dùng Data Contract v2.0 nhúng sẵn trong prompt (thay mọi bản tự tổng hợp).
- Giữ CHAM_CONG tổng hợp tháng (chỉ đổi camelCase), thêm CHAM_CONG_NGAY làm khung Sprint 2; thêm CHUC_VU; gioiTinh 3 giá trị.
- Phase P1: viết lại data.js, migrate toàn bộ file dùng schema cũ (kể cả enum), schemaVersion "2.0" cho localStorage, bổ sung token CSS thiếu, cập nhật bảng chênh lệch CSDL.
- Không đưa ngày hiện tại vào data.js; không trỏ ảnh không tồn tại.

[Định dạng đầu ra]
CHANGELOG, bảng migrate đã áp dụng, bảng chênh lệch CSDL, báo cáo mã nguồn, checklist DoD, khối lệnh git (nhánh feature/nhan-vien-ho-so, commit "[Refactor]: ..."); dừng sau P1 chờ xác nhận.

### Prompt 04 — Duyệt có điều kiện P1; sửa P1.1 (dữ liệu mẫu) và làm P2 (logic.js thuần)

[Bối cảnh]
AI Z hoàn thành P1 (Data Contract v2.0, migrate 5 trang, kho-du-lieu schema 2.0). Review phát hiện: HOP_DONG/LUONG sinh bằng map(), hợp đồng thử việc NV0005 vượt giới hạn, hợp đồng chồng lấn (NV0005, NV0010), ngày bắt đầu không khớp ngayVaoLam, CAU_HINH hard-code ngày 18/10 và mâu thuẫn THAM_SO, còn fallback PascalCase, báo cáo thiếu logic.js/features.js, kiểm tra bằng html-validate thay vì W3C.

[Yêu cầu]
- P1.1: viết lại dữ liệu hợp đồng/lương dạng literal theo quy tắc R1-R8; Contract v2.0.1 (ngayCongChuan vào THAM_SO, bỏ CAU_HINH, maTruongPhong = null); layNgayHomNay() giờ địa phương + ?ngay= để demo; gỡ fallback v1.1; báo cáo bổ sung (diff logic.js/features.js, số liệu trước migrate, .gitignore); kiểm tra W3C validator.
- P2: các hàm thuần trong logic.js (tinhTuoi, tinhThamNien, kiemTraNhanVien, locNhanVien, thống kê, kiemTraToanVenDuLieu...) + chayKiemThu() với ca biên; refactor tại chỗ, chạy lại hồi quy index/bang-luong.

[Định dạng đầu ra]
CHANGELOG, báo cáo mã nguồn đầy đủ, checklist DoD, explain-back từng hàm, khối lệnh git (git status trước khi add; commit "[Fix]"/"[Feat]"); dừng sau P2 chờ xác nhận.

### Prompt 05 — Duyệt có điều kiện P1.1/P2; sửa P1.2 và nộp bằng chứng thô (Sprint 1/3)

[Bối cảnh]
AI Z báo hoàn thành P1.1 và P2 nhưng: dòng lương hiện hành của NV0003 bị đổi ML03 → ML02 làm quỹ lương lệch khỏi mốc 276.519.231 (tính tay ≈ 269.134.615) trong khi báo cáo ghi "khớp 100%"; schemaVersion vẫn "2.0" dù dữ liệu mẫu đã đổi (localStorage cũ không được làm sạch); báo cáo thiếu code logic.js/features.js, CHANGELOG, khối lệnh Terminal và output thô của kiểm thử; dữ liệu mẫu có ngày hết hạn sớm (HD0005) và mốc thời gian vô lý (kỷ luật trước ngày vào làm, điểm phỏng vấn ở tương lai).

[Yêu cầu]
- P1.2: sửa dữ liệu mẫu theo danh sách cụ thể (khôi phục NV0003 = ML03, dời ngày vào làm/hợp đồng NV0005 để còn hiệu lực đến Demo Day, sửa KL-2026-001 và UV0003, thêm chứng chỉ đã hết hạn), thêm DATA_VERSION = "2.0.1" và để kho-du-lieu.js dùng nó; xóa ký tự thừa cuối data.js; thêm mục "Hạn chế đã biết" vào README.
- Chạy thật và dán nguyên output: mốc lương, chayKiemThu(), kiemTraToanVenDuLieu tại 3 ngày (23/10 và 06/11 kỳ vọng [], 20/11 kỳ vọng đúng 2 vi phạm R6), W3C, console/request profile sạch, git log/status/diff.
- Soát logic: so sánh ngưỡng lương thử việc bằng số nguyên, nêu quy ước đếm ngày, in layNgayHomNay().
- Nộp đầy đủ CHANGELOG, mã nguồn logic.js/features.js, khối lệnh git; dừng, không sang P3.

[Định dạng đầu ra]
Báo cáo gồm: output thô từng kiểm tra, code đầy đủ phần đã sửa, CHANGELOG, khối lệnh Terminal (commit "[Fix]: ..." trên nhánh feature/nhan-vien-ho-so); dừng chờ xác nhận.
###Continute ...
