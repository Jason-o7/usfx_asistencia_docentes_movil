import 'package:dartz/dartz.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';

abstract class RegisterNotificationRepository {
  // Notificaciones para el menú desplegable del ícono de notificaciones
  Future<Either<Failure, List<RegisterNotification>>> getActiveNotifications({
    int page,
    int perPage,
  });

  // TODO implementar más métodos de notificaciones de registro
}
