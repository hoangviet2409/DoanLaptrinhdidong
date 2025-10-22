using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class a1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$iu0Pe2W6zbQjqT5xHYrzcOVHoLkup8B7oFWPCfEf.GXVOdcf6ntXi", new DateTime(2025, 10, 22, 8, 2, 14, 411, DateTimeKind.Local).AddTicks(7272) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$ocRUlYMaQMWW/ecBWHF/Oekz01G7AsZaFB4Fgq6y0xVeeabSPQdQO", new DateTime(2025, 10, 21, 22, 56, 21, 553, DateTimeKind.Local).AddTicks(6565) });
        }
    }
}
