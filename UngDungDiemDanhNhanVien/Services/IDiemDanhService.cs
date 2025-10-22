using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public interface IDiemDanhService
    {
        Task<DiemDanhResponse> DiemDanhVao(DiemDanhVaoRequest request);
        Task<DiemDanhResponse> DiemDanhRa(DiemDanhRaRequest request);
        Task<DiemDanhResponse> DiemDanhThuCong(DiemDanhThuCongRequest request, int quanTriVienId);
        Task<LichSuDiemDanhResponse> LayLichSuDiemDanh(int nhanVienId, DateTime? tuNgay = null, DateTime? denNgay = null);
        Task<LichSuDiemDanhResponse> LayLichSuDiemDanhTheoMa(string maNhanVien, DateTime? tuNgay = null, DateTime? denNgay = null);
        Task<DiemDanh?> LayDiemDanhHienTai(int nhanVienId);
        Task<DiemDanhDto?> LayDiemDanhHienTaiTheoMa(string maNhanVien);
        Task<DiemDanhDto?> LayDiemDanhHienTaiCaNhan(int nhanVienId);
        Task<ThongKeDiemDanhResponse> LayThongKeDiemDanhTheoMa(string maNhanVien);
        Task<AdminDashboardResponse> LayThongTinDashboardAdmin();
        Task<bool> CapNhatDiemDanh(int id, DiemDanh diemDanh);
        Task<bool> XoaDiemDanh(int id);
        Task<DiemDanhResponse> DiemDanhNfc(DiemDanhNfcRequest request);
    }
}