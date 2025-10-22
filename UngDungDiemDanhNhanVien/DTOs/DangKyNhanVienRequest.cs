using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangKyNhanVienRequest
    {
        [Required(ErrorMessage = "Mã nhân viên là bắt buộc")]
        [StringLength(20, MinimumLength = 3, ErrorMessage = "Mã nhân viên phải từ 3-20 ký tự")]
        public string MaNhanVien { get; set; } = string.Empty;

        [Required(ErrorMessage = "Họ tên là bắt buộc")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Họ tên phải từ 2-100 ký tự")]
        public string HoTen { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email là bắt buộc")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100, ErrorMessage = "Email không được quá 100 ký tự")]
        public string Email { get; set; } = string.Empty;

        [StringLength(15, ErrorMessage = "Số điện thoại không được quá 15 ký tự")]
        [Phone(ErrorMessage = "Số điện thoại không hợp lệ")]
        public string? SoDienThoai { get; set; }

        [StringLength(100, ErrorMessage = "Phòng ban không được quá 100 ký tự")]
        public string? PhongBan { get; set; }

        [StringLength(100, ErrorMessage = "Chức vụ không được quá 100 ký tự")]
        public string? ChucVu { get; set; }

        [Required(ErrorMessage = "Lương giờ là bắt buộc")]
        [Range(0, double.MaxValue, ErrorMessage = "Lương giờ phải lớn hơn 0")]
        public decimal LuongGio { get; set; }

        [StringLength(20, ErrorMessage = "Trạng thái không được quá 20 ký tự")]
        public string TrangThai { get; set; } = "HoatDong"; // HoatDong, TamKhoa

        // Thông tin đăng nhập (tùy chọn)
        [StringLength(50, ErrorMessage = "Mã sinh trắc học không được quá 50 ký tự")]
        public string? MaSinhTracHoc { get; set; }

        [StringLength(50, ErrorMessage = "Mã khuôn mặt không được quá 50 ký tự")]
        public string? MaKhuonMat { get; set; }

        [StringLength(50, ErrorMessage = "Mã thẻ NFC không được quá 50 ký tự")]
        public string? MaTheNFC { get; set; }
    }
}
