import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';
import '../models/sign_in_model.dart';
import '../models/sign_up_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signUp(SignUpModel signUp);
  Future<UserCredential> signIn(SignInModel signIn);
  Future<UserCredential> googleAuthentication();
  Future<void> createUser(SignUpModel user);
  Future<Unit> verifyEmail();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore fireStore;
  FirebaseAuth firebaseInstance = FirebaseAuth.instance;
  AuthRemoteDataSourceImpl({required this.fireStore , required this.firebaseInstance});

  @override
  Future<UserCredential> signIn(SignInModel signIn) async {
    try {
      firebaseInstance.setSettings(appVerificationDisabledForTesting: true);
      await  firebaseInstance.currentUser?.reload();
     return  await firebaseInstance.signInWithEmailAndPassword(
        email: signIn.email,
        password: signIn.password,
      );
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ExistedAccountException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }else{
        throw ServerException();
      }
    }
  }

  @override
  Future<UserCredential> signUp(SignUpModel signUp) async {
    try {
      firebaseInstance.setSettings(appVerificationDisabledForTesting: true);
      await  firebaseInstance.currentUser?.reload();
      return await firebaseInstance.createUserWithEmailAndPassword(
        email: signUp.email,
        password: signUp.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeekPassException();
      } else if (e.code == 'email-already-in-use') {
        throw ExistedAccountException();
      }else{
        throw ServerException();
      }
    }
  }

  @override
  Future<void> createUser(SignUpModel user) async {
    try {
      final usersCollectionRef = fireStore.collection("users");
      final userDoc = await usersCollectionRef.doc(user.uid).get();

      if (userDoc.exists) {
        print('User already exists in Fire store.');
        return;
      }
      return await usersCollectionRef.doc(user.uid).set({
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
      });
    } catch(e){
      throw ServerException();
    }
  }

  @override
  Future<Unit> verifyEmail() async {
    final user = firebaseInstance.currentUser;
    if(user != null){
      try{
        await user.reload();
        // Check if email is verified already
        if (user.emailVerified) {
          print("Email is already verified.");
           return Future.value(unit);
        }
        await user.sendEmailVerification();
      }on FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          throw TooManyRequestsException();
        }else {
          throw ServerException();
        }
      }catch(e){
        throw ServerException();
      }
    }else{
      throw NoUserException();
    }
    return Future.value(unit);
  }

  @override
  Future<UserCredential> googleAuthentication() async {
    await  firebaseInstance.currentUser?.reload();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try{
      return await firebaseInstance.signInWithCredential(credential);
    }catch(e){
      throw ServerException();
    }
  }

}
