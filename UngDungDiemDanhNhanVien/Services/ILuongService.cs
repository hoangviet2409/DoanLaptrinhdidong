using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public interface ILuongService
    {
        Task<Luong> TinhLuong(int nhanVienId, DateTime ngayBatDau, DateTime ngayKetThuc, string loaiKy);
        Task<IEnumerable<Luong>> LayLichSuLuong(int nhanVienId);
        Task<Luong?> CapNhatLuong(int id, decimal thuong, decimal truLuong, string? trangThai = null, string? ghiChu = null);
        Task<bool> XoaLuong(int id);
        Task<bool> TaoBangLuongThang(int thang, int nam);
    }
}
