import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required String chatId,
    required List<String> users,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) : super(
    chatId: chatId,
    users: users,
    lastMessage: lastMessage,
    lastMessageTime: lastMessageTime,
  );

  static ChatModel fromJson(DocumentSnapshot json) {
    return ChatModel(
      chatId: json.id,
      users: List<String>.from(json.get('users')),
      lastMessage: json.get('lastMessage') ?? '',
      lastMessageTime: (json.get('lastMessageTime') as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }
}
