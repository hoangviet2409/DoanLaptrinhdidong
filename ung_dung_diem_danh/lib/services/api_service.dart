import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late final Dio _dio;
  final Logger _logger = Logger();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.requestTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.requestTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Automatically add token from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('REQUEST BODY: ${options.data}');
          _logger.d('REQUEST HEADERS: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    // Bỏ qua SSL certificate validation cho localhost (CHỈ DÙNG CHO DEVELOPMENT)
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  // Set Authorization token
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove Authorization token
  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Allow callers to handle 404 (e.g., treat as "no data")
      if (e.response?.statusCode == 404 && e.response != null) {
        return e.response!;
      }
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.put(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  Exception _handleError(DioException error) {
    String errorMessage = 'Đã xảy ra lỗi không xác định';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Kết nối bị timeout. Vui lòng thử lại.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleResponseError(error.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request đã bị hủy';
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          errorMessage = 'Không có kết nối Internet. Vui lòng kiểm tra lại.';
        } else {
          errorMessage = 'Không thể kết nối đến server';
        }
        break;
      default:
        errorMessage = error.message ?? 'Đã xảy ra lỗi';
    }

    return Exception(errorMessage);
  }

  String _handleResponseError(Response? response) {
    if (response == null) return 'Server không phản hồi';

    switch (response.statusCode) {
      case 400:
        return 'Dữ liệu không hợp lệ';
      case 401:
        return 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
      case 403:
        return 'Bạn không có quyền truy cập';
      case 404:
        return 'Không tìm thấy dữ liệu';
      case 500:
        return 'Lỗi server. Vui lòng thử lại sau.';
      default:
        return 'Đã xảy ra lỗi (${response.statusCode})';
    }
  }
}
