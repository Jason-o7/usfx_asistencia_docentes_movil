import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/exceptions.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/features/auth/domain/repositories/auth_repository.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/data/datasources/register_notification_remote_data_source.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/repositories/register_notification_repository.dart';

class RegisterNotificationRepositoryImpl
    implements RegisterNotificationRepository {
  final RegisterNotificationRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  RegisterNotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, List<RegisterNotification>>> getActiveNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      // 1. Obtener credenciales
      final authResult = await authRepository.getCurrentAuthData();
      return authResult.fold((failure) => Left(failure), (authData) async {
        if (authData == null) {
          return Left(
            AuthFailure(
              type: AuthErrorType.unauthorized,
              message: 'No autorizado',
            ),
          );
        }

        // 2. Obtener notificaciones
        final notifications = await remoteDataSource.getNotifications(
          teacherId: authData.userId,
          authToken: authData.token,
          page: page,
          perPage: perPage,
        );

        return Right(notifications.map((model) => model.toEntity()).toList());
      });
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          code: 'SERVER_ERROR_${e.statusCode}',
        ),
      );
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Error de comunicación con el servidor',
          statusCode: e.response?.statusCode,
          code: 'DIO_ERROR',
        ),
      );
    }
  }
}
