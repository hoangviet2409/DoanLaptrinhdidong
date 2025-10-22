using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using UngDungDiemDanhNhanVien.Data;
using UngDungDiemDanhNhanVien.DTOs;
using UngDungDiemDanhNhanVien.Models;

namespace UngDungDiemDanhNhanVien.Services
{
    public class XacThucService : IXacThucService
    {
        private readonly UngDungDiemDanhContext _context;
        private readonly IConfiguration _configuration;

        public XacThucService(UngDungDiemDanhContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        public async Task<DangNhapResponse> DangNhapQuanTriVien(DangNhapRequest request)
        {
            var quanTriVien = await _context.QuanTriVien
                .FirstOrDefaultAsync(q => q.TenDangNhap == request.TenDangNhap);

            if (quanTriVien == null || string.IsNullOrEmpty(request.MatKhau) || string.IsNullOrEmpty(quanTriVien.MatKhauHash) || !BCrypt.Net.BCrypt.Verify(request.MatKhau, quanTriVien.MatKhauHash))
            {
                return new DangNhapResponse
                {
                    ThanhCong = false,
                    ThongBao = "Tên đăng nhập hoặc mật khẩu không đúng"
                };
            }

            var token = TaoJwtToken(quanTriVien.Id.ToString(), quanTriVien.VaiTro, quanTriVien.Email);

            return new DangNhapResponse
            {
                ThanhCong = true,
                ThongBao = "Đăng nhập thành công",
                Token = token,
                VaiTro = quanTriVien.VaiTro,
                HoTen = quanTriVien.Email
            };
        }

        public async Task<DangNhapResponse> DangNhapNhanVien(DangNhapNhanVienRequest request)
        {
            try
            {
                if (string.IsNullOrEmpty(request.MaNhanVien))
                {
                    return new DangNhapResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Mã nhân viên không được để trống"
                    };
                }

                var nhanVien = await _context.NhanVien
                    .AsNoTracking() // Đảm bảo luôn lấy data mới từ DB
                    .FirstOrDefaultAsync(n => n.MaNhanVien == request.MaNhanVien);

                if (nhanVien == null)
                {
                    return new DangNhapResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Mã nhân viên không tồn tại"
                    };
                }

                // LOG: Debug password hash
                Console.WriteLine($"[DEBUG] MaNV: {request.MaNhanVien}, MatKhauHash từ DB: {nhanVien.MatKhauHash?.Substring(0, Math.Min(20, nhanVien.MatKhauHash?.Length ?? 0))}...");

                // Kiểm tra mật khẩu nếu có
                if (!string.IsNullOrEmpty(request.MatKhau) && 
                    (string.IsNullOrEmpty(nhanVien.MatKhauHash) || 
                     !BCrypt.Net.BCrypt.Verify(request.MatKhau, nhanVien.MatKhauHash)))
                {
                    Console.WriteLine($"[DEBUG] Mật khẩu không khớp cho MaNV: {request.MaNhanVien}");
                    return new DangNhapResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Mã nhân viên hoặc mật khẩu không đúng"
                    };
                }
                Console.WriteLine($"[DEBUG] Đăng nhập thành công cho MaNV: {request.MaNhanVien}");

                if (nhanVien.TrangThai != "HoatDong")
                {
                    return new DangNhapResponse
                    {
                        ThanhCong = false,
                        ThongBao = "Tài khoản nhân viên đã bị khóa"
                    };
                }

                var token = TaoJwtToken(nhanVien.Id.ToString(), "NhanVien", nhanVien.HoTen, nhanVien.MaNhanVien);

