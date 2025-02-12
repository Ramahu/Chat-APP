import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable{
  final String chatId;
  final List<String> users;
  final String lastMessage;
  final DateTime lastMessageTime;

  const ChatEntity({
    required this.chatId,
    required this.users,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  @override
  List<Object?> get props  => [ chatId, users , lastMessage ,lastMessageTime ];
}
