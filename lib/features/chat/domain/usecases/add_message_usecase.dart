import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/user_list_messages_repo.dart';

class AddMessageUseCase {
  final UserListMessagesRepo userListMessagesRepo;

  AddMessageUseCase( this.userListMessagesRepo);

  Future<Either<Failure, Unit>> call({ required MessageEntity message, required String chatId}) async {
    return await userListMessagesRepo.addMessage(messageEntity: message, chatId: chatId);
  }
}
