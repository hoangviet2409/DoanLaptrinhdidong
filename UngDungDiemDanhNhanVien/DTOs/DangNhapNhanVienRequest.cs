using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangNhapNhanVienRequest
    {
        [Required(ErrorMessage = "Mã nhân viên là bắt buộc")]
        public string MaNhanVien { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
        public string MatKhau { get; set; } = string.Empty;
    }
}
