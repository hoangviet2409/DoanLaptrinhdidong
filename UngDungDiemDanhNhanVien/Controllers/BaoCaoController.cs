using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Services;

namespace UngDungDiemDanhNhanVien.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class BaoCaoController : ControllerBase
    {
        private readonly IBaoCaoService _baoCaoService;

        public BaoCaoController(IBaoCaoService baoCaoService)
        {
            _baoCaoService = baoCaoService;
        }

        /// <summary>
        /// Lấy báo cáo tuần
        /// </summary>
        [HttpGet("tuan")]
        public async Task<ActionResult<BaoCaoResponse>> LayBaoCaoTuan(
            [FromQuery] int? nhanVienId = null,
            [FromQuery] DateTime? ngayBatDau = null)
        {
            try
            {
                // Nếu không có ngày bắt đầu, lấy tuần hiện tại
                var ngayBatDauTuan = ngayBatDau ?? DateTime.Now.Date.AddDays(-(int)DateTime.Now.DayOfWeek);
                
                var diemDanh = await _baoCaoService.LayBaoCaoTuan(nhanVienId, ngayBatDauTuan);
                var thongKe = TinhThongKeBaoCao(diemDanh);

                return Ok(new BaoCaoResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy báo cáo tuần thành công",
                    DanhSachDiemDanh = diemDanh.Select(d => new DiemDanhDto
                    {
                        Id = d.Id,
                        NhanVienId = d.NhanVienId,
                        HoTen = d.NhanVien.HoTen,
                        MaNhanVien = d.NhanVien.MaNhanVien,
                        GioVao = d.GioVao,
                        GioRa = d.GioRa,
                        PhuongThucVao = d.PhuongThucVao,
                        PhuongThucRa = d.PhuongThucRa,
                        ViDo = !string.IsNullOrEmpty(d.ViDo) ? decimal.Parse(d.ViDo) : null,
                        KinhDo = !string.IsNullOrEmpty(d.KinhDo) ? decimal.Parse(d.KinhDo) : null,
                        GhiChu = d.GhiChu,
                        Ngay = d.Ngay,
                        TrangThai = d.TrangThai,
                        TongGioLam = d.GioVao.HasValue && d.GioRa.HasValue ? 
                            (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours : 0
                    }),
                    ThongKe = thongKe
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new BaoCaoResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy báo cáo tuần: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy báo cáo tháng
        /// </summary>
        [HttpGet("thang")]
        public async Task<ActionResult<BaoCaoResponse>> LayBaoCaoThang(
            [FromQuery] int? nhanVienId = null,
            [FromQuery] int? thang = null,
            [FromQuery] int? nam = null)
        {
            try
            {
                var thangHienTai = thang ?? DateTime.Now.Month;
                var namHienTai = nam ?? DateTime.Now.Year;

                var diemDanh = await _baoCaoService.LayBaoCaoThang(nhanVienId, thangHienTai, namHienTai);
                var thongKe = TinhThongKeBaoCao(diemDanh);

                return Ok(new BaoCaoResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy báo cáo tháng thành công",
                    DanhSachDiemDanh = diemDanh.Select(d => new DiemDanhDto
                    {
                        Id = d.Id,
                        NhanVienId = d.NhanVienId,
                        HoTen = d.NhanVien.HoTen,
                        MaNhanVien = d.NhanVien.MaNhanVien,
                        GioVao = d.GioVao,
                        GioRa = d.GioRa,
                        PhuongThucVao = d.PhuongThucVao,
                        PhuongThucRa = d.PhuongThucRa,
                        ViDo = !string.IsNullOrEmpty(d.ViDo) ? decimal.Parse(d.ViDo) : null,
                        KinhDo = !string.IsNullOrEmpty(d.KinhDo) ? decimal.Parse(d.KinhDo) : null,
                        GhiChu = d.GhiChu,
                        Ngay = d.Ngay,
                        TrangThai = d.TrangThai,
                        TongGioLam = d.GioVao.HasValue && d.GioRa.HasValue ? 
                            (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours : 0
                    }),
                    ThongKe = thongKe
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new BaoCaoResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy báo cáo tháng: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy báo cáo quý
        /// </summary>
        [HttpGet("quy")]
        public async Task<ActionResult<BaoCaoResponse>> LayBaoCaoQuy(
            [FromQuery] int? nhanVienId = null,
            [FromQuery] int? quy = null,
            [FromQuery] int? nam = null)
        {
            try
            {
                var quyHienTai = quy ?? ((DateTime.Now.Month - 1) / 3 + 1);
                var namHienTai = nam ?? DateTime.Now.Year;

                var diemDanh = await _baoCaoService.LayBaoCaoQuy(nhanVienId, quyHienTai, namHienTai);
                var thongKe = TinhThongKeBaoCao(diemDanh);

                return Ok(new BaoCaoResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy báo cáo quý thành công",
                    DanhSachDiemDanh = diemDanh.Select(d => new DiemDanhDto
                    {
                        Id = d.Id,
                        NhanVienId = d.NhanVienId,
                        HoTen = d.NhanVien.HoTen,
                        MaNhanVien = d.NhanVien.MaNhanVien,
                        GioVao = d.GioVao,
                        GioRa = d.GioRa,
                        PhuongThucVao = d.PhuongThucVao,
                        PhuongThucRa = d.PhuongThucRa,
                        ViDo = !string.IsNullOrEmpty(d.ViDo) ? decimal.Parse(d.ViDo) : null,
                        KinhDo = !string.IsNullOrEmpty(d.KinhDo) ? decimal.Parse(d.KinhDo) : null,
                        GhiChu = d.GhiChu,
                        Ngay = d.Ngay,
                        TrangThai = d.TrangThai,
                        TongGioLam = d.GioVao.HasValue && d.GioRa.HasValue ? 
                            (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours : 0
                    }),
                    ThongKe = thongKe
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new BaoCaoResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy báo cáo quý: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy báo cáo năm
        /// </summary>
        [HttpGet("nam")]
        public async Task<ActionResult<BaoCaoResponse>> LayBaoCaoNam(
            [FromQuery] int? nhanVienId = null,
            [FromQuery] int? nam = null)
        {
            try
            {
                var namHienTai = nam ?? DateTime.Now.Year;

                var diemDanh = await _baoCaoService.LayBaoCaoNam(nhanVienId, namHienTai);
                var thongKe = TinhThongKeBaoCao(diemDanh);

                return Ok(new BaoCaoResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy báo cáo năm thành công",
                    DanhSachDiemDanh = diemDanh.Select(d => new DiemDanhDto
                    {
                        Id = d.Id,
                        NhanVienId = d.NhanVienId,
                        HoTen = d.NhanVien.HoTen,
                        MaNhanVien = d.NhanVien.MaNhanVien,
                        GioVao = d.GioVao,
                        GioRa = d.GioRa,
                        PhuongThucVao = d.PhuongThucVao,
                        PhuongThucRa = d.PhuongThucRa,
                        ViDo = !string.IsNullOrEmpty(d.ViDo) ? decimal.Parse(d.ViDo) : null,
                        KinhDo = !string.IsNullOrEmpty(d.KinhDo) ? decimal.Parse(d.KinhDo) : null,
                        GhiChu = d.GhiChu,
                        Ngay = d.Ngay,
                        TrangThai = d.TrangThai,
                        TongGioLam = d.GioVao.HasValue && d.GioRa.HasValue ? 
                            (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours : 0
                    }),
                    ThongKe = thongKe
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new BaoCaoResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy báo cáo năm: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Gửi báo cáo qua email
        /// </summary>
        [HttpPost("gui-email")]
        public async Task<ActionResult<BaoCaoEmailResponse>> GuiBaoCaoEmail([FromBody] BaoCaoEmailRequest request)
        {
            try
            {
                var thanhCong = await _baoCaoService.GuiBaoCaoEmail(request.NhanVienId, request.LoaiBaoCao);

                return Ok(new BaoCaoEmailResponse
                {
                    ThanhCong = thanhCong,
                    ThongBao = thanhCong ? "Gửi email thành công" : "Gửi email thất bại"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new BaoCaoEmailResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi gửi email: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy báo cáo cá nhân (cho nhân viên)
        /// </summary>
        [HttpGet("ca-nhan/tuan")]
        [Authorize(Roles = "NhanVien")]
        public async Task<ActionResult<BaoCaoResponse>> LayBaoCaoCaNhanTuan([FromQuery] DateTime? ngayBatDau = null)
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int nhanVienId))
                {
                    return BadRequest(new BaoCaoResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không thể xác định ID nhân viên từ token"
                    });
                }

                var ngayBatDauTuan = ngayBatDau ?? DateTime.Now.Date.AddDays(-(int)DateTime.Now.DayOfWeek);
                var diemDanh = await _baoCaoService.LayBaoCaoTuan(nhanVienId, ngayBatDauTuan);
                var thongKe = TinhThongKeBaoCao(diemDanh);

                return Ok(new BaoCaoResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy báo cáo cá nhân tuần thành công",
                    DanhSachDiemDanh = diemDanh.Select(d => new DiemDanhDto
                    {
                        Id = d.Id,
                        NhanVienId = d.NhanVienId,
                        HoTen = d.NhanVien.HoTen,
                        MaNhanVien = d.NhanVien.MaNhanVien,
                        GioVao = d.GioVao,
                        GioRa = d.GioRa,
                        PhuongThucVao = d.PhuongThucVao,
                        PhuongThucRa = d.PhuongThucRa,
                        ViDo = !string.IsNullOrEmpty(d.ViDo) ? decimal.Parse(d.ViDo) : null,
                        KinhDo = !string.IsNullOrEmpty(d.KinhDo) ? decimal.Parse(d.KinhDo) : null,
                        GhiChu = d.GhiChu,
                        Ngay = d.Ngay,
                        TrangThai = d.TrangThai,
                        TongGioLam = d.GioVao.HasValue && d.GioRa.HasValue ? 
                            (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours : 0
                    }),
                    ThongKe = thongKe
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new BaoCaoResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy báo cáo cá nhân: {ex.Message}"
                });
            }
        }

        private ThongKeBaoCaoDto TinhThongKeBaoCao(IEnumerable<Models.DiemDanh> diemDanh)
        {
            var danhSach = diemDanh.ToList();
            var tongNgayLam = danhSach.Count(d => d.GioVao.HasValue);
            var tongGioLam = danhSach.Where(d => d.GioVao.HasValue && d.GioRa.HasValue)
                .Sum(d => (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours);
            var tongGioLamTrungBinh = tongNgayLam > 0 ? tongGioLam / tongNgayLam : 0;
            var soNgayNghi = danhSach.Count(d => !d.GioVao.HasValue);
            var soLanDiMuon = danhSach.Count(d => d.GioVao.HasValue && d.GioVao.Value.TimeOfDay > TimeSpan.FromHours(8));
            var soLanVeSom = danhSach.Count(d => d.GioRa.HasValue && d.GioRa.Value.TimeOfDay < TimeSpan.FromHours(17));
            var tyLeDiemDanh = danhSach.Count > 0 ? (decimal)tongNgayLam / danhSach.Count * 100 : 0;

            return new ThongKeBaoCaoDto
            {
                TongNgayLam = tongNgayLam,
                TongGioLam = tongGioLam,
                TongGioLamTrungBinh = tongGioLamTrungBinh,
                SoNgayNghi = soNgayNghi,
                SoLanDiMuon = soLanDiMuon,
                SoLanVeSom = soLanVeSom,
                TyLeDiemDanh = tyLeDiemDanh
            };
        }
    }
}
