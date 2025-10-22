using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace UngDungDiemDanhNhanVien.Migrations
{
    /// <inheritdoc />
    public partial class AddMaTheNfcToNhanVien : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "MaTheNfc",
                table: "NhanVien",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$c0RRqV.cYZw1NvkiPIMHM.pK9BHx4bgFNeKsugX0Oh1Cj/QBzE3FG", new DateTime(2025, 10, 22, 17, 20, 2, 304, DateTimeKind.Local).AddTicks(5682) });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MaTheNfc",
                table: "NhanVien");

            migrationBuilder.UpdateData(
                table: "QuanTriVien",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "MatKhauHash", "NgayTao" },
                values: new object[] { "$2a$11$oLOGBfjKXJ26ILpGl1j0zOTg.kw3zVBY8k9jkLNY8yQtL.mzJ5kOO", new DateTime(2025, 10, 22, 9, 12, 48, 783, DateTimeKind.Local).AddTicks(1695) });
        }
    }
}
