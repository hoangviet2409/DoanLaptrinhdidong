using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Models;
using UngDungDiemDanhNhanVien.Services;

namespace UngDungDiemDanhNhanVien.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class NhanVienController : ControllerBase
    {
        private readonly INhanVienService _nhanVienService;

        public NhanVienController(INhanVienService nhanVienService)
        {
            _nhanVienService = nhanVienService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<IEnumerable<NhanVien>>> LayDanhSachNhanVien()
        {
            var nhanVien = await _nhanVienService.LayDanhSachNhanVien();
            return Ok(nhanVien);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<NhanVien>> LayNhanVienTheoId(int id)
        {
            var nhanVien = await _nhanVienService.LayNhanVienTheoId(id);
            if (nhanVien == null)
                return NotFound("Không tìm thấy nhân viên");

            return Ok(nhanVien);
        }

        [HttpGet("ma/{maNhanVien}")]
        public async Task<ActionResult<NhanVien>> LayNhanVienTheoMa(string maNhanVien)
        {
            var nhanVien = await _nhanVienService.LayNhanVienTheoMa(maNhanVien);
            if (nhanVien == null)
                return NotFound("Không tìm thấy nhân viên");

            return Ok(nhanVien);
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<NhanVien>> ThemNhanVien(NhanVien nhanVien)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var nhanVienMoi = await _nhanVienService.ThemNhanVien(nhanVien);
                return CreatedAtAction(nameof(LayNhanVienTheoId), new { id = nhanVienMoi.Id }, nhanVienMoi);
            }
            catch (Exception ex)
            {
                return BadRequest($"Lỗi tạo nhân viên: {ex.Message}");
            }
        }

        [HttpPut("{id}")]
        [Authorize] // Cho phép tất cả user đã đăng nhập
        public async Task<ActionResult<NhanVien>> CapNhatNhanVien(int id, NhanVien nhanVien)
        {
            var nhanVienCapNhat = await _nhanVienService.CapNhatNhanVien(id, nhanVien);
            if (nhanVienCapNhat == null)
                return NotFound("Không tìm thấy nhân viên");

            return Ok(nhanVienCapNhat);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult> XoaNhanVien(int id)
        {
            var result = await _nhanVienService.XoaNhanVien(id);
            if (!result)
                return NotFound("Không tìm thấy nhân viên");

            return NoContent();
        }

        [HttpPut("{id}/trang-thai")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult> CapNhatTrangThai(int id, [FromBody] string trangThai)
        {
            var result = await _nhanVienService.CapNhatTrangThai(id, trangThai);
            if (!result)
                return NotFound("Không tìm thấy nhân viên");

            return Ok("Cập nhật trạng thái thành công");
        }

        [HttpPut("{id}/dang-ky-sinh-trac-hoc")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult> DangKySinhTracHoc(int id, [FromBody] string maSinhTracHoc)
        {
            var result = await _nhanVienService.DangKySinhTracHoc(id, maSinhTracHoc);
            if (!result)
                return NotFound("Không tìm thấy nhân viên");

            return Ok("Đăng ký sinh trắc học thành công");
        }

        // API cho NFC
        [HttpPost("gan-the-nfc")]
        [Authorize]
        public async Task<ActionResult> GanTheNFC([FromBody] GanTheNFCRequest request)
        {
            try
            {
                await _nhanVienService.CapNhatMaTheNFC(request.MaNhanVien, request.MaTheNFC);
                return Ok(new { thanhCong = true, thongBao = "Gán thẻ NFC thành công" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { thanhCong = false, thongBao = ex.Message });
            }
        }

        [HttpGet("kiem-tra-the-nfc/{maTheNFC}")]
        [AllowAnonymous]
        public async Task<ActionResult<KiemTraTheNFCResponse>> KiemTraTheNFC(string maTheNFC)
        {
            try
            {
                var nhanVien = await _nhanVienService.LayNhanVienTheoMaTheNFC(maTheNFC);
                
                if (nhanVien == null)
                {
                    return Ok(new KiemTraTheNFCResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Thẻ NFC không hợp lệ hoặc chưa được đăng ký"
                    });
                }

                return Ok(new KiemTraTheNFCResponse
                {
                    ThanhCong = true,
                    ThongBao = "Thẻ NFC hợp lệ",
                    NhanVien = new NhanVienNFCInfo
                    {
                        Id = nhanVien.Id,
                        MaNhanVien = nhanVien.MaNhanVien,
                        HoTen = nhanVien.HoTen,
                        Email = nhanVien.Email,
                        PhongBan = nhanVien.PhongBan,
                        ChucVu = nhanVien.ChucVu
                    }
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new KiemTraTheNFCResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi: {ex.Message}"
                });
            }
        }
    }
}
