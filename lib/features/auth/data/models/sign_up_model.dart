import '../../domain/entities/sign_up_entity.dart';

class SignUpModel extends SignUpEntity {
  const SignUpModel({
    required super.name,
    required super.email,
    required super.password ,
    required super.repeatedPassword,
    super.uid,
  });


  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        repeatedPassword: '',
        uid: json['userId']
    );
  }

  Map<String, dynamic> toJson() {
    return { 'name': name, 'email': email, 'password': password ,'userId':uid };
  }
}
