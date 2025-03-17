import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/core/usecases/usecase.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailAndPasswordUseCase
    implements UseCase<AuthData, SignInParams> {
  // A T R I B U T O S
  final AuthRepository repository;

  // C O N S T R U C T O R
  SignInWithEmailAndPasswordUseCase(this.repository);

  // M E T O D O S
  @override
  Future<Either<Failure, AuthData>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

// Parámetros de entrada
class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
