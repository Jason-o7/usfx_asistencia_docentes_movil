import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_event.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_state.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/widgets/notifications_dropdown.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/widgets/unread_indicator.dart';

class NotificationIconWithOverlay extends StatefulWidget {
  const NotificationIconWithOverlay({super.key});

  @override
  State<NotificationIconWithOverlay> createState() =>
      _NotificationIconWithOverlayState();
}

class _NotificationIconWithOverlayState
    extends State<NotificationIconWithOverlay> {
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();

  void _showOverlay(List<RegisterNotification> notifications) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: 330,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(-238, 45), // Ajustar posición
              child: NotificationsDropdown(notifications: notifications),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterNotificationBloc, RegisterNotificationState>(
      listener: (context, state) {
        if (state is RegisterNotificationsOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showOverlay(state.notifications);
          });
        } else if (state is RegisterNotificationsClosed ||
            state is RegisterNotificationsError) {
          _removeOverlay();
        }
      },
      builder: (context, state) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap:
                    () => context.read<RegisterNotificationBloc>().add(
                      const ToggleNotifications(),
                    ),
                customBorder: const CircleBorder(),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPalette.lightBackgroundColor,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.notifications_none_sharp,
                    color: AppPalette.darkTextColor,
                  ),
                ),
              ),
              if (state is RegisterNotificationsClosed && state.hasUnread)
                const Positioned(right: 0, top: 0, child: UnreadIndicator()),
            ],
          ),
        );
      },
    );
  }
}
