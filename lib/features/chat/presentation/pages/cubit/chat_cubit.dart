import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/add_message_usecase.dart';
import '../../../domain/usecases/get_last_msg_usecase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/get_userlist_firebase_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final AddMessageUseCase addMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final GetChatListUseCase getUserListUseCase;
  final GetLastMessageUseCase getLastMessageUseCase;

  Completer<void> completer = Completer<void>();

  ChatCubit({
    required this.addMessageUseCase,
    required this.getMessagesUseCase,
    required this.getUserListUseCase,
    required this.getLastMessageUseCase,
  }) : super(ChatInitialState());

  final Map<String, String?> _lastMessages = {};

  Future<void> addMessage(MessageEntity messageEntity,String chatId) async {
    emit(LoadingState());
    final failureOrUint = await addMessageUseCase(message: messageEntity,chatId: chatId);
    emit(eitherToState(failureOrUint, AddMessageSuccessState()));
  }

  Future<void> getMessages(String chatId) async {
    emit(LoadingState());
    final messageStream = getMessagesUseCase(chatId);
    await for (final either in messageStream) {
      either.fold(
            (failure) => emit(ErrorChatState(message: _mapFailureToMessage(failure))),
            (listUserMsg) => emit(GetMessagesSuccessState(listUserMsg: listUserMsg)),
      );
    }
  }

  Future<void> getUserList(String currentUserId) async {
    emit(LoadingState());
    final failureOrListUserEntity = await getUserListUseCase(currentUserId);
    // emit(eitherToState(failureOrUserEntity, GetUserListSuccessState()));
    emit(eitherToStates(failureOrListUserEntity, (listUserEntity) {
      for (var user in listUserEntity) {
        final chatId = generateChatId(currentUserId, user.uid!);
        getLastMessage(chatId);
      }
      return GetUserListSuccessState(usersList:listUserEntity );
    }));

  }

  Future<void> getLastMessage(String chatId) async {
    emit(LoadingState());
    final failureOrLastMsg = await getLastMessageUseCase(chatId);
    // emit(eitherToState(failureOrLastMsg as Either, GetLastMessageSuccessState()));
    emit(eitherToStates(failureOrLastMsg, (lastMsg) {
      _lastMessages[chatId] = lastMsg;
      return GetLastMessageSuccessState(chatId: chatId,message:lastMsg );
    }));
  }
  String? getLastMessageForChat(String chatId) {
    return _lastMessages[chatId];
  }

  String generateChatId(String userId1, String userId2) {
    // Ensure the smaller ID comes first for consistency
    // return userId1.hashCode <= userId2.hashCode
    //     ? '${userId1}_$userId2'
    //     : '${userId2}_$userId1';

    // List<String> uids = [uid1, uid2];
    // uids.sort(); // Ensures consistent order
    // return '${uids[0]}_${uids[1]}'; // e.g., uid1_uid2
    return 'yJbcpkeiDxqpNAQDopnW' ;
  }

  ChatState eitherToState(Either either, ChatState state) {
    return either.fold(
          (failure) => ErrorChatState(message: _mapFailureToMessage(failure)),
          (_) => state,
    );
  }

  ChatState eitherToStates<L extends Failure, R>(
      Either<L, R> either,
      ChatState Function(R data) onSuccess,
      ) {
    return either.fold(
          (failure) => ErrorChatState(message: _mapFailureToMessage(failure)),
          (data) => onSuccess(data),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return serverFailureMessage;
      case OfflineFailure _:
        return offlineFailureMessage;
      case TooManyRequestsFailure _:
        return tooManyRequestsFailureMessage;
      case NotLoggedInFailure _:
        return '';
      default:
        return "Unexpected Error, Please try again later.";
    }
  }
}
