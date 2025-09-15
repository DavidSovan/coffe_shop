import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_coffee_shop/features/auth/models/user_model.dart';
import '../services/auth_service.dart';
import 'package:uc_coffee_shop/core/network/dio.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService(DioClient().dio);
  bool _isLoading = false;
  String _errorMessage = '';
  UserModel? _user;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  UserModel? get user => _user;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _authService.login(email, password);
      await _handleAuthResponse(response);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    try {
      final response = await _authService.register(username, email, password);
      await _handleAuthResponse(response);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleAuthResponse(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', response['access_token']);

    _user = UserModel.fromJson(response['user']);
    _user = _user!.copyWith(accessToken: response['access_token']);
    // Store user data if needed
    notifyListeners();
  }

  Future<bool> logout() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null || token.isEmpty) {
        // No token to revoke; ensure local cleanup
        await prefs.remove('access_token');
        return true;
      }
      await _authService.logout(token);
      await prefs.remove('access_token');
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
