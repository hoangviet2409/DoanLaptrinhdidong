using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace UngDungDiemDanhNhanVien.Models
{
    [Table("DiemDanh")]
    public class DiemDanh
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int NhanVienId { get; set; }

        public DateTime? GioVao { get; set; }
        public DateTime? GioRa { get; set; }

        [StringLength(50)]
        public string PhuongThucVao { get; set; } = "SinhTracHoc"; // SinhTracHoc, KhuonMat, ThuCong

        [StringLength(50)]
        public string? PhuongThucRa { get; set; }

        [Column("ViTriLat")]
        public string? ViDo { get; set; }

        [Column("ViTriLng")]
        public string? KinhDo { get; set; }

        [StringLength(500)]
        public string? GhiChu { get; set; }

        [Column("NguoiTaoId")]
        public int? QuanTriVienId { get; set; } // null nếu tự điểm danh

        [Required]
        [Column("NgayDiemDanh")]
        public DateTime Ngay { get; set; }

        [Required]
        public DateTime NgayTao { get; set; } = DateTime.Now;

        public DateTime? NgayCapNhat { get; set; }

        // TongGioLam được tính toán từ GioVao và GioRa, không lưu trong database

        [StringLength(20)]
        public string TrangThai { get; set; } = "DangLam"; // DangLam, DaVe, Nghi

        // Navigation properties
        [ForeignKey("NhanVienId")]
        public virtual NhanVien NhanVien { get; set; } = null!;

        [ForeignKey("QuanTriVienId")]
        public virtual QuanTriVien? QuanTriVien { get; set; }
    }
}
