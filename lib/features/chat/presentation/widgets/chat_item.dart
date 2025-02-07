import 'package:flutter/material.dart';
import '../../../../core/util/colors.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';

Widget chatItem({
  required UserEntity user,
  required String lastMessage,
  // required String lastMessageTime,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    leading: CircleAvatar(
      radius: 25,
      backgroundImage: user.photoUrl != null
          ? NetworkImage(user.photoUrl!)
          : const AssetImage('assets/default_avatar.png') as ImageProvider,
    ),
    title: Text(
      user.name!,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
    subtitle: Text(
      lastMessage,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: grey),
    ),
    // trailing: Text(
    //   _formatTimestamp(lastMessageTime),
    //   style: const TextStyle(fontSize: 12, color: grey),
    // ),
  );
}

// Helper function to format the timestamp
String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  if (now.difference(timestamp).inDays == 0) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  } else if (now.difference(timestamp).inDays == 1) {
    return "Yesterday";
  } else {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }
}
