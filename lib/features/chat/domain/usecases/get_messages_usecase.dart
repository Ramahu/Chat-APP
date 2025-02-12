import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/useCase/stream_use_case.dart';
import '../entities/message.dart';
import '../repositories/user_list_messages_repo.dart';

class GetMessagesUseCase  implements StreamUseCase<List<MessageEntity>, String>{
  final UserListMessagesRepo repository;

  GetMessagesUseCase(this.repository);

  @override
  Stream<Either<Failure, List<MessageEntity>>> call(String chatId) {
    return repository.getAllMessages(chatId);
  }
}
