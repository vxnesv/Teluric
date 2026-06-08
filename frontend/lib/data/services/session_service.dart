import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';


class SessionService {
  static const _keyToken = 'auth_token';
  static const _keyUser = 'user_data';

  static String? _token;
  static UserModel? _currentUser;

  static String? get token => _token;
  static UserModel? get currentUser => _currentUser;

  static bool get isAuthenticated => _token != null && _currentUser != null;

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_keyToken);
    final userJson = prefs.getString(_keyUser);
    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
      } catch (_) {
        _currentUser = null;
      }
    }
  }

  /// Persiste o token e o usuário e atualiza a memória.
  static Future<void> saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    _token = token;
    _currentUser = user;
  }

  /// Remove a sessão do disco e da memória (logout).
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    _token = null;
    _currentUser = null;
  }
}
