import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'package:tuple/tuple.dart';

import 'data_manager.dart';

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
  static AccountManager _instance = AccountManager._();

  factory AccountManager() => _instance;

  AccountManager._();

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User user;
  static final List<Tuple2<String,RegExp>> passwordConstraints = [
    Tuple2('Tra 8 e 30 caratteri', RegExp(r'^.{8,30}$')),
    Tuple2('Una lettera maiuscola', RegExp(r'[A-Z]')),
    Tuple2('Una lettera minuscola', RegExp(r'[a-z]')),
    Tuple2('Un numero', RegExp(r'\d')),
    Tuple2('Un carattere speciale (@\$!%*?&)', RegExp(r'[!@#$&*~]')),
  ];

  /// Check if a user auth exists, and if so, load the object from the db
  Future<bool> cacheSignIn() async {
    if (_auth.currentUser != null) {
      user = await DataManager().load(_auth.currentUser!.uid, useCache: true);
    }
    return _auth.currentUser != null;
  }

  Future<SignInStatus> signIn(String emailAddress, String password) async {
    try {
      final userCredential =
          await _auth.signInWithEmailAndPassword(email: emailAddress, password: password);
      user = await DataManager().load(userCredential.user!.uid, useCache: false);
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

  /// Logout the current cached user and re-initialize this manager
  Future<void> signOut() async {
    await _auth.signOut();
    _instance = AccountManager._();
  }

  Future<fb.UserCredential?> _askGoogleAccount() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

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
          user = User(email: userCredential.user!.email!, username: userCredential.user!.displayName!);
          user.uid = userCredential.user!.uid;
          DataManager().save(user);
          return SignInStatus.successNewAccount;
        } else {
          print('👤 SignIn with Google');
          print('📘${userCredential.additionalUserInfo!.profile}');
          user = await DataManager().load(userCredential.user!.uid, useCache: false);
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

  /// Reload the user from the database skipping the cache
  reloadUser() async {
    User newUser = await DataManager().load(user.uid!, useCache: false);
    user.charactersUIDs = newUser.charactersUIDs;
    user.deletedCharactersUIDs = newUser.deletedCharactersUIDs;
    user.campaignsUIDs = newUser.campaignsUIDs;
    // ...
    // All other fields that may have changed
    // Note: I intentionally avoid reassigning the new instance
    // in order to preserve any listener to the `ValueListener` fields
  }

  Future<ResetPasswordStatus> resetPasswordWithConstraints(
      String currentPassword, String newPassword) async {
    // Check if a user is currently logged in
    if (_auth.currentUser == null) {
      print('🚨 No user is logged in.');
      return ResetPasswordStatus.error;
    }

    // Validate the new password constraints
    final passwordPattern =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,30}$');
    if (!passwordPattern.hasMatch(newPassword)) {
      print('🚨 Password does not meet the constraints.');
      return ResetPasswordStatus.error;
    }

    try {
      // Reauthenticate the user with the current password
      final email = _auth.currentUser!.email!;
      final credential = fb.EmailAuthProvider.credential(email: email, password: currentPassword);
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // Update the password
      await _auth.currentUser!.updatePassword(newPassword);
      print('✅ Password successfully updated.');
      return ResetPasswordStatus.success;
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print('🚨 The current password is incorrect.');
      } else if (e.code == 'requires-recent-login') {
        print('🚨 User needs to reauthenticate.');
      } else {
        print('🚨 Firebase error: ${e.message}');
      }
      return ResetPasswordStatus.error;
    } catch (e) {
      print('🚨 An unexpected error occurred: $e');
      return ResetPasswordStatus.error;
    }
  }
}
