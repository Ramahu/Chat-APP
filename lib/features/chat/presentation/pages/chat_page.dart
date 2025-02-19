import 'package:chat/core/util/constant.dart';
import 'package:chat/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/core/util/colors.dart';
import '../../../../core/responsive_ui.dart';
import '../../../../core/util/icons.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/snackBar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/widgets/text_form.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';
import '../widgets/message_bubble.dart';
import 'cubit/chat_cubit.dart';
import 'home_page.dart';


class ChatPage extends StatelessWidget{
  final UserEntity receiverUser;
  final String currentUserId;
  final String chatId;
   ChatPage({super.key,required this.currentUserId, required this.receiverUser,required this.chatId});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar(currentUserId:currentUserId,user: receiverUser,context: context),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageEntity>>(
                stream: context.read<ChatCubit>().getMessages(chatId),
                builder: (context, snapshot) {
                  print("📥 StreamBuilder State: ${snapshot.connectionState}");

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    if (!snapshot.hasData) {
                      return const LoadingWidget();
                    }
                  }
                  if (snapshot.hasError) {
                    print("❌ Error in StreamBuilder: ${snapshot.error}");
                    return SnackBarMessage().showSnackBar(
                        message: "Failed to load messages.", context: context, isError: true);
                    // return const Center(child: Text("Failed to load messages."));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }
                  print("✅ UI Received Messages: ${snapshot.data!.length}");
                  return messagesList(snapshot.data!, currentUserId,context);
                },
              ),
            ),


            SizedBox(height: Responsive.heightMultiplier(context) * 0.5,),
            messageInputField(
              context:  context,
              controller: _messageController,
              onSend: () {
                final messageText = _messageController.text.trim();
                if (messageText.isNotEmpty) {
                  context.read<ChatCubit>().addMessage(
                     MessageEntity(
                      text: messageText,
                      senderId: currentUserId,
                      recieverId: receiverUser.uid!,
                      time: DateTime.now(),
                    ), chatId );
                  _messageController.clear();
                }
              },
            ),
            SizedBox(height: Responsive.heightMultiplier(context) * 1,),
          ],
        ),
    );
  }
}

Widget messagesList(List<MessageEntity> messages, String currentUserId , BuildContext context) {
  return ListView.builder(
    reverse: true, // To keep the latest message at the bottom
    itemCount: messages.length,
    itemBuilder: (context, index) {
      final message = messages[index];
      final isSender = message.senderId == currentUserId;

      return messageBubble(
        message: message.text,
        isSender: isSender,
        timestamp: message.time,
        context: context,
      );
    },
  );
}

Widget messageInputField({
  required TextEditingController controller,
  required VoidCallback onSend,
  required BuildContext context,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    width: Responsive.width(context) * 0.95,
    decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isDarkMode ? grey[800] :grey[300],
    ),
    child: Row(
      children: [
        Expanded(
          child:
          defaultTextForm(
            controller: controller,
            hint: 'Type a message...',
            border:noneBorder,
          ),
        ),
        IconButton(
          icon: const Icon(send, color:defaultBlue2),
          onPressed: onSend,
        ),
      ],
    ),
  );
}

PreferredSizeWidget appbar({
  required String currentUserId,
  required UserEntity user ,
  required BuildContext context
}) => AppBar(
leading: IconButton(
icon: const Icon(arrow_back),
onPressed: () {
navigateAndFinish(context, HomePage(currentUserId:currentUserId));
},
),
title: Row(
children: [
CircleAvatar(
radius: 20,
backgroundImage: user.photoUrl != null
    ? NetworkImage(user.photoUrl!)
    : const AssetImage(Assets.assetsDefaultAvatar) as ImageProvider,
),
const SizedBox(width: 10),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
  user.name!,
style: const TextStyle(
fontSize: 16,
),
),
const SizedBox(height: 2),
Text(
'Online',
style: TextStyle(
color: green[600],
fontSize: 12,
),
),
],
),
],
),
actions: [
IconButton(
icon: const Icon(videocam),
onPressed: () {
},
),
IconButton(
icon: const Icon(call),
onPressed: () {
},
),
IconButton(
icon: const Icon(more_vert),
onPressed: () {
},
),
],
);
