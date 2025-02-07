import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sign_up_entity.dart';
import '../repositories/authentication_repository.dart';

class CreateUserUseCase {
  final AuthenticationRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(SignUpEntity user) async {
    return await repository.createUser(user);
  }
}
