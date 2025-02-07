import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';


abstract class ChatListFirebaseRemoteSource {
  Future<List<UserEntity>> getUserListFromFirebase(String currentUserId);
}

class ChatListFirebaseRemoteImpl implements ChatListFirebaseRemoteSource {
  final FirebaseFirestore fireStore;
  ChatListFirebaseRemoteImpl({required this.fireStore});

  @override
  Future<List<UserEntity>> getUserListFromFirebase(String currentUserId) async {
    try {
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      print("Current User ID: $currentUserId");
      // 1️⃣ Get all chat documents where the current user is a participant
      QuerySnapshot chatSnapshot = await fireStore
          .collection("chats")
          .where("users", arrayContains: currentUserId)
          .get();

      print("Chats found: ${chatSnapshot.docs.length}");

      // 2️⃣ Extract unique user IDs from chats
      Set<String> userIds = {};
      for (var chatDoc in chatSnapshot.docs) {
        List<dynamic> usersInChat = chatDoc.get("users") ?? [];
        print("Users in chat: $usersInChat");

        // ✅ Convert dynamic list to List<String>
        userIds.addAll(usersInChat
            .where((id) => id != currentUserId)
            .map((id) => id.toString())); // Explicit conversion to String
      }
      print("Unique User IDs: $userIds");
      if (userIds.isEmpty) {
        return []; // No chats found
      }

      // Fetch user details in batch
      QuerySnapshot usersSnapshot = await fireStore
          .collection("users")
          .where("uid", whereIn: userIds.toList())
          .get();

      print("Users fetched: ${usersSnapshot.docs.length}");

      // Map user documents to UserEntity
      List<UserEntity> userList = usersSnapshot.docs.map((userDoc) {
        print("Fetched user: ${userDoc.data()}");

        return UserModel(
          email: userDoc.get("email"),
          token: userDoc.data().toString().contains("token") ? userDoc.get("token") : "",
          uid: userDoc.get("uid"),
          name: userDoc.get("name"),
        );
      }).toList();
      print("Users fetched: ${userList.length}");

      return userList;
    } catch (e) {
      throw ServerException();
    }
  }

}