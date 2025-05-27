import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_shadows.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_text_styles.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/notification_ui.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_bloc.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/presentation/bloc/register_notification_event.dart';

class NotificationsDropdown extends StatelessWidget {
  final List<NotificationUi> notifications;

  const NotificationsDropdown({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        // Configuraciones de todas las notificaciones
        // width: 300,
        height: 500,
        decoration: BoxDecoration(
          color: AppPalette.lightBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: AppShadows.strongShadow,
        ),
        child: Column(
          children: [
            // Título y botón de configuraciones
            Container(
              decoration: BoxDecoration(
                color: AppPalette.secondaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 15,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notificaciones',
                      style: AppTextStyles.subtitleBold(
                        color: AppPalette.lightTextColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: AppPalette.lightTextColor,
                        size: 28,
                      ),
                      onPressed:
                          () => context.read<RegisterNotificationBloc>().add(
                            RefreshNotificationsEvent(), // TODO: Cambiar a evento de configuraciones
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  notifications.isEmpty
                      ? const Center(
                        child: Text('No hay nuevas notificaciones'),
                      )
                      : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder:
                            (context, index) => ListTile(
                              leading: Icon(
                                notifications[index].icon,
                                color: notifications[index].iconColor,
                              ),
                              title: Text(
                                notifications[index].title,
                                style: AppTextStyles.body(
                                  color: _getTitleColor(
                                    notifications[index].title,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notifications[index].content,
                                    style: AppTextStyles.body(
                                      color: AppPalette.darkTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    notifications[index].timeAgo,
                                    style: AppTextStyles.caption(
                                      color: AppPalette.darkTextColor
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTitleColor(String title) {
    return title.contains('Tiempo')
        ? AppPalette.successColor
        : AppPalette.darkTextColor;
  }
}
