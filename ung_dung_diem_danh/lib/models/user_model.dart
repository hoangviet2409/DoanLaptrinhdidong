import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String token;
  final String vaiTro;
  final int? nhanVienId;
  final String hoTen;

  const UserModel({
    required this.token,
    required this.vaiTro,
    this.nhanVienId,
    required this.hoTen,
  });

  bool get isAdmin => vaiTro == 'Admin';
  bool get isEmployee => vaiTro == 'NhanVien';
  bool get isManager => vaiTro == 'QuanLy';

  @override
  List<Object?> get props => [token, vaiTro, nhanVienId, hoTen];
}

