import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';

abstract class UserListMessagesRepo {
  Stream<Either<Failure, List<MessageEntity>>> getAllMessages(String chatId);
  Future<Either<Failure, Unit>> addMessage({required MessageEntity messageEntity, required String chatId});
  Future<Either<Failure,(String, DateTime?)>> getLastMessage(String chatId);
}
