using Microsoft.EntityFrameworkCore;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Data
{
    public class UngDungDiemDanhContext : DbContext
    {
        public UngDungDiemDanhContext(DbContextOptions<UngDungDiemDanhContext> options) : base(options)
        {
        }

        public DbSet<NhanVien> NhanVien { get; set; }
        public DbSet<QuanTriVien> QuanTriVien { get; set; }
        public DbSet<DiemDanh> DiemDanh { get; set; }
        public DbSet<Luong> Luong { get; set; }
        public DbSet<NhatKyEmail> NhatKyEmail { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Cấu hình NhanVien
            modelBuilder.Entity<NhanVien>(entity =>
            {
                entity.HasIndex(e => e.MaNhanVien).IsUnique();
                entity.HasIndex(e => e.Email).IsUnique();
            });

            // Cấu hình QuanTriVien
            modelBuilder.Entity<QuanTriVien>(entity =>
            {
                entity.HasIndex(e => e.TenDangNhap).IsUnique();
                entity.HasIndex(e => e.Email).IsUnique();
            });

            // Cấu hình DiemDanh
            modelBuilder.Entity<DiemDanh>(entity =>
            {
                entity.HasOne(d => d.NhanVien)
                    .WithMany(n => n.DanhSachDiemDanh)
                    .HasForeignKey(d => d.NhanVienId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(d => d.QuanTriVien)
                    .WithMany()
                    .HasForeignKey(d => d.QuanTriVienId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.HasIndex(e => new { e.NhanVienId, e.Ngay }).IsUnique();
            });

            // Cấu hình Luong
            modelBuilder.Entity<Luong>(entity =>
            {
                entity.HasOne(l => l.NhanVien)
                    .WithMany(n => n.DanhSachLuong)
                    .HasForeignKey(l => l.NhanVienId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // Cấu hình NhatKyEmail
            modelBuilder.Entity<NhatKyEmail>(entity =>
            {
                entity.HasOne(n => n.NhanVien)
                    .WithMany()
                    .HasForeignKey(n => n.NhanVienId)
                    .OnDelete(DeleteBehavior.SetNull);
            });

            // Seed data cho QuanTriVien
            modelBuilder.Entity<QuanTriVien>().HasData(
                new QuanTriVien
                {
                    Id = 1,
                    TenDangNhap = "admin",
                    MatKhauHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
                    Email = "admin@congty.com",
                    VaiTro = "Admin",
                    NgayTao = DateTime.Now
                }
            );
        }
    }
}
