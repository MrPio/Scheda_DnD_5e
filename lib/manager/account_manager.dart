import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'data_manager.dart';

enum SignInStatus {
  success,
  wrongCredentials,
  userNotInDatabase;

  const SignInStatus();
}


enum SignUpStatus {
  success,
  weakPassword,
  emailInUse,
  genericError;

  const SignUpStatus();
}

class AccountManager {
  static final AccountManager _instance = AccountManager._();

  factory AccountManager() => _instance;

  AccountManager._();

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  late User user;

  Future<bool> cacheSignIn() async {
    String? uid = await IOManager().get("uid");
    if (uid == null) return false;
    user = await DataManager().loadUser(uid, force: true);
    return true;
  }

  Future<SignInStatus> signIn(emailAddress, password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      await IOManager().set("uid", credential.user!.uid);
      user = await DataManager().loadUser(credential.user?.uid, force: true);
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
      await IOManager().set("uid", credential.user!.uid);
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
    await IOManager().remove("uid");
    await _auth.signOut();
  }

  bool isEmailValid(String email) =>
      RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$').hasMatch(email);
}
