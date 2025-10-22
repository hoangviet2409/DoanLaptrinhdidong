using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class AddGhiChuNgayThanhToanToLuong : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "GhiChu",
                table: "Luong",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "NgayThanhToan",
                table: "Luong",
                type: "datetime2",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$oLOGBfjKXJ26ILpGl1j0zOTg.kw3zVBY8k9jkLNY8yQtL.mzJ5kOO", new DateTime(2025, 10, 22, 9, 12, 48, 783, DateTimeKind.Local).AddTicks(1695) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "GhiChu",
                table: "Luong");

            migrationBuilder.DropColumn(
                name: "NgayThanhToan",
                table: "Luong");

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$iu0Pe2W6zbQjqT5xHYrzcOVHoLkup8B7oFWPCfEf.GXVOdcf6ntXi", new DateTime(2025, 10, 22, 8, 2, 14, 411, DateTimeKind.Local).AddTicks(7272) });
        }
    }
}
