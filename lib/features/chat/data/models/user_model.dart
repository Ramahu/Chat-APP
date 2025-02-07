import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    final String? email,
    final String? token,
    final String? uid,
    final String? name,
  }) : super(
          email: email!,
          token: token!,
          uid: uid,
          name: name,
        );

//This is where we define from json and to json methods.

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      token: json['token'],
      uid: json['userId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "token": token,
      "userId": uid,
      'name' : name,
    };
  }
}
