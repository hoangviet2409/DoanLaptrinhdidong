using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Services;

namespace UngDungDiemDanhNhanVien.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DiemDanhController : ControllerBase
    {
        private readonly IDiemDanhService _diemDanhService;

        public DiemDanhController(IDiemDanhService diemDanhService)
        {
            _diemDanhService = diemDanhService;
        }

        /// <summary>
        /// Điểm danh vào cho nhân viên
        /// </summary>
        [HttpPost("diem-danh-vao")]
        public async Task<ActionResult<DiemDanhResponse>> DiemDanhVao([FromBody] DiemDanhVaoRequest request)
        {
            var result = await _diemDanhService.DiemDanhVao(request);
            
            if (!result.ThanhCong)
                return BadRequest(result);
                
            return Ok(result);
        }

        /// <summary>
        /// Điểm danh ra cho nhân viên
        /// </summary>
        [HttpPost("diem-danh-ra")]
        public async Task<ActionResult<DiemDanhResponse>> DiemDanhRa([FromBody] DiemDanhRaRequest request)
        {
            var result = await _diemDanhService.DiemDanhRa(request);
            
            if (!result.ThanhCong)
                return BadRequest(result);
                
            return Ok(result);
        }

        /// <summary>
        /// Điểm danh bằng thẻ NFC (toggle vào/ra)
        /// </summary>
        [HttpPost("diem-danh-nfc")]
        [AllowAnonymous]
        public async Task<ActionResult<DiemDanhResponse>> DiemDanhNfc([FromBody] DiemDanhNfcRequest request)
        {
            var result = await _diemDanhService.DiemDanhNfc(request);
            if (!result.ThanhCong)
                return BadRequest(result);
            return Ok(result);
        }

        /// <summary>
        /// Chấm công thủ công (chỉ Admin)
        /// </summary>
        [HttpPost("cham-cong-thu-cong")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<DiemDanhResponse>> ChamCongThuCong([FromBody] DiemDanhThuCongRequest request)
        {
            // Lấy ID của admin từ JWT token
            var adminIdClaim = User.FindFirst("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier");
            if (adminIdClaim == null || !int.TryParse(adminIdClaim.Value, out int adminId))
            {
                return BadRequest(new DiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = "Không thể xác định thông tin admin"
                });
            }

            var result = await _diemDanhService.DiemDanhThuCong(request, adminId);
            
            if (!result.ThanhCong)
                return BadRequest(result);
                
            return Ok(result);
        }

        /// <summary>
        /// Lấy lịch sử điểm danh của nhân viên (theo ID)
        /// </summary>
        [HttpGet("lich-su/{nhanVienId}")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<LichSuDiemDanhResponse>> LayLichSuDiemDanh(
            int nhanVienId, 
            [FromQuery] DateTime? tuNgay = null, 
            [FromQuery] DateTime? denNgay = null)
        {
            var result = await _diemDanhService.LayLichSuDiemDanh(nhanVienId, tuNgay, denNgay);
            
            if (!result.ThanhCong)
                return BadRequest(result);
                
            return Ok(result);
        }

        /// <summary>
        /// Lấy lịch sử điểm danh của nhân viên (theo mã nhân viên)
        /// </summary>
        [HttpGet("lich-su-ma/{maNhanVien}")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<LichSuDiemDanhResponse>> LayLichSuDiemDanhTheoMa(
            string maNhanVien, 
            [FromQuery] DateTime? tuNgay = null, 
            [FromQuery] DateTime? denNgay = null)
        {
            var result = await _diemDanhService.LayLichSuDiemDanhTheoMa(maNhanVien, tuNgay, denNgay);
            
            if (!result.ThanhCong)
                return BadRequest(result);
                
            return Ok(result);
        }

        /// <summary>
        /// Lấy thông tin điểm danh hiện tại của nhân viên (theo ID)
        /// </summary>
        [HttpGet("hien-tai/{nhanVienId}")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<DiemDanhDto>> LayDiemDanhHienTai(int nhanVienId)
        {
            var diemDanh = await _diemDanhService.LayDiemDanhHienTai(nhanVienId);
            
            if (diemDanh == null)
                return NotFound("Không tìm thấy bản ghi điểm danh hôm nay");
                
            return Ok(diemDanh);
        }

        /// <summary>
        /// Lấy thông tin điểm danh hiện tại của nhân viên (theo mã nhân viên) - Admin/Manager only
        /// </summary>
        [HttpGet("hien-tai-ma/{maNhanVien}")]
        [Authorize(Roles = "Admin,QuanLy")]
        public async Task<ActionResult<DiemDanhDto>> LayDiemDanhHienTaiTheoMa(string maNhanVien)
        {
            var diemDanh = await _diemDanhService.LayDiemDanhHienTaiTheoMa(maNhanVien);
            
            if (diemDanh == null)
                return NotFound("Không tìm thấy bản ghi điểm danh hôm nay");
                
            return Ok(diemDanh);
        }

        /// <summary>
        /// Lấy thông tin điểm danh hiện tại của nhân viên (cho chính nhân viên đó)
        /// </summary>
        [HttpGet("hien-tai-ca-nhan")]
        [Authorize(Roles = "NhanVien")]
        public async Task<ActionResult<DiemDanhDto>> LayDiemDanhHienTaiCaNhan()
        {
            try
            {
                // Lấy ID nhân viên từ JWT token
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int nhanVienId))
                {
                    return BadRequest("Không thể xác định ID nhân viên từ token");
                }

                var diemDanh = await _diemDanhService.LayDiemDanhHienTaiCaNhan(nhanVienId);
                
                if (diemDanh == null)
                    return NotFound("Không tìm thấy bản ghi điểm danh hôm nay");
                    
                return Ok(diemDanh);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Lỗi server: {ex.Message}");
            }
        }

        /// <summary>
        /// Lấy lịch sử điểm danh cá nhân (cho chính nhân viên đó)
        /// </summary>
        [HttpGet("lich-su-ca-nhan")]
        [Authorize(Roles = "NhanVien")]
        public async Task<ActionResult<LichSuDiemDanhResponse>> LayLichSuDiemDanhCaNhan(
            [FromQuery] DateTime? tuNgay = null, 
            [FromQuery] DateTime? denNgay = null)
        {
            try
            {
                // Lấy mã nhân viên từ JWT token
                var maNhanVienClaim = User.FindFirst("MaNhanVien");
                if (maNhanVienClaim == null)
                {
                    return BadRequest(new LichSuDiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không thể xác định mã nhân viên từ token"
                    });
                }

                var result = await _diemDanhService.LayLichSuDiemDanhTheoMa(maNhanVienClaim.Value, tuNgay, denNgay);
                
                if (!result.ThanhCong)
                    return BadRequest(result);
                    
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new LichSuDiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi server: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Lấy thống kê điểm danh cá nhân (cho chính nhân viên đó)
        /// </summary>
        [HttpGet("thong-ke-ca-nhan")]
        [Authorize(Roles = "NhanVien")]
        public async Task<ActionResult<ThongKeDiemDanhResponse>> LayThongKeDiemDanhCaNhan()
        {
            try
            {
                // Lấy mã nhân viên từ JWT token
                var maNhanVienClaim = User.FindFirst("MaNhanVien");
                if (maNhanVienClaim == null)
                {
                    return BadRequest(new ThongKeDiemDanhResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Không thể xác định mã nhân viên từ token"
                    });
                }

                var result = await _diemDanhService.LayThongKeDiemDanhTheoMa(maNhanVienClaim.Value);
                
                if (!result.ThanhCong)
                    return BadRequest(result);
                    
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new ThongKeDiemDanhResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi server: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Cập nhật bản ghi điểm danh (chỉ Admin)
        /// </summary>
        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public Task<ActionResult> CapNhatDiemDanh(int id, [FromBody] DiemDanhDto diemDanhDto)
        {
            // TODO: Implement update logic
            return Task.FromResult<ActionResult>(Ok("Chức năng cập nhật điểm danh đang phát triển"));
        }

        /// <summary>
        /// Lấy thông tin dashboard admin
        /// </summary>
        [HttpGet("dashboard-admin")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<AdminDashboardResponse>> LayThongTinDashboardAdmin()
        {
            var result = await _diemDanhService.LayThongTinDashboardAdmin();
            
            if (!result.ThanhCong)
                return BadRequest(result);
                
            return Ok(result);
        }

        /// <summary>
        /// Xóa bản ghi điểm danh (chỉ Admin)
        /// </summary>
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult> XoaDiemDanh(int id)
        {
            var result = await _diemDanhService.XoaDiemDanh(id);
            
            if (!result)
                return NotFound("Không tìm thấy bản ghi điểm danh");
                
            return Ok("Xóa bản ghi điểm danh thành công");
        }
    }
}