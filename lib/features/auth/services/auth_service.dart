import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;
  AuthService(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw 'Using wrong credential';
      }
      throw e.response?.data['message'] ??
          e.response?.data['error'] ??
          e.message ??
          'Login failed';
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post(
        '/api/v1/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          e.response?.data['error'] ??
          e.message ??
          'Logout failed';
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'role_names': ['customer'],
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          e.response?.data['error'] ??
          e.message ??
          'Registration failed';
    }
  }
}
