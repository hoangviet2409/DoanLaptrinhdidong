using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangKyAdminRequest
    {
        [Required(ErrorMessage = "Tên đăng nhập là bắt buộc")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "Tên đăng nhập phải từ 3-50 ký tự")]
        public string TenDangNhap { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Mật khẩu phải từ 6-100 ký tự")]
        public string MatKhau { get; set; } = string.Empty;

        [Required(ErrorMessage = "Xác nhận mật khẩu là bắt buộc")]
        [Compare("MatKhau", ErrorMessage = "Mật khẩu và xác nhận mật khẩu không khớp")]
        public string XacNhanMatKhau { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email là bắt buộc")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100, ErrorMessage = "Email không được quá 100 ký tự")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vai trò là bắt buộc")]
        [StringLength(50, ErrorMessage = "Vai trò không được quá 50 ký tự")]
        public string VaiTro { get; set; } = "Admin"; // Admin, QuanLy
    }
}
