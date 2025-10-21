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
    public class LuongController : ControllerBase
    {
        private readonly ILuongService _luongService;

        public LuongController(ILuongService luongService)
        {
            _luongService = luongService;
        }

        /// <summary>
        /// Tính lương cho nhân viên
        /// </summary>
        [HttpPost("tinh-luong")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<LuongResponse>> TinhLuong([FromBody] TinhLuongRequest request)
        {
            try
            {
                var luong = await _luongService.TinhLuong(
                    request.NhanVienId, 
                    request.NgayBatDau, 
                    request.NgayKetThuc, 
                    request.LoaiKy);

                return Ok(new LuongResponse
                {
                    ThanhCong = true,
                    ThongBao = "Tính lương thành công",
                    Luong = new LuongDto
                    {
                        Id = luong.Id,
                        NhanVienId = luong.NhanVienId,
                        TenNhanVien = luong.NhanVien?.HoTen ?? "N/A",
                        MaNhanVien = luong.NhanVien?.MaNhanVien ?? "N/A",
                        LoaiKy = luong.LoaiKy,
                        NgayBatDau = luong.NgayBatDau,
                        NgayKetThuc = luong.NgayKetThuc,
                        TongGioLam = luong.TongGioLam,
                        LuongGio = luong.LuongGio,
                        TongTien = luong.TongTien,
                        Thuong = luong.Thuong,
                        TruLuong = luong.TruLuong,
                        TongCong = luong.TongCong,
                        TrangThai = luong.TrangThai,
                        NgayTao = luong.NgayTao
                    }
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi tính lương: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy lịch sử lương của nhân viên
        /// </summary>
        [HttpGet("lich-su/{nhanVienId}")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<LuongResponse>> LayLichSuLuong(int nhanVienId)
        {
            try
            {
                var danhSachLuong = await _luongService.LayLichSuLuong(nhanVienId);

                return Ok(new LuongResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy lịch sử lương thành công",
                    DanhSachLuong = danhSachLuong.Select(l => new LuongDto
                    {
                        Id = l.Id,
                        NhanVienId = l.NhanVienId,
                        TenNhanVien = l.NhanVien?.HoTen ?? "N/A",
                        MaNhanVien = l.NhanVien?.MaNhanVien ?? "N/A",
                        LoaiKy = l.LoaiKy,
                        NgayBatDau = l.NgayBatDau,
                        NgayKetThuc = l.NgayKetThuc,
                        TongGioLam = l.TongGioLam,
                        LuongGio = l.LuongGio,
                        TongTien = l.TongTien,
                        Thuong = l.Thuong,
                        TruLuong = l.TruLuong,
                        TongCong = l.TongCong,
                        TrangThai = l.TrangThai,
                        NgayTao = l.NgayTao
                    })
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy lịch sử lương: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy lịch sử lương cá nhân (cho nhân viên)
        /// </summary>
        [HttpGet("lich-su-ca-nhan")]
        [Authorize(Roles = "NhanVien")]
        public async Task<ActionResult<LuongResponse>> LayLichSuLuongCaNhan()
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int nhanVienId))
                {
                    return BadRequest(new LuongResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không thể xác định ID nhân viên từ token"
                    });
                }

                var danhSachLuong = await _luongService.LayLichSuLuong(nhanVienId);

                return Ok(new LuongResponse
                {
                    ThanhCong = true,
                    ThongBao = "Lấy lịch sử lương cá nhân thành công",
                    DanhSachLuong = danhSachLuong.Select(l => new LuongDto
                    {
                        Id = l.Id,
                        NhanVienId = l.NhanVienId,
                        TenNhanVien = l.NhanVien?.HoTen ?? "N/A",
                        MaNhanVien = l.NhanVien?.MaNhanVien ?? "N/A",
                        LoaiKy = l.LoaiKy,
                        NgayBatDau = l.NgayBatDau,
                        NgayKetThuc = l.NgayKetThuc,
                        TongGioLam = l.TongGioLam,
                        LuongGio = l.LuongGio,
                        TongTien = l.TongTien,
                        Thuong = l.Thuong,
                        TruLuong = l.TruLuong,
                        TongCong = l.TongCong,
                        TrangThai = l.TrangThai,
                        NgayTao = l.NgayTao
                    })
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy lịch sử lương cá nhân: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Cập nhật lương (thêm thưởng, trừ lương)
        /// </summary>
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<LuongResponse>> CapNhatLuong(int id, [FromBody] CapNhatLuongRequest request)
        {
            try
            {
                var luong = await _luongService.CapNhatLuong(id, request.Thuong, request.TruLuong);

                if (luong == null)
                {
                    return NotFound(new LuongResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không tìm thấy bản ghi lương"
                    });
                }

                return Ok(new LuongResponse
                {
                    ThanhCong = true,
                    ThongBao = "Cập nhật lương thành công",
                    Luong = new LuongDto
                    {
                        Id = luong.Id,
                        NhanVienId = luong.NhanVienId,
                        TenNhanVien = luong.NhanVien?.HoTen ?? "N/A",
                        MaNhanVien = luong.NhanVien?.MaNhanVien ?? "N/A",
                        LoaiKy = luong.LoaiKy,
                        NgayBatDau = luong.NgayBatDau,
                        NgayKetThuc = luong.NgayKetThuc,
                        TongGioLam = luong.TongGioLam,
                        LuongGio = luong.LuongGio,
                        TongTien = luong.TongTien,
                        Thuong = luong.Thuong,
                        TruLuong = luong.TruLuong,
                        TongCong = luong.TongCong,
                        TrangThai = luong.TrangThai,
                        NgayTao = luong.NgayTao
                    }
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi cập nhật lương: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Tạo bảng lương tháng cho tất cả nhân viên
        /// </summary>
        [HttpPost("tao-bang-luong-thang")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<LuongResponse>> TaoBangLuongThang([FromBody] TaoBangLuongRequest request)
        {
            try
            {
                var thanhCong = await _luongService.TaoBangLuongThang(request.Thang, request.Nam);

                return Ok(new LuongResponse
                {
                    ThanhCong = thanhCong,
                    ThongBao = thanhCong ? "Tạo bảng lương tháng thành công" : "Tạo bảng lương tháng thất bại"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi tạo bảng lương tháng: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy thông tin lương theo ID
        /// </summary>
        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<LuongResponse>> LayLuongTheoId(int id)
        {
            try
            {
                // TODO: Implement GetById method in service
                return Ok(new LuongResponse
                {
                    ThanhCong = true,
                    ThongBao = "Chức năng đang phát triển"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi lấy thông tin lương: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Xóa bản ghi lương (chỉ Admin)
        /// </summary>
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<LuongResponse>> XoaLuong(int id)
        {
            try
            {
                // TODO: Implement Delete method in service
                return Ok(new LuongResponse
                {
                    ThanhCong = true,
                    ThongBao = "Chức năng đang phát triển"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new LuongResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi khi xóa lương: {ex.Message}"
                });
            }
        }
    }
}
