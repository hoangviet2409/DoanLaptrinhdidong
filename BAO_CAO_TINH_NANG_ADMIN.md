# 📊 Báo cáo Tính năng Admin - Chi tiết

## 🎯 Checklist Tính năng Admin

### 1. ✅ Dashboard Tổng quan (HOÀN THÀNH)

#### Backend API
```
✅ GET /api/DiemDanh/dashboard-admin
   - Tổng nhân viên
   - Nhân viên đang làm việc
   - Nhân viên chưa điểm danh
   - Tỷ lệ chuyên cần
   - Giờ làm trung bình
   - Thống kê 7 ngày
```

#### Flutter Screen
```
✅ man_hinh_tong_quan_admin.dart
   - Hiển thị thống kê tổng quan
   - Cards với số liệu
   - Danh sách nhân viên đang làm
   - Danh sách nhân viên chưa điểm danh
   - Thống kê theo ngày (7 ngày)
```

#### Trạng thái: ✅ **HOÀN THÀNH 100%**
- Backend: Done (đã fix bug Average())
- Flutter: Done
- Integration: Done

---

### 2. ✅ Quản lý Nhân viên (HOÀN THÀNH)

#### Backend APIs
```
✅ GET    /api/NhanVien                     - Danh sách (có phân trang)
✅ GET    /api/NhanVien/{id}                - Chi tiết theo ID
✅ GET    /api/NhanVien/ma/{maNhanVien}     - Chi tiết theo Mã
✅ POST   /api/NhanVien                     - Thêm nhân viên
✅ PUT    /api/NhanVien/{id}                - Cập nhật thông tin
✅ DELETE /api/NhanVien/{id}                - Xóa nhân viên
✅ PUT    /api/NhanVien/{id}/trang-thai     - Đóng/Mở tài khoản
✅ PUT    /api/NhanVien/{id}/dang-ky-sinh-trac-hoc  - Đăng ký biometric
```

#### Flutter Screens
```
✅ man_hinh_quan_ly_user.dart            - Danh sách nhân viên
✅ man_hinh_tao_nhan_vien.dart           - Form thêm mới
✅ man_hinh_chinh_sua_nhan_vien.dart     - Form chỉnh sửa
✅ man_hinh_chi_tiet_nhan_vien.dart      - Xem chi tiết
✅ man_hinh_quan_ly_nhan_vien_admin.dart - Quản lý tổng quan
```

#### Trạng thái: ✅ **HOÀN THÀNH 100%**
- Backend: Done (8 APIs)
- Flutter: Done (5 screens)
- Chức năng:
  - ✅ Thêm nhân viên mới
  - ✅ Sửa thông tin
  - ✅ Xóa nhân viên
  - ✅ Đóng/Mở tài khoản
  - ✅ Tìm kiếm
  - ✅ Xem chi tiết

---

### 3. ✅ Chấm công Thủ công (HOÀN THÀNH)

#### Backend API
```
✅ POST /api/DiemDanh/cham-cong-thu-cong
   - Chấm công cho nhân viên
   - Chọn ngày, giờ vào, giờ ra
   - Ghi chú lý do
   - Lưu ID admin

✅ PUT /api/DiemDanh/{id}
   - Chỉnh sửa điểm danh

✅ DELETE /api/DiemDanh/{id}
   - Xóa bản ghi điểm danh
```

#### Flutter Screen
```
⚠️ CẦN KIỂM TRA: Có trong man_hinh_quan_ly_user.dart?
   - Form chấm công thủ công
   - DatePicker chọn ngày
   - TimePicker chọn giờ vào/ra
   - TextField ghi chú
```

#### Trạng thái: ⚠️ **90% HOÀN THÀNH**
- Backend: Done (3 APIs)
- Flutter: Cần kiểm tra màn hình chấm công

---

### 4. ✅ Báo cáo (HOÀN THÀNH)

#### Backend APIs
```
✅ GET /api/BaoCao/tuan      - Báo cáo tuần
✅ GET /api/BaoCao/thang     - Báo cáo tháng
✅ GET /api/BaoCao/quy       - Báo cáo quý
✅ GET /api/BaoCao/nam       - Báo cáo năm
⚠️ POST /api/BaoCao/gui-email - Gửi email (có API, chưa test)
```

