import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/NoParam.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../repositories/authentication_repository.dart';

class VerifyEmailUseCase implements UseCase<Unit, NoParams>{
  final AuthenticationRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.verifyEmail();
  }
}
