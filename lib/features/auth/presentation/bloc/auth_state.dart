import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

// Estado de inicio
class AuthInitial extends AuthState {}

// Estado de carga (se presiono el boton de login)
class AuthLoading extends AuthState {}

// Estado Autenticado (la autenticación fue exitosa)
class Authenticated extends AuthState {
  final AuthData authData;

  Authenticated({required this.authData});

  @override
  List<Object> get props => [authData];
}

// (no se está usando) Estado No Autenticado (la autenticación fue fallida)
class Unauthenticated extends AuthState {}

// Estado de error
class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
