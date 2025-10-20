using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public interface IBaoCaoService
    {
        Task<IEnumerable<DiemDanh>> LayBaoCaoTuan(int? nhanVienId, DateTime ngayBatDau);
        Task<IEnumerable<DiemDanh>> LayBaoCaoThang(int? nhanVienId, int thang, int nam);
        Task<IEnumerable<DiemDanh>> LayBaoCaoQuy(int? nhanVienId, int quy, int nam);
        Task<IEnumerable<DiemDanh>> LayBaoCaoNam(int? nhanVienId, int nam);
        Task<bool> GuiBaoCaoEmail(int nhanVienId, string loaiBaoCao);
    }
}
