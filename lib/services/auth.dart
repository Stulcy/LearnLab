// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  /* Sign in with email */
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /* Register with email */
  Future<List<String>> registerWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      result.user.sendEmailVerification();
      return [result.user.uid, ''];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return [null, 'password is too weak'];
      } else if (e.code == 'email-already-in-use') {
        return [null, 'email is already in use'];
      } else if (e.code == 'invalid-email') {
        return [null, 'enter a valid email'];
      }
      return [null, e.code];
    } catch (e) {
      // General exception
      print(e);
      return [null, 'an error occured'];
    }
  }

  /* Sign out */
  Future<void> signOut() async {
    await FirebaseMessaging.instance.deleteToken();
    await _auth.signOut();
  }

  /* Password reset */
  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'invalid email';
      }
      return e.code;
    } catch (e) {
      print('general exception');
      return 'error';
    }
  }

  Future<bool> reauthenticateUser(String email, String password) async {
    try {
      final AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeEmail(String newEmail) async {
    try {
      await _auth.currentUser.updateEmail(newEmail);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _auth.currentUser.delete();
    } catch (e) {
      print(e);
    }
  }

  /* Auth change user stream */
  Stream<User> get user {
    return _auth.authStateChanges();
  }
}
