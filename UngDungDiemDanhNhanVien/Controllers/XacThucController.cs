using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Services;

namespace UngDungDiemDanhNhanVien.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class XacThucController : ControllerBase
    {
        private readonly IXacThucService _xacThucService;

        public XacThucController(IXacThucService xacThucService)
        {
            _xacThucService = xacThucService;
        }

        [HttpPost("dang-nhap-quan-tri")]
        public async Task<ActionResult<DangNhapResponse>> DangNhapQuanTriVien(DangNhapRequest request)
        {
            var result = await _xacThucService.DangNhapQuanTriVien(request);
            return Ok(result);
        }

        [HttpPost("dang-nhap-nhan-vien")]
        public async Task<ActionResult<DangNhapResponse>> DangNhapNhanVien(DangNhapNhanVienRequest request)
        {
            var result = await _xacThucService.DangNhapNhanVien(request);
            return Ok(result);
        }

        [HttpPost("xac-thuc-sinh-trac-hoc")]
        public async Task<ActionResult<DangNhapResponse>> XacThucSinhTracHoc(DangNhapNhanVienRequest request)
        {
            var result = await _xacThucService.XacThucSinhTracHoc(request);
            return Ok(result);
        }

        [HttpPost("dang-ky")]
        public async Task<ActionResult<DangKyResponse>> DangKy(DangKyRequest request)
        {
            // Chỉ cho phép đăng ký nhân viên từ public
            if (request.VaiTro != "NhanVien")
            {
                return BadRequest(new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Chỉ có thể đăng ký tài khoản nhân viên từ đây. Vui lòng liên hệ Admin để tạo tài khoản quản lý."
                });
            }

            var result = await _xacThucService.DangKy(request);
            return Ok(result);
        }

        [HttpPost("dang-ky-admin")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<DangKyResponse>> DangKyAdmin(DangKyRequest request)
        {
            // Admin có thể tạo Admin/Quản lý/Nhân viên
            if (request.VaiTro != "Admin" && request.VaiTro != "QuanLy" && request.VaiTro != "NhanVien")
            {
                return BadRequest(new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Chỉ có thể tạo tài khoản Admin, Quản lý hoặc Nhân viên từ đây."
                });
            }

            var result = await _xacThucService.DangKy(request);
            return Ok(result);
        }
    }
}
