import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/exceptions.dart';

@immutable
abstract class Failure extends Equatable {
  final String message;
  final String code;
  final DateTime timestamp;

  Failure({
    required this.message,
    this.code = 'GENERIC_ERROR',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  List<Object> get props => [message, code, timestamp];
}

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({
    required super.message,
    this.statusCode,
    super.code = 'SERVER_ERROR',
  });
}

class AuthFailure extends Failure {
  final AuthErrorType type;

  AuthFailure({
    required super.message,
    required this.type,
    super.code = 'AUTH_ERROR',
  });
}

class NetworkFailure extends Failure {
  NetworkFailure()
    : super(message: 'No hay conexión a internet', code: 'NETWORK_UNAVAILABLE');
}

class CacheFailure extends Failure {
  final String operation;
  final String storageType;

  CacheFailure({
    required super.message,
    required this.operation,
    required this.storageType,
  }) : super(code: 'CACHE_ERROR');

  factory CacheFailure.fromException(CacheException e) {
    return CacheFailure(
      message: e.message,
      operation: e.operation,
      storageType: e.storageType,
    );
  }
}
