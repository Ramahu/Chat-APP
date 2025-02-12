import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../repositories/user_list_messages_repo.dart';

class GetLastMessageUseCase implements UseCase< (String, DateTime?), String>{
  final UserListMessagesRepo repository;

  GetLastMessageUseCase(this.repository);

  @override
  Future<Either<Failure, (String, DateTime?)>> call(String chatId) {
    return repository.getLastMessage(chatId);
  }
}
