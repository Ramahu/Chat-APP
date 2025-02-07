import 'package:chat/features/auth/presentation/pages/SignIn_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app_theme.dart';
import 'core/network/local/cache_helper.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/presentation/pages/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/cubit/auth_state.dart';
import 'features/chat/presentation/pages/cubit/chat_cubit.dart';
import 'features/chat/presentation/pages/home_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) =>  di.sl<AuthCubit>()..checkLoggingIn(),),
          BlocProvider(create: (_) => di.sl<ChatCubit>()),
        ],

              child: MaterialApp(
                title: 'Chat App',
                theme: AppTheme.lightTheme(context),
                darkTheme: AppTheme.darkTheme(context),
                themeMode: ThemeMode.system,
                debugShowCheckedModeBanner: false,
                home:  const AuthWrapper(),
              ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is SignedInPageState) {
          final authLocalDataSourceImpl = AuthLocalDataSourceImpl();

          return FutureBuilder<String?>(
            future: authLocalDataSourceImpl.getCachedUid(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                String currentUserId = snapshot.data!;
                print("Current User ID in main: $currentUserId");

                return HomePage(currentUserId: currentUserId);
              }

              return  SignIn();
            },
          );
        } else {
          return  SignIn();
        }
      },
    );
  }
}

