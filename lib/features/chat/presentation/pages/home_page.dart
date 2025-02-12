import 'package:chat/features/chat/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/icons.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/snackBar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/pages/SignIn_page.dart';
import '../../../auth/presentation/pages/cubit/auth_cubit.dart';
import '../widgets/chat_item.dart';
import 'chat_page.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';


class HomePage extends StatelessWidget{
  final String currentUserId;

  const HomePage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    context.read<ChatCubit>().getUserList(currentUserId.toString());

    return Scaffold(
        appBar: appbar(context: context),
    body: SafeArea(
    child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: RefreshIndicator(
    onRefresh: () async {
      context.read<ChatCubit>().getUserList(currentUserId.toString()); },
    child:  BlocConsumer<ChatCubit,ChatState>(
    listener: (context , state){
      if (state is ErrorChatState){
    SnackBarMessage().showSnackBar(
    message: state.message, context: context, isError: true);
    }
    },
    builder: (context,state) {
    if(state is LoadingState){
    return const LoadingWidget();
    }else if (state is GetUserListSuccessState) {
      final usersList = state.usersList;
      if(usersList.isNotEmpty ){
      return chatsList(usersList,currentUserId);}
      else {return const Center(child: Text("No chats yet."));}
    }
    else {
    return const Center(child: Text("No chats yet."));}
    }
    )
    )
    )
    )
    );
  }

}

PreferredSizeWidget appbar({required BuildContext context}) => AppBar(
    title: Text('HapHat'),
    actions: [
      IconButton(
        icon: const Icon(search),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(logout),
        onPressed: () {
          context.read<AuthCubit>().logOut();
          navigateAndFinish(context, SignIn());
        },
      ),
    ]
);

Widget chatsList(List<UserEntity> usersList, String currentUserId) {
  return ListView.separated(
    itemCount: usersList.length,
    separatorBuilder: (_, __) => const Divider(),
    itemBuilder: (context, index) {
      final user = usersList[index];
      final chatId = context.read<ChatCubit>().generateChatId(currentUserId, user.uid!);
      final lastMessageData = context.read<ChatCubit>().getLastMessageForChat(chatId);
      final lastMessage = lastMessageData?['message'] ?? 'No messages yet';
      final DateTime? lastMessageTime = lastMessageData?['time'] ;

      return chatItem(
        user: user,
        lastMessage: lastMessage,
        lastMessageTime : lastMessageTime == null ? 'now': _formatTimestamp(lastMessageTime) ,
        onTap: () {
          navigateTo(context, ChatPage(currentUserId: currentUserId,
            receiverUser: user,chatId: chatId,));
        },
      );
    },
  );
}

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