using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DoiMatKhauRequest
    {
        [Required(ErrorMessage = "Mật khẩu cũ là bắt buộc")]
        public string MatKhauCu { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mật khẩu mới là bắt buộc")]
        [MinLength(6, ErrorMessage = "Mật khẩu mới phải có ít nhất 6 ký tự")]
        public string MatKhauMoi { get; set; } = string.Empty;

        [Required(ErrorMessage = "Xác nhận mật khẩu mới là bắt buộc")]
        [Compare("MatKhauMoi", ErrorMessage = "Mật khẩu xác nhận không khớp")]
        public string XacNhanMatKhauMoi { get; set; } = string.Empty;
    }
}

