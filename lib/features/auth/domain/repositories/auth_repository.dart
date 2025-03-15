import 'package:dartz/dartz.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';

abstract class AuthRepository {
  // Autenticación
  Future<Either<Failure, AuthData>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> recoverPassword({required String email});

  // Gestión de tokens
  Future<void> registerFcmToken({required AuthData authData});
  Future<Either<Failure, bool>> validateAuthToken();
  Future<Either<Failure, AuthData?>> getCurrentAuthData();

  // Estado de autenticación
  Future<Either<Failure, bool>> isAuthenticated();
}
