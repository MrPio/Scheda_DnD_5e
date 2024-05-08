import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'data_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignInStatus {
  success,
  wrongCredentials,
  userNotInDatabase,
  googleProviderError,
  canceled,
  successNewAccount;
}

enum SignUpStatus {
  success,
  weakPassword,
  emailInUse,
  genericError,
  googleProviderError,
  canceled;
}

enum ResetPasswordStatus {
  success,
  error;
}

class AccountManager {
  static final AccountManager _instance = AccountManager._();

  factory AccountManager() => _instance;

  AccountManager._();

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User user;

  // Check if a user auth exists, and if so, load the object from the db
  Future<bool> cacheSignIn() async {
    if (_auth.currentUser != null) {
      user =
          await DataManager().load(_auth.currentUser!.uid, useCache: false);
    }
    return _auth.currentUser != null;
  }

  Future<SignInStatus> signIn(String emailAddress, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      user = await DataManager()
          .load(userCredential.user!.uid, useCache: false);
    } catch (e) {
      if (e.toString().contains("type 'Null' is not a subtype")) {
        return SignInStatus.userNotInDatabase;
      }
      return SignInStatus.wrongCredentials;
    }
    return SignInStatus.success;
  }

  Future<SignUpStatus> signUp(email, password, User newUser) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      newUser.uid = credential.user!.uid;
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return SignUpStatus.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return SignUpStatus.emailInUse;
      }
    } catch (e) {
      return SignUpStatus.genericError;
    }
    await DataManager().save(newUser);
    user = newUser;
    return SignUpStatus.success;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<fb.UserCredential?> _askGoogleAccount() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return await _auth.signInWithCredential(credential);
    }
    return null;
  }

  Future<SignInStatus> signInWithGoogle() async {
    try {
      final userCredential = await _askGoogleAccount();
      if (userCredential != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          print('👤 SignUp with Google');
          user = User(
              email: userCredential.user!.email!,
              nickname: userCredential.user!.displayName!);
          user.uid = userCredential.user!.uid;
          DataManager().save(user);
          return SignInStatus.successNewAccount;
        } else {
          print('👤 SignIn with Google');
          print('📘${userCredential.additionalUserInfo!.profile}');
          user = await DataManager()
              .load(userCredential.user!.uid, useCache: false);
          return SignInStatus.success;
        }
      } else {
        return SignInStatus.canceled;
      }
    } catch (e) {
      print(e);
      if (e.toString().contains("type 'Null' is not a subtype")) {
        return SignInStatus.userNotInDatabase;
      }
      return SignInStatus.googleProviderError;
    }
  }

  Future<ResetPasswordStatus> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ResetPasswordStatus.success;
    } catch (e) {
      return ResetPasswordStatus.error;
    }
  }

  reloadUser()async {
    User newUser=await DataManager().load(user.uid!,useCache: false);
    user.charactersUIDs=newUser.charactersUIDs;
    user.campaignsUIDs=newUser.campaignsUIDs;
    // All other fields that may have changed
    // Note: I intentionally do not reassign the user with the new instance
    // in order to maintain any listener to the ValueListener fields
  }
}
