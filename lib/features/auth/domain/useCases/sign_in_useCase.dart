import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../entities/sign_in_entity.dart';
import '../repositories/authentication_repository.dart';

class SignInUseCase implements UseCase<UserCredential, SignInEntity>{
  final AuthenticationRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserCredential>> call(SignInEntity signIn) async {
    return await repository.signIn(signIn);
  }
}
