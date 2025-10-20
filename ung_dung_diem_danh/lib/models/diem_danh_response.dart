import 'package:equatable/equatable.dart';

class DiemDanhResponse extends Equatable {
  final bool thanhCong;
  final String thongBao;
  final DiemDanhDto? diemDanh;

  const DiemDanhResponse({
    required this.thanhCong,
    required this.thongBao,
    this.diemDanh,
  });

  factory DiemDanhResponse.fromJson(Map<String, dynamic> json) {
    return DiemDanhResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      diemDanh: json['diemDanh'] != null 
          ? DiemDanhDto.fromJson(json['diemDanh']) 
          : null,
    );
  }

  @override
  List<Object?> get props => [thanhCong, thongBao, diemDanh];
}

class DiemDanhDto extends Equatable {
  final int id;
  final int nhanVienId;
  final String maNhanVien;
  final String hoTen;
  final DateTime? gioVao;
  final DateTime? gioRa;
  final String phuongThucVao;
  final String? phuongThucRa;
  final double? viDo;
  final double? kinhDo;
  final String? ghiChu;
  final DateTime ngay;
  final double? tongGioLam;
  final String trangThai;
  final String? tenQuanTriVien;

  const DiemDanhDto({
    required this.id,
    required this.nhanVienId,
    required this.maNhanVien,
    required this.hoTen,
    this.gioVao,
    this.gioRa,
    required this.phuongThucVao,
    this.phuongThucRa,
    this.viDo,
    this.kinhDo,
    this.ghiChu,
    required this.ngay,
    this.tongGioLam,
    required this.trangThai,
    this.tenQuanTriVien,
  });

  factory DiemDanhDto.fromJson(Map<String, dynamic> json) {
    return DiemDanhDto(
      id: json['id'],
      nhanVienId: json['nhanVienId'],
      maNhanVien: json['maNhanVien'] ?? '',
      hoTen: json['hoTen'] ?? '',
      gioVao: json['gioVao'] != null ? DateTime.parse(json['gioVao']) : null,
      gioRa: json['gioRa'] != null ? DateTime.parse(json['gioRa']) : null,
      phuongThucVao: json['phuongThucVao'] ?? '',
      phuongThucRa: json['phuongThucRa'],
      viDo: json['viDo']?.toDouble(),
      kinhDo: json['kinhDo']?.toDouble(),
      ghiChu: json['ghiChu'],
      ngay: DateTime.parse(json['ngay']),
      tongGioLam: json['tongGioLam']?.toDouble(),
      trangThai: json['trangThai'] ?? '',
      tenQuanTriVien: json['tenQuanTriVien'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nhanVienId': nhanVienId,
      'maNhanVien': maNhanVien,
      'hoTen': hoTen,
      'gioVao': gioVao?.toIso8601String(),
      'gioRa': gioRa?.toIso8601String(),
      'phuongThucVao': phuongThucVao,
      'phuongThucRa': phuongThucRa,
      'viDo': viDo,
      'kinhDo': kinhDo,
      'ghiChu': ghiChu,
      'ngay': ngay.toIso8601String(),
      'tongGioLam': tongGioLam,
      'trangThai': trangThai,
      'tenQuanTriVien': tenQuanTriVien,
    };
  }

  // Helper methods
  bool get daDiemDanhVao => gioVao != null;
  bool get daDiemDanhRa => gioRa != null;
  bool get dangLam => trangThai == 'DangLam';
  bool get daVe => trangThai == 'DaVe';
  bool get nghi => trangThai == 'Nghi';

  String get trangThaiText {
    switch (trangThai) {
      case 'DangLam':
        return 'Đang làm';
      case 'DaVe':
        return 'Đã về';
      case 'Nghi':
        return 'Nghỉ';
      default:
        return trangThai;
    }
  }

  String get phuongThucVaoText {
    switch (phuongThucVao) {
      case 'SinhTracHoc':
        return 'Sinh trắc học';
      case 'KhuonMat':
        return 'Khuôn mặt';
      case 'ThuCong':
        return 'Thủ công';
      default:
        return phuongThucVao;
    }
  }

  String get phuongThucRaText {
    if (phuongThucRa == null) return '';
    switch (phuongThucRa) {
      case 'SinhTracHoc':
        return 'Sinh trắc học';
      case 'KhuonMat':
        return 'Khuôn mặt';
      case 'ThuCong':
        return 'Thủ công';
      default:
        return phuongThucRa!;
    }
  }

  @override
  List<Object?> get props => [
        id,
        nhanVienId,
        maNhanVien,
        hoTen,
        gioVao,
        gioRa,
        phuongThucVao,
        phuongThucRa,
        viDo,
        kinhDo,
        ghiChu,
        ngay,
        tongGioLam,
        trangThai,
        tenQuanTriVien,
      ];
}

class LichSuDiemDanhResponse extends Equatable {
  final bool thanhCong;
  final String thongBao;
  final List<DiemDanhDto> danhSachDiemDanh;
  final int tongSoBanGhi;

  const LichSuDiemDanhResponse({
    required this.thanhCong,
    required this.thongBao,
    required this.danhSachDiemDanh,
    required this.tongSoBanGhi,
  });

  factory LichSuDiemDanhResponse.fromJson(Map<String, dynamic> json) {
    return LichSuDiemDanhResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      danhSachDiemDanh: (json['danhSachDiemDanh'] as List<dynamic>?)
          ?.map((item) => DiemDanhDto.fromJson(item))
          .toList() ?? [],
      tongSoBanGhi: json['tongSoBanGhi'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [thanhCong, thongBao, danhSachDiemDanh, tongSoBanGhi];
}
