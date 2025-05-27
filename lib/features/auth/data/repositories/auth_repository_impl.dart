import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/exceptions.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/core/network/network_info.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepositoryImpl implements AuthRepository {
  // A T R I B U T O S
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final FirebaseMessaging firebaseMessaging;

  // C O N S T R U C T O R
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.firebaseMessaging,
  });

  // ---------------------------------------------------------------------------
  // M E T O D O S

  // 1. Iniciar Sesión
  @override
  Future<Either<Failure, AuthData>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Verificar conexión a internet
    if (await networkInfo.isConnected()) {
      try {
        // O N L I N E
        // Mandamos la petición al servidor usando el remoteDataSource
        // y esperamos la respuesta la cual es un authData que contiene esta información
        // userId: '1'
        // token: '1111'
        // expirationDate: DateTime.now()
        final authData = await remoteDataSource.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        await localDataSource.cacheAuthData(authData);

        final actualAuthData = await localDataSource.getCachedAuthData();
        await registerFcmToken(authData: actualAuthData);

        return Right(actualAuthData);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: _mapAuthError(e.type), type: e.type));
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: _mapServerError(e), statusCode: e.statusCode),
        );
      } on CacheException catch (e) {
        return Left(
          CacheFailure(
            message: e.message,
            operation: e.operation,
            storageType: e.storageType,
          ),
        );
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthData?>> getCurrentAuthData() async {
    try {
      final authData = await localDataSource.getCachedAuthData();
      return Right(authData);
    } on CacheException {
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Error obteniendo credenciales',
          operation: 'get',
          storageType: 'local',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> validateAuthToken() async {
    final authData = await localDataSource.getCachedAuthData();

    final isValid = authData.expirationDate.isAfter(DateTime.now());
    if (!isValid) await localDataSource.clearAuthData();

    return Right(isValid);
  }

  @override
  Future<Either<Failure, void>> recoverPassword({required String email}) {
    // TODO: implement recoverPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> registerFcmToken({required AuthData authData}) async {
    try {
      final fcmToken = await firebaseMessaging.getToken();
      if (fcmToken != null) {
        final deviceType = await getDeviceType();
        await remoteDataSource.registerFcmToken(
          userId: authData.userId,
          fcmToken: fcmToken,
          deviceType: deviceType,
          authToken: authData.token,
        );
      }
    } on ServerException catch (e) {
      throw ServerFailure(
        message: 'Error registrando dispositivo',
        statusCode: e.statusCode,
      );
    }
  }
}

// Métodos auxiliares de mapeo
String _mapAuthError(AuthErrorType type) {
  return switch (type) {
    AuthErrorType.invalidCredentials => 'Credenciales incorrectas',
    AuthErrorType.tokenExpired => 'Sesión expirada',
    AuthErrorType.unauthorized => 'Acceso no autorizado',
    AuthErrorType.accountLocked => 'Cuenta bloqueada',
    AuthErrorType.userNotFound => 'Usuario no encontrado',
  };
}

String _mapServerError(ServerException e) {
  return switch (e.errorCode) {
    'INVALID_REQUEST' => 'Solicitud inválida',
    'RATE_LIMITED' => 'Demasiados intentos, intente más tarde',
    _ => 'Error del servidor (${e.statusCode})',
  };
}

Future<String> getDeviceType() async {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'iOS';
  }
  return 'Unknown';
}
