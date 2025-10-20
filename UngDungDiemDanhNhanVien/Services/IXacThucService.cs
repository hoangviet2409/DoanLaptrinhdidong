using UngDungDiemDanhNhanVien.DTOs;

namespace UngDungDiemDanhNhanVien.Services
{
    public interface IXacThucService
    {
        // Đăng nhập
        Task<DangNhapResponse> DangNhapQuanTriVien(DangNhapRequest request);
        Task<DangNhapResponse> DangNhapNhanVien(DangNhapNhanVienRequest request);
        Task<DangNhapResponse> XacThucSinhTracHoc(DangNhapNhanVienRequest request);
        
        // Đăng ký
        Task<DangKyResponse> DangKy(DangKyRequest request);
        
        // Utility
        string TaoJwtToken(string userId, string vaiTro, string hoTen, string? maNhanVien = null);
    }
}
