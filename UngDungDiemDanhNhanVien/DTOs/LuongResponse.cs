using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.DTOs
{
    public class LuongResponse
    {
        public bool ThanhCong { get; set; }
        public string ThongBao { get; set; } = string.Empty;
        public LuongDto? Luong { get; set; }
        public IEnumerable<LuongDto>? DanhSachLuong { get; set; }
    }

    public class LuongDto
    {
        public int Id { get; set; }
        public int NhanVienId { get; set; }
        public string TenNhanVien { get; set; } = string.Empty;
        public string MaNhanVien { get; set; } = string.Empty;
        public string LoaiKy { get; set; } = string.Empty;
        public DateTime NgayBatDau { get; set; }
        public DateTime NgayKetThuc { get; set; }
        public decimal TongGioLam { get; set; }
        public decimal LuongGio { get; set; }
        public decimal TongTien { get; set; }
        public decimal Thuong { get; set; }
        public decimal TruLuong { get; set; }
        public decimal TongCong { get; set; }
        public string TrangThai { get; set; } = string.Empty;
        public DateTime NgayTao { get; set; }
    }

    public class TinhLuongRequest
    {
        public int NhanVienId { get; set; }
        public DateTime NgayBatDau { get; set; }
        public DateTime NgayKetThuc { get; set; }
        public string LoaiKy { get; set; } = string.Empty; // "Tuan", "Thang", "Quy", "Nam"
    }

    public class CapNhatLuongRequest
    {
        public decimal Thuong { get; set; }
        public decimal TruLuong { get; set; }
        public string? TrangThai { get; set; }
        public string? GhiChu { get; set; }
    }

    public class TaoBangLuongRequest
    {
        public int Thang { get; set; }
        public int Nam { get; set; }
    }
}

