import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/auth_data.dart';

class AuthDataModel extends AuthData {
  const AuthDataModel({
    required super.userId,
    required super.token,
    required super.expirationDate,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      userId: json['userId'],
      token: json['token'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'token': token,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }
}
