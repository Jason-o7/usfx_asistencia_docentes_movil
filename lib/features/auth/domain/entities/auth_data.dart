import 'package:equatable/equatable.dart';

class AuthData extends Equatable {
  final String userId;
  final String token;
  final DateTime expirationDate;

  const AuthData({
    required this.userId,
    required this.token,
    required this.expirationDate,
  });

  @override
  List<Object?> get props => [userId, token, expirationDate];
}
