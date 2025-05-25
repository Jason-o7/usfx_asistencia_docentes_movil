import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/notification_ui.dart';
import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';

class NotificationMapper {
  static List<NotificationUi> toUiModel(List<RegisterNotification> entities) {
    return entities.map((entity) {
      final title = switch (entity.title.toLowerCase()) {
        'input' => 'Entrada a Tiempo',
        'output' => 'Salida a Tiempo',
        _ => 'Notificación',
      };

      final content = _buildContent(
        title: title,
        subject: entity.subject,
        registerTime: entity.registerTime,
      );

      return NotificationUi(
        title: title,
        icon: Icons.check_circle,
        iconColor: Colors.green,
        timeAgo: timeago.format(entity.registerTime, locale: 'es'),
        content: content,
        subject: entity.subject,
        registerTime: entity.registerTime,
      );
    }).toList();
  }

  static String _buildContent({
    required String title,
    required String subject,
    required DateTime registerTime,
  }) {
    final time =
        '${registerTime.hour.toString().padLeft(2, '0')}:'
        '${registerTime.minute.toString().padLeft(2, '0')}';

    return switch (title) {
      'Entrada a Tiempo' =>
        'Entraste a tiempo a la materia $subject a las $time',
      'Salida a Tiempo' =>
        'Saliste a tiempo de la materia $subject a las $time',
      _ => 'Nueva notificación: $title',
    };
  }
}
