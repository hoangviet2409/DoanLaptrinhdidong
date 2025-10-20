using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "NhanVien",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MaNhanVien = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    HoTen = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    SoDienThoai = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: true),
                    TenDangNhap = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    MatKhauHash = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    MaSinhTracHoc = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    MaKhuonMat = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PhongBan = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    ChucVu = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    LuongGio = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    TrangThai = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    NgayTao = table.Column<DateTime>(type: "datetime2", nullable: false),
                    NgayCapNhat = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NhanVien", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "QuanTriVien",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TenDangNhap = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    MatKhauHash = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    VaiTro = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    NgayTao = table.Column<DateTime>(type: "datetime2", nullable: false),
                    NgayCapNhat = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_QuanTriVien", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Luong",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NhanVienId = table.Column<int>(type: "int", nullable: false),
                    LoaiKy = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    NgayBatDau = table.Column<DateTime>(type: "datetime2", nullable: false),
                    NgayKetThuc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TongGioLam = table.Column<decimal>(type: "decimal(5,2)", nullable: false),
                    LuongGio = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    TongTien = table.Column<decimal>(type: "decimal(12,2)", nullable: false),
                    Thuong = table.Column<decimal>(type: "decimal(12,2)", nullable: false),
                    TruLuong = table.Column<decimal>(type: "decimal(12,2)", nullable: false),
                    TongCong = table.Column<decimal>(type: "decimal(12,2)", nullable: false),
                    TrangThai = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    NgayTao = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Luong", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Luong_NhanVien_NhanVienId",
                        column: x => x.NhanVienId,
                        principalTable: "NhanVien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "NhatKyEmail",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NhanVienId = table.Column<int>(type: "int", nullable: true),
                    LoaiEmail = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    NgayGui = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TrangThai = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    ThongBaoLoi = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NhatKyEmail", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NhatKyEmail_NhanVien_NhanVienId",
                        column: x => x.NhanVienId,
                        principalTable: "NhanVien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "DiemDanh",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NhanVienId = table.Column<int>(type: "int", nullable: false),
                    GioVao = table.Column<DateTime>(type: "datetime2", nullable: true),
                    GioRa = table.Column<DateTime>(type: "datetime2", nullable: true),
                    PhuongThucVao = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PhuongThucRa = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    ViDo = table.Column<decimal>(type: "decimal(10,6)", nullable: true),
                    KinhDo = table.Column<decimal>(type: "decimal(10,6)", nullable: true),
                    GhiChu = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    QuanTriVienId = table.Column<int>(type: "int", nullable: true),
                    Ngay = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TongGioLam = table.Column<decimal>(type: "decimal(5,2)", nullable: true),
                    TrangThai = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DiemDanh", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DiemDanh_NhanVien_NhanVienId",
                        column: x => x.NhanVienId,
                        principalTable: "NhanVien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_DiemDanh_QuanTriVien_QuanTriVienId",
                        column: x => x.QuanTriVienId,
                        principalTable: "QuanTriVien",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.InsertData(
                table: "QuanTriVien",
                columns: new[] { "Id", "Email", "MatKhauHash", "NgayCapNhat", "NgayTao", "TenDangNhap", "VaiTro" },
                values: new object[] { 1, "admin@congty.com", "$2a$11$umOg3W0WNhvZWsrKBaJQFOtd9niNt7H.CVzwxpmX.MxfU/wv8WLgq", null, new DateTime(2025, 10, 20, 8, 18, 28, 838, DateTimeKind.Local).AddTicks(8210), "admin", "Admin" });

            migrationBuilder.CreateIndex(
                name: "IX_DiemDanh_NhanVienId_Ngay",
                table: "DiemDanh",
                columns: new[] { "NhanVienId", "Ngay" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_DiemDanh_QuanTriVienId",
                table: "DiemDanh",
                column: "QuanTriVienId");

            migrationBuilder.CreateIndex(
                name: "IX_Luong_NhanVienId",
                table: "Luong",
                column: "NhanVienId");

            migrationBuilder.CreateIndex(
                name: "IX_NhanVien_Email",
                table: "NhanVien",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_NhanVien_MaNhanVien",
                table: "NhanVien",
                column: "MaNhanVien",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_NhatKyEmail_NhanVienId",
                table: "NhatKyEmail",
                column: "NhanVienId");

            migrationBuilder.CreateIndex(
                name: "IX_QuanTriVien_Email",
                table: "QuanTriVien",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_QuanTriVien_TenDangNhap",
                table: "QuanTriVien",
                column: "TenDangNhap",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DiemDanh");

            migrationBuilder.DropTable(
                name: "Luong");

            migrationBuilder.DropTable(
                name: "NhatKyEmail");

            migrationBuilder.DropTable(
                name: "QuanTriVien");

            migrationBuilder.DropTable(
                name: "NhanVien");
        }
    }
}
