// lib/config.dart

enum Environment { emulator, phisic, production }

class ApiConfig {
  static Environment environment = Environment.emulator;

  static String get baseUrl {
    switch (environment) {
      case Environment.emulator:
        return 'http://10.0.2.2:8080'; // emulator
      case Environment.phisic:
        return 'http://192.168.1.13:8080'; // phisic
      case Environment.production:
        return 'https://3f7b-37-182-179-83.ngrok-free.app'; // Produzione
    }
  }

  static String get allEndpoint => '$baseUrl/all/';
  static String get userEndpoint => '$baseUrl/user/';
  static String get adminEndpoint => '$baseUrl/admin/';
  static String get addUserEndpoint => '$baseUrl/addUser';
  static String get loginEndpoint => '$baseUrl/login';
  static String get forgotPasswordEndpoint => '$baseUrl/forgotPassword';

}