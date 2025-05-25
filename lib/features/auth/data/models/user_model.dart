import 'package:usfx_asistencia_docentes_movil/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  User toEntity() {
    return User(email: email);
  }
}
