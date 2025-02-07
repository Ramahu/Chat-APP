import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/user_list_messages_repo.dart';

class GetMessagesUseCase {
  final UserListMessagesRepo repository;
  GetMessagesUseCase(this.repository);

  Stream<Either<Failure, List<MessageEntity>>> call(String chatId) {
    return repository.getAllMessages(chatId);
  }
}
