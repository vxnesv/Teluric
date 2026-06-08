import 'package:flutter/foundation.dart';

import 'dart:html' as html;

class ApiConstants {
  static String get _host {
    if (kIsWeb) {
      final String hostname = html.window.location.hostname ?? '127.0.0.1';
      return 'http://$hostname:8000';
    } else {
      return 'http://10.0.2.2:8000';   // Se for no Emulador do Android Studio
    }
  }

  static String get register => '$_host/api/v1/auth/register';
  static String get login => '$_host/api/v1/auth/login';
  static String get me => '$_host/api/v1/auth/me';

  static String get areas => '$_host/api/v1/areas';
  static String get analise => '$_host/api/v1/analise/processar';
  static String get certificados => '$_host/api/v1/certificados';
}

