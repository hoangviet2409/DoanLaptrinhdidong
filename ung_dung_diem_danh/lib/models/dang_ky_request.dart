class DangKyRequest {
  final String tenDangNhap;
  final String matKhau;
  final String email;
  final String vaiTro;
  final String? hoTen;
  final String? soDienThoai;
  final String? xacNhanMatKhau;

  DangKyRequest({
    required this.tenDangNhap,
    required this.matKhau,
    required this.email,
    required this.vaiTro,
    this.hoTen,
    this.soDienThoai,
    String? xacNhanMatKhau,
  }) : xacNhanMatKhau = xacNhanMatKhau ?? matKhau; // Auto-fill với matKhau nếu null

  Map<String, dynamic> toJson() {
    return {
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
      'email': email,
      'vaiTro': vaiTro,
      'hoTen': hoTen,
      'soDienThoai': soDienThoai,
      'xacNhanMatKhau': xacNhanMatKhau,
    };
  }

  factory DangKyRequest.fromJson(Map<String, dynamic> json) {
    return DangKyRequest(
      tenDangNhap: json['tenDangNhap'] ?? '',
      matKhau: json['matKhau'] ?? '',
      email: json['email'] ?? '',
      vaiTro: json['vaiTro'] ?? '',
      hoTen: json['hoTen'],
      soDienThoai: json['soDienThoai'],
      xacNhanMatKhau: json['xacNhanMatKhau'],
    );
  }
}

class DangKyAdminRequest extends DangKyRequest {
  DangKyAdminRequest({
    required String tenDangNhap,
    required String matKhau,
    required String email,
    String? hoTen,
    String? soDienThoai,
  }) : super(
          tenDangNhap: tenDangNhap,
          matKhau: matKhau,
          email: email,
          vaiTro: 'Admin',
          hoTen: hoTen,
          soDienThoai: soDienThoai,
        );
}

class DangKyNhanVienRequest extends DangKyRequest {
  final String maNhanVien;
  final String? phongBan;
  final String? chucVu;
  final double luongGio;

  DangKyNhanVienRequest({
    required this.maNhanVien,
    required String tenDangNhap,
    required String matKhau,
    required String email,
    required this.luongGio,
    String? hoTen,
    String? soDienThoai,
    this.phongBan,
    this.chucVu,
  }) : super(
          tenDangNhap: tenDangNhap,
          matKhau: matKhau,
          email: email,
          vaiTro: 'NhanVien',
          hoTen: hoTen,
          soDienThoai: soDienThoai,
        );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'maNhanVien': maNhanVien,
      'phongBan': phongBan,
      'chucVu': chucVu,
      'luongGio': luongGio,
    });
    return json;
  }

  factory DangKyNhanVienRequest.fromJson(Map<String, dynamic> json) {
    return DangKyNhanVienRequest(
      maNhanVien: json['maNhanVien'] ?? '',
      tenDangNhap: json['tenDangNhap'] ?? '',
      matKhau: json['matKhau'] ?? '',
      email: json['email'] ?? '',
      luongGio: (json['luongGio'] ?? 0.0).toDouble(),
      hoTen: json['hoTen'],
      soDienThoai: json['soDienThoai'],
      phongBan: json['phongBan'],
      chucVu: json['chucVu'],
    );
  }
}