#### Flutter Screens
```
✅ man_hinh_bao_cao_tuan.dart    - Báo cáo tuần
✅ man_hinh_bao_cao_thang.dart   - Báo cáo tháng
✅ man_hinh_bao_cao_quy.dart     - Báo cáo quý
✅ man_hinh_bao_cao_nam.dart     - Báo cáo năm
```

#### Trạng thái: ✅ **95% HOÀN THÀNH**
- Backend: Done (5 APIs)
- Flutter: Done (4 screens)
- Gửi email: Có API, chưa test SMTP

---

### 5. ⚠️ Tính Lương (CẦN PHÁT TRIỂN FLUTTER)

#### Backend APIs
```
✅ POST   /api/Luong/tinh-luong              - Tính lương
✅ GET    /api/Luong/lich-su/{nhanVienId}    - Lịch sử lương
✅ PUT    /api/Luong/{id}                    - Cập nhật (thưởng/phạt)
✅ POST   /api/Luong/tao-bang-luong-thang    - Tạo bảng lương tháng
✅ GET    /api/Luong/{id}                    - Chi tiết bảng lương
✅ DELETE /api/Luong/{id}                    - Xóa bảng lương
```

#### Flutter Screen
```
❌ CHƯA CÓ: man_hinh_tinh_luong_admin.dart
   Cần:
   - Form tính lương
   - Chọn kỳ lương (tuần/tháng)
   - Chọn nhân viên
   - Hiển thị kết quả
   - Danh sách bảng lương
   - Chỉnh sửa thưởng/phạt
```

#### Trạng thái: ⚠️ **50% HOÀN THÀNH**
- Backend: Done (6 APIs) ✅
- Flutter: **CHƯA CÓ SCREEN** ❌

---

### 6. ⚠️ Gửi Email Báo cáo (CẦN TEST & FLUTTER)

#### Backend
```
✅ EmailService.cs - Đã có
✅ EmailTemplates.cs - Đã có templates HTML
⚠️ SMTP Configuration - Cần config trong appsettings.json
⏳ Hangfire - Đang tắt (cần bật cho auto email)
```

#### APIs
```
✅ POST /api/BaoCao/gui-email
   - Gửi báo cáo qua email
   - Chọn loại báo cáo
   - Chọn nhân viên
```

#### Flutter Screen
```
❌ CHƯA CÓ: man_hinh_gui_email_admin.dart
   Cần:
   - Form gửi email
   - Chọn nhân viên
   - Chọn loại báo cáo
   - Preview email
   - Gửi thủ công
```

#### Trạng thái: ⚠️ **60% HOÀN THÀNH**
- Backend: Done (service + API)
- SMTP: Chưa config
- Flutter: **CHƯA CÓ SCREEN**
- Auto email: Chưa bật Hangfire

---

## 📊 Tổng kết Tình trạng

### ✅ Hoàn thành (100%)
1. ✅ Dashboard tổng quan
2. ✅ Quản lý nhân viên (CRUD)
3. ✅ Báo cáo (4 loại)

### ⚠️ Cần hoàn thiện (50-90%)
4. ⚠️ Chấm công thủ công (90% - cần check Flutter)
5. ⚠️ Tính lương (50% - thiếu Flutter screen)
6. ⚠️ Gửi email (60% - thiếu Flutter + config SMTP)

---

## 🚀 Kế hoạch Phát triển

### Phase 1: Flutter Screens còn thiếu (Priority: HIGH)

#### 1.1 Màn hình Chấm công Thủ công
```dart
man_hinh_cham_cong_thu_cong_admin.dart
- Form input:
  - Dropdown chọn nhân viên
  - DatePicker chọn ngày
  - TimePicker chọn giờ vào
  - TimePicker chọn giờ ra
  - TextField ghi chú
- Button Lưu
- Validation
```

#### 1.2 Màn hình Tính Lương
```dart
man_hinh_quan_ly_luong_admin.dart
- Tab 1: Tính lương mới
  - Form:
    - Dropdown kỳ lương (Tuần/Tháng)
    - DatePicker từ ngày - đến ngày
    - Dropdown nhân viên (hoặc tất cả)
    - Button "Tính lương"
  - Hiển thị kết quả:
    - Tổng giờ làm
    - Lương cơ bản
    - Thưởng
    - Phạt
    - Tổng lương
  - Button "Lưu bảng lương"
  
- Tab 2: Danh sách bảng lương
  - List bảng lương đã tạo
  - Filter theo nhân viên, kỳ lương
  - Action: Xem chi tiết, Chỉnh sửa, Xóa
  
- Tab 3: Chỉnh sửa bảng lương
  - Form:
    - Thêm/sửa thưởng
    - Thêm/sửa phạt
    - Ghi chú
  - Button "Cập nhật"
```

