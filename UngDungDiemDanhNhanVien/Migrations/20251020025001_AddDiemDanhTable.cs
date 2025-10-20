using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class AddDiemDanhTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DiemDanh_QuanTriVien_QuanTriVienId",
                table: "DiemDanh");

            migrationBuilder.DropIndex(
                name: "IX_DiemDanh_NhanVienId_Ngay",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "KinhDo",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "TongGioLam",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "ViDo",
                table: "DiemDanh");

            migrationBuilder.RenameColumn(
                name: "QuanTriVienId",
                table: "DiemDanh",
                newName: "NguoiTaoId");

            migrationBuilder.RenameColumn(
                name: "Ngay",
                table: "DiemDanh",
                newName: "NgayTao");

            migrationBuilder.RenameIndex(
                name: "IX_DiemDanh_QuanTriVienId",
                table: "DiemDanh",
                newName: "IX_DiemDanh_NguoiTaoId");

            migrationBuilder.AlterColumn<string>(
                name: "PhuongThucVao",
                table: "DiemDanh",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "GhiChu",
                table: "DiemDanh",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "NgayCapNhat",
                table: "DiemDanh",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "NgayDiemDanh",
                table: "DiemDanh",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "ViTriLat",
                table: "DiemDanh",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ViTriLng",
                table: "DiemDanh",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$NzdudkbEa6jjobAa0G7keuXjPYWxXK/lncc1SZohwEhVT1oKGTT3W", new DateTime(2025, 10, 20, 9, 50, 0, 993, DateTimeKind.Local).AddTicks(5442) });

            migrationBuilder.CreateIndex(
                name: "IX_DiemDanh_NhanVienId_NgayDiemDanh",
                table: "DiemDanh",
                columns: new[] { "NhanVienId", "NgayDiemDanh" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_DiemDanh_QuanTriVien_NguoiTaoId",
                table: "DiemDanh",
                column: "NguoiTaoId",
                principalTable: "QuanTriVien",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DiemDanh_QuanTriVien_NguoiTaoId",
                table: "DiemDanh");

            migrationBuilder.DropIndex(
                name: "IX_DiemDanh_NhanVienId_NgayDiemDanh",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "NgayCapNhat",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "NgayDiemDanh",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "ViTriLat",
                table: "DiemDanh");

            migrationBuilder.DropColumn(
                name: "ViTriLng",
                table: "DiemDanh");

            migrationBuilder.RenameColumn(
                name: "NguoiTaoId",
                table: "DiemDanh",
                newName: "QuanTriVienId");

            migrationBuilder.RenameColumn(
                name: "NgayTao",
                table: "DiemDanh",
                newName: "Ngay");

            migrationBuilder.RenameIndex(
                name: "IX_DiemDanh_NguoiTaoId",
                table: "DiemDanh",
                newName: "IX_DiemDanh_QuanTriVienId");

            migrationBuilder.AlterColumn<string>(
                name: "PhuongThucVao",
                table: "DiemDanh",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "GhiChu",
                table: "DiemDanh",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(255)",
                oldMaxLength: 255,
                oldNullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "KinhDo",
                table: "DiemDanh",
                type: "decimal(10,6)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "TongGioLam",
                table: "DiemDanh",
                type: "decimal(5,2)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "ViDo",
                table: "DiemDanh",
                type: "decimal(10,6)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$PGwA1ckTO5l7LTkQsSqcMOna63rxOOU0WHYgTR2nURh/ZxB.4M80m", new DateTime(2025, 10, 20, 8, 37, 10, 355, DateTimeKind.Local).AddTicks(3460) });

            migrationBuilder.CreateIndex(
                name: "IX_DiemDanh_NhanVienId_Ngay",
                table: "DiemDanh",
                columns: new[] { "NhanVienId", "Ngay" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_DiemDanh_QuanTriVien_QuanTriVienId",
                table: "DiemDanh",
                column: "QuanTriVienId",
                principalTable: "QuanTriVien",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }
    }
}
