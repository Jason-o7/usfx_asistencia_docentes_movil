class ServerException implements Exception {
  final String message;
  final int statusCode;
  final String? errorCode;
  final DateTime timestamp;

  ServerException({
    required this.message,
    required this.statusCode,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'ServerException[$statusCode](${timestamp.toIso8601String()}): $message';
}

// -----------------------------------------------------------------------------

class AuthException implements Exception {
  final String message;
  final AuthErrorType type;
  final DateTime timestamp;

  AuthException({required this.type, String? message, DateTime? timestamp})
    : message = message ?? _getDefaultMessage(type),
      timestamp = timestamp ?? DateTime.now();

  static String _getDefaultMessage(AuthErrorType type) => switch (type) {
    AuthErrorType.invalidCredentials => 'Credenciales inválidas',
    AuthErrorType.tokenExpired => 'Token expirado',
    AuthErrorType.unauthorized => 'Acceso no autorizado',
    AuthErrorType.accountLocked => 'Cuenta bloqueada',
    AuthErrorType.userNotFound => 'Usuario no encontrado',
  };

  @override
  String toString() =>
      'AuthException[${type.name}](${timestamp.toIso8601String()}): $message';
}

enum AuthErrorType {
  invalidCredentials,
  tokenExpired,
  unauthorized,
  accountLocked,
  userNotFound,
}

// -----------------------------------------------------------------------------

class CacheException implements Exception {
  final String message;
  final String operation;
  final String storageType;
  final DateTime timestamp;

  CacheException({
    required this.message,
    required this.operation,
    required this.storageType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'CacheException[$storageType.$operation](${timestamp.toIso8601String()}): $message';
  }
}

// -----------------------------------------------------------------------------
