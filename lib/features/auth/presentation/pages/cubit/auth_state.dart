import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingState extends AuthState{}

class EmailIsSentState extends AuthState{}

class EmailIsVerifiedState extends AuthState{}

class SignedInPageState extends AuthState{}

class VerifyEmailPageState extends AuthState{}

class LoggedOutState extends AuthState{}

class SignedInState extends AuthState{
  final String uid ;
  SignedInState({required this.uid});
  @override
  List<Object> get props => [uid];
}

class SignedUpState extends AuthState{
  final String uid ;
  SignedUpState({required this.uid});
  @override
  List<Object> get props => [uid];
}

class CreateUserState extends AuthState{}

class GoogleSignInState extends AuthState{
  final String uid ;
  GoogleSignInState({required this.uid});
  @override
  List<Object> get props => [uid];
}


class ErrorAuthState extends AuthState{
  final String message ;
  ErrorAuthState({required this.message});
  @override
  List<Object> get props => [message];
}

