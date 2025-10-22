import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../screens/auth/man_hinh_dang_nhap.dart';
import '../screens/main_man_hinh.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isLoginPage = state.matchedLocation == '/login';

        // Nếu đang loading, giữ nguyên trang hiện tại
        if (authState is AuthLoading) {
          return null;
        }

        // Nếu chưa đăng nhập và không ở trang login, redirect về login
        if (authState is AuthUnauthenticated && !isLoginPage) {
          return '/login';
        }

        // Nếu đã đăng nhập và đang ở trang login, redirect về home
        if (authState is AuthAuthenticated && isLoginPage) {
          if (authState.user.isAdmin) {
            return '/admin/dashboard';
          } else {
            return '/employee/home';
          }
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(context.read<AuthBloc>().stream),
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

  // Legacy static router for compatibility
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

// Helper class để refresh GoRouter khi AuthBloc state thay đổi
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (AuthState _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

