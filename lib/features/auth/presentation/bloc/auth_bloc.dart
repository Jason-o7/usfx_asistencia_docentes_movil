import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // A T R I B U T O S
  final SignInWithEmailAndPasswordUseCase signInUseCase;

  // C O N S T R U C T O R
  AuthBloc({required this.signInUseCase}) : super(AuthInitial()) {
    // cuando se reciba el evento SignInRequested, se ejecutará el método _handleSignIn
    on<SignInRequested>(_handleSignIn);
  }

  // M É T O D O S
  FutureOr<void> _handleSignIn(
    // A T R I B U T O S - D E - E N T R A D A
    // Evento que se recibe que tambien contiene los datos de entrada
    SignInRequested event,
    // Estado que sale que tambien contiene los datos de salida
    Emitter<AuthState> emit,
  ) async {
    // Emitir el estado de carga para que la interfaz de usuario muestre un indicador de carga
    emit(AuthLoading());

    // Ejecutar el caso de uso para iniciar sesión
    final result = await signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    // El resultado puede ser exito (authData) o fracaso (failure)
    // Si es exito, se emite el estado Authenticated con los datos de autenticación
    // Si es fracaso, se emite el estado AuthError con el mensaje de error
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (authData) => emit(Authenticated(authData: authData)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return 'Error del servidor (${failure.statusCode})';
    } else if (failure is CacheFailure) {
      return 'Error de almacenamiento local';
    } else if (failure is NetworkFailure) {
      return 'Sin conexión a internet';
    } else {
      return 'Error inesperado';
    }
  }
}
