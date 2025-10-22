class LuongResponse {
  final bool thanhCong;
  final String thongBao;
  final List<LuongDto> danhSachLuong;

  LuongResponse({
    required this.thanhCong,
    required this.thongBao,
    required this.danhSachLuong,
  });

  factory LuongResponse.fromJson(Map<String, dynamic> json) {
    return LuongResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      danhSachLuong: json['danhSachLuong'] != null
          ? (json['danhSachLuong'] as List)
              .map((item) => LuongDto.fromJson(item))
              .toList()
          : [],
    );
  }
}

class LuongDto {
  final int id;
  final int nhanVienId;
  final String tenNhanVien;
  final String maNhanVien;
  final String loaiKy; // Tuan, Thang
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final double tongGioLam;
  final double luongGio;
  final double tongTien;
  final double? thuong;
  final double? truLuong;
  final double tongCong;
  final String trangThai; // ChuaThanhToan, DaThanhToan
  final DateTime ngayTao;
  final DateTime? ngayThanhToan;
  final String? ghiChu;

  LuongDto({
    required this.id,
    required this.nhanVienId,
    required this.tenNhanVien,
    required this.maNhanVien,
    required this.loaiKy,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.tongGioLam,
    required this.luongGio,
    required this.tongTien,
    this.thuong,
    this.truLuong,
    required this.tongCong,
    required this.trangThai,
    required this.ngayTao,
    this.ngayThanhToan,
    this.ghiChu,
  });

  factory LuongDto.fromJson(Map<String, dynamic> json) {
    return LuongDto(
      id: json['id'] ?? 0,
      nhanVienId: json['nhanVienId'] ?? 0,
      tenNhanVien: json['tenNhanVien'] ?? '',
      maNhanVien: json['maNhanVien'] ?? '',
      loaiKy: json['loaiKy'] ?? '',
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayKetThuc: DateTime.parse(json['ngayKetThuc']),
      tongGioLam: (json['tongGioLam'] ?? 0).toDouble(),
      luongGio: (json['luongGio'] ?? 0).toDouble(),
      tongTien: (json['tongTien'] ?? 0).toDouble(),
      thuong: json['thuong'] != null ? (json['thuong'] as num).toDouble() : null,
      truLuong: json['truLuong'] != null ? (json['truLuong'] as num).toDouble() : null,
      tongCong: (json['tongCong'] ?? 0).toDouble(),
      trangThai: json['trangThai'] ?? '',
      ngayTao: DateTime.parse(json['ngayTao']),
      ngayThanhToan: json['ngayThanhToan'] != null ? DateTime.parse(json['ngayThanhToan']) : null,
      ghiChu: json['ghiChu'],
    );
  }
}

