using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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
        [Authorize(Roles = "Admin")]
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
    }
}
