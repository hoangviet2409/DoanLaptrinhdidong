using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UngDungDiemDanhNhanVien.Models
{
    [Table("NhanVien")]
    public class NhanVien
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(20)]
        public string MaNhanVien { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string HoTen { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [StringLength(15)]
        public string? SoDienThoai { get; set; }

        [StringLength(255)]
        public string? MatKhauHash { get; set; }

        [StringLength(50)]
        public string? MaSinhTracHoc { get; set; }

        [StringLength(50)]
        public string? MaKhuonMat { get; set; }

        [StringLength(100)]
        public string? PhongBan { get; set; }

        [StringLength(100)]
        public string? ChucVu { get; set; }

        [Column(TypeName = "decimal(10,2)")]
        public decimal LuongGio { get; set; }

        [Required]
        [StringLength(20)]
        public string TrangThai { get; set; } = "HoatDong"; // HoatDong, TamKhoa

        public DateTime NgayTao { get; set; } = DateTime.Now;
        public DateTime? NgayCapNhat { get; set; }

        // Navigation properties
        public virtual ICollection<DiemDanh> DanhSachDiemDanh { get; set; } = new List<DiemDanh>();
        public virtual ICollection<Luong> DanhSachLuong { get; set; } = new List<Luong>();
    }
}
