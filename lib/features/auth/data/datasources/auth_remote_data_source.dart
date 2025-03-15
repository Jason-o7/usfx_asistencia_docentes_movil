import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/exceptions.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthData> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> registerFcmToken({
    required String userId,
    required String fcmToken,
    required String deviceType,
  });
  Future<void> signOut({required String token});
  Future<void> recoverPassword({required String email});
  Future<void> validateToken(String token);
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl(this.dio, this.localDataSource);

  @override
  Future<AuthData> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'https://hsqlmjx0-5000.brs.devtunnels.ms/frav1/mdl/signIn',
        data: {'email': email, 'password': password},
      );

      // Verificar el estado de la respuesta
      if (response.data['status'] == 'success') {
        // Éxito: Extraer el token y crear AuthData
        final token = response.data['data']['token'];
        return AuthData(
          userId: _extractUserIdFromToken(token), // Extraer userId del token
          token: token,
          expirationDate: _extractExpirationDateFromToken(
            token,
          ), // Extraer fecha de expiración
        );
      } else if (response.data['status'] == 'error') {
        // Error: Manejar según el mensaje
        final errorMessage = response.data['message'];
        if (errorMessage == 'Contraseña incorrecta.') {
          throw AuthException(
            message: errorMessage,
            type: AuthErrorType.invalidCredentials,
          );
        } else if (errorMessage == 'Error al iniciar sesión.') {
          throw AuthException(
            message: 'Usuario no encontrado',
            type: AuthErrorType.userNotFound,
          );
        } else {
          throw ServerException(
            message: errorMessage,
            statusCode: response.statusCode ?? 500,
          );
        }
      } else {
        // Respuesta inesperada
        throw ServerException(
          message: 'Respuesta inesperada del servidor',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      // Manejar errores de red o del servidor
      throw ServerException(
        message: e.response?.data['message'] ?? 'Error de autenticación',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<void> registerFcmToken({
    required String userId,
    required String fcmToken,
    required String deviceType,
  }) async {
    try {
      final authData = await localDataSource.getCachedAuthData();

      await dio.post(
        'https://hsqlmjx0-5000.brs.devtunnels.ms/frav1/mdl/users/devices',
        data: {
          'id_user': userId,
          'device_token': fcmToken,
          'device_type': deviceType,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authData.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      throw ServerException(
        message: 'Error registrando token FCM: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } on CacheException {
      throw AuthException(
        type: AuthErrorType.unauthorized,
      ); // Ahora usa el mensaje predefinido
    }
  }

  @override
  Future<void> recoverPassword({required String email}) {
    // TODO: implement recoverPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut({required String token}) {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> validateToken(String token) {
    // TODO: implement validateToken
    throw UnimplementedError();
  }
}

String _extractUserIdFromToken(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw const FormatException('Token JWT inválido');
  }

  final payload = parts[1];
  final decodedPayload = base64Url.decode(payload);
  final payloadMap = jsonDecode(utf8.decode(decodedPayload));

  return payloadMap['sub']; // 'sub' es el campo que contiene el userId
}

DateTime _extractExpirationDateFromToken(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw const FormatException('Token JWT inválido');
  }

  final payload = parts[1];
  final decodedPayload = base64Url.decode(payload);
  final payloadMap = jsonDecode(utf8.decode(decodedPayload));

  final expirationTimestamp =
      payloadMap['exp']; // 'exp' es el campo que contiene la fecha de expiración
  return DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);
}
