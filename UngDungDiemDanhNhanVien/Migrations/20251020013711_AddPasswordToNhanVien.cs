using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class AddPasswordToNhanVien : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "MatKhauHash",
                table: "NhanVien",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: true);

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$PGwA1ckTO5l7LTkQsSqcMOna63rxOOU0WHYgTR2nURh/ZxB.4M80m", new DateTime(2025, 10, 20, 8, 37, 10, 355, DateTimeKind.Local).AddTicks(3460) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MatKhauHash",
                table: "NhanVien");

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$KDWEtYTEIy4UY8JWYufEjealpFPOfdbmcgqFIQ63MRhQNNNDXDCDm", new DateTime(2025, 10, 20, 8, 28, 48, 51, DateTimeKind.Local).AddTicks(6156) });
        }
    }
}
