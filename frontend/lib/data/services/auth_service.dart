import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'session_service.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  static const _headers = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 15);

  static Future<UserModel> register({
    required String nome,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.register),
            headers: _headers,
            body: jsonEncode({'nome': nome, 'email': email, 'password': password}),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return UserModel.fromJson(body);
      }

      final detail = body['detail'];
      throw AuthException(
        detail is String ? detail : 'Erro ao cadastrar usuário',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Não foi possível conectar ao servidor');
    }
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.login),
            headers: _headers,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final token = body['access_token'] as String;
        final user = UserModel.fromJson(body['user'] as Map<String, dynamic>);
        await SessionService.saveSession(token, user);
        return user;
      }

      final detail = body['detail'];
      throw AuthException(
        detail is String ? detail : 'Email ou senha inválidos',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Não foi possível conectar ao servidor');
    }
  }

  static Future<void> logout() => SessionService.clearSession();
}
