namespace UngDungDiemDanhNhanVien.Services
{
    public interface IEmailService
    {
        Task<bool> GuiEmail(string to, string subject, string body);
        Task<bool> GuiBaoCaoTuan(string to, string tenNhanVien, object data);
        Task<bool> GuiBaoCaoThang(string to, string tenNhanVien, object data);
    }
}
