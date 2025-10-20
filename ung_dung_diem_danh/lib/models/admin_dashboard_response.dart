import 'package:equatable/equatable.dart';

class AdminDashboardResponse extends Equatable {
  final bool thanhCong;
  final String thongBao;
  final ThongKeTongQuan thongKeTongQuan;
  final List<NhanVienDangLamViec> nhanVienDangLamViec;
  final List<NhanVienChuaDiemDanh> nhanVienChuaDiemDanh;
  final List<ThongKeTheoNgay> thongKeTheoNgay;

  const AdminDashboardResponse({
    required this.thanhCong,
    required this.thongBao,
    required this.thongKeTongQuan,
    required this.nhanVienDangLamViec,
    required this.nhanVienChuaDiemDanh,
    required this.thongKeTheoNgay,
  });

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) {
    return AdminDashboardResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      thongKeTongQuan: ThongKeTongQuan.fromJson(json['thongKeTongQuan'] ?? {}),
      nhanVienDangLamViec: (json['nhanVienDangLamViec'] as List<dynamic>?)
          ?.map((item) => NhanVienDangLamViec.fromJson(item))
          .toList() ?? [],
      nhanVienChuaDiemDanh: (json['nhanVienChuaDiemDanh'] as List<dynamic>?)
          ?.map((item) => NhanVienChuaDiemDanh.fromJson(item))
          .toList() ?? [],
      thongKeTheoNgay: (json['thongKeTheoNgay'] as List<dynamic>?)
          ?.map((item) => ThongKeTheoNgay.fromJson(item))
          .toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
        thanhCong,
        thongBao,
        thongKeTongQuan,
        nhanVienDangLamViec,
        nhanVienChuaDiemDanh,
        thongKeTheoNgay,
      ];
}

class ThongKeTongQuan extends Equatable {
  final int tongNhanVien;
  final int nhanVienDangLamViec;
  final int nhanVienNghi;
  final int nhanVienChuaDiemDanh;
  final double tyLeChuyenCan;
  final double gioLamTrungBinh;

  const ThongKeTongQuan({
    required this.tongNhanVien,
    required this.nhanVienDangLamViec,
    required this.nhanVienNghi,
    required this.nhanVienChuaDiemDanh,
    required this.tyLeChuyenCan,
    required this.gioLamTrungBinh,
  });

  factory ThongKeTongQuan.fromJson(Map<String, dynamic> json) {
    return ThongKeTongQuan(
      tongNhanVien: json['tongNhanVien'] ?? 0,
      nhanVienDangLamViec: json['nhanVienDangLamViec'] ?? 0,
      nhanVienNghi: json['nhanVienNghi'] ?? 0,
      nhanVienChuaDiemDanh: json['nhanVienChuaDiemDanh'] ?? 0,
      tyLeChuyenCan: (json['tyLeChuyenCan'] ?? 0).toDouble(),
      gioLamTrungBinh: (json['gioLamTrungBinh'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        tongNhanVien,
        nhanVienDangLamViec,
        nhanVienNghi,
        nhanVienChuaDiemDanh,
        tyLeChuyenCan,
        gioLamTrungBinh,
      ];
}

class NhanVienDangLamViec extends Equatable {
  final int id;
  final String maNhanVien;
  final String hoTen;
  final String phongBan;
  final String chucVu;
  final DateTime? gioVao;
  final String trangThai;
  final double soGioLam;

  const NhanVienDangLamViec({
    required this.id,
    required this.maNhanVien,
    required this.hoTen,
    required this.phongBan,
    required this.chucVu,
    this.gioVao,
    required this.trangThai,
    required this.soGioLam,
  });

  factory NhanVienDangLamViec.fromJson(Map<String, dynamic> json) {
    return NhanVienDangLamViec(
      id: json['id'] ?? 0,
      maNhanVien: json['maNhanVien'] ?? '',
      hoTen: json['hoTen'] ?? '',
      phongBan: json['phongBan'] ?? '',
      chucVu: json['chucVu'] ?? '',
      gioVao: json['gioVao'] != null ? DateTime.parse(json['gioVao']) : null,
      trangThai: json['trangThai'] ?? '',
      soGioLam: (json['soGioLam'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        maNhanVien,
        hoTen,
        phongBan,
        chucVu,
        gioVao,
        trangThai,
        soGioLam,
      ];
}

class NhanVienChuaDiemDanh extends Equatable {
  final int id;
  final String maNhanVien;
  final String hoTen;
  final String phongBan;
  final String chucVu;
  final String lyDo;

  const NhanVienChuaDiemDanh({
    required this.id,
    required this.maNhanVien,
    required this.hoTen,
    required this.phongBan,
    required this.chucVu,
    required this.lyDo,
  });

  factory NhanVienChuaDiemDanh.fromJson(Map<String, dynamic> json) {
    return NhanVienChuaDiemDanh(
      id: json['id'] ?? 0,
      maNhanVien: json['maNhanVien'] ?? '',
      hoTen: json['hoTen'] ?? '',
      phongBan: json['phongBan'] ?? '',
      chucVu: json['chucVu'] ?? '',
      lyDo: json['lyDo'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        maNhanVien,
        hoTen,
        phongBan,
        chucVu,
        lyDo,
      ];
}

class ThongKeTheoNgay extends Equatable {
  final DateTime ngay;
  final int soNhanVienDiemDanh;
  final int soNhanVienDiMuon;
  final int soNhanVienVeSom;
  final double gioLamTrungBinh;

  const ThongKeTheoNgay({
    required this.ngay,
    required this.soNhanVienDiemDanh,
    required this.soNhanVienDiMuon,
    required this.soNhanVienVeSom,
    required this.gioLamTrungBinh,
  });

  factory ThongKeTheoNgay.fromJson(Map<String, dynamic> json) {
    return ThongKeTheoNgay(
      ngay: DateTime.parse(json['ngay']),
      soNhanVienDiemDanh: json['soNhanVienDiemDanh'] ?? 0,
      soNhanVienDiMuon: json['soNhanVienDiMuon'] ?? 0,
      soNhanVienVeSom: json['soNhanVienVeSom'] ?? 0,
      gioLamTrungBinh: (json['gioLamTrungBinh'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        ngay,
        soNhanVienDiemDanh,
        soNhanVienDiMuon,
        soNhanVienVeSom,
        gioLamTrungBinh,
      ];
}
