import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  final String name;
  final String email;
  final String password;
  final String repeatedPassword;
  final String? uid;


  const SignUpEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.repeatedPassword,
    this.uid,
  });

  @override
  List<Object?> get props => [ name, email, password, repeatedPassword , uid];
}
