import 'package:equatable/equatable.dart';
import '../../models/dang_nhap_request.dart';
import '../../models/dang_ky_request.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginAdminRequested extends AuthEvent {
  final DangNhapRequest request;

  const LoginAdminRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class LoginEmployeeRequested extends AuthEvent {
  final DangNhapNhanVienRequest request;

  const LoginEmployeeRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class BiometricAuthRequested extends AuthEvent {
  final DangNhapNhanVienRequest request;

  const BiometricAuthRequested(this.request);

  @override
  List<Object?> get props => [request];
}


class RegisterAdminRequested extends AuthEvent {
  final DangKyRequest request;

  const RegisterAdminRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class RegisterEmployeeRequested extends AuthEvent {
  final DangKyNhanVienRequest request;

  const RegisterEmployeeRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class LogoutRequested extends AuthEvent {}

