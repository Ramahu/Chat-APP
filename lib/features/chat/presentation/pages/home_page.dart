import 'package:chat/core/util/colors.dart';
import 'package:chat/features/chat/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/icons.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/pages/SignIn_page.dart';
import '../../../auth/presentation/pages/cubit/auth_cubit.dart';
import '../widgets/chat_item.dart';
import 'chat_page.dart';
import 'cubit/chat_cubit.dart';
import 'cubit/chat_state.dart';

class HomePage extends StatelessWidget{
  final String currentUserId;

  HomePage({Key? key, required this.currentUserId}) : super(key: key);

  // final chatCubit =  BlocProvider.of<ChatCubit>;
  // final authCubit = BlocProvider.of<AuthCubit>;

  @override
  Widget build(BuildContext context) {
    context.read<ChatCubit>().getUserList(currentUserId.toString());

    return Scaffold(
        appBar: AppBar(title: Text('Chat App'),
            actions: [
              IconButton(
                icon: const Icon(search, color: grey),
                onPressed: () {
                },
              ),
            IconButton(
            icon: const Icon(logout, color: grey),
              onPressed: () {
                context.read<AuthCubit>().logOut();
                navigateAndFinish(context, SignIn());
              },
    ),]
    ),
    body: SafeArea(
    child: Padding(
    padding: EdgeInsets.all(10.0),
    child: BlocConsumer<ChatCubit,ChatState>(
    listener: (context , state){
      if (state is ErrorChatState){
    SnackBarMessage().showSnackBar(
    message: state.message, context: context, isError: true);
    }
    },
    builder: (context,state) {
    if(state is LoadingState){
    return LoadingWidget();
    }else if (state is GetUserListSuccessState) {
      final usersList = state.usersList;
      if(usersList.isNotEmpty ){
      return chatsList(usersList,currentUserId);}
      else {return Center(child: Text("No users found."));}
    }
    else {
    return Center(child: Text("No users found."));}
    }
    )
    )
    )
    );
  }

}

Widget chatsList(List<UserEntity> usersList, String currentUserId) {
  return ListView.separated(
    // physics: const BouncingScrollPhysics(),
    // scrollDirection: Axis.horizontal,
    itemCount: usersList.length,
    separatorBuilder: (_, __) => Divider(),
    itemBuilder: (context, index) {
      final user = usersList[index];
      final chatId = context.read<ChatCubit>().generateChatId(currentUserId, user.uid!);
      final lastMessage = context.read<ChatCubit>().getLastMessageForChat(chatId) ?? 'No messages yet';
      return chatItem(
        user: user,
        lastMessage: lastMessage,
        onTap: () {
          navigateTo(context, ChatPage(currentUserId: currentUserId,
            receiverUser: user,chatId: chatId,));
        },
      );
    },
  );
}