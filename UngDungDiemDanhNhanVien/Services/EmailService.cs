using MailKit.Net.Smtp;
using MimeKit;
using UngDungDiemDanhNhanVien.Helpers;

namespace UngDungDiemDanhNhanVien.Services
{
    public class EmailService : IEmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<bool> GuiEmail(string to, string subject, string body)
        {
            try
            {
                var emailSettings = _configuration.GetSection("EmailSettings");
                var smtpServer = emailSettings["SmtpServer"];
                var smtpPort = int.Parse(emailSettings["SmtpPort"]!);
                var smtpUsername = emailSettings["SmtpUsername"];
                var smtpPassword = emailSettings["SmtpPassword"];
                var fromEmail = emailSettings["FromEmail"];
                var fromName = emailSettings["FromName"];

                var message = new MimeMessage();
                message.From.Add(new MailboxAddress(fromName, fromEmail));
                message.To.Add(new MailboxAddress("", to));
                message.Subject = subject;

                var bodyBuilder = new BodyBuilder
                {
                    HtmlBody = body
                };
                message.Body = bodyBuilder.ToMessageBody();

                using var client = new SmtpClient();
                await client.ConnectAsync(smtpServer, smtpPort, false);
                await client.AuthenticateAsync(smtpUsername, smtpPassword);
                await client.SendAsync(message);
                await client.DisconnectAsync(true);

                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> GuiBaoCaoTuan(string to, string tenNhanVien, object data)
        {
            var subject = $"Báo cáo tuần - {tenNhanVien}";
            var body = EmailTemplates.TaoBaoCaoTuan(tenNhanVien, data);
            return await GuiEmail(to, subject, body);
        }

        public async Task<bool> GuiBaoCaoThang(string to, string tenNhanVien, object data)
        {
            var subject = $"Báo cáo tháng - {tenNhanVien}";
            var body = EmailTemplates.TaoBaoCaoThang(tenNhanVien, data);
            return await GuiEmail(to, subject, body);
        }
    }
}
