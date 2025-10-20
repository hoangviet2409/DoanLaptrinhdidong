namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DiemDanhResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public DiemDanhDto? DiemDanh { get; set; }
    }

    public class DiemDanhDto
    {
        public int Id { get; set; }
        public int NhanVienId { get; set; }
        public string MaNhanVien { get; set; } = string.Empty;
        public string HoTen { get; set; } = string.Empty;
        public DateTime? GioVao { get; set; }
        public DateTime? GioRa { get; set; }
        public string PhuongThucVao { get; set; } = string.Empty;
        public string? PhuongThucRa { get; set; }
        public decimal? ViDo { get; set; }
        public decimal? KinhDo { get; set; }
        public string? GhiChu { get; set; }
        public DateTime Ngay { get; set; }
        public decimal? TongGioLam { get; set; }
        public string TrangThai { get; set; } = string.Empty;
        public string? TenQuanTriVien { get; set; } // Tên admin nếu chấm thủ công
    }

    public class LichSuDiemDanhResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public List<DiemDanhDto> DanhSachDiemDanh { get; set; } = new List<DiemDanhDto>();
        public int TongSoBanGhi { get; set; }
    }
}