#### 1.3 Màn hình Gửi Email
```dart
man_hinh_gui_email_admin.dart
- Form:
  - Dropdown chọn loại báo cáo
    - Báo cáo tuần
    - Báo cáo tháng
    - Báo cáo quý
    - Báo cáo năm
  - Multi-select nhân viên
  - Preview email content
- Button "Gửi email"
- Hiển thị trạng thái gửi
- Log lịch sử email đã gửi
```

### Phase 2: Backend Configuration (Priority: MEDIUM)

#### 2.1 SMTP Email Setup
```json
// appsettings.json
{
  "EmailSettings": {
    "SmtpServer": "smtp.gmail.com",
    "SmtpPort": 587,
    "SmtpUsername": "your-email@gmail.com",
    "SmtpPassword": "your-app-password",
    "FromEmail": "noreply@company.com",
    "FromName": "Hệ thống Điểm Danh"
  }
}
```

#### 2.2 Bật Hangfire (Auto Email)
```csharp
// Program.cs - Uncomment lines 74-81
builder.Services.AddHangfire(...);
builder.Services.AddHangfireServer();

// Add recurring jobs
RecurringJob.AddOrUpdate(
    "gui-bao-cao-tuan",
    () => emailService.GuiBaoCaoTuanChoTatCa(),
    Cron.Weekly(DayOfWeek.Sunday, 18)
);
```

### Phase 3: Testing & Polish (Priority: LOW)

#### 3.1 Testing
- Test tất cả admin features
- Test gửi email thực tế
- Test tính lương đúng
- Test chấm công thủ công

#### 3.2 UI/UX Polish
- Thêm loading states
- Error handling
- Success messages
- Confirmation dialogs

---

## 📋 Chi tiết Screen cần tạo

### 1. man_hinh_cham_cong_thu_cong_admin.dart

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManHinhChamCongThuCongAdmin extends StatefulWidget {
  const ManHinhChamCongThuCongAdmin({super.key});

  @override
  State<ManHinhChamCongThuCongAdmin> createState() => 
      _ManHinhChamCongThuCongAdminState();
}

