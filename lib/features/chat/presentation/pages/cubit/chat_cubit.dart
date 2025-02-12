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

  final Map<String, Map<String, dynamic>?> _lastMessagesAndTime = {};

  Future<void> addMessage(MessageEntity messageEntity,String chatId) async {
    emit(LoadingState());
    final failureOrUint = await addMessageUseCase(AddMessageParams(message: messageEntity, chatId: chatId));
    emit(eitherToState(failureOrUint, AddMessageSuccessState()));
  }

  // Stream<List<MessageEntity>> getMessages(String chatId) async* {
  //   emit(LoadingState());
  //   final messageStream = getMessagesUseCase(chatId);
  //   // print('Fetched in cubit ${messageStream.length} messages');
  //   await for (final either in messageStream) {
  //     either.fold(
  //           (failure) => emit(ErrorChatState(message: _mapFailureToMessage(failure))),
  //           (listUserMsg) => emit(GetMessagesSuccessState(listUserMsg: listUserMsg)),
  //     );
  //   }
  // }

  Stream<List<MessageEntity>> getMessages(String chatId) {
    return getMessagesUseCase(chatId).map((either) {
      return either.fold(
            (failure) { emit(ErrorChatState(message: _mapFailureToMessage(failure)));
          return [];
        },
            (messages) { emit(GetMessagesSuccessState(listUserMsg: messages));
          return messages;
        },
      );
    });
  }


  Future<void> getUserList(String currentUserId) async {
    emit(LoadingState());
    final failureOrListUserEntity = await getUserListUseCase(currentUserId);
    emit(eitherToStates(failureOrListUserEntity, (listUserEntity) {
      for (var user in listUserEntity) {
        final chatId = generateChatId(currentUserId, user.uid!);
        getLastMessage(chatId);
      }
      return GetUserListSuccessState(usersList:listUserEntity );
    }));

  }

  // Future<void> getLastMessage(String chatId) async {
  //   emit(LoadingState());
  //   final failureOrLastMsg = await getLastMessageUseCase(chatId);
  //   emit(eitherToStates(failureOrLastMsg, (result) {
  //     _lastMessages[chatId] = lastMsg;
  //     return GetLastMessageSuccessState(chatId: chatId,message:lastMsg );
  //   }));
  // }

  Future<void> getLastMessage(String chatId) async {
    emit(LoadingState());
    final failureOrLastMsg = await getLastMessageUseCase(chatId);
    emit(eitherToStates(failureOrLastMsg, (result) {
      String lastMessage = result.$1;
      DateTime? lastMessageTime = result.$2;

      _lastMessagesAndTime[chatId] = {
        'message': lastMessage,
        'time': lastMessageTime!,
      };

      return GetLastMessageSuccessState(
        chatId: chatId,
        message: lastMessage,
        time: lastMessageTime,
      );
    }));
  }

  Map<String, dynamic>? getLastMessageForChat(String chatId) {
    return _lastMessagesAndTime[chatId];
  }

  String generateChatId(String userId1, String userId2) {
    // Ensure the smaller ID comes first for consistency
    // return userId1.hashCode <= userId2.hashCode
    //     ? '${userId1}_$userId2'
    //     : '${userId2}_$userId1';

    // List<String> sortedIds = [userId1, userId2]..sort();
    // return "${sortedIds[0]}_${sortedIds[1]}";

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
