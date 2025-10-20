namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangNhapResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public string? Token { get; set; }
        public string? VaiTro { get; set; }
        public int? NhanVienId { get; set; }
        public string? HoTen { get; set; }
    }
}
