using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UngDungDiemDanhNhanVien.Models
{
    [Table("QuanTriVien")]
    public class QuanTriVien
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string TenDangNhap { get; set; } = string.Empty;

        [Required]
        [StringLength(255)]
        public string MatKhauHash { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [StringLength(50)]
        public string VaiTro { get; set; } = "Admin"; // Admin, QuanLy

        public DateTime NgayTao { get; set; } = DateTime.Now;
        public DateTime? NgayCapNhat { get; set; }
    }
}
