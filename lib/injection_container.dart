import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/authentication_repository.dart';
import 'features/auth/domain/useCases/check_verification_useCase.dart';
import 'features/auth/domain/useCases/create_user_usecase.dart';
import 'features/auth/domain/useCases/first_page_useCase.dart';
import 'features/auth/domain/useCases/google_auth_useCase.dart';
import 'features/auth/domain/useCases/logout_useCase.dart';
import 'features/auth/domain/useCases/sign_in_useCase.dart';
import 'features/auth/domain/useCases/sign_up_useCase.dart';
import 'features/auth/domain/useCases/verifiy_email_useCase.dart';
import 'features/auth/presentation/pages/cubit/auth_cubit.dart';
import 'features/chat/data/datasources/remote/chat_list_firebase_remote_source.dart';
import 'features/chat/data/datasources/remote/user_message_list_remote_source.dart';
import 'features/chat/data/repositories/user_messages_list_repo_impl.dart';
import 'features/chat/data/repositories/userlist_firebase_repo_impl.dart';
import 'features/chat/domain/repositories/user_list_messages_repo.dart';
import 'features/chat/domain/repositories/chat_list_repo.dart';
import 'features/chat/domain/usecases/add_message_usecase.dart';
import 'features/chat/domain/usecases/get_last_msg_usecase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/get_userlist_firebase_usecase.dart';
import 'features/chat/presentation/pages/cubit/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {

// cubit
// Auth feature
  sl.registerFactory(() => AuthCubit(signInUseCase: sl(),
      signUpUseCase: sl(),createUserUseCase: sl(), firstPage: sl() , verifyEmailUseCase: sl(),
      checkVerificationUseCase:sl(), logOutUseCase: sl(), googleAuthUseCase: sl()));
  // Chat feature
  sl.registerFactory(() => ChatCubit(addMessageUseCase: sl(),
      getMessagesUseCase: sl(), getUserListUseCase: sl() ,getLastMessageUseCase : sl()));


// Use Cases
// Auth feature
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => FirstPageUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckVerificationUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => GoogleAuthUseCase(sl()));
// Chat feature
  sl.registerLazySingleton(() => AddMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => GetChatListUseCase(sl()));
  sl.registerLazySingleton(() => GetLastMessageUseCase(sl()));




// Repository
// Auth feature
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImp(
      networkInfo: sl(), authRemoteDataSource: sl()));
  // Chat feature
  sl.registerLazySingleton<ChatListRepository>(() => ChatListRepoImpl( networkInfo: sl(),firebaseRemote: sl()));
  sl.registerLazySingleton<UserListMessagesRepo>(() => UserMessagesListRepoImpl( networkInfo: sl(),userMessageListRemoteSource: sl()));


// Data Sources
// Auth feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(fireStore: sl(), firebaseInstance: sl()));
  // Chat feature
  sl.registerLazySingleton<UserMessageListRemoteSource>(
          () => UserMessageListRemoteSourceImpl(fireStore: sl()));
  sl.registerLazySingleton<ChatListFirebaseRemoteSource>(
          () => ChatListFirebaseRemoteImpl(fireStore: sl()));


//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final fireStore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => fireStore);
  final  firebaseInstance = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseInstance);




}
