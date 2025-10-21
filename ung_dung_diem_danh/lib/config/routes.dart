import 'package:go_router/go_router.dart';
import '../screens/auth/man_hinh_dang_nhap.dart';
import '../screens/main_man_hinh.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const ManHinhDangNhap(),
          ),
      GoRoute(
        path: '/employee/home',
        name: 'employee_home',
        builder: (context, state) => const MainManHinh(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        name: 'admin_dashboard',
        builder: (context, state) => const MainManHinh(),
      ),
    ],
  );
}

