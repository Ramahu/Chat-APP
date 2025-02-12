import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? email;
  final String? token;
  final String? uid;
  final String? name;
  final String? photoUrl;

  const UserEntity({
    this.email,
    this.token,
    this.uid,
    this.photoUrl,
    this.name,
  });

  @override
  List<Object?> get props  => [ email, token , uid ,photoUrl , name ];
}
