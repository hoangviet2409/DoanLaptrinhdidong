using Microsoft.EntityFrameworkCore;
using UngDungDiemDanhNhanVien.Data;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public class NhanVienService : INhanVienService
    {
        private readonly UngDungDiemDanhContext _context;

        public NhanVienService(UngDungDiemDanhContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<NhanVien>> LayDanhSachNhanVien()
        {
            return await _context.NhanVien
                .OrderBy(n => n.HoTen)
                .ToListAsync();
        }

        public async Task<NhanVien?> LayNhanVienTheoId(int id)
        {
            return await _context.NhanVien.FindAsync(id);
        }

        public async Task<NhanVien?> LayNhanVienTheoMa(string maNhanVien)
        {
            return await _context.NhanVien
                .FirstOrDefaultAsync(n => n.MaNhanVien == maNhanVien);
        }

        public async Task<NhanVien> ThemNhanVien(NhanVien nhanVien)
        {
            nhanVien.NgayTao = DateTime.Now;
            _context.NhanVien.Add(nhanVien);
            await _context.SaveChangesAsync();
            return nhanVien;
        }

        public async Task<NhanVien?> CapNhatNhanVien(int id, NhanVien nhanVien)
        {
            var nhanVienHienTai = await _context.NhanVien.FindAsync(id);
            if (nhanVienHienTai == null) return null;

            // Cập nhật tất cả các trường
            nhanVienHienTai.MaNhanVien = nhanVien.MaNhanVien;
            nhanVienHienTai.HoTen = nhanVien.HoTen;
            nhanVienHienTai.Email = nhanVien.Email;
            nhanVienHienTai.SoDienThoai = nhanVien.SoDienThoai;
            nhanVienHienTai.PhongBan = nhanVien.PhongBan;
            nhanVienHienTai.ChucVu = nhanVien.ChucVu;
            nhanVienHienTai.LuongGio = nhanVien.LuongGio;
            nhanVienHienTai.TrangThai = nhanVien.TrangThai;
            nhanVienHienTai.MaSinhTracHoc = nhanVien.MaSinhTracHoc;
            nhanVienHienTai.MaKhuonMat = nhanVien.MaKhuonMat;
            nhanVienHienTai.NgayCapNhat = DateTime.Now;

            await _context.SaveChangesAsync();
            return nhanVienHienTai;
        }

        public async Task<bool> XoaNhanVien(int id)
        {
            var nhanVien = await _context.NhanVien.FindAsync(id);
            if (nhanVien == null) return false;

            _context.NhanVien.Remove(nhanVien);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> CapNhatTrangThai(int id, string trangThai)
        {
            var nhanVien = await _context.NhanVien.FindAsync(id);
            if (nhanVien == null) return false;

            nhanVien.TrangThai = trangThai;
            nhanVien.NgayCapNhat = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DangKySinhTracHoc(int id, string maSinhTracHoc)
        {
            var nhanVien = await _context.NhanVien.FindAsync(id);
            if (nhanVien == null) return false;

            nhanVien.MaSinhTracHoc = maSinhTracHoc;
            nhanVien.NgayCapNhat = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
