import 'package:delivery_app/Shared/Shared_widget/responsive_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Usercontroller {
  String? Exceptioncode;
  Future signin(TextEditingController Email, TextEditingController Password,
      BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: Email.text.trim(), password: Password.text.trim());
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Invalid-email.') {
        _Errormessage(context, 'invalid-email');
      } else if (e.code == 'user-not-found') {
        Exceptioncode = 'No user found for that email.';
        _Errormessage(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Exceptioncode = 'Wrong password provided for that user.';
        _Errormessage(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signup(TextEditingController Email, TextEditingController Password,
      BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Email.text.trim(), password: Password.text.trim());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.message}');
      if (e.message == 'Password should be at least 6 characters') {
        Exceptioncode = 'weak-password';
        _Errormessage(context, 'Weak-password');
      } else if (e.message == 'The email address is badly formatted.') {
        Exceptioncode == 'Invalid-email';
        _Errormessage(context, 'Invalid-email');
      } else if (e.message ==
          'The email address is already in use by another account.') {
        Exceptioncode == 'email-already-in-use';
        _Errormessage(context, 'Email-already-in-use');
      }
    } catch (e) {
      print(e);
    }
  }

  _Errormessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black87,
        content: Text(
          message,
          style: TextStyle(
              color: Colors.amber,
              fontSize: middletext(MediaQuery.of(context).size.height)),
        )));
  }
}
