import 'package:equatable/equatable.dart';

class DiemDanhVaoRequest extends Equatable {
  final String maNhanVien;
  final String phuongThuc;
  final double? viDo;
  final double? kinhDo;
  final String? ghiChu;

  const DiemDanhVaoRequest({
    required this.maNhanVien,
    this.phuongThuc = 'SinhTracHoc',
    this.viDo,
    this.kinhDo,
    this.ghiChu,
  });

  Map<String, dynamic> toJson() {
    return {
      'maNhanVien': maNhanVien.toString(),
      'phuongThuc': phuongThuc,
      'viDo': viDo,
      'kinhDo': kinhDo,
      'ghiChu': ghiChu,
    };
  }

  @override
  List<Object?> get props => [maNhanVien, phuongThuc, viDo, kinhDo, ghiChu];
}

class DiemDanhRaRequest extends Equatable {
  final String maNhanVien;
  final String phuongThuc;
  final double? viDo;
  final double? kinhDo;
  final String? ghiChu;

  const DiemDanhRaRequest({
    required this.maNhanVien,
    this.phuongThuc = 'SinhTracHoc',
    this.viDo,
    this.kinhDo,
    this.ghiChu,
  });

  Map<String, dynamic> toJson() {
    return {
      'maNhanVien': maNhanVien.toString(),
      'phuongThuc': phuongThuc,
      'viDo': viDo,
      'kinhDo': kinhDo,
      'ghiChu': ghiChu,
    };
  }

  @override
  List<Object?> get props => [maNhanVien, phuongThuc, viDo, kinhDo, ghiChu];
}

class DiemDanhThuCongRequest extends Equatable {
  final String maNhanVien;
  final DateTime gioVao;
  final DateTime? gioRa;
  final String? ghiChu;

  const DiemDanhThuCongRequest({
    required this.maNhanVien,
    required this.gioVao,
    this.gioRa,
    this.ghiChu,
  });

  Map<String, dynamic> toJson() {
    return {
      'maNhanVien': maNhanVien.toString(),
      'gioVao': gioVao.toIso8601String(),
      'gioRa': gioRa?.toIso8601String(),
      'ghiChu': ghiChu,
    };
  }

  @override
  List<Object?> get props => [maNhanVien, gioVao, gioRa, ghiChu];
}
