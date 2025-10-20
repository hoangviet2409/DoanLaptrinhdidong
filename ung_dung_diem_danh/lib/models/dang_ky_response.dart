import 'package:equatable/equatable.dart';

class DangKyResponse extends Equatable {
  final bool thanhCong;
  final String thongBao;
  final String? token;
  final String? vaiTro;
  final int? id;
  final String? tenDangNhap;
  final String? hoTen;
  final String? email;

  const DangKyResponse({
    required this.thanhCong,
    required this.thongBao,
    this.token,
    this.vaiTro,
    this.id,
    this.tenDangNhap,
    this.hoTen,
    this.email,
  });

  factory DangKyResponse.fromJson(Map<String, dynamic> json) {
    return DangKyResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      token: json['token'],
      vaiTro: json['vaiTro'],
      id: json['id'],
      tenDangNhap: json['tenDangNhap'],
      hoTen: json['hoTen'],
      email: json['email'],
    );
  }

  @override
  List<Object?> get props => [
        thanhCong,
        thongBao,
        token,
        vaiTro,
        id,
        tenDangNhap,
        hoTen,
        email,
      ];
}
