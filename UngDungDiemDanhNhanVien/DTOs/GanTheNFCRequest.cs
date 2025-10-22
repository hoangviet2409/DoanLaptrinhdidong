using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class GanTheNFCRequest
    {
        [Required(ErrorMessage = "Mã nhân viên là bắt buộc")]
        public string MaNhanVien { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mã thẻ NFC là bắt buộc")]
        [StringLength(50)]
        public string MaTheNFC { get; set; } = string.Empty;
    }

    public class KiemTraTheNFCResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public NhanVienNFCInfo? NhanVien { get; set; }
    }

    public class NhanVienNFCInfo
    {
        public int Id { get; set; }
        public string MaNhanVien { get; set; } = string.Empty;
        public string HoTen { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? PhongBan { get; set; }
        public string? ChucVu { get; set; }
    }
}

