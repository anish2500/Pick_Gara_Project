import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // true = Emulator, false = Physical Device
  static const bool useEmulator = false;

  static const String _emulator = '10.0.2.2';
  static const String _physical = '192.168.18.4';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:4000/api';
    }
    return useEmulator
        ? 'http://$_emulator:4000/api'
        : 'http://$_physical:4000/api';
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String login = '/auth/login';
  static const String register = '/auth/register';

  static const String rooms = '/rooms';
  static const String places = '/places';

  static String voteForRoom(String roomId) => '/rooms/$roomId/vote';
}
