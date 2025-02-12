import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/message_model.dart';

abstract class UserMessageListRemoteSource {
  Stream<List<MessageEntity>> getAllMessages(String chatId);
  Future<void> addMessage({ required MessageEntity messageEntity ,required String chatId});
  Future<Map<String, dynamic>?> getLastMessage(String chatId);

}

class UserMessageListRemoteSourceImpl implements UserMessageListRemoteSource {
  final FirebaseFirestore fireStore;
  UserMessageListRemoteSourceImpl({required this.fireStore});

  @override
  Future<void> addMessage({required MessageEntity messageEntity, required String chatId}) async {
    try {
      final timestamp = DateTime.now();
      final chatsCollectionRef = fireStore.collection("chats").doc(chatId);
      final messageCollectionRef = chatsCollectionRef.collection("messages");

      // Check if the chat exists
      final chatDoc = await chatsCollectionRef.get();
      if (!chatDoc.exists) {
        await chatsCollectionRef.set({
          'users': [messageEntity.senderId, messageEntity.recieverId],
          'lastMessage': messageEntity.text,
          'lastMessageTime': timestamp,
        });
      } else {
        await chatsCollectionRef.update({
          'lastMessage': messageEntity.text,
          'lastMessageTime': timestamp,
        });
      }

      // Add the new message to the messages sub-collection
      var messageId = messageCollectionRef.doc().id;
      final newMessage = MessageModel(
        time: timestamp,
        text: messageEntity.text,
        receiverId: messageEntity.recieverId,
        senderId: messageEntity.senderId,
      ).toJson();

      await messageCollectionRef.doc(messageId).set(newMessage);

    } catch (e) {
      throw ServerException();
    }
  }


  @override
  Stream<List<MessageEntity>> getAllMessages(String chatId) {
    final chatsCollectionRef = fireStore.collection("chats").doc(chatId);
    final messagesRef = chatsCollectionRef.collection("messages")
        .orderBy("time", descending: true); // Ordering by latest message

    return messagesRef.snapshots().map((querySnapshot) {
      print("Fetched ${querySnapshot.docs.length} messages");
      return querySnapshot.docs.map((doc) {
        print("Message Data: ${doc.data()}");

        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return MessageModel.fromJson(data);
        } else {
          throw Exception("Invalid message data.");
        }
      }).toList();
    });
  }

  // @override
  // Future<String?> getLastMessage(String chatId) async {
  //   final chatDoc = await fireStore.collection("chats").doc(chatId).get();
  //   if (chatDoc.exists && chatDoc.data()!.containsKey('lastMessage')) {
  //     return chatDoc.get('lastMessage');
  //   }
  //   return null;
  // }

  @override
  Future<Map<String, dynamic>?> getLastMessage(String chatId) async {
    try {
      final chatDoc = await fireStore.collection("chats").doc(chatId).get();

      if (chatDoc.exists &&
          chatDoc.data()!.containsKey('lastMessage') &&
          chatDoc.data()!.containsKey('lastMessageTime')) {

        String lastMessage = chatDoc.get('lastMessage');
        DateTime lastMessageTime = chatDoc.get('lastMessageTime');

        return {
          'lastMessage': lastMessage,
          'lastMessageTime': lastMessageTime,
        };
      }
      return null;
    } catch (e) {
      print("Error getting last message: $e");
      return null;
    }
  }


}
