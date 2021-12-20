import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuth {
  static bool emailInUse = false;
  static bool userExists = false;

  static Future<User?> registerUsingEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    FireAuth.emailInUse = false;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trimRight(),
        password: password.trimRight(),
      );
      user = userCredential.user;
      // ignore: deprecated_member_use
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: avoid_print
        print('A password escolhida é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        // ignore: avoid_print
        //print('Já existe uma conta com esse e-mail!!');
        FireAuth.emailInUse = true;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    FireAuth.userExists = true;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('Nenhum utilizador encontrado para este email.');
        FireAuth.userExists = false;
      } else if (e.code == 'wrong-password') {
        // ignore: avoid_print
        print('Senha errada.');
      }
    }
    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }

/*
  static Future<void> resetPassword({required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: unused_local_variable

    FireAuth.userExists = true;

    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: '@',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('Nenhum utilizador encontrado para este email.');
        FireAuth.userExists = false;
      } else {
        try {
          auth.sendPasswordResetEmail(email: email);
        } on FirebaseAuthException catch (e) {
          // ignore: avoid_print
          print(e.code);
        }
      }
    }
  }
  */

  static Future<void> resetPassword({required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: unused_local_variable

    FireAuth.userExists = true;

    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('Nenhum utilizador encontrado para este email.');
        FireAuth.userExists = false;
      } else {
        // ignore: avoid_print
        print(e.code);
      }
    }
  }

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    UserCredential userCredential;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      userCredential = await auth.signInWithCredential(credential);
      user = userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return user;
  }
}
