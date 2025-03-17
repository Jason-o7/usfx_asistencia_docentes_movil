import 'package:usfx_asistencia_docentes_movil/core/errors/exceptions.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheAuthData(AuthData authData);
  Future<AuthData> getCachedAuthData();
  Future<void> clearAuthData();
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _storage = FlutterSecureStorage();
  static const _userIdKey = 'user_id';
  static const _tokenKey = 'auth_token';
  static const _expirationKey = 'expiration_date';

  @override
  Future<void> cacheAuthData(AuthData authData) async {
    try {
      await Future.wait([
        _storage.write(key: _userIdKey, value: authData.userId),
        _storage.write(key: _tokenKey, value: authData.token),
        _storage.write(
          key: _expirationKey,
          value: authData.expirationDate.toIso8601String(),
        ),
      ]);
    } catch (e) {
      throw CacheException(
        message: 'Error guardando datos de sesión',
        operation: 'write',
        storageType: 'SecureStorage',
      );
    }
  }

  @override
  Future<AuthData> getCachedAuthData() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      final token = await _storage.read(key: _tokenKey);
      final expiration = await _storage.read(key: _expirationKey);

      if (userId == null) throw _missingFieldError('user_id');
      if (token == null) throw _missingFieldError('auth_token');
      if (expiration == null) throw _missingFieldError('expiration_date');

      return AuthData(
        userId: userId,
        token: token,
        expirationDate: DateTime.parse(expiration),
      );
    } catch (e) {
      // Manejo mejorado de errores
      if (e is CacheException) rethrow;
      throw CacheException(
        message: 'Error crítico de almacenamiento',
        operation: 'read',
        storageType: 'SecureStorage',
      );
    }
  }

  CacheException _missingFieldError(String field) {
    return CacheException(
      message: 'Campo requerido faltante: $field',
      operation: 'read',
      storageType: 'SecureStorage',
    );
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _storage.delete(key: _userIdKey),
        _storage.delete(key: _tokenKey),
        _storage.delete(key: _expirationKey),
      ]);
    } catch (e) {
      throw CacheException(
        message: 'Error limpiando datos de sesión',
        operation: 'delete',
        storageType: 'SecureStorage',
      );
    }
  }
}
