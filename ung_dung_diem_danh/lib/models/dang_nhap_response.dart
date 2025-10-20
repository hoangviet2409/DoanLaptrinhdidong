import 'package:equatable/equatable.dart';

class DangNhapResponse extends Equatable {
  final bool thanhCong;
  final String thongBao;
  final String? token;
  final String? vaiTro;
  final int? nhanVienId;
  final String? hoTen;

  const DangNhapResponse({
    required this.thanhCong,
    required this.thongBao,
    this.token,
    this.vaiTro,
    this.nhanVienId,
    this.hoTen,
  });

  factory DangNhapResponse.fromJson(Map<String, dynamic> json) {
    return DangNhapResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      token: json['token'],
      vaiTro: json['vaiTro'],
      nhanVienId: json['nhanVienId'],
      hoTen: json['hoTen'],
    );
  }

  @override
  List<Object?> get props => [thanhCong, thongBao, token, vaiTro, nhanVienId, hoTen];
}

