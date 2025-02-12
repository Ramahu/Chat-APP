import 'package:flutter/material.dart';
import '../../../../core/util/colors.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/user.dart';

Widget chatItem({
  required UserEntity user,
  required String lastMessage,
  required String lastMessageTime ,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    leading: CircleAvatar(
      radius: 25,
      backgroundImage: user.photoUrl != null
          ? NetworkImage(user.photoUrl!)
          : const AssetImage(Assets.assetsDefaultAvatar) as ImageProvider,
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
    trailing: Text(
        lastMessageTime,
      style: const TextStyle(fontSize: 12, color: grey),
    ),
  );
}
