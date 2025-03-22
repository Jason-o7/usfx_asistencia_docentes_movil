import 'package:usfx_asistencia_docentes_movil/features/register_notifications/domain/entities/register_notification.dart';
import 'package:intl/intl.dart';

class RegisterNotificationModel extends RegisterNotification {
  const RegisterNotificationModel({
    required super.idNotification,
    required super.idPerson,
    required super.type,
    required super.title,
    required super.subject,
    required super.acronym,
    required super.classroom,
    required super.registerTime,
    required super.readAt,
    required super.status,
  });

  factory RegisterNotificationModel.fromJson(
    Map<String, dynamic> json,
    String idPerson,
  ) {
    final subject = json['Subject'] as Map<String, dynamic>;
    final idNotification = json['id_notification'] as int;
    String title;
    if (json['register_type'] == 'input') {
      title = 'Entrada Registrada';
    } else if (json['register_type'] == 'output') {
      title = 'Salida Registrada';
    } else {
      title = json['register_type'].toString();
    }

    return RegisterNotificationModel(
      idNotification: idNotification.toString(),
      idPerson: idPerson,
      type: json['notification_type'] as String, // attendance, system, etc
      title: title,
      subject: subject['name'] as String,
      acronym: subject['acronym'] as String,
      classroom: subject['classroom'] as String,
      registerTime: DateFormat(
        'EEE, dd MMM yyyy HH:mm:ss z',
      ).parse(json['register_time'] as String),
      readAt:
          json['read_at'] != null
              ? DateFormat(
                'EEE, dd MMM yyyy HH:mm:ss z',
              ).parse(json['read_at'] as String)
              : null,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    // Formatea las fechas sin milésimas
    final dateFormat = DateFormat(
      'yyyy-MM-ddTHH:mm:ss',
    ); // Formato ISO 8601 sin milésimas

    return {
      'id_notification': idNotification,
      'id_person': idPerson,
      'type': type,
      'title': title,
      'subject': subject,
      'acronym': acronym,
      'classroom': classroom,
      'register_time': dateFormat.format(
        registerTime,
      ), // Formatea sin milésimas
      'readAt':
          readAt != null
              ? dateFormat.format(readAt!)
              : null, // Formatea sin milésimas
      'status': status,
    };
  }

  RegisterNotification toEntity() {
    return RegisterNotification(
      idNotification: idNotification,
      idPerson: idPerson,
      type: type,
      title: title,
      subject: subject,
      acronym: acronym,
      classroom: classroom,
      registerTime: registerTime,
      readAt: readAt,
      status: status,
    );
  }
}
