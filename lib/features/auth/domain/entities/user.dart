import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;

  // Constructor
  const User({required this.email});

  // Métodos
  @override
  List<Object?> get props => [email];
}
