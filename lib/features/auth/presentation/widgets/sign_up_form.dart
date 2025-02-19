import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../core/responsive_ui.dart';
import '../../../../core/util/colors.dart';
import '../../../../core/util/constant.dart';
import '../../../../core/util/icons.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/snackBar_message.dart';
import '../../../../generated/assets.dart';
import '../../../chat/presentation/pages/home_page.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../pages/SignIn_page.dart';
import '../pages/cubit/auth_cubit.dart';
import '../pages/cubit/auth_state.dart';
import '../pages/verfiy_email.dart';
import 'gradient_button.dart';
import 'options_box.dart';
import 'or_divider.dart';
import 'text_form.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isVisible = false;
  bool isVisible2 = false;
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
              controller: _usernameController,
              type: TextInputType.text,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              autofillHints: [AutofillHints.email],
              label: 'Full Name',
              labelStyle: const TextStyle(
                fontSize: 18,
                color: grey,
              ),
              prefix: const Icon(
                mail_outline_outlined,
                color: defaultBlue2,
              ),
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              border:noneBorder,
              focusedBorder: noneBorder,
              enableBorder: noneBorder,
            ),
            SizedBox(height: Responsive.heightMultiplier(context) * 2,),
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
                color: defaultBlue2,
              ),
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email address';
                }
                else if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid E-Mail';
                }
                return null;
              },
              border:noneBorder,
              focusedBorder: noneBorder,
              enableBorder: noneBorder,
            ),
            SizedBox(height: Responsive.heightMultiplier(context) * 2,),
        defaultTextForm(
          width: 400,
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
            color: defaultBlue2,
          ),
          suffix: isVisible ? visibility : visibility_off,
          suffixPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
          isPassword: isVisible ? false : true,
          maxLines: 1,
          autoValidateMode:
          AutovalidateMode.onUserInteraction,
          autofillHints: [AutofillHints.password],
          validate: (value) {
            if (value!.isEmpty) {
              return 'Please enter password';
            }
            else if (value.length < 6) {
              return 'The password must contains more than six characters.';
            }
            return null;
          },
          border:noneBorder,
          focusedBorder: noneBorder,
          enableBorder: noneBorder,
          ),
            SizedBox(height: Responsive.heightMultiplier(context) * 2,),
            defaultTextForm(
              width: 400,
              height: Responsive.heightMultiplier(context) * 7,
              bgColor:  isDarkMode ? grey[800] :grey[200],
              controller: _confirmPasswordController,
              type: TextInputType.visiblePassword,
              label: 'Confirm Password',
              labelStyle: const TextStyle(
                fontSize: 18,
                color: grey,
              ),
              prefix: const Icon(
                key_outlined,
                color: defaultBlue2,
              ),
              suffix: isVisible2 ? visibility : visibility_off,
              suffixPressed: () {
                setState(() {
                  isVisible2 = !isVisible2;
                });
              },
              isPassword: isVisible2 ? false : true,
              maxLines: 1,
              autoValidateMode:
              AutovalidateMode.onUserInteraction,
              autofillHints: [AutofillHints.password],
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password confirmation';
                }
                else if (value != _passwordController.text) {
                  return "Password doesn't match.";
                }
                return null;
              },
              border:noneBorder,
              focusedBorder: noneBorder,
              enableBorder: noneBorder,
            ),
            SizedBox(height: Responsive.heightMultiplier(context) * 2.5,),
            BlocConsumer<AuthCubit ,AuthState>(
              listener: (context , state){
                final AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl();
                if(state is SignedUpState){
                   authLocalDataSourceImpl.cacheUid(state.uid);
                  navigateTo(context, const VerifyEmail());
                  authCubit(context).sendEmailVerification();
                }else if (state is GoogleSignInState){
                  authLocalDataSourceImpl.cacheUid(state.uid);
                  navigateAndFinish(context, HomePage(currentUserId:state.uid));
                }
                 else if (state is ErrorAuthState){
                  SnackBarMessage().showSnackBar(
                      message: state.message, context: context, isError: true);
                }
              },
              builder: (context, state) {
                if(state is LoadingState){
                  return const Center(child: CircularProgressIndicator());
                }
                return defaultGradientBottom(
                    text: 'Create Account',
                    width: 400,
                    height: Responsive.heightMultiplier(context) * 6.5,
                    context: context,
                    color1: indigoAccent,
                    color2: defaultBlue2,
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        authCubit(context).signUp(SignUpEntity(
                email: _emailController.text,
                password: _passwordController.text ,
                repeatedPassword: _confirmPasswordController.text ,
                name: _usernameController.text,));
                }}
                );
              }
            ),
            orDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                optionsBox(
                  context: context,
                  imgColor: red,
                  borderColor: grey,
                  imagePath: Assets.assetsGoogleIcon,
                  onPressed: (){
                    authCubit(context).signInWithGoogle();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account?", style: TextStyle(fontSize: 18,)),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      navigateAndReplace(context, const SignIn());
                    },
                    child: const Text("Login"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
