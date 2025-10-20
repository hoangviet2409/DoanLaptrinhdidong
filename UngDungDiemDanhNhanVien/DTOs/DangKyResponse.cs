namespace UngDungDiemDanhNhanVien.DTOs
{
    public class DangKyResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public string? Token { get; set; }
        public string? VaiTro { get; set; }
        public int? Id { get; set; }
        public string? TenDangNhap { get; set; }
        public string? HoTen { get; set; }
        public string? Email { get; set; }
    }
}
