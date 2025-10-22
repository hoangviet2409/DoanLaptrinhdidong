using System.ComponentModel.DataAnnotations;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DiemDanhVaoRequest
    {
        [Required(ErrorMessage = "Mã nhân viên là bắt buộc")]
        public string MaNhanVien { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "Phương thức không được vượt quá 50 ký tự")]
        public string PhuongThuc { get; set; } = "SinhTracHoc"; // SinhTracHoc, KhuonMat, ThuCong

        [Range(-90, 90, ErrorMessage = "Vĩ độ không hợp lệ")]
        public decimal? ViDo { get; set; }

        [Range(-180, 180, ErrorMessage = "Kinh độ không hợp lệ")]
        public decimal? KinhDo { get; set; }

        [StringLength(500, ErrorMessage = "Ghi chú không được vượt quá 500 ký tự")]
        public string? GhiChu { get; set; }
    }

    public class DiemDanhRaRequest
    {
        [Required(ErrorMessage = "Mã nhân viên là bắt buộc")]
        public string MaNhanVien { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "Phương thức không được vượt quá 50 ký tự")]
        public string PhuongThuc { get; set; } = "SinhTracHoc"; // SinhTracHoc, KhuonMat, ThuCong

        [Range(-90, 90, ErrorMessage = "Vĩ độ không hợp lệ")]
        public decimal? ViDo { get; set; }

        [Range(-180, 180, ErrorMessage = "Kinh độ không hợp lệ")]
        public decimal? KinhDo { get; set; }

        [StringLength(500, ErrorMessage = "Ghi chú không được vượt quá 500 ký tự")]
        public string? GhiChu { get; set; }
    }

    public class DiemDanhThuCongRequest
    {
        [Required(ErrorMessage = "ID nhân viên là bắt buộc")]
        public int NhanVienId { get; set; }

        [Required(ErrorMessage = "Giờ vào là bắt buộc")]
        public DateTime GioVao { get; set; }

        public DateTime? GioRa { get; set; }

        [Range(-90, 90, ErrorMessage = "Vĩ độ không hợp lệ")]
        public decimal? ViDo { get; set; }

        [Range(-180, 180, ErrorMessage = "Kinh độ không hợp lệ")]
        public decimal? KinhDo { get; set; }

        [StringLength(500, ErrorMessage = "Ghi chú không được vượt quá 500 ký tự")]
        public string? GhiChu { get; set; }
    }

    public class DiemDanhNfcRequest
    {
        [Required(ErrorMessage = "Mã thẻ NFC là bắt buộc")]
        public string MaTheNfc { get; set; } = string.Empty;

        [Range(-90, 90, ErrorMessage = "Vĩ độ không hợp lệ")]
        public decimal? ViDo { get; set; }

        [Range(-180, 180, ErrorMessage = "Kinh độ không hợp lệ")]
        public decimal? KinhDo { get; set; }

        [StringLength(500, ErrorMessage = "Ghi chú không được vượt quá 500 ký tự")]
        public string? GhiChu { get; set; }
    }
}