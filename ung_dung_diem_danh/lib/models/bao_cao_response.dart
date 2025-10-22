class BaoCaoResponse {
  final bool thanhCong;
  final String thongBao;
  final List<DiemDanhDto>? danhSachDiemDanh;
  final ThongKeBaoCaoDto? thongKe;

  BaoCaoResponse({
    required this.thanhCong,
    required this.thongBao,
    this.danhSachDiemDanh,
    this.thongKe,
  });

  factory BaoCaoResponse.fromJson(Map<String, dynamic> json) {
    return BaoCaoResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      danhSachDiemDanh: (json['danhSachDiemDanh'] as List?)
          ?.map((item) => DiemDanhDto.fromJson(item))
          .toList(),
      thongKe: json['thongKe'] != null 
          ? ThongKeBaoCaoDto.fromJson(json['thongKe']) 
          : null,
    );
  }
}

class DiemDanhDto {
  final int id;
  final int nhanVienId;
  final String hoTenNhanVien;
  final String maNhanVien;
  final DateTime gioVao;
  final DateTime? gioRa;
  final String phuongThucVao;
  final String? phuongThucRa;
  final DateTime ngay;
  final String trangThai;
  final double? viDo;
  final double? kinhDo;
  final String? ghiChu;

  DiemDanhDto({
    required this.id,
    required this.nhanVienId,
    required this.hoTenNhanVien,
    required this.maNhanVien,
    required this.gioVao,
    this.gioRa,
    required this.phuongThucVao,
    this.phuongThucRa,
    required this.ngay,
    required this.trangThai,
    this.viDo,
    this.kinhDo,
    this.ghiChu,
  });

  factory DiemDanhDto.fromJson(Map<String, dynamic> json) {
    return DiemDanhDto(
      id: json['id'] ?? 0,
      nhanVienId: json['nhanVienId'] ?? 0,
      hoTenNhanVien: json['hoTen'] ?? json['hoTenNhanVien'] ?? '',
      maNhanVien: json['maNhanVien'] ?? '',
      gioVao: DateTime.parse(json['gioVao']),
      gioRa: json['gioRa'] != null ? DateTime.parse(json['gioRa']) : null,
      phuongThucVao: json['phuongThucVao'] ?? '',
      phuongThucRa: json['phuongThucRa'],
      ngay: DateTime.parse(json['ngay']),
      trangThai: json['trangThai'] ?? '',
      viDo: json['viDo']?.toDouble(),
      kinhDo: json['kinhDo']?.toDouble(),
      ghiChu: json['ghiChu'],
    );
  }
}

class ThongKeBaoCaoDto {
  final int tongSoNgayLamViec;
  final int soNgayDiLam;
  final int soNgayNghi;
  final int soLanDiMuon;
  final int soLanVeSom;
  final double tongGioLam;
  final double tyLeDiLam;

  ThongKeBaoCaoDto({
    required this.tongSoNgayLamViec,
    required this.soNgayDiLam,
    required this.soNgayNghi,
    required this.soLanDiMuon,
    required this.soLanVeSom,
    required this.tongGioLam,
    required this.tyLeDiLam,
  });

  factory ThongKeBaoCaoDto.fromJson(Map<String, dynamic> json) {
    return ThongKeBaoCaoDto(
      tongSoNgayLamViec: json['tongSoNgayLamViec'] ?? 0,
      soNgayDiLam: json['soNgayDiLam'] ?? 0,
      soNgayNghi: json['soNgayNghi'] ?? 0,
      soLanDiMuon: json['soLanDiMuon'] ?? 0,
      soLanVeSom: json['soLanVeSom'] ?? 0,
      tongGioLam: (json['tongGioLam'] ?? 0.0).toDouble(),
      tyLeDiLam: (json['tyLeDiLam'] ?? 0.0).toDouble(),
    );
  }
}
