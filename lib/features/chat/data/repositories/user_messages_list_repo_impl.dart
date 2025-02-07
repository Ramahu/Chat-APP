import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/user_list_messages_repo.dart';
import '../datasources/remote/user_message_list_remote_source.dart';

class UserMessagesListRepoImpl implements UserListMessagesRepo {
  final UserMessageListRemoteSource userMessageListRemoteSource;
  final NetworkInfo networkInfo;

  UserMessagesListRepoImpl({required this.networkInfo, required this.userMessageListRemoteSource});

  @override
  Future<Either<Failure, Unit>> addMessage({required MessageEntity messageEntity, required String chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        await userMessageListRemoteSource.addMessage(messageEntity: messageEntity,chatId:chatId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> getAllMessages(String chatId) async* {
    if (await networkInfo.isConnected) {
      try {
        final messageStream = userMessageListRemoteSource.getAllMessages(chatId);

        // Mapping the data to Either<Failure, List<MessageEntity>>
        yield* messageStream.map((messages) => Right<Failure, List<MessageEntity>>(messages));
      } on ServerException {
        yield Left(ServerFailure());
      }
    } else {
      yield Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure,String>> getLastMessage(String chatId) async{
    if (await networkInfo.isConnected) {
      try {
        String? lastMessage = await userMessageListRemoteSource.getLastMessage(chatId);
        return  Right(lastMessage!);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }


}