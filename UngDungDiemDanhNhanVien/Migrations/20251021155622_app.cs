using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class app : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$ocRUlYMaQMWW/ecBWHF/Oekz01G7AsZaFB4Fgq6y0xVeeabSPQdQO", new DateTime(2025, 10, 21, 22, 56, 21, 553, DateTimeKind.Local).AddTicks(6565) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$4Osk/0J.9pdUQgk3yrwz7uOzgoHFQRa0yTae6VaFFFlWoqMmX0GQO", new DateTime(2025, 10, 20, 23, 5, 32, 50, DateTimeKind.Local).AddTicks(8756) });
        }
    }
}
