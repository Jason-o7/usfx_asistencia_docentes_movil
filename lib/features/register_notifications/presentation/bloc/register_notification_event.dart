import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterNotificationEvent extends Equatable {
  const RegisterNotificationEvent();

  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------------------------------------
class ToggleNotifications extends RegisterNotificationEvent {
  final int page;
  final int perPage;

  const ToggleNotifications({this.page = 1, this.perPage = 10});

  @override
  List<Object> get props => [page, perPage];
}

// -----------------------------------------------------------------------------------------------------------
class RefreshNotificationsEvent extends RegisterNotificationEvent {
  const RefreshNotificationsEvent();

  @override
  List<Object> get props => [];
}
