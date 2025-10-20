using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using UngDungDiemDanhNhanVien.Data;
using UngDungDiemDanhNhanVien.Services;
using UngDungDiemDanhNhanVien.Helpers;
using Serilog;
using Hangfire;
using Hangfire.SqlServer;

var builder = WebApplication.CreateBuilder(args);

// Cấu hình Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .WriteTo.File("logs/ungdungdiemdanh-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Cấu hình Entity Framework
builder.Services.AddDbContext<UngDungDiemDanhContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Cấu hình AutoMapper
builder.Services.AddAutoMapper(typeof(Program));

// Cấu hình JWT Authentication
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["SecretKey"];

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtSettings["Issuer"],
            ValidAudience = jwtSettings["Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey ?? ""))
        };
    });

// Cấu hình CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Đăng ký services
builder.Services.AddScoped<IXacThucService, XacThucService>();
builder.Services.AddScoped<INhanVienService, NhanVienService>();
builder.Services.AddScoped<IDiemDanhService, DiemDanhService>();
builder.Services.AddScoped<IBaoCaoService, BaoCaoService>();
builder.Services.AddScoped<ILuongService, LuongService>();
builder.Services.AddScoped<IEmailService, EmailService>();

// Cấu hình Hangfire cho background jobs (TẠM THỜI TẮT ĐỂ TEST)
// builder.Services.AddHangfire(configuration => configuration
//     .SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
//     .UseSimpleAssemblyNameTypeSerializer()
//     .UseRecommendedSerializerSettings()
//     .UseSqlServerStorage(builder.Configuration.GetConnectionString("DefaultConnection")));

// builder.Services.AddHangfireServer();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Khởi tạo database và seed admin
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<UngDungDiemDanhContext>();
    context.Database.EnsureCreated();
    
    // Tạo admin account nếu chưa có
    if (!context.QuanTriVien.Any())
    {
        var admin = new UngDungDiemDanhNhanVien.Models.QuanTriVien
        {
            TenDangNhap = "admin",
            MatKhauHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
            Email = "admin@congty.com",
            VaiTro = "Admin",
            NgayTao = DateTime.Now
        };
        context.QuanTriVien.Add(admin);
        context.SaveChanges();
        Log.Information("✅ Đã tạo tài khoản admin mặc định: admin/admin123");
    }
}

app.Run();
