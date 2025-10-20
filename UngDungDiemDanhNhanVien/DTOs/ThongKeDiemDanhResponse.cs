namespace UngDungDiemDanhNhanVien.DTOs
{
    public class ThongKeDiemDanhResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public int NgayLamViecTrongThang { get; set; }
        public double TongGioLamTrongThang { get; set; }
        public double GioLamTrungBinh { get; set; }
        public int NgayLamViecTrongTuan { get; set; }
        public double TongGioLamTrongTuan { get; set; }
    }
}
