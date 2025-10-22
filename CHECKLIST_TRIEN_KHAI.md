# ✅ Checklist Triển khai - Ứng dụng Điểm Danh

## 🎯 Mục tiêu: Deploy Production trong 2-4 tuần

---

## 📋 PHASE 1: TESTING & BUG FIXES (Tuần 1)

### Backend Testing

- [ ] **Test Authentication**
  - [ ] Login admin thành công
  - [ ] Login nhân viên thành công
  - [ ] Token expiry hoạt động đúng
  - [ ] Biometric authentication work
  - [ ] Logout clear session

- [ ] **Test Employee Management**
  - [ ] Thêm nhân viên mới
  - [ ] Cập nhật thông tin nhân viên
  - [ ] Đóng/Mở tài khoản
  - [ ] Xóa nhân viên
  - [ ] Search & filter works
  - [ ] Xem chi tiết nhân viên

- [ ] **Test Attendance**
  - [ ] Điểm danh vào thành công
  - [ ] Điểm danh ra thành công
  - [ ] Không thể điểm danh 2 lần
  - [ ] Chấm công thủ công (admin)
  - [ ] Lịch sử điểm danh hiển thị đúng
  - [ ] Thống kê giờ làm chính xác

- [ ] **Test Reports**
  - [ ] Báo cáo tuần chính xác
  - [ ] Báo cáo tháng chính xác
  - [ ] Báo cáo quý chính xác
  - [ ] Báo cáo năm chính xác
  - [ ] Thống kê: giờ làm, đi muộn, về sớm đúng
  - [ ] Filter theo nhân viên works

- [ ] **Test Salary**
  - [ ] Tính lương tuần đúng công thức
  - [ ] Tính lương tháng đúng công thức
  - [ ] Thưởng/Phạt tính đúng
  - [ ] Lịch sử lương hiển thị đầy đủ
  - [ ] Chỉnh sửa bảng lương hoạt động

- [ ] **Test Email**
  - [ ] Gửi email báo cáo thành công
  - [ ] Email template hiển thị đẹp
  - [ ] Lưu log email đúng

### Flutter Testing

- [ ] **Test Login**
  - [ ] Login admin
  - [ ] Login employee
  - [ ] Remember me works
  - [ ] Logout works
  - [ ] Token refresh automatic

- [ ] **Test Employee Screens**
  - [ ] Home screen hiển thị đúng
  - [ ] Điểm danh vào/ra works
  - [ ] Biometric popup khi điểm danh
  - [ ] Lịch sử điểm danh load đúng
  - [ ] Profile screen đầy đủ

- [ ] **Test Admin Screens**
  - [ ] Dashboard hiển thị stats
  - [ ] Quản lý nhân viên CRUD works
  - [ ] Chấm công thủ công works
  - [ ] Báo cáo 4 loại hiển thị
  - [ ] Charts/graphs render

- [ ] **Test Permissions**
  - [ ] Employee không vào được admin screens
  - [ ] Admin có full access
  - [ ] Biometric permission request

### Cross-platform Testing

- [ ] **Android**
  - [ ] Test trên emulator
  - [ ] Test trên thiết bị thật
  - [ ] Biometric works (fingerprint)
  - [ ] GPS permission works
  - [ ] Camera permission works

- [ ] **iOS** (nếu có)
  - [ ] Test trên simulator
  - [ ] Test trên thiết bị thật
  - [ ] Face ID works
  - [ ] GPS permission works
  - [ ] Camera permission works

### Bug Fixing

- [ ] Fix tất cả bugs phát hiện
- [ ] Test lại sau khi fix
- [ ] Document known issues

---

## 🔧 PHASE 2: CONFIGURATION (Tuần 1-2)

### Backend Configuration

- [ ] **Database Production**
  - [ ] Cài SQL Server trên production server
  - [ ] Tạo database
  - [ ] Run migrations
  - [ ] Backup strategy setup
  - [ ] Set retention policy

- [ ] **appsettings.json Production**
  ```json
  - [ ] Update ConnectionString
  - [ ] Update JWT SecretKey (strong key)
  - [ ] Update EmailSettings (SMTP)
  - [ ] Update Issuer/Audience
  - [ ] Set ExpiryMinutes appropriate
  ```

- [ ] **Email Configuration**
  - [ ] Tạo Gmail app password
  - [ ] Test gửi email thực tế
  - [ ] Verify email template render
  - [ ] Check spam folder

- [ ] **Hangfire (Optional)**
  - [ ] Uncomment Hangfire code in Program.cs
  - [ ] Add recurring jobs
  - [ ] Test background jobs
  - [ ] Setup Hangfire dashboard

