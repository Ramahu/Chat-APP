import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive_ui.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/snackBar_message.dart';
import '../../../../generated/assets.dart';
import '../../../chat/presentation/pages/home_page.dart';
import '../../data/datasources/auth_local_data_source.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class VerifyEmail extends StatelessWidget{
  const VerifyEmail({super.key});


  @override
  Widget build(BuildContext context) {
    // Calls method when the widget builds
    // Future.microtask(() => context.read<AuthCubit>().checkEmailVerification());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {  //  Ensure the widget is still mounted
        context.read<AuthCubit>().checkEmailVerification();
      }
    });

    return  SafeArea(
      child:Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(50),
                  child: Image(image: AssetImage(Assets.assetsEmailVerify)),
                ),
                Text('Verify your E-Mail address',
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: Responsive.textMultiplier(context) * 7),),
                BlocConsumer<AuthCubit , AuthState>(
                  listener: ( context, state) async {
                    if(state is EmailIsVerifiedState){
                      final AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl();
                      final currentUserId = await authLocalDataSourceImpl.getCachedUid();
                      // ✅ Check if the widget is still mounted
                      if (!context.mounted) return;

                      if (currentUserId != null && currentUserId.isNotEmpty) {
                        navigateAndReplace(context,HomePage(currentUserId: currentUserId));
                      }else {
                        SnackBarMessage().showSnackBar(
                            message:"User ID not found. Please sign in again." ,
                            context: context, isError: true);
                      }
                    }
                  },
                  builder: (context, state) {
                    if(state is EmailIsSentState){
                      return const
                      // Center(child:
                      Text(
                        'A verification email has been dispatched; kindly verify your account to proceed.',
                        textAlign: TextAlign.center,)
                      // )
                      ;
                    }else if (state is ErrorAuthState){
                    //   return  Center(child: Text(state.message,
                    //       style: const TextStyle(color: red),
                    //       textAlign: TextAlign.center));
                    // }
                     return SnackBarMessage().showSnackBar(
                          message: state.message, context: context, isError: true);
                    }
                    else{
                      return const Center(child: Text('Sending verification email...',
                          textAlign: TextAlign.center));
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Did not receive any email?"),
                    TextButton(
                        child: const Text("resend email"),
                        onPressed: (){
                          BlocProvider.of<AuthCubit>(context).sendEmailVerification();
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
