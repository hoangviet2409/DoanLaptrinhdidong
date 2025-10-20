import 'package:equatable/equatable.dart';

class NhanVienModel extends Equatable {
  final int id;
  final String maNhanVien;
  final String hoTen;
  final String email;
  final String? soDienThoai;
  final String? maSinhTracHoc;
  final String? maKhuonMat;
  final String? phongBan;
  final String? chucVu;
  final double luongGio;
  final String trangThai;
  final DateTime ngayTao;
  final DateTime? ngayCapNhat;

  const NhanVienModel({
    required this.id,
    required this.maNhanVien,
    required this.hoTen,
    required this.email,
    this.soDienThoai,
    this.maSinhTracHoc,
    this.maKhuonMat,
    this.phongBan,
    this.chucVu,
    required this.luongGio,
    required this.trangThai,
    required this.ngayTao,
    this.ngayCapNhat,
  });

  factory NhanVienModel.fromJson(Map<String, dynamic> json) {
    return NhanVienModel(
      id: json['id'] ?? 0,
      maNhanVien: json['maNhanVien'] ?? '',
      hoTen: json['hoTen'] ?? '',
      email: json['email'] ?? '',
      soDienThoai: json['soDienThoai'],
      maSinhTracHoc: json['maSinhTracHoc'],
      maKhuonMat: json['maKhuonMat'],
      phongBan: json['phongBan'],
      chucVu: json['chucVu'],
      luongGio: (json['luongGio'] ?? 0).toDouble(),
      trangThai: json['trangThai'] ?? 'HoatDong',
      ngayTao: DateTime.parse(json['ngayTao']),
      ngayCapNhat: json['ngayCapNhat'] != null 
          ? DateTime.parse(json['ngayCapNhat']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maNhanVien': maNhanVien,
      'hoTen': hoTen,
      'email': email,
      'soDienThoai': soDienThoai,
      'maSinhTracHoc': maSinhTracHoc,
      'maKhuonMat': maKhuonMat,
      'phongBan': phongBan,
      'chucVu': chucVu,
      'luongGio': luongGio,
      'trangThai': trangThai,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        maNhanVien,
        hoTen,
        email,
        soDienThoai,
        maSinhTracHoc,
        maKhuonMat,
        phongBan,
        chucVu,
        luongGio,
        trangThai,
        ngayTao,
        ngayCapNhat,
      ];
}
