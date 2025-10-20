using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UngDungDiemDanhNhanVien.Models
{
    [Table("NhatKyEmail")]
    public class NhatKyEmail
    {
        [Key]
        public int Id { get; set; }

        public int? NhanVienId { get; set; }

        [StringLength(50)]
        public string LoaiEmail { get; set; } = string.Empty; // BaoCaoTuan, BaoCaoThang

        public DateTime NgayGui { get; set; } = DateTime.Now;

        [StringLength(20)]
        public string TrangThai { get; set; } = "ThanhCong"; // ThanhCong, ThatBai

        [StringLength(500)]
        public string? ThongBaoLoi { get; set; }

        // Navigation properties
        [ForeignKey("NhanVienId")]
        public virtual NhanVien? NhanVien { get; set; }
    }
}
