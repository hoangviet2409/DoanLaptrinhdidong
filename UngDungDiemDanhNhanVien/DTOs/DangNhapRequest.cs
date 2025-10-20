using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangNhapRequest
    {
        [Required(ErrorMessage = "Tên đăng nhập là bắt buộc")]
        public string TenDangNhap { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
        public string MatKhau { get; set; } = string.Empty;
    }
}
