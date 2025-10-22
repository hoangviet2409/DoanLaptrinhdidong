using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UngDungDiemDanhNhanVien.Models
{
    [Table("Luong")]
    public class Luong
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int NhanVienId { get; set; }

        [StringLength(20)]
        public string LoaiKy { get; set; } = "Tuan"; // Tuan, Thang

        public DateTime NgayBatDau { get; set; }
        public DateTime NgayKetThuc { get; set; }

        [Column(TypeName = "decimal(5,2)")]
        public decimal TongGioLam { get; set; }

        [Column(TypeName = "decimal(10,2)")]
        public decimal LuongGio { get; set; }

        [Column(TypeName = "decimal(12,2)")]
        public decimal TongTien { get; set; }

        [Column(TypeName = "decimal(12,2)")]
        public decimal Thuong { get; set; } = 0;

        [Column(TypeName = "decimal(12,2)")]
        public decimal TruLuong { get; set; } = 0;

        [Column(TypeName = "decimal(12,2)")]
        public decimal TongCong { get; set; }

        [StringLength(20)]
        public string TrangThai { get; set; } = "ChuaTra"; // ChuaTra, DaTra

        public DateTime NgayTao { get; set; } = DateTime.Now;
        
        public DateTime? NgayThanhToan { get; set; }
        
        [StringLength(500)]
        public string? GhiChu { get; set; }

        // Navigation properties
        [ForeignKey("NhanVienId")]
        public virtual NhanVien NhanVien { get; set; } = null!;
    }
}
