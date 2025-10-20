using Microsoft.EntityFrameworkCore;
using UngDungDiemDanhNhanVien.Data;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public class LuongService : ILuongService
    {
        private readonly UngDungDiemDanhContext _context;

        public LuongService(UngDungDiemDanhContext context)
        {
            _context = context;
        }

        public async Task<Luong> TinhLuong(int nhanVienId, DateTime ngayBatDau, DateTime ngayKetThuc, string loaiKy)
        {
            var nhanVien = await _context.NhanVien.FindAsync(nhanVienId);
            if (nhanVien == null)
                throw new ArgumentException("Không tìm thấy nhân viên");

            var diemDanh = await _context.DiemDanh
                .Where(d => d.NhanVienId == nhanVienId && 
                           d.Ngay >= ngayBatDau && d.Ngay <= ngayKetThuc &&
                           d.GioVao.HasValue && d.GioRa.HasValue)
                .ToListAsync();

            var tongGioLam = diemDanh.Sum(d => 
                d.GioVao.HasValue && d.GioRa.HasValue ? 
                (decimal)(d.GioRa.Value - d.GioVao.Value).TotalHours : 0);
            var tongTien = tongGioLam * nhanVien.LuongGio;

            var luong = new Luong
            {
                NhanVienId = nhanVienId,
                LoaiKy = loaiKy,
                NgayBatDau = ngayBatDau,
                NgayKetThuc = ngayKetThuc,
                TongGioLam = tongGioLam,
                LuongGio = nhanVien.LuongGio,
                TongTien = tongTien,
                Thuong = 0,
                TruLuong = 0,
                TongCong = tongTien,
                TrangThai = "ChuaTra",
                NgayTao = DateTime.Now
            };

            _context.Luong.Add(luong);
            await _context.SaveChangesAsync();
            return luong;
        }

        public async Task<IEnumerable<Luong>> LayLichSuLuong(int nhanVienId)
        {
            return await _context.Luong
                .Where(l => l.NhanVienId == nhanVienId)
                .OrderByDescending(l => l.NgayTao)
                .ToListAsync();
        }

        public async Task<Luong?> CapNhatLuong(int id, decimal thuong, decimal truLuong)
        {
            var luong = await _context.Luong.FindAsync(id);
            if (luong == null) return null;

            luong.Thuong = thuong;
            luong.TruLuong = truLuong;
            luong.TongCong = luong.TongTien + thuong - truLuong;

            await _context.SaveChangesAsync();
            return luong;
        }

        public async Task<bool> TaoBangLuongThang(int thang, int nam)
        {
            var ngayBatDau = new DateTime(nam, thang, 1);
            var ngayKetThuc = ngayBatDau.AddMonths(1).AddDays(-1);

            var nhanVien = await _context.NhanVien
                .Where(n => n.TrangThai == "HoatDong")
                .ToListAsync();

            foreach (var nv in nhanVien)
            {
                // Kiểm tra xem đã có bảng lương tháng này chưa
                var daCoLuong = await _context.Luong
                    .AnyAsync(l => l.NhanVienId == nv.Id && 
                                 l.LoaiKy == "Thang" &&
                                 l.NgayBatDau == ngayBatDau);

                if (!daCoLuong)
                {
                    await TinhLuong(nv.Id, ngayBatDau, ngayKetThuc, "Thang");
                }
            }

            return true;
        }
    }
}
