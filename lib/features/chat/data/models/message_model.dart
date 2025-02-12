import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.text,
    required super.senderId,
    required String receiverId,
    required super.time,
  }) : super(
    recieverId: receiverId,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      time: (json['time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "time": Timestamp.fromDate(time),
      "text": text,
      "receiverId": recieverId,
    };
  }
}
