using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public interface INhanVienService
    {
        Task<IEnumerable<NhanVien>> LayDanhSachNhanVien();
        Task<NhanVien?> LayNhanVienTheoId(int id);
        Task<NhanVien?> LayNhanVienTheoMa(string maNhanVien);
        Task<NhanVien> ThemNhanVien(NhanVien nhanVien);
        Task<NhanVien?> CapNhatNhanVien(int id, NhanVien nhanVien);
        Task<bool> XoaNhanVien(int id);
        Task<bool> CapNhatTrangThai(int id, string trangThai);
        Task<bool> DangKySinhTracHoc(int id, string maSinhTracHoc);
    }
}
