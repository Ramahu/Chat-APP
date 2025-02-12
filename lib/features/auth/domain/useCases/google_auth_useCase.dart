import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/NoParam.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../repositories/authentication_repository.dart';

class GoogleAuthUseCase implements UseCase<UserCredential, NoParams> {
  final AuthenticationRepository repository;

  GoogleAuthUseCase(this.repository);

  @override
  Future<Either<Failure, UserCredential>> call(NoParams params) async {
    return await repository.googleSignIn();
  }
}

