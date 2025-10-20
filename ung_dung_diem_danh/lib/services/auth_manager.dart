import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import 'auth_service.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  /// Xử lý lỗi 401 - Token hết hạn
  static Future<void> handleTokenExpired(BuildContext context) async {
    try {
      // Clear all stored data
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      await authService.dangXuat();
      
      // Dispatch logout event to clear auth state
      if (context.mounted) {
        context.read<AuthBloc>().add(LogoutRequested());
      }
      
      // Show message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // If there's an error during logout, still try to clear the state
      if (context.mounted) {
        context.read<AuthBloc>().add(LogoutRequested());
      }
    }
  }

  /// Kiểm tra và xử lý lỗi authentication
  static Future<bool> handleAuthError(BuildContext context, dynamic error) async {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      
      if (statusCode == 401) {
        await handleTokenExpired(context);
        return true; // Error was handled
      }
    }
    
    return false; // Error was not handled
  }
}