class _ManHinhChamCongThuCongAdminState 
    extends State<ManHinhChamCongThuCongAdmin> {
  
  // Controllers
  final _formKey = GlobalKey<FormState>();
  int? _selectedNhanVienId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _gioVao;
  TimeOfDay? _gioRa;
  final _ghiChuController = TextEditingController();
  
  // State
  bool _isLoading = false;
  List<NhanVienModel> _danhSachNhanVien = [];
  
  @override
  void initState() {
    super.initState();
    _loadDanhSachNhanVien();
  }
  
  Future<void> _loadDanhSachNhanVien() async {
    // Load từ API
  }
  
  Future<void> _chamCongThuCong() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Call API /api/DiemDanh/cham-cong-thu-cong
      final request = {
        'nhanVienId': _selectedNhanVienId,
        'ngay': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'gioVao': _gioVao != null 
            ? DateTime(_selectedDate.year, _selectedDate.month, 
                _selectedDate.day, _gioVao!.hour, _gioVao!.minute)
                .toIso8601String()
            : null,
        'gioRa': _gioRa != null
            ? DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, _gioRa!.hour, _gioRa!.minute)
                .toIso8601String()
            : null,
        'ghiChu': _ghiChuController.text,
        'phuongThucVao': 'ThuCong',
      };
      
      // TODO: Implement API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chấm công thành công')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chấm Công Thủ Công'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Dropdown chọn nhân viên
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Nhân viên',
                border: OutlineInputBorder(),
              ),
              value: _selectedNhanVienId,
              items: _danhSachNhanVien.map((nv) {
                return DropdownMenuItem(
                  value: nv.id,
                  child: Text('${nv.maNhanVien} - ${nv.hoTen}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedNhanVienId = value),
              validator: (value) => 
                  value == null ? 'Vui lòng chọn nhân viên' : null,
            ),
            
            const SizedBox(height: 16),
            
            // DatePicker chọn ngày
            ListTile(
              title: const Text('Ngày'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // TimePicker giờ vào
            ListTile(
              title: const Text('Giờ vào'),
              subtitle: Text(_gioVao?.format(context) ?? 'Chưa chọn'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _gioVao ?? const TimeOfDay(hour: 8, minute: 0),
                );
                if (picked != null) {
                  setState(() => _gioVao = picked);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // TimePicker giờ ra
            ListTile(
              title: const Text('Giờ ra'),
              subtitle: Text(_gioRa?.format(context) ?? 'Chưa chọn'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _gioRa ?? const TimeOfDay(hour: 17, minute: 0),
                );
                if (picked != null) {
                  setState(() => _gioRa = picked);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // TextField ghi chú
            TextFormField(
              controller: _ghiChuController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
                hintText: 'Lý do chấm công thủ công...',
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // Button Lưu
            ElevatedButton(
              onPressed: _isLoading ? null : _chamCongThuCong,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Lưu Chấm Công'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _ghiChuController.dispose();
    super.dispose();
  }
}
```

### 2. man_hinh_quan_ly_luong_admin.dart

```dart
import 'package:flutter/material.dart';

class ManHinhQuanLyLuongAdmin extends StatefulWidget {
  const ManHinhQuanLyLuongAdmin({super.key});

  @override
  State<ManHinhQuanLyLuongAdmin> createState() => 
      _ManHinhQuanLyLuongAdminState();
}

class _ManHinhQuanLyLuongAdminState extends State<ManHinhQuanLyLuongAdmin>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Lương'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tính Lương', icon: Icon(Icons.calculate)),
            Tab(text: 'Danh Sách', icon: Icon(Icons.list)),
            Tab(text: 'Chỉnh Sửa', icon: Icon(Icons.edit)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabTinhLuong(),
          _buildTabDanhSach(),
          _buildTabChinhSua(),
        ],
      ),
    );
  }
  
  Widget _buildTabTinhLuong() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Form tính lương
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kỳ lương',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Tuan', child: Text('Tuần')),
                    DropdownMenuItem(value: 'Thang', child: Text('Tháng')),
                  ],
                  onChanged: (value) {},
                ),
                // TODO: Thêm các fields khác
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabDanhSach() {
    return ListView(
      children: [
        // Danh sách bảng lương
      ],
    );
  }
  
  Widget _buildTabChinhSua() {
    return ListView(
      children: [
        // Form chỉnh sửa
      ],
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
```

### 3. man_hinh_gui_email_admin.dart

```dart
import 'package:flutter/material.dart';

class ManHinhGuiEmailAdmin extends StatefulWidget {
  const ManHinhGuiEmailAdmin({super.key});

  @override
  State<ManHinhGuiEmailAdmin> createState() => _ManHinhGuiEmailAdminState();
}

class _ManHinhGuiEmailAdminState extends State<ManHinhGuiEmailAdmin> {
  String? _loaiBaoCao;
  List<int> _selectedNhanVienIds = [];
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi Email Báo Cáo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Form gửi email
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Loại báo cáo',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'tuan', child: Text('Báo cáo tuần')),
              DropdownMenuItem(value: 'thang', child: Text('Báo cáo tháng')),
              DropdownMenuItem(value: 'quy', child: Text('Báo cáo quý')),
              DropdownMenuItem(value: 'nam', child: Text('Báo cáo năm')),
            ],
            onChanged: (value) => setState(() => _loaiBaoCao = value),
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: _guiEmail,
            child: const Text('Gửi Email'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _guiEmail() async {
    // Implement
  }
}
```

---

## 🎯 Ưu tiên Thực hiện

### Sprint 1 (Tuần này)
1. ✅ Fix bug Dashboard (DONE)
2. 🔨 Tạo màn hình Chấm công thủ công
3. 🔨 Tạo màn hình Tính lương (cơ bản)

### Sprint 2 (Tuần sau)
4. 🔨 Hoàn thiện màn hình Tính lương (đầy đủ)
5. 🔨 Tạo màn hình Gửi email
6. ⚙️ Config SMTP email

### Sprint 3 (Tuần sau nữa)
7. 🧪 Test tất cả features
8. 🎨 Polish UI/UX
9. 📖 Update documentation

---

**📅 Ngày tạo**: 22/10/2025  
**👨‍💻 Team**: NHViet Development  
**⭐ Status**: In Progress

