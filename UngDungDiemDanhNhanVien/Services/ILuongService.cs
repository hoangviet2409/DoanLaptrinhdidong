using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public interface ILuongService
    {
        Task<Luong> TinhLuong(int nhanVienId, DateTime ngayBatDau, DateTime ngayKetThuc, string loaiKy);
        Task<IEnumerable<Luong>> LayLichSuLuong(int nhanVienId);
        Task<Luong?> CapNhatLuong(int id, decimal thuong, decimal truLuong);
        Task<bool> TaoBangLuongThang(int thang, int nam);
    }
}
