class DangKyRequest {
  final String vaiTro; // Admin, QuanLy, NhanVien
  final String email;
  final String? soDienThoai;
  
  // Thông tin Admin/QuanLy
  final String? tenDangNhap;
  final String? matKhau;
  final String? xacNhanMatKhau;
  
  // Thông tin Nhân viên
  final String? maNhanVien;
  final String? hoTen;
  final String? phongBan;
  final String? chucVu;
  final double? luongGio;
  final String trangThai;
  final String? maSinhTracHoc;
  final String? maKhuonMat;
  
  // Mật khẩu cho nhân viên
  final String? matKhauNhanVien;

  DangKyRequest({
    required this.vaiTro,
    required this.email,
    this.soDienThoai,
    this.tenDangNhap,
    this.matKhau,
    this.xacNhanMatKhau,
    this.maNhanVien,
    this.hoTen,
    this.phongBan,
    this.chucVu,
    this.luongGio,
    this.trangThai = 'HoatDong',
    this.maSinhTracHoc,
    this.maKhuonMat,
    this.matKhauNhanVien,
  });

  Map<String, dynamic> toJson() {
    return {
      'vaiTro': vaiTro,
      'email': email,
      'soDienThoai': soDienThoai,
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
      'xacNhanMatKhau': xacNhanMatKhau,
      'maNhanVien': maNhanVien,
      'hoTen': hoTen,
      'phongBan': phongBan,
      'chucVu': chucVu,
      'luongGio': luongGio,
      'trangThai': trangThai,
      'maSinhTracHoc': maSinhTracHoc,
      'maKhuonMat': maKhuonMat,
      'matKhauNhanVien': matKhauNhanVien,
    };
  }

  factory DangKyRequest.fromJson(Map<String, dynamic> json) {
    return DangKyRequest(
      vaiTro: json['vaiTro'] ?? '',
      email: json['email'] ?? '',
      soDienThoai: json['soDienThoai'],
      tenDangNhap: json['tenDangNhap'],
      matKhau: json['matKhau'],
      xacNhanMatKhau: json['xacNhanMatKhau'],
      maNhanVien: json['maNhanVien'],
      hoTen: json['hoTen'],
      phongBan: json['phongBan'],
      chucVu: json['chucVu'],
      luongGio: json['luongGio']?.toDouble(),
      trangThai: json['trangThai'] ?? 'HoatDong',
      maSinhTracHoc: json['maSinhTracHoc'],
      maKhuonMat: json['maKhuonMat'],
      matKhauNhanVien: json['matKhauNhanVien'],
    );
  }

  // Factory methods cho từng loại đăng ký
  factory DangKyRequest.admin({
    required String tenDangNhap,
    required String matKhau,
    required String email,
    String? soDienThoai,
  }) {
    return DangKyRequest(
      vaiTro: 'Admin',
      email: email,
      soDienThoai: soDienThoai,
      tenDangNhap: tenDangNhap,
      matKhau: matKhau,
    );
  }

  factory DangKyRequest.quanLy({
    required String tenDangNhap,
    required String matKhau,
    required String email,
    String? soDienThoai,
  }) {
    return DangKyRequest(
      vaiTro: 'QuanLy',
      email: email,
      soDienThoai: soDienThoai,
      tenDangNhap: tenDangNhap,
      matKhau: matKhau,
    );
  }

  factory DangKyRequest.nhanVien({
    required String maNhanVien,
    required String hoTen,
    required String email,
    required double luongGio,
    String? soDienThoai,
    String? phongBan,
    String? chucVu,
    String? maSinhTracHoc,
    String? maKhuonMat,
  }) {
    return DangKyRequest(
      vaiTro: 'NhanVien',
      email: email,
      soDienThoai: soDienThoai,
      maNhanVien: maNhanVien,
      hoTen: hoTen,
      phongBan: phongBan,
      chucVu: chucVu,
      luongGio: luongGio,
      maSinhTracHoc: maSinhTracHoc,
      maKhuonMat: maKhuonMat,
    );
  }
}
