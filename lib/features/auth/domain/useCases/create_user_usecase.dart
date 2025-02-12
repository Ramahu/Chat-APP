import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../entities/sign_up_entity.dart';
import '../repositories/authentication_repository.dart';

class CreateUserUseCase implements UseCase<Unit, SignUpEntity>{
  final AuthenticationRepository repository;

  CreateUserUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SignUpEntity user) async {
    return await repository.createUser(user);
  }
}
