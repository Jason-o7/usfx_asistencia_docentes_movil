import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/core/errors/failures.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/usecases/get_active_notifications.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_state.dart';

class RegisterNotificationBloc
    extends Bloc<RegisterNotificationEvent, RegisterNotificationState> {
  // TODO añadir el usecase CheckUnreadNotificationsUseCase para ver si hay notificaciones por leer
  final GetActiveNotifications getActiveNotifications;
  // TODO añadir el usecase MarkNotificationsAsReadUseCase para marcar notificaciones como leídas
  static const int _perPage = 10;
  int _currentPage = 1;
  bool _hasReachedMax = false;

  RegisterNotificationBloc({required this.getActiveNotifications})
    : super(RegisterNotificationsClosed(hasUnread: false)) {
    on<ToggleNotifications>(_onToggleNotifications);
    on<RefreshNotificationsEvent>(_onRefreshNotifications);
    // _checkUnreadNotifications();
  }

  // Future<void> _checkUnreadNotifications() async {
  //   final result = await checkUnreadNotifications(NoParams());
  //   result.fold(
  //     (failure) => emit(
  //       RegisterNotificationsError(message: _mapFailureToMessage(failure)),
  //     ),
  //     (hasUnread) => emit(RegisterNotificationsClosed(hasUnread: hasUnread)),
  //   );
  // }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<RegisterNotificationState> emit,
  ) async {
    if (state is RegisterNotificationsOpen) {
      // Cerrar notificaciones
      // await _markNotificationsAsRead();
      emit(RegisterNotificationsClosed(hasUnread: false));
    } else {
      // Abrir notificaciones
      emit(RegisterNotificationsLoading());
      final result = await getActiveNotifications(
        GetActiveNotificationsParams(page: _currentPage, perPage: _perPage),
      );

      result.fold(
        (failure) => emit(
          RegisterNotificationsError(message: _mapFailureToMessage(failure)),
        ),
        (notifications) {
          _hasReachedMax = notifications.length < _perPage;
          emit(
            RegisterNotificationsOpen(
              notifications: notifications,
              hasReachedMax: _hasReachedMax,
            ),
          );
        },
      );
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotificationsEvent event,
    Emitter<RegisterNotificationState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;

    emit(RegisterNotificationsLoading());
    final result = await getActiveNotifications(
      GetActiveNotificationsParams(page: _currentPage, perPage: _perPage),
    );

    result.fold(
      (failure) => emit(
        RegisterNotificationsError(message: _mapFailureToMessage(failure)),
      ),
      (notifications) {
        _hasReachedMax = notifications.length < _perPage;
        emit(
          RegisterNotificationsOpen(
            notifications: notifications,
            hasReachedMax: _hasReachedMax,
          ),
        );
      },
    );
  }

  // Future<void> _markNotificationsAsRead() async {
  // final result = await markNotificationsAsRead(NoParams());
  // result.fold(
  //   (failure) => emit(RegisterNotificationsError(
  //     message: _mapFailureToMessage(failure),
  //   )),
  //   (_) {}, // No hacer nada si tiene éxito
  // );
  // }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
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
