namespace UngDungDiemDanhNhanVien.DTOs
{
    public class AdminDashboardResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public ThongKeTongQuan ThongKeTongQuan { get; set; } = new();
        public List<NhanVienDangLamViec> NhanVienDangLamViec { get; set; } = new();
        public List<NhanVienChuaDiemDanh> NhanVienChuaDiemDanh { get; set; } = new();
        public List<ThongKeTheoNgay> ThongKeTheoNgay { get; set; } = new();
    }

    public class ThongKeTongQuan
    {
        public int TongNhanVien { get; set; }
        public int NhanVienDangLamViec { get; set; }
        public int NhanVienNghi { get; set; }
        public int NhanVienChuaDiemDanh { get; set; }
        public double TyLeChuyenCan { get; set; }
        public double GioLamTrungBinh { get; set; }
    }

    public class NhanVienDangLamViec
    {
        public int Id { get; set; }
        public string MaNhanVien { get; set; } = string.Empty;
        public string HoTen { get; set; } = string.Empty;
        public string PhongBan { get; set; } = string.Empty;
        public string ChucVu { get; set; } = string.Empty;
        public DateTime? GioVao { get; set; }
        public string TrangThai { get; set; } = string.Empty;
        public double SoGioLam { get; set; }
    }

    public class NhanVienChuaDiemDanh
    {
        public int Id { get; set; }
        public string MaNhanVien { get; set; } = string.Empty;
        public string HoTen { get; set; } = string.Empty;
        public string PhongBan { get; set; } = string.Empty;
        public string ChucVu { get; set; } = string.Empty;
        public string LyDo { get; set; } = string.Empty; // "ChuaDiemDanh", "DiMuon", "VeSom"
    }

    public class ThongKeTheoNgay
    {
        public DateTime Ngay { get; set; }
        public int SoNhanVienDiemDanh { get; set; }
        public int SoNhanVienDiMuon { get; set; }
        public int SoNhanVienVeSom { get; set; }
        public double GioLamTrungBinh { get; set; }
    }
}
