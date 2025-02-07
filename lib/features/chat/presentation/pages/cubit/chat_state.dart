import 'package:equatable/equatable.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/user.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {}

class LoadingState extends ChatState{}

class GetMessagesSuccessState extends ChatState{
  final List<MessageEntity> listUserMsg;
  GetMessagesSuccessState({required this.listUserMsg});

  @override
  List<Object> get props => [listUserMsg];
}

class AddMessageSuccessState extends ChatState{}

class GetUserListSuccessState extends ChatState{
  final List<UserEntity> usersList;
  GetUserListSuccessState({required this.usersList});

  @override
  List<Object> get props => [usersList];
}
class GetLastMessageSuccessState extends ChatState{
  final String message ;
  final String chatId;
  GetLastMessageSuccessState({required this.message , required this.chatId});
  @override
  List<Object> get props => [message];
}

class ErrorChatState extends ChatState{
  final String message ;
  ErrorChatState({required this.message});
  @override
  List<Object> get props => [message];
}



// class GetMessagesSuccessState extends ChatState {
//   final List<MessageEntity> messages;
//
//   GetMessagesSuccessState({required this.messages});
//
//   @override
//   List<Object> get props => [messages];
// }


// class GetUserListSuccessState extends ChatState {
//   final List<UserEntity> users;
//
//   GetUserListSuccessState({required this.users});
//
//   @override
//   List<Object> get props => [users];
// }

