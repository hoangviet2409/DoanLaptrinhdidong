namespace UngDungDiemDanhNhanVien.DTOs
{
    /// <summary>
    /// Response cho các API báo cáo
    /// </summary>
    public class BaoCaoResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public IEnumerable<DiemDanhDto>? DanhSachDiemDanh { get; set; }
        public ThongKeBaoCaoDto? ThongKe { get; set; }
    }

    /// <summary>
    /// DTO cho thống kê báo cáo
    /// </summary>
    public class ThongKeBaoCaoDto
    {
        public int TongNgayLam { get; set; }
        public decimal TongGioLam { get; set; }
        public decimal TongGioLamTrungBinh { get; set; }
        public int SoNgayNghi { get; set; }
        public int SoLanDiMuon { get; set; }
        public int SoLanVeSom { get; set; }
        public decimal TyLeDiemDanh { get; set; }
    }

    /// <summary>
    /// Response cho API gửi email báo cáo
    /// </summary>
    public class BaoCaoEmailResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
    }

    /// <summary>
    /// Request cho API gửi email báo cáo
    /// </summary>
    public class BaoCaoEmailRequest
    {
        public int NhanVienId { get; set; }
        public string LoaiBaoCao { get; set; } = string.Empty; // "tuan", "thang", "quy", "nam"
    }
}

