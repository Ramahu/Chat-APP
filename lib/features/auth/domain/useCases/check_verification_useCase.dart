import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../repositories/authentication_repository.dart';

class CheckVerificationUseCase implements UseCase<Unit, Completer>{
  final AuthenticationRepository repository;

  CheckVerificationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Completer completer){
    return  repository.checkEmailVerification(completer);
  }
}
