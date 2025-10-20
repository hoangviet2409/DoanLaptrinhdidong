using Microsoft.EntityFrameworkCore;
using UngDungDiemDanhNhanVien.Data;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public class BaoCaoService : IBaoCaoService
    {
        private readonly UngDungDiemDanhContext _context;
        private readonly IEmailService _emailService;

        public BaoCaoService(UngDungDiemDanhContext context, IEmailService emailService)
        {
            _context = context;
            _emailService = emailService;
        }

        public async Task<IEnumerable<DiemDanh>> LayBaoCaoTuan(int? nhanVienId, DateTime ngayBatDau)
        {
            var ngayKetThuc = ngayBatDau.AddDays(6);
            var query = _context.DiemDanh
                .Include(d => d.NhanVien)
                .Where(d => d.Ngay >= ngayBatDau && d.Ngay <= ngayKetThuc);

            if (nhanVienId.HasValue)
                query = query.Where(d => d.NhanVienId == nhanVienId.Value);

            return await query.OrderBy(d => d.Ngay).ToListAsync();
        }

        public async Task<IEnumerable<DiemDanh>> LayBaoCaoThang(int? nhanVienId, int thang, int nam)
        {
            var ngayBatDau = new DateTime(nam, thang, 1);
            var ngayKetThuc = ngayBatDau.AddMonths(1).AddDays(-1);

            var query = _context.DiemDanh
                .Include(d => d.NhanVien)
                .Where(d => d.Ngay >= ngayBatDau && d.Ngay <= ngayKetThuc);

            if (nhanVienId.HasValue)
                query = query.Where(d => d.NhanVienId == nhanVienId.Value);

            return await query.OrderBy(d => d.Ngay).ToListAsync();
        }

        public async Task<IEnumerable<DiemDanh>> LayBaoCaoQuy(int? nhanVienId, int quy, int nam)
        {
            var thangBatDau = (quy - 1) * 3 + 1;
            var ngayBatDau = new DateTime(nam, thangBatDau, 1);
            var ngayKetThuc = ngayBatDau.AddMonths(3).AddDays(-1);

            var query = _context.DiemDanh
                .Include(d => d.NhanVien)
                .Where(d => d.Ngay >= ngayBatDau && d.Ngay <= ngayKetThuc);

            if (nhanVienId.HasValue)
                query = query.Where(d => d.NhanVienId == nhanVienId.Value);

            return await query.OrderBy(d => d.Ngay).ToListAsync();
        }

        public async Task<IEnumerable<DiemDanh>> LayBaoCaoNam(int? nhanVienId, int nam)
        {
            var ngayBatDau = new DateTime(nam, 1, 1);
            var ngayKetThuc = new DateTime(nam, 12, 31);

            var query = _context.DiemDanh
                .Include(d => d.NhanVien)
                .Where(d => d.Ngay >= ngayBatDau && d.Ngay <= ngayKetThuc);

            if (nhanVienId.HasValue)
                query = query.Where(d => d.NhanVienId == nhanVienId.Value);

            return await query.OrderBy(d => d.Ngay).ToListAsync();
        }

        public async Task<bool> GuiBaoCaoEmail(int nhanVienId, string loaiBaoCao)
        {
            var nhanVien = await _context.NhanVien.FindAsync(nhanVienId);
            if (nhanVien == null) return false;

            try
            {
                var thanhCong = loaiBaoCao switch
                {
                    "BaoCaoTuan" => await _emailService.GuiBaoCaoTuan(nhanVien.Email, nhanVien.HoTen, new { }),
                    "BaoCaoThang" => await _emailService.GuiBaoCaoThang(nhanVien.Email, nhanVien.HoTen, new { }),
                    _ => false
                };

                // Ghi log
                var nhatKy = new NhatKyEmail
                {
                    NhanVienId = nhanVienId,
                    LoaiEmail = loaiBaoCao,
                    TrangThai = thanhCong ? "ThanhCong" : "ThatBai"
                };
                _context.NhatKyEmail.Add(nhatKy);
                await _context.SaveChangesAsync();

                return thanhCong;
            }
            catch (Exception ex)
            {
                var nhatKy = new NhatKyEmail
                {
                    NhanVienId = nhanVienId,
                    LoaiEmail = loaiBaoCao,
                    TrangThai = "ThatBai",
                    ThongBaoLoi = ex.Message
                };
                _context.NhatKyEmail.Add(nhatKy);
                await _context.SaveChangesAsync();
                return false;
            }
        }
    }
}
