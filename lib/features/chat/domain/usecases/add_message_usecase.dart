import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/generic/useCase/useCase.dart';
import '../entities/message.dart';
import '../repositories/user_list_messages_repo.dart';

class AddMessageParams {
  final MessageEntity message;
  final String chatId;

  AddMessageParams({required this.message, required this.chatId});
}

class AddMessageUseCase implements UseCase<Unit, AddMessageParams> {
  final UserListMessagesRepo userListMessagesRepo;

  AddMessageUseCase(this.userListMessagesRepo);

  @override
  Future<Either<Failure, Unit>> call(AddMessageParams params) async {
    return await userListMessagesRepo.addMessage(
        messageEntity: params.message,
        chatId: params.chatId
    );
  }
}

