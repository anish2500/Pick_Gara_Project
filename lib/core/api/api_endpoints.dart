import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static final String baseUrl = kIsWeb
      ? 'http://localhost:4000/api'
      : 'http://10.0.2.2:4000/api';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String login = '/auth/login';
  static const String register = '/auth/register';
}
