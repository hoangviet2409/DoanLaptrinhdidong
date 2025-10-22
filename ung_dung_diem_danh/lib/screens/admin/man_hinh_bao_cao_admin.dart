import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'man_hinh_bao_cao_tuan.dart';
import 'man_hinh_bao_cao_thang.dart';
import 'man_hinh_bao_cao_quy.dart';
import 'man_hinh_bao_cao_nam.dart';

/// Màn hình báo cáo thống nhất với TabBar
class ManHinhBaoCaoAdmin extends StatefulWidget {
  const ManHinhBaoCaoAdmin({super.key});

  @override
  State<ManHinhBaoCaoAdmin> createState() => _ManHinhBaoCaoAdminState();
}

class _ManHinhBaoCaoAdminState extends State<ManHinhBaoCaoAdmin> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo & Thống Kê'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.calendar_today, size: 20),
              text: 'Tuần',
            ),
            Tab(
              icon: Icon(Icons.calendar_view_month, size: 20),
              text: 'Tháng',
            ),
            Tab(
              icon: Icon(Icons.calendar_view_week, size: 20),
              text: 'Quý',
            ),
            Tab(
              icon: Icon(Icons.calendar_view_day, size: 20),
              text: 'Năm',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ManHinhBaoCaoTuan(),
          ManHinhBaoCaoThang(),
          ManHinhBaoCaoQuy(),
          ManHinhBaoCaoNam(),
        ],
      ),
    );
  }
}

