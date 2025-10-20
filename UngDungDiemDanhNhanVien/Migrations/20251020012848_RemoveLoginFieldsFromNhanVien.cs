using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class RemoveLoginFieldsFromNhanVien : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MatKhauHash",
                table: "NhanVien");

            migrationBuilder.DropColumn(
                name: "TenDangNhap",
                table: "NhanVien");

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$KDWEtYTEIy4UY8JWYufEjealpFPOfdbmcgqFIQ63MRhQNNNDXDCDm", new DateTime(2025, 10, 20, 8, 28, 48, 51, DateTimeKind.Local).AddTicks(6156) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "MatKhauHash",
                table: "NhanVien",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "TenDangNhap",
                table: "NhanVien",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$umOg3W0WNhvZWsrKBaJQFOtd9niNt7H.CVzwxpmX.MxfU/wv8WLgq", new DateTime(2025, 10, 20, 8, 18, 28, 838, DateTimeKind.Local).AddTicks(8210) });
        }
    }
}
