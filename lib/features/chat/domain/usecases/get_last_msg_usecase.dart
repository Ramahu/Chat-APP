import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_list_messages_repo.dart';

class GetLastMessageUseCase {
  final UserListMessagesRepo repository;
  GetLastMessageUseCase(this.repository);

  Future<Either<Failure, String>> call(String chatId) {
    return repository.getLastMessage(chatId);
  }
}
