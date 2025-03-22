import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/core/usecases/usecase.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/repositories/register_notification_repository.dart';

class GetActiveNotifications
    implements
        UseCase<List<RegisterNotification>, GetActiveNotificationsParams> {
  // Atributo
  final RegisterNotificationRepository registerNotificationRepository;

  // Constructor
  GetActiveNotifications(this.registerNotificationRepository);

  @override
  Future<Either<Failure, List<RegisterNotification>>> call(
    GetActiveNotificationsParams params,
  ) async {
    return await registerNotificationRepository.getActiveNotifications(
      page: params.page,
      perPage: params.perPage,
    );
  }
}

// Parámetros de entrada
class GetActiveNotificationsParams extends Equatable {
  final int page;
  final int perPage;

  const GetActiveNotificationsParams({this.page = 1, this.perPage = 10});

  @override
  List<Object> get props => [page, perPage];
}
