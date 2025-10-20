import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(UngDungDiemDanh(prefs: prefs));
}

class UngDungDiemDanh extends StatelessWidget {
  final SharedPreferences prefs;

  const UngDungDiemDanh({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo services
    final apiService = ApiService();
    final authService = AuthService(apiService, prefs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService)..add(CheckAuthStatus()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Điểm Danh Nhân Viên',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

