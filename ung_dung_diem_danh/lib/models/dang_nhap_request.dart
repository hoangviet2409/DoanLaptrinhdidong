import 'package:equatable/equatable.dart';

class DangNhapRequest extends Equatable {
  final String tenDangNhap;
  final String matKhau;

  const DangNhapRequest({
    required this.tenDangNhap,
    required this.matKhau,
  });

  Map<String, dynamic> toJson() {
    return {
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
    };
  }

  @override
  List<Object?> get props => [tenDangNhap, matKhau];
}

class DangNhapNhanVienRequest extends Equatable {
  final String maNhanVien;
  final String matKhau;

  const DangNhapNhanVienRequest({
    required this.maNhanVien,
    required this.matKhau,
  });

  Map<String, dynamic> toJson() {
    return {
      'maNhanVien': maNhanVien.toString(),
      'matKhau': matKhau,
    };
  }

  @override
  List<Object?> get props => [maNhanVien, matKhau];
}

