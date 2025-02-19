import 'package:flutter/material.dart';
import '../../../../core/responsive_ui.dart';
import '../../../../generated/assets.dart';
import '../widgets/sign_in_form.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800; // Web/Desktop View

          return Row(
            children: [
              // Left Section for Web/Desktop
              if (isWideScreen)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          height: Responsive.heightMultiplier(context) * 28,
                          width: Responsive.width(context) * 0.35,
                          image: const AssetImage(Assets.assetsLogoWithName2),
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Welcome to Chat App!",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

              // Right Section (Login Form)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 80 : 20),
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: Responsive.heightMultiplier(context) * 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isWideScreen) // Show image only on mobile
                            Hero(
                              tag: 'sign',
                              child: Image(
                                height: Responsive.heightMultiplier(context) * 28,
                                width: Responsive.width(context) * 0.3,
                                image: const AssetImage(Assets.assetsSignIn),
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const LoginForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
