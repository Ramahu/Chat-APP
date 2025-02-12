import 'package:flutter/material.dart';
import '../../../../core/util/colors.dart';

Widget messageBubble({
  required String message,
  required bool isSender,
  required DateTime timestamp,
}) {
  return Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSender ? defaultBlue2 : grey[600],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isSender ? const Radius.circular(16) : const Radius.circular(0),
          bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16
                , color: isSender ? white : black54,),
          ),
          SizedBox(height: 4),
          Text(
            "${timestamp.hour}:${timestamp.minute}",
            style: TextStyle(fontSize: 12, color: black54),
          ),
        ],
      ),
    ),
  );
}
