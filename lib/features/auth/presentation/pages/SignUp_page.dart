import 'package:flutter/material.dart';

import '../../../../core/responsive_ui.dart';
import '../../../../generated/assets.dart';
import '../widgets/sign_up_form.dart';

class SignUp extends StatelessWidget{
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(height: Responsive.heightMultiplier(context) * 1,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag: 'sign',
                child: Image(
                  height: Responsive.heightMultiplier(context) * 28,
                  width: Responsive.width(context) * 0.3,
                  image: const AssetImage(Assets.assetsSignIn)),
            ),
            ),
            Center(
                child: Text("Sign Up",
                  style: TextStyle(fontSize: Responsive.textMultiplier(context) * 7 ,
                      fontWeight: FontWeight.bold),)),
            SizedBox(height: Responsive.heightMultiplier(context) * 1.5,),
            const SignUpForm(),
          ],
        ),
      ),
    );
  }
}
