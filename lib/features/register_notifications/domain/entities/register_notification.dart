import 'package:equatable/equatable.dart';

class RegisterNotification extends Equatable {
  final String idNotification;
  final String idPerson;
  final String type;
  final String title;
  final String subject;
  final String acronym;
  final String classroom;
  final DateTime registerTime;
  final DateTime? readAt;
  final String status;

  const RegisterNotification({
    required this.idNotification,
    required this.idPerson,
    required this.type,
    required this.title,
    required this.subject,
    required this.acronym,
    required this.classroom,
    required this.registerTime,
    this.readAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
    idNotification,
    idPerson,
    type,
    title,
    subject,
    classroom,
    registerTime,
    readAt,
    status,
  ];
}