- [ ] **Security**
  - [ ] Enable HTTPS
  - [ ] Configure CORS properly (không dùng AllowAll)
  - [ ] Add rate limiting (optional)
  - [ ] Setup firewall rules

- [ ] **Logging**
  - [ ] Verify Serilog writing to file
  - [ ] Setup log rotation
  - [ ] Configure log levels
  - [ ] Setup monitoring (optional)

### Flutter Configuration

- [ ] **API URLs**
  - [ ] Update constants.dart với production URL
  - [ ] Test connectivity
  - [ ] Handle HTTPS certificates

- [ ] **Firebase (Optional)**
  - [ ] Create Firebase project
  - [ ] Download google-services.json (Android)
  - [ ] Download GoogleService-Info.plist (iOS)
  - [ ] Add to project
  - [ ] Test push notifications

- [ ] **Build Configuration**
  - [ ] Update app name
  - [ ] Update package name/bundle ID
  - [ ] Set app version
  - [ ] Configure app icons
  - [ ] Configure splash screen

- [ ] **Permissions**
  - [ ] AndroidManifest.xml permissions
  - [ ] Info.plist permissions (iOS)
  - [ ] Runtime permission handling

---

## 🚀 PHASE 3: DEPLOYMENT (Tuần 2-3)

### Backend Deployment

- [ ] **Choose Hosting**
  - [ ] VPS (DigitalOcean, Linode, Vultr)
  - [ ] Cloud (Azure, AWS)
  - [ ] Shared hosting
  
