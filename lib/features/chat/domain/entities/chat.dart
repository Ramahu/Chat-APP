class ChatEntity {
  final String chatId;
  final List<String> users;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatEntity({
    required this.chatId,
    required this.users,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
