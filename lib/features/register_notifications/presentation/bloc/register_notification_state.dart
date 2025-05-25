import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/notification_ui.dart';

@immutable
abstract class RegisterNotificationState extends Equatable {
  const RegisterNotificationState();

  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------------------------------------
class RegisterNotificationsClosed extends RegisterNotificationState {
  // Atributo de salida para la interfaz
  final bool hasUnread;
  // Constructor
  const RegisterNotificationsClosed({required this.hasUnread});

  @override
  List<Object> get props => [hasUnread];
}

// -----------------------------------------------------------------------------------------------------------
class RegisterNotificationsLoading extends RegisterNotificationState {}

// -----------------------------------------------------------------------------------------------------------
class RegisterNotificationsOpen extends RegisterNotificationState {
  final List<NotificationUi> notifications;
  final bool hasReachedMax;

  const RegisterNotificationsOpen({
    required this.notifications,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [notifications, hasReachedMax];
}

// -----------------------------------------------------------------------------------------------------------
class RegisterNotificationsError extends RegisterNotificationState {
  final String message;

  const RegisterNotificationsError({required this.message});

  @override
  List<Object> get props => [message];
}
