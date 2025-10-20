using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangKyRequest
    {
        [Required(ErrorMessage = "Vai trò là bắt buộc")]
        [StringLength(50, ErrorMessage = "Vai trò không được quá 50 ký tự")]
        public string VaiTro { get; set; } = string.Empty; // Admin, QuanLy, NhanVien

        // Thông tin chung
        [Required(ErrorMessage = "Email là bắt buộc")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100, ErrorMessage = "Email không được quá 100 ký tự")]
        public string Email { get; set; } = string.Empty;

        [StringLength(15, ErrorMessage = "Số điện thoại không được quá 15 ký tự")]
        [Phone(ErrorMessage = "Số điện thoại không hợp lệ")]
        public string? SoDienThoai { get; set; }

        // Thông tin Admin/QuanLy
        [StringLength(50, MinimumLength = 3, ErrorMessage = "Tên đăng nhập phải từ 3-50 ký tự")]
        public string? TenDangNhap { get; set; }

        [StringLength(100, MinimumLength = 6, ErrorMessage = "Mật khẩu phải từ 6-100 ký tự")]
        public string? MatKhau { get; set; }

        [Compare("MatKhau", ErrorMessage = "Mật khẩu và xác nhận mật khẩu không khớp")]
        public string? XacNhanMatKhau { get; set; }

        // Thông tin Nhân viên
        [StringLength(20, MinimumLength = 3, ErrorMessage = "Mã nhân viên phải từ 3-20 ký tự")]
        public string? MaNhanVien { get; set; }

        [StringLength(100, MinimumLength = 2, ErrorMessage = "Họ tên phải từ 2-100 ký tự")]
        public string? HoTen { get; set; }

        // Mật khẩu cho nhân viên
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Mật khẩu nhân viên phải từ 6-100 ký tự")]
        public string? MatKhauNhanVien { get; set; }

        [StringLength(100, ErrorMessage = "Phòng ban không được quá 100 ký tự")]
        public string? PhongBan { get; set; }

        [StringLength(100, ErrorMessage = "Chức vụ không được quá 100 ký tự")]
        public string? ChucVu { get; set; }

        [Range(0, double.MaxValue, ErrorMessage = "Lương giờ phải lớn hơn 0")]
        public decimal? LuongGio { get; set; }

        [StringLength(20, ErrorMessage = "Trạng thái không được quá 20 ký tự")]
        public string TrangThai { get; set; } = "HoatDong";

        [StringLength(50, ErrorMessage = "Mã sinh trắc học không được quá 50 ký tự")]
        public string? MaSinhTracHoc { get; set; }

        [StringLength(50, ErrorMessage = "Mã khuôn mặt không được quá 50 ký tự")]
        public string? MaKhuonMat { get; set; }
    }
}
