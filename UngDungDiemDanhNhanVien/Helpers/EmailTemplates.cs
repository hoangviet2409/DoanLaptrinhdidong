namespace UngDungDiemDanhNhanVien.Helpers
{
    public static class EmailTemplates
    {
        public static string TaoBaoCaoTuan(string tenNhanVien, object data)
        {
            return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Báo cáo tuần</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }}
        .container {{ max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        .header {{ text-align: center; color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 20px; margin-bottom: 30px; }}
        .content {{ line-height: 1.6; color: #34495e; }}
        .footer {{ margin-top: 30px; padding-top: 20px; border-top: 1px solid #ecf0f1; text-align: center; color: #7f8c8d; font-size: 14px; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>📊 Báo cáo tuần</h1>
            <h2>Nhân viên: {tenNhanVien}</h2>
        </div>
        <div class='content'>
            <p>Xin chào <strong>{tenNhanVien}</strong>,</p>
            <p>Đây là báo cáo tuần của bạn:</p>
            <ul>
                <li>📅 Tuần: {DateTime.Now.AddDays(-7):dd/MM/yyyy} - {DateTime.Now:dd/MM/yyyy}</li>
                <li>⏰ Tổng giờ làm: [Sẽ được cập nhật]</li>
                <li>📈 Số ngày làm việc: [Sẽ được cập nhật]</li>
                <li>🏠 Số ngày nghỉ: [Sẽ được cập nhật]</li>
            </ul>
            <p>Cảm ơn bạn đã làm việc chăm chỉ trong tuần qua!</p>
        </div>
        <div class='footer'>
            <p>Hệ thống điểm danh nhân viên</p>
            <p>Email này được gửi tự động, vui lòng không trả lời.</p>
        </div>
    </div>
</body>
</html>";
        }

        public static string TaoBaoCaoThang(string tenNhanVien, object data)
        {
            return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Báo cáo tháng</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }}
        .container {{ max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        .header {{ text-align: center; color: #2c3e50; border-bottom: 2px solid #e74c3c; padding-bottom: 20px; margin-bottom: 30px; }}
        .content {{ line-height: 1.6; color: #34495e; }}
        .stats {{ background-color: #ecf0f1; padding: 20px; border-radius: 5px; margin: 20px 0; }}
        .footer {{ margin-top: 30px; padding-top: 20px; border-top: 1px solid #ecf0f1; text-align: center; color: #7f8c8d; font-size: 14px; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>📈 Báo cáo tháng</h1>
            <h2>Nhân viên: {tenNhanVien}</h2>
        </div>
        <div class='content'>
            <p>Xin chào <strong>{tenNhanVien}</strong>,</p>
            <p>Đây là báo cáo tháng của bạn:</p>
            <div class='stats'>
                <h3>📊 Thống kê tháng {DateTime.Now.Month}/{DateTime.Now.Year}</h3>
                <ul>
                    <li>⏰ Tổng giờ làm: [Sẽ được cập nhật]</li>
                    <li>💰 Lương dự kiến: [Sẽ được cập nhật]</li>
                    <li>📅 Số ngày làm việc: [Sẽ được cập nhật]</li>
                    <li>🏠 Số ngày nghỉ: [Sẽ được cập nhật]</li>
                    <li>⏰ Giờ làm trung bình/ngày: [Sẽ được cập nhật]</li>
                </ul>
            </div>
            <p>Chi tiết từng ngày sẽ được cập nhật trong hệ thống.</p>
            <p>Cảm ơn bạn đã làm việc chăm chỉ trong tháng qua!</p>
        </div>
        <div class='footer'>
            <p>Hệ thống điểm danh nhân viên</p>
            <p>Email này được gửi tự động, vui lòng không trả lời.</p>
        </div>
    </div>
</body>
</html>";
        }
    }
}
