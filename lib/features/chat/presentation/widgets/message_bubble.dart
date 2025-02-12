import 'package:flutter/material.dart';
import '../../../../core/util/colors.dart';

Widget messageBubble({
  required String message,
  required bool isSender,
  required DateTime timestamp,
  required BuildContext context,
}) {
  return Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isSender ? white : black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 12, color: black54),
            ),
          ],
        ),
      ),
    ),
  );
}
