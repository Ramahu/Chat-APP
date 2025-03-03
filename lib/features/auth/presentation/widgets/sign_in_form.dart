import 'package:chat/features/auth/presentation/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive_ui.dart';
import '../../../../core/util/colors.dart';
import '../../../../core/util/constant.dart';
import '../../../../core/util/icons.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/snackBar_message.dart';
import '../../../../generated/assets.dart';
import '../../../chat/presentation/pages/home_page.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../domain/entities/sign_in_entity.dart';
import '../pages/SignUp_page.dart';
import '../pages/cubit/auth_cubit.dart';
import '../pages/cubit/auth_state.dart';
import '../pages/verfiy_email.dart';
import 'gradient_button.dart';
import 'options_box.dart';
import 'or_divider.dart';


class LoginForm extends StatefulWidget {
   const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isVisible = false;
  final authCubit = BlocProvider.of<AuthCubit>;


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
             defaultTextForm(
               width: 400,
               height: Responsive.heightMultiplier(context) * 7,
               bgColor:  isDarkMode ? grey[800] :grey[200],
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  autoValidateMode:
                  AutovalidateMode.onUserInteraction,
                  autofillHints: [AutofillHints.email],
                  label: 'Email Address',
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    color: grey,
                  ),
                  prefix: const Icon(
                    mail_outline_outlined,
                    color: indigoAccent,
                  ),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email address';
                    }
                    return null;
                  },
                  border:noneBorder,
                  focusedBorder: noneBorder,
                  enableBorder: noneBorder,
                ),
                SizedBox(height: Responsive.heightMultiplier(context) * 2,),
                defaultTextForm(
                  width:400,
                  height: Responsive.heightMultiplier(context) * 7,
                  bgColor:  isDarkMode ? grey[800] :grey[200],
                  controller: _passwordController,
                  type: TextInputType.visiblePassword,
                  label: 'Password',
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    color: grey,
                  ),
                  prefix: const Icon(
                    key_outlined,
                    color: indigoAccent,
                  ),
                  suffix:
                  isVisible ? visibility : visibility_off,
                  suffixPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  isPassword: isVisible?false : true,
                  maxLines: 1,
                  autoValidateMode:
                  AutovalidateMode.onUserInteraction,
                  autofillHints: [AutofillHints.password],
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  border: noneBorder,
                  focusedBorder: noneBorder,
                  enableBorder: noneBorder,
                ),
                 SizedBox(height: Responsive.heightMultiplier(context) * 2.5,),

                BlocConsumer<AuthCubit,AuthState>(
                  listener: (context , state) async {
                    final AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl();

                    if(state is SignedInState){
                      authLocalDataSourceImpl.cacheUid(state.uid);
                      authCubit(context).checkLoggingIn();
                    }else if (state is SignedInPageState){
                      final currentUserId = await authLocalDataSourceImpl.getCachedUid();

                      // Check if the widget is still mounted
                      if (!context.mounted) return;

                      if (currentUserId != null && currentUserId.isNotEmpty) {
                        print("Current User ID in sign in page : $currentUserId");
                        navigateAndFinish(context, HomePage(currentUserId:currentUserId));
                      } else {
                        SnackBarMessage().showSnackBar(
                            message:"User ID not found. Please sign in again." ,
                            context: context, isError: true);
                      }
                    }else if ( state is GoogleSignInState){
                      authLocalDataSourceImpl.cacheUid(state.uid);
                      navigateAndFinish(context, HomePage(currentUserId:state.uid));
                    }else if (state is VerifyEmailPageState ){
                      navigateTo(context, const VerifyEmail());
                      authCubit(context).sendEmailVerification();
                    }
                    else if (state is ErrorAuthState){
                      SnackBarMessage().showSnackBar(
                          message: state.message, context: context, isError: true);
                    }
                  },
                  builder: (context,state) {
                    if(state is LoadingState){
                      return const Center(child: CircularProgressIndicator());
                    }
                    return defaultGradientBottom(
                    text: ' Log In',
                    width: 400,
    height: Responsive.heightMultiplier(context) * 6,
    context: context,
    color1: indigoAccent,
    color2: defaultBlue2,
    function: () async {
    if (_formKey.currentState!.validate()) {
      authCubit(context).signIn(SignInEntity(
    password: _passwordController.text ,
    email: _emailController.text)
    );}}
    );
                  }
                ),

                orDivider(),

                  optionsBox(
                    context: context,
                    imgColor: red,
                    borderColor: grey,
                    imagePath: Assets.assetsGoogleIcon,
                    onPressed: () {
                      authCubit(context).signInWithGoogle();
                    },
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Need an account ?" , style: TextStyle(fontSize: 18,)),
                    Flexible(
                      child: TextButton(
                        onPressed: () {
                          navigateAndReplace(context, const SignUp());
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
