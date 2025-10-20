using Microsoft.EntityFrameworkCore;
using UngDungDiemDanhNhanVien.Data;
using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public class DiemDanhService : IDiemDanhService
    {
        private readonly UngDungDiemDanhContext _context;

        public DiemDanhService(UngDungDiemDanhContext context)
        {
            _context = context;
        }

        public async Task<DiemDanhResponse> DiemDanhVao(DiemDanhVaoRequest request)
        {
            try
            {
                // Tìm nhân viên theo mã
                var nhanVien = await _context.NhanVien
                    .FirstOrDefaultAsync(n => n.MaNhanVien == request.MaNhanVien);

                if (nhanVien == null)
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không tìm thấy nhân viên với mã: " + request.MaNhanVien
                    };
                }

                if (nhanVien.TrangThai != "HoatDong")
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Tài khoản nhân viên đã bị khóa"
                    };
                }

                var ngayHienTai = DateTime.Now.Date;

                // Kiểm tra xem đã điểm danh vào chưa
                var diemDanhHienTai = await _context.DiemDanh
                    .FirstOrDefaultAsync(d => d.NhanVienId == nhanVien.Id && d.Ngay == ngayHienTai);

                if (diemDanhHienTai != null && diemDanhHienTai.GioVao.HasValue)
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Bạn đã điểm danh vào lúc: " + diemDanhHienTai.GioVao.Value.ToString("HH:mm")
                    };
                }

                // Tạo hoặc cập nhật bản ghi điểm danh
                if (diemDanhHienTai == null)
                {
                    diemDanhHienTai = new DiemDanh
                    {
                        NhanVienId = nhanVien.Id,
                        Ngay = ngayHienTai,
                        TrangThai = "DangLam"
                    };
                    _context.DiemDanh.Add(diemDanhHienTai);
                }

                diemDanhHienTai.GioVao = DateTime.Now;
                diemDanhHienTai.PhuongThucVao = request.PhuongThuc;
                diemDanhHienTai.ViDo = request.ViDo?.ToString();
                diemDanhHienTai.KinhDo = request.KinhDo?.ToString();
                diemDanhHienTai.GhiChu = request.GhiChu;

                await _context.SaveChangesAsync();

                return new DiemDanhResponse
                {
                    ThanhCong = true,
                    ThongBao = "Điểm danh vào thành công lúc: " + diemDanhHienTai.GioVao.Value.ToString("HH:mm"),
                    DiemDanh = await TaoDiemDanhDto(diemDanhHienTai)
                };
            }
            catch (Exception ex)
            {
                return new DiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi điểm danh: " + ex.Message
                };
            }
        }

        public async Task<DiemDanhResponse> DiemDanhRa(DiemDanhRaRequest request)
        {
            try
            {
                // Tìm nhân viên theo mã
                var nhanVien = await _context.NhanVien
                    .FirstOrDefaultAsync(n => n.MaNhanVien == request.MaNhanVien);

                if (nhanVien == null)
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không tìm thấy nhân viên với mã: " + request.MaNhanVien
                    };
                }

                var ngayHienTai = DateTime.Now.Date;

                // Tìm bản ghi điểm danh hôm nay
                var diemDanhHienTai = await _context.DiemDanh
                    .FirstOrDefaultAsync(d => d.NhanVienId == nhanVien.Id && d.Ngay == ngayHienTai);

                if (diemDanhHienTai == null || !diemDanhHienTai.GioVao.HasValue)
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Bạn chưa điểm danh vào hôm nay"
                    };
                }

                if (diemDanhHienTai.GioRa.HasValue)
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Bạn đã điểm danh ra lúc: " + diemDanhHienTai.GioRa.Value.ToString("HH:mm")
                    };
                }

                // Cập nhật giờ ra
                diemDanhHienTai.GioRa = DateTime.Now;
                diemDanhHienTai.PhuongThucRa = request.PhuongThuc;
                diemDanhHienTai.ViDo = request.ViDo?.ToString();
                diemDanhHienTai.KinhDo = request.KinhDo?.ToString();
                diemDanhHienTai.TrangThai = "DaVe";

                // Tính tổng giờ làm (không lưu vào database, chỉ tính toán khi cần)

                await _context.SaveChangesAsync();

                // Tính tổng giờ làm để hiển thị
                var tongGioLam = (decimal)(diemDanhHienTai.GioRa.Value - diemDanhHienTai.GioVao.Value).TotalHours;
                
                return new DiemDanhResponse
                {
                    ThanhCong = true,
                    ThongBao = $"Điểm danh ra thành công lúc: {diemDanhHienTai.GioRa.Value.ToString("HH:mm")}. Tổng giờ làm: {Math.Round(tongGioLam, 2)} giờ",
                    DiemDanh = await TaoDiemDanhDto(diemDanhHienTai)
                };
            }
            catch (Exception ex)
            {
                return new DiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi điểm danh ra: " + ex.Message
                };
            }
        }

        public async Task<DiemDanhResponse> DiemDanhThuCong(DiemDanhThuCongRequest request, int quanTriVienId)
        {
            try
            {
                // Tìm nhân viên theo mã
                var nhanVien = await _context.NhanVien
                    .FirstOrDefaultAsync(n => n.MaNhanVien == request.MaNhanVien);

                if (nhanVien == null)
                {
                    return new DiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không tìm thấy nhân viên với mã: " + request.MaNhanVien
                    };
                }

                var ngayDiemDanh = request.GioVao.Date;

                // Kiểm tra xem đã có bản ghi điểm danh chưa
                var diemDanhHienTai = await _context.DiemDanh
                    .FirstOrDefaultAsync(d => d.NhanVienId == nhanVien.Id && d.Ngay == ngayDiemDanh);

                if (diemDanhHienTai != null)
                {
                    // Cập nhật bản ghi hiện tại
                    diemDanhHienTai.GioVao = request.GioVao;
                    diemDanhHienTai.GioRa = request.GioRa;
                    diemDanhHienTai.PhuongThucVao = "ThuCong";
                    diemDanhHienTai.PhuongThucRa = request.GioRa.HasValue ? "ThuCong" : null;
                    diemDanhHienTai.ViDo = request.ViDo?.ToString();
                    diemDanhHienTai.KinhDo = request.KinhDo?.ToString();
                    diemDanhHienTai.GhiChu = request.GhiChu;
                    diemDanhHienTai.QuanTriVienId = quanTriVienId;

                    if (request.GioRa.HasValue)
                    {
                        diemDanhHienTai.TrangThai = "DaVe";
                    }
                    else
                    {
                        diemDanhHienTai.TrangThai = "DangLam";
                    }
                }
                else
                {
                    // Tạo bản ghi mới
                    diemDanhHienTai = new DiemDanh
                    {
                        NhanVienId = nhanVien.Id,
                        Ngay = ngayDiemDanh,
                        GioVao = request.GioVao,
                        GioRa = request.GioRa,
                        PhuongThucVao = "ThuCong",
                        PhuongThucRa = request.GioRa.HasValue ? "ThuCong" : null,
                        ViDo = request.ViDo?.ToString(),
                        KinhDo = request.KinhDo?.ToString(),
                        GhiChu = request.GhiChu,
                        QuanTriVienId = quanTriVienId,
                        TrangThai = request.GioRa.HasValue ? "DaVe" : "DangLam"
                    };

                    _context.DiemDanh.Add(diemDanhHienTai);
                }

                await _context.SaveChangesAsync();

                return new DiemDanhResponse
                {
                    ThanhCong = true,
                    ThongBao = "Chấm công thủ công thành công",
                    DiemDanh = await TaoDiemDanhDto(diemDanhHienTai)
                };
            }
            catch (Exception ex)
            {
                return new DiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi chấm công thủ công: " + ex.Message
                };
            }
        }

        public async Task<LichSuDiemDanhResponse> LayLichSuDiemDanh(int nhanVienId, DateTime? tuNgay = null, DateTime? denNgay = null)
        {
            try
            {
                var query = _context.DiemDanh
                    .Include(d => d.NhanVien)
                    .Include(d => d.QuanTriVien)
                    .Where(d => d.NhanVienId == nhanVienId);

                if (tuNgay.HasValue)
                    query = query.Where(d => d.Ngay >= tuNgay.Value);

                if (denNgay.HasValue)
                    query = query.Where(d => d.Ngay <= denNgay.Value);

                var danhSachDiemDanh = await query
                    .OrderByDescending(d => d.Ngay)
                    .ThenByDescending(d => d.GioVao)
                    .ToListAsync();

                var diemDanhDtos = new List<DiemDanhDto>();
                foreach (var dd in danhSachDiemDanh)
                {
                    diemDanhDtos.Add(await TaoDiemDanhDto(dd));
                }

                return new LichSuDiemDanhResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy lịch sử điểm danh thành công",
                    DanhSachDiemDanh = diemDanhDtos,
                    TongSoBanGhi = diemDanhDtos.Count
                };
            }
            catch (Exception ex)
            {
                return new LichSuDiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi lấy lịch sử điểm danh: " + ex.Message
                };
            }
        }

        public async Task<LichSuDiemDanhResponse> LayLichSuDiemDanhTheoMa(string maNhanVien, DateTime? tuNgay = null, DateTime? denNgay = null)
        {
            try
            {
                var nhanVien = await _context.NhanVien
                    .FirstOrDefaultAsync(n => n.MaNhanVien == maNhanVien);

                if (nhanVien == null)
                {
                    return new LichSuDiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không tìm thấy nhân viên với mã: " + maNhanVien
                    };
                }

                return await LayLichSuDiemDanh(nhanVien.Id, tuNgay, denNgay);
            }
            catch (Exception ex)
            {
                return new LichSuDiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi lấy lịch sử điểm danh: " + ex.Message
                };
            }
        }

        public async Task<DiemDanh?> LayDiemDanhHienTai(int nhanVienId)
        {
            var ngayHienTai = DateTime.Now.Date;
            return await _context.DiemDanh
                .Include(d => d.NhanVien)
                .Include(d => d.QuanTriVien)
                .FirstOrDefaultAsync(d => d.NhanVienId == nhanVienId && d.Ngay == ngayHienTai);
        }

        public async Task<DiemDanhDto?> LayDiemDanhHienTaiTheoMa(string maNhanVien)
        {
            var nhanVien = await _context.NhanVien
                .FirstOrDefaultAsync(n => n.MaNhanVien == maNhanVien);

            if (nhanVien == null) return null;

            var diemDanh = await LayDiemDanhHienTai(nhanVien.Id);
            return diemDanh != null ? await TaoDiemDanhDto(diemDanh) : null;
        }

        public async Task<DiemDanhDto?> LayDiemDanhHienTaiCaNhan(int nhanVienId)
        {
            var diemDanh = await LayDiemDanhHienTai(nhanVienId);
            return diemDanh != null ? await TaoDiemDanhDto(diemDanh) : null;
        }

        public async Task<AdminDashboardResponse> LayThongTinDashboardAdmin()
        {
            try
            {
                var ngayHienTai = DateTime.Now.Date;
                var dauTuan = ngayHienTai.AddDays(-(int)ngayHienTai.DayOfWeek);
                var cuoiTuan = dauTuan.AddDays(6);

                // Lấy tất cả nhân viên
                var tatCaNhanVien = await _context.NhanVien
                    .Where(n => n.TrangThai == "HoatDong")
                    .ToListAsync();

                // Lấy điểm danh hôm nay
                var diemDanhHomNay = await _context.DiemDanh
                    .Include(d => d.NhanVien)
                    .Where(d => d.Ngay == ngayHienTai)
                    .ToListAsync();

                // Lấy điểm danh 7 ngày gần nhất
                var diemDanh7Ngay = await _context.DiemDanh
                    .Include(d => d.NhanVien)
                    .Where(d => d.Ngay >= dauTuan && d.Ngay <= cuoiTuan)
                    .ToListAsync();

                // Tính thống kê tổng quan
                var tongNhanVien = tatCaNhanVien.Count;
                var nhanVienDangLamViec = diemDanhHomNay.Count(d => d.GioRa == null);
                var nhanVienNghi = diemDanhHomNay.Count(d => d.GioRa != null);
                var nhanVienChuaDiemDanh = tongNhanVien - diemDanhHomNay.Count;
                var tyLeChuyenCan = tongNhanVien > 0 ? (double)diemDanhHomNay.Count / tongNhanVien * 100 : 0;
                var gioLamTrungBinh = diemDanhHomNay.Any() ? 
                    diemDanhHomNay.Where(d => d.GioVao != null && d.GioRa != null)
                        .Average(d => (d.GioRa.Value - d.GioVao.Value).TotalHours) : 0;

                // Danh sách nhân viên đang làm việc
                var nhanVienDangLamViecList = diemDanhHomNay
                    .Where(d => d.GioRa == null)
                    .Select(d => new NhanVienDangLamViec
                    {
                        Id = d.NhanVienId,
                        MaNhanVien = d.NhanVien.MaNhanVien,
                        HoTen = d.NhanVien.HoTen,
                        PhongBan = d.NhanVien.PhongBan,
                        ChucVu = d.NhanVien.ChucVu,
                        GioVao = d.GioVao,
                        TrangThai = d.TrangThai,
                        SoGioLam = d.GioVao != null ? (DateTime.Now - d.GioVao.Value).TotalHours : 0
                    })
                    .ToList();

                // Danh sách nhân viên chưa điểm danh
                var nhanVienDaDiemDanhIds = diemDanhHomNay.Select(d => d.NhanVienId).ToList();
                var nhanVienChuaDiemDanhList = tatCaNhanVien
                    .Where(n => !nhanVienDaDiemDanhIds.Contains(n.Id))
                    .Select(n => new NhanVienChuaDiemDanh
                    {
                        Id = n.Id,
                        MaNhanVien = n.MaNhanVien,
                        HoTen = n.HoTen,
                        PhongBan = n.PhongBan,
                        ChucVu = n.ChucVu,
                        LyDo = "ChuaDiemDanh"
                    })
                    .ToList();

                // Thống kê theo ngày (7 ngày gần nhất)
                var thongKeTheoNgay = new List<ThongKeTheoNgay>();
                for (int i = 6; i >= 0; i--)
                {
                    var ngay = ngayHienTai.AddDays(-i);
                    var diemDanhNgay = diemDanh7Ngay.Where(d => d.Ngay == ngay).ToList();
                    
                    thongKeTheoNgay.Add(new ThongKeTheoNgay
                    {
                        Ngay = ngay,
                        SoNhanVienDiemDanh = diemDanhNgay.Count,
                        SoNhanVienDiMuon = diemDanhNgay.Count(d => d.GioVao?.Hour > 8), // Giả sử 8h là giờ bắt đầu
                        SoNhanVienVeSom = diemDanhNgay.Count(d => d.GioRa?.Hour < 17), // Giả sử 17h là giờ kết thúc
                        GioLamTrungBinh = diemDanhNgay.Any() ? 
                            diemDanhNgay.Where(d => d.GioVao != null && d.GioRa != null)
                                .Average(d => (d.GioRa.Value - d.GioVao.Value).TotalHours) : 0
                    });
                }

                return new AdminDashboardResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy thông tin dashboard thành công",
                    ThongKeTongQuan = new ThongKeTongQuan
                    {
                        TongNhanVien = tongNhanVien,
                        NhanVienDangLamViec = nhanVienDangLamViec,
                        NhanVienNghi = nhanVienNghi,
                        NhanVienChuaDiemDanh = nhanVienChuaDiemDanh,
                        TyLeChuyenCan = tyLeChuyenCan,
                        GioLamTrungBinh = gioLamTrungBinh
                    },
                    NhanVienDangLamViec = nhanVienDangLamViecList,
                    NhanVienChuaDiemDanh = nhanVienChuaDiemDanhList,
                    ThongKeTheoNgay = thongKeTheoNgay
                };
            }
            catch (Exception ex)
            {
                return new AdminDashboardResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi lấy thông tin dashboard: " + ex.Message
                };
            }
        }

        public async Task<bool> CapNhatDiemDanh(int id, DiemDanh diemDanh)
        {
            try
            {
                var diemDanhHienTai = await _context.DiemDanh.FindAsync(id);
                if (diemDanhHienTai == null) return false;

                diemDanhHienTai.GioVao = diemDanh.GioVao;
                diemDanhHienTai.GioRa = diemDanh.GioRa;
                diemDanhHienTai.PhuongThucVao = diemDanh.PhuongThucVao;
                diemDanhHienTai.PhuongThucRa = diemDanh.PhuongThucRa;
                diemDanhHienTai.ViDo = diemDanh.ViDo;
                diemDanhHienTai.KinhDo = diemDanh.KinhDo;
                diemDanhHienTai.GhiChu = diemDanh.GhiChu;
                diemDanhHienTai.TrangThai = diemDanh.TrangThai;

                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> XoaDiemDanh(int id)
        {
            try
            {
                var diemDanh = await _context.DiemDanh.FindAsync(id);
                if (diemDanh == null) return false;

                _context.DiemDanh.Remove(diemDanh);
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        private async Task<DiemDanhDto> TaoDiemDanhDto(DiemDanh diemDanh)
        {
            await _context.Entry(diemDanh)
                .Reference(d => d.NhanVien)
                .LoadAsync();

            // QuanTriVien có thể null nếu là điểm danh tự động
            if (diemDanh.QuanTriVienId.HasValue)
            {
                await _context.Entry(diemDanh)
                    .Reference(d => d.QuanTriVien)
                    .LoadAsync();
            }

            // Tính tổng giờ làm nếu có cả giờ vào và giờ ra
            decimal? tongGioLam = null;
            if (diemDanh.GioVao.HasValue && diemDanh.GioRa.HasValue)
            {
                tongGioLam = (decimal)(diemDanh.GioRa.Value - diemDanh.GioVao.Value).TotalHours;
            }

            return new DiemDanhDto
            {
                Id = diemDanh.Id,
                NhanVienId = diemDanh.NhanVienId,
                MaNhanVien = diemDanh.NhanVien.MaNhanVien,
                HoTen = diemDanh.NhanVien.HoTen,
                GioVao = diemDanh.GioVao,
                GioRa = diemDanh.GioRa,
                PhuongThucVao = diemDanh.PhuongThucVao,
                PhuongThucRa = diemDanh.PhuongThucRa,
                ViDo = decimal.TryParse(diemDanh.ViDo, out var viDo) ? viDo : null,
                KinhDo = decimal.TryParse(diemDanh.KinhDo, out var kinhDo) ? kinhDo : null,
                GhiChu = diemDanh.GhiChu,
                Ngay = diemDanh.Ngay,
                TongGioLam = tongGioLam,
                TrangThai = diemDanh.TrangThai,
                TenQuanTriVien = diemDanh.QuanTriVien?.Email
            };
        }

        public async Task<ThongKeDiemDanhResponse> LayThongKeDiemDanhTheoMa(string maNhanVien)
        {
            try
            {
                var nhanVien = await _context.NhanVien
                    .FirstOrDefaultAsync(n => n.MaNhanVien == maNhanVien);

                if (nhanVien == null)
                {
                    return new ThongKeDiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không tìm thấy nhân viên với mã: " + maNhanVien
                    };
                }

                return await LayThongKeDiemDanh(nhanVien.Id);
            }
            catch (Exception ex)
            {
                return new ThongKeDiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi lấy thống kê điểm danh: " + ex.Message
                };
            }
        }

        private async Task<ThongKeDiemDanhResponse> LayThongKeDiemDanh(int nhanVienId)
        {
            try
            {
                var ngayHienTai = DateTime.Now;
                var dauThang = new DateTime(ngayHienTai.Year, ngayHienTai.Month, 1);
                var cuoiThang = dauThang.AddMonths(1).AddDays(-1);
                
                var dauTuan = ngayHienTai.AddDays(-(int)ngayHienTai.DayOfWeek);
                var cuoiTuan = dauTuan.AddDays(6);

                // Thống kê tháng
                var diemDanhThang = await _context.DiemDanh
                    .Where(d => d.NhanVienId == nhanVienId && 
                               d.Ngay >= dauThang && 
                               d.Ngay <= cuoiThang &&
                               d.GioRa != null)
                    .ToListAsync();

                var ngayLamViecTrongThang = diemDanhThang.Count;
                var tongGioLamTrongThang = diemDanhThang.Sum(d => 
                    d.GioVao != null && d.GioRa != null ? 
                    (d.GioRa.Value - d.GioVao.Value).TotalHours : 0);
                var gioLamTrungBinh = ngayLamViecTrongThang > 0 ? tongGioLamTrongThang / ngayLamViecTrongThang : 0;

                // Thống kê tuần
                var diemDanhTuan = await _context.DiemDanh
                    .Where(d => d.NhanVienId == nhanVienId && 
                               d.Ngay >= dauTuan && 
                               d.Ngay <= cuoiTuan &&
                               d.GioRa != null)
                    .ToListAsync();

                var ngayLamViecTrongTuan = diemDanhTuan.Count;
                var tongGioLamTrongTuan = diemDanhTuan.Sum(d => 
                    d.GioVao != null && d.GioRa != null ? 
                    (d.GioRa.Value - d.GioVao.Value).TotalHours : 0);

                return new ThongKeDiemDanhResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy thống kê thành công",
                    NgayLamViecTrongThang = ngayLamViecTrongThang,
                    TongGioLamTrongThang = tongGioLamTrongThang,
                    GioLamTrungBinh = gioLamTrungBinh,
                    NgayLamViecTrongTuan = ngayLamViecTrongTuan,
                    TongGioLamTrongTuan = tongGioLamTrongTuan
                };
            }
            catch (Exception ex)
            {
                return new ThongKeDiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Lỗi khi tính toán thống kê: " + ex.Message
                };
            }
        }
    }
}