import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required String text,
    required String senderId,
    required String recieverId,
    required DateTime time,
  }) : super(
    time: time,
    text: text,
    senderId: senderId,
    recieverId: recieverId,
  );

  static MessageModel fromJson(DocumentSnapshot json) {
    return MessageModel(
      senderId: json.get('senderId') as String,
      time: (json.get('time') as Timestamp).toDate(),
      text: json.get('text') as String,
      recieverId: json.get('recieverId') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "time": Timestamp.fromDate(time),
      "text": text,
      "reciverId": recieverId,
    };
  }
}
