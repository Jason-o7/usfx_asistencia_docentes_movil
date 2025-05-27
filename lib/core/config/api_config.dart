class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://10.0.2.2:5000';
  // static const String baseUrl = 'https://hsqlmjx0-5000.brs.devtunnels.ms';

  // Auth endpoints
  static const String signIn = '$baseUrl/frav1/mdl/signIn';
  static const String signOut = '$baseUrl/frav1/mdl/signOut';
  static const String recoverPassword = '$baseUrl/frav1/mdl/recoverPassword';

  // User endpoints
  static const String registerDevice = '$baseUrl/frav1/mdl/users/devices';
}