- [ ] **Server Setup**
  - [ ] Install .NET 8 Runtime
  - [ ] Install SQL Server
  - [ ] Configure IIS/Nginx
  - [ ] Setup SSL certificate (Let's Encrypt)
  - [ ] Configure domain/subdomain

- [ ] **Deploy Backend**
  ```bash
  - [ ] dotnet publish -c Release
  - [ ] Upload files to server
  - [ ] Configure web server
  - [ ] Test API endpoints
  - [ ] Verify database connection
  ```

- [ ] **Post-deployment**
  - [ ] Test all APIs từ production URL
  - [ ] Check logs
  - [ ] Monitor performance
  - [ ] Setup backup cron job

### Flutter Deployment

- [ ] **Build Android APK**
  ```bash
  - [ ] flutter build apk --release
  - [ ] Test APK trên thiết bị
  - [ ] Verify biometric works
  - [ ] Verify API connection
  ```

- [ ] **Build Android App Bundle (AAB)** - Nếu lên Play Store
  ```bash
  - [ ] Generate signing key
  - [ ] Configure key.properties
  - [ ] flutter build appbundle --release
  - [ ] Test internal release
  ```

- [ ] **Build iOS** (nếu cần)
  ```bash
  - [ ] Setup Apple Developer account
  - [ ] Configure signing
  - [ ] flutter build ios --release
  - [ ] Test on TestFlight
  ```

- [ ] **Distribution**
  - [ ] Direct APK download link
  - [ ] Google Play Store (optional)
  - [ ] Apple App Store (optional)
  - [ ] MDM/Enterprise distribution

---

## 👥 PHASE 4: USER TRAINING (Tuần 3)

### Documentation

- [ ] **User Manual - Admin**
  - [ ] How to login
  - [ ] How to add employees
  - [ ] How to edit/delete
  - [ ] How to manual attendance
  - [ ] How to view reports
  - [ ] How to send email reports
  - [ ] How to calculate salary

- [ ] **User Manual - Employee**
  - [ ] How to login
  - [ ] How to register biometric
  - [ ] How to check-in/out
  - [ ] How to view attendance history
  - [ ] How to view salary
  - [ ] How to update profile

- [ ] **Quick Reference Guide**
  - [ ] Login credentials format
  - [ ] Troubleshooting common issues
  - [ ] Contact support info
  - [ ] FAQ

### Training Sessions

- [ ] **Admin Training (2 hours)**
  - [ ] System overview
  - [ ] Add first employees
  - [ ] Demo check-in/out
  - [ ] Generate reports
  - [ ] Calculate salary
  - [ ] Q&A session

- [ ] **Employee Training (30 mins)**
  - [ ] Install app
  - [ ] Login first time
  - [ ] Register fingerprint
  - [ ] Practice check-in/out
  - [ ] View history & salary
  - [ ] Q&A session

- [ ] **Create Training Videos**
  - [ ] Screen recording cho admin
  - [ ] Screen recording cho employee
  - [ ] Upload to YouTube/internal

---

## 🎯 PHASE 5: GO LIVE (Tuần 4)

### Pre-launch Checklist

- [ ] **Data Preparation**
  - [ ] Create admin account
  - [ ] Import/Add all employees
  - [ ] Set salary rates
  - [ ] Test with real data

- [ ] **Communication**
  - [ ] Announce launch date
  - [ ] Send installation instructions
  - [ ] Share user manuals
  - [ ] Setup support channel

- [ ] **Monitoring**
  - [ ] Monitor server resources
  - [ ] Check error logs
  - [ ] Monitor API response times
  - [ ] Watch for crashes

### Launch Day

- [ ] **Morning**
  - [ ] Verify all systems up
  - [ ] Send reminder to all users
  - [ ] Be on standby for support

- [ ] **During Day**
  - [ ] Monitor check-ins
  - [ ] Respond to issues quickly
  - [ ] Collect feedback
  - [ ] Fix critical bugs immediately

- [ ] **End of Day**
  - [ ] Review all check-ins/outs
  - [ ] Fix data issues
  - [ ] Note improvements needed
  - [ ] Send thank you message

### Post-launch (Week 1)

- [ ] **Daily Checks**
  - [ ] Monitor attendance
  - [ ] Check for missing check-ins/outs
  - [ ] Review error logs
  - [ ] User feedback review

- [ ] **Weekly Tasks**
  - [ ] Generate first weekly report
  - [ ] Calculate first salary (if weekly)
  - [ ] Survey user satisfaction
  - [ ] Plan improvements

---

## 🔧 MAINTENANCE & SUPPORT

### Daily Tasks

- [ ] Check server uptime
- [ ] Review error logs
- [ ] Monitor database size
- [ ] Respond to user issues

### Weekly Tasks

- [ ] Backup database
- [ ] Review system performance
- [ ] Check disk space
- [ ] Update documentation if needed

### Monthly Tasks

- [ ] Security updates
- [ ] Performance optimization
- [ ] User feedback analysis
- [ ] Plan new features

---

## 📊 SUCCESS METRICS

### Week 1
- [ ] 100% users can login
- [ ] 90%+ check-in success rate
- [ ] 90%+ check-out success rate
- [ ] < 5 critical bugs

### Month 1
- [ ] 95%+ attendance accuracy
- [ ] 100% salary calculated correctly
- [ ] < 2 support tickets per day
- [ ] Positive user feedback (>80%)

### Month 3
- [ ] Full adoption (100% users)
- [ ] < 1 bug per week
- [ ] Self-service support (users help each other)
- [ ] Identify features for v2.0

---

## 🚨 ROLLBACK PLAN

### If Critical Issues

- [ ] **Backup Ready**
  - [ ] Have database backup before launch
  - [ ] Have previous version APK
  - [ ] Document rollback steps

- [ ] **Communication**
  - [ ] Notify users immediately
  - [ ] Explain issue and fix timeline
  - [ ] Provide workaround if possible

- [ ] **Recovery**
  - [ ] Restore database if needed
  - [ ] Deploy fix ASAP
  - [ ] Test thoroughly before re-launch

---

## 📞 SUPPORT CONTACTS

### Technical Issues
- **Developer**: [Your Contact]
- **Server Admin**: [Contact]
- **Database Admin**: [Contact]

### Business Issues
- **HR Manager**: [Contact]
- **IT Manager**: [Contact]

### Emergency
- **24/7 Hotline**: [Phone]
- **Email**: support@company.com

---

## ✅ FINAL CHECKLIST BEFORE GO-LIVE

### Critical (Must Have)
- [ ] ✅ Backend deployed and working
- [ ] ✅ Database migrated and backed up
- [ ] ✅ Flutter APK distributed
- [ ] ✅ Admin account created
- [ ] ✅ All employees added
- [ ] ✅ User training completed
- [ ] ✅ Support channel ready
- [ ] ✅ Rollback plan documented

### Important (Should Have)
- [ ] 📧 Email configured (can do manual)
- [ ] 🔔 Monitoring setup
- [ ] 📖 Documentation complete
- [ ] 🧪 Testing done (90%+)
- [ ] 💾 Backup strategy in place

### Nice to Have (Can Add Later)
- [ ] 🔥 Firebase push notifications
- [ ] 📊 Advanced analytics
- [ ] 📄 Export Excel/PDF
- [ ] 🌐 Web admin panel
- [ ] 🎫 NFC card support

---

**🎉 CHÚC MỪNG! Bạn đã sẵn sàng GO LIVE! 🚀**

**Checklist này giúp:**
- ✅ Không bỏ sót bước nào
- ✅ Track progress rõ ràng
- ✅ Phân công công việc
- ✅ Đảm bảo chất lượng
- ✅ Launch thành công!

---

**📅 Last Updated**: 22/10/2025  
**👨‍💻 Created by**: NHViet Team  
**📧 Questions?** [Contact Support]