                return new DangNhapResponse
                {
                    ThanhCong = true,
                    ThongBao = "Đăng nhập thành công",
                    Token = token,
                    VaiTro = "NhanVien",
                    NhanVienId = nhanVien.Id,
                    HoTen = nhanVien.HoTen
                };
            }
            catch (Exception ex)
            {
                return new DangNhapResponse
                {
                    ThanhCong = false,
                    ThongBao = $"Lỗi đăng nhập: {ex.Message}"
                };
            }
        }

        public async Task<DangNhapResponse> XacThucSinhTracHoc(DangNhapNhanVienRequest request)
        {
            var nhanVien = await _context.NhanVien
                .FirstOrDefaultAsync(n => n.MaNhanVien == request.MaNhanVien);

            if (nhanVien == null)
            {
                return new DangNhapResponse
                {
                    ThanhCong = false,
                    ThongBao = "Mã nhân viên không tồn tại"
                };
            }

            // Kiểm tra mật khẩu nếu có
            if (!string.IsNullOrEmpty(request.MatKhau) && 
                (string.IsNullOrEmpty(nhanVien.MatKhauHash) || 
                 !BCrypt.Net.BCrypt.Verify(request.MatKhau, nhanVien.MatKhauHash)))
            {
                return new DangNhapResponse
                {
                    ThanhCong = false,
                    ThongBao = "Mã nhân viên hoặc mật khẩu không đúng"
                };
            }

            if (nhanVien.TrangThai != "HoatDong")
            {
                return new DangNhapResponse
                {
                    ThanhCong = false,
                    ThongBao = "Tài khoản nhân viên đã bị khóa"
                };
            }

            var token = TaoJwtToken(nhanVien.Id.ToString(), "NhanVien", nhanVien.HoTen, nhanVien.MaNhanVien);

            return new DangNhapResponse
            {
                ThanhCong = true,
                ThongBao = "Xác thực sinh trắc học thành công",
                Token = token,
                VaiTro = "NhanVien",
                NhanVienId = nhanVien.Id,
                HoTen = nhanVien.HoTen
            };
        }

        public async Task<DangKyResponse> DangKy(DangKyRequest request)
        {
            // Validate dựa trên vai trò
            if (request.VaiTro == "Admin" || request.VaiTro == "QuanLy")
            {
                return await DangKyAdminQuanLy(request);
            }
            else if (request.VaiTro == "NhanVien")
            {
                return await DangKyNhanVien(request);
            }
            else
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Vai trò không hợp lệ"
                };
            }
        }

        private async Task<DangKyResponse> DangKyAdminQuanLy(DangKyRequest request)
        {
            // Validate thông tin bắt buộc cho Admin/QuanLy
            if (string.IsNullOrEmpty(request.TenDangNhap) || string.IsNullOrEmpty(request.MatKhau))
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Tên đăng nhập và mật khẩu là bắt buộc cho Admin/Quản lý"
                };
            }

            // Kiểm tra tên đăng nhập đã tồn tại
            var existingAdmin = await _context.QuanTriVien
                .FirstOrDefaultAsync(q => q.TenDangNhap == request.TenDangNhap);
            
            if (existingAdmin != null)
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Tên đăng nhập đã tồn tại"
                };
            }

            // Kiểm tra email đã tồn tại
            var existingEmail = await _context.QuanTriVien
                .FirstOrDefaultAsync(q => q.Email == request.Email);
            
            if (existingEmail != null)
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Email đã được sử dụng"
                };
            }

            // Tạo admin/quản lý mới
            var adminMoi = new QuanTriVien
            {
                TenDangNhap = request.TenDangNhap,
                MatKhauHash = BCrypt.Net.BCrypt.HashPassword(request.MatKhau),
                Email = request.Email,
                VaiTro = request.VaiTro,
                NgayTao = DateTime.Now
            };

            _context.QuanTriVien.Add(adminMoi);
            await _context.SaveChangesAsync();

            // Tạo token
            var token = TaoJwtToken(adminMoi.Id.ToString(), adminMoi.VaiTro, adminMoi.Email);

            return new DangKyResponse
            {
                ThanhCong = true,
                ThongBao = $"Đăng ký {request.VaiTro.ToLower()} thành công",
                Token = token,
                VaiTro = adminMoi.VaiTro,
                Id = adminMoi.Id,
                TenDangNhap = adminMoi.TenDangNhap,
                HoTen = adminMoi.Email,
                Email = adminMoi.Email
            };
        }

        private async Task<DangKyResponse> DangKyNhanVien(DangKyRequest request)
        {
            // Validate thông tin bắt buộc cho Nhân viên
            if (string.IsNullOrEmpty(request.MaNhanVien) || string.IsNullOrEmpty(request.HoTen) || !request.LuongGio.HasValue)
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Mã nhân viên, họ tên và lương giờ là bắt buộc cho Nhân viên"
                };
            }

            // Kiểm tra mã nhân viên đã tồn tại
            var existingNhanVien = await _context.NhanVien
                .FirstOrDefaultAsync(n => n.MaNhanVien == request.MaNhanVien);
            
            if (existingNhanVien != null)
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Mã nhân viên đã tồn tại"
                };
            }

            // Kiểm tra email đã tồn tại
            var existingEmail = await _context.NhanVien
                .FirstOrDefaultAsync(n => n.Email == request.Email);
            
            if (existingEmail != null)
            {
                return new DangKyResponse
                {
                    ThanhCong = false,
                    ThongBao = "Email đã được sử dụng"
                };
            }

            // Tạo nhân viên mới
            var nhanVienMoi = new NhanVien
            {
                MaNhanVien = request.MaNhanVien,
                HoTen = request.HoTen,
                Email = request.Email,
                SoDienThoai = request.SoDienThoai,
                PhongBan = request.PhongBan,
                ChucVu = request.ChucVu,
                LuongGio = request.LuongGio.Value,
                TrangThai = request.TrangThai,
                MaSinhTracHoc = request.MaSinhTracHoc,
                MaKhuonMat = request.MaKhuonMat,
                MaTheNFC = request.MaTheNFC,
                NgayTao = DateTime.Now
            };

            // Tạo mật khẩu cho nhân viên nếu có
            if (!string.IsNullOrEmpty(request.MatKhauNhanVien))
            {
                nhanVienMoi.MatKhauHash = BCrypt.Net.BCrypt.HashPassword(request.MatKhauNhanVien);
            }

            _context.NhanVien.Add(nhanVienMoi);
            await _context.SaveChangesAsync();

            // Tạo token
            var token = TaoJwtToken(nhanVienMoi.Id.ToString(), "NhanVien", nhanVienMoi.HoTen, nhanVienMoi.MaNhanVien);

            return new DangKyResponse
            {
                ThanhCong = true,
                ThongBao = "Đăng ký nhân viên thành công",
                Token = token,
                VaiTro = "NhanVien",
                Id = nhanVienMoi.Id,
                TenDangNhap = nhanVienMoi.MaNhanVien,
                HoTen = nhanVienMoi.HoTen,
                Email = nhanVienMoi.Email
            };
        }

        public async Task<bool> DoiMatKhau(int userId, DoiMatKhauRequest request)
        {
            // Tìm người dùng trong bảng QuanTriVien (AsNoTracking để lấy data mới nhất)
            var quanTriVien = await _context.QuanTriVien.AsNoTracking().FirstOrDefaultAsync(q => q.Id == userId);
            
            if (quanTriVien != null)
            {
                // Kiểm tra mật khẩu cũ
                if (!string.IsNullOrEmpty(quanTriVien.MatKhauHash) &&
                    !BCrypt.Net.BCrypt.Verify(request.MatKhauCu, quanTriVien.MatKhauHash))
                {
                    Console.WriteLine($"[DEBUG] Đổi MK thất bại: Mật khẩu cũ sai cho QuanTriVien ID={userId}");
                    return false; // Mật khẩu cũ không đúng
                }

                // Cập nhật mật khẩu mới
                var newHash = BCrypt.Net.BCrypt.HashPassword(request.MatKhauMoi);
                Console.WriteLine($"[DEBUG] Đổi MK QuanTriVien ID={userId}: Hash mới={newHash.Substring(0,20)}...");
                
                // Load entity để update (entity cũ đã AsNoTracking nên không bị conflict)
                var quanTriVienToUpdate = await _context.QuanTriVien.FindAsync(userId);
                if (quanTriVienToUpdate != null)
                {
                    quanTriVienToUpdate.MatKhauHash = newHash;
                    _context.Entry(quanTriVienToUpdate).State = EntityState.Modified;
                    
                    var result = await _context.SaveChangesAsync();
                    Console.WriteLine($"[DEBUG] SaveChanges trả về: {result} row(s) affected cho QuanTriVien ID={userId}");
                    return result > 0;
                }
            }

            // Tìm người dùng trong bảng NhanVien (AsNoTracking để lấy data mới nhất)
            var nhanVien = await _context.NhanVien.AsNoTracking().FirstOrDefaultAsync(n => n.Id == userId);
            
            if (nhanVien != null)
            {
                // Kiểm tra mật khẩu cũ nếu có
                if (!string.IsNullOrEmpty(nhanVien.MatKhauHash) && 
                    !BCrypt.Net.BCrypt.Verify(request.MatKhauCu, nhanVien.MatKhauHash))
                {
                    Console.WriteLine($"[DEBUG] Đổi MK thất bại: Mật khẩu cũ sai cho NhanVien ID={userId}");
                    return false; // Mật khẩu cũ không đúng
                }

                // Cập nhật mật khẩu mới
                var newHash = BCrypt.Net.BCrypt.HashPassword(request.MatKhauMoi);
                Console.WriteLine($"[DEBUG] Đổi MK NhanVien ID={userId}, MaNV={nhanVien.MaNhanVien}: Hash mới={newHash.Substring(0,20)}...");
                
                // Load entity để update (entity cũ đã AsNoTracking nên không bị conflict)
                var nhanVienToUpdate = await _context.NhanVien.FindAsync(userId);
                if (nhanVienToUpdate != null)
                {
                    nhanVienToUpdate.MatKhauHash = newHash;
                    nhanVienToUpdate.NgayCapNhat = DateTime.Now;
                    _context.Entry(nhanVienToUpdate).State = EntityState.Modified;
                    
                    var result = await _context.SaveChangesAsync();
                    Console.WriteLine($"[DEBUG] SaveChanges trả về: {result} row(s) affected cho NhanVien ID={userId}");
                    return result > 0;
                }
            }

            Console.WriteLine($"[DEBUG] Không tìm thấy người dùng ID={userId}");
            return false; // Không tìm thấy người dùng
        }

        public string TaoJwtToken(string userId, string vaiTro, string hoTen, string? maNhanVien = null)
        {
            var jwtSettings = _configuration.GetSection("JwtSettings");
            var secretKey = jwtSettings["SecretKey"];
            var issuer = jwtSettings["Issuer"];
            var audience = jwtSettings["Audience"];
            var expiryHours = int.Parse(jwtSettings["ExpiryHours"]!);

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey ?? ""));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, userId),
                new Claim(ClaimTypes.Role, vaiTro),
                new Claim(ClaimTypes.Name, hoTen),
                new Claim("VaiTro", vaiTro)
            };

            // Thêm MaNhanVien claim nếu có
            if (!string.IsNullOrEmpty(maNhanVien))
            {
                claims.Add(new Claim("MaNhanVien", maNhanVien));
            }

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: DateTime.Now.AddHours(expiryHours),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}

