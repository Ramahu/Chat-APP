import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/sign_in_entity.dart';
import '../../../domain/entities/sign_up_entity.dart';
import '../../../domain/useCases/check_verification_useCase.dart';
import '../../../domain/useCases/create_user_usecase.dart';
import '../../../domain/useCases/first_page_useCase.dart';
import '../../../domain/useCases/google_auth_useCase.dart';
import '../../../domain/useCases/logout_useCase.dart';
import '../../../domain/useCases/sign_in_useCase.dart';
import '../../../domain/useCases/sign_up_useCase.dart';
import '../../../domain/useCases/verifiy_email_useCase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final CreateUserUseCase createUserUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final FirstPageUseCase firstPage;
  final CheckVerificationUseCase checkVerificationUseCase;
  final LogOutUseCase logOutUseCase;
  final GoogleAuthUseCase googleAuthUseCase;

  Completer<void> completer = Completer<void>();

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.createUserUseCase,
    required this.firstPage,
    required this.verifyEmailUseCase,
    required this.checkVerificationUseCase,
    required this.logOutUseCase,
    required this.googleAuthUseCase,
  }) : super(AuthInitial());

  void checkLoggingIn() {
    final theFirstPage = firstPage();
    if (theFirstPage.isLoggedIn) {
      emit(SignedInPageState());
    }
    else if (theFirstPage.isVerifyingEmail) {
      emit(VerifyEmailPageState());
    }
  }

  Future<void> signIn(SignInEntity signInEntity) async {
    emit(LoadingState());
    final failureOrUserCredential = await signInUseCase(signInEntity);
    // emit(eitherToState(failureOrUserCredential, SignedInState()));
    emit(eitherToStates(failureOrUserCredential, (userCredential) {
      return SignedInState(uid : userCredential.user!.uid);
    }));
  }

  Future<void> signUp(SignUpEntity signUpEntity) async {
    emit(LoadingState());
    final failureOrUserCredential = await signUpUseCase(signUpEntity);
    emit(eitherToStates(failureOrUserCredential, (userCredential) {
      final user = SignUpEntity(
        uid: userCredential.user!.uid,
        name: signUpEntity.name,
        email: signUpEntity.email,
        password: signUpEntity.password,
        repeatedPassword: signUpEntity.repeatedPassword,
      );
      createUser(user);
      return SignedUpState(uid : user.uid!);
    }));

    // emit(eitherToState(failureOrUserCredential, SignedUpState()));
  }

  Future<void> createUser(SignUpEntity user) async {
    emit(LoadingState());
    final failureOrResult = await createUserUseCase(user);
    emit(eitherToState(failureOrResult, CreateUserState()));
  }

  Future<void> sendEmailVerification() async {
    final failureOrSentEmail = await verifyEmailUseCase();
    emit(eitherToState(failureOrSentEmail, EmailIsSentState()));
  }

  Future<void> checkEmailVerification() async {
    if (!completer.isCompleted) {
      completer.complete();
      completer = Completer<void>();
    }
    final failureOrEmailVerified = await checkVerificationUseCase(completer);
    emit(eitherToState(failureOrEmailVerified, EmailIsVerifiedState()));
  }

  Future<void> logOut() async {
    final failureOrLogOut = await logOutUseCase();
    emit(eitherToState(failureOrLogOut, LoggedOutState()));
  }

  Future<void> signInWithGoogle() async {
    emit(LoadingState());
    final failureOrUserCredential = await googleAuthUseCase();

    emit(eitherToStates(failureOrUserCredential, (userCredential) {
      final user = userCredential.user;

      final signUpEntity = SignUpEntity(
        uid: user!.uid,
        name: user.displayName ?? 'No Name',          // Google provides displayName
        email: user.email ?? 'No Email',              // Google provides email
        password: '',                                 // No password for Google Sign-In
        repeatedPassword: '',                         // Same here
      );

      createUser(signUpEntity);
      return GoogleSignInState(uid:signUpEntity.uid!);
    }));

    // emit(eitherToState(failureOrUserCredential, GoogleSignInState()));
  }

  AuthState eitherToState(Either either, AuthState state) {
    return either.fold(
          (failure) => ErrorAuthState(message: _mapFailureToMessage(failure)),
          (_) => state,
    );
  }

  AuthState eitherToStates<L extends Failure, R>(
      Either<L, R> either,
      AuthState Function(R data) onSuccess,
      ) {
    return either.fold(
          (failure) => ErrorAuthState(message: _mapFailureToMessage(failure)),
          (data) => onSuccess(data),
    );
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return serverFailureMessage;
      case OfflineFailure _:
        return offlineFailureMessage;
      case WeekPassFailure _:
        return weakPassFailureMessage;
      case ExistedAccountFailure _:
        return existedAccountFailureMessage;
      case NoUserFailure _:
        return noUserFailureMessage;
      case TooManyRequestsFailure _:
        return tooManyRequestsFailureMessage;
      case WrongPasswordFailure _:
        return wrongPasswordFailureMessage;
      case UnmatchedPassFailure _:
        return unmatchedPasswordFailureMessage;
      case NotLoggedInFailure _:
        return '';
      default:
        return "Unexpected Error, Please try again later.";
    }
  }
}
