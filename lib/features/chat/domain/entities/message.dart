import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable{
  final String text;
  final String senderId;
  final String recieverId;
  final DateTime time;

  MessageEntity({
    required this.time,
    required this.text,
    required this.recieverId,
    required this.senderId,
  });

  @override
  List<Object?> get props => [ time, text,recieverId,senderId];
}
