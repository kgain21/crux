import 'dart:async';

import 'package:crux/backend/services/base_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    /*final FirebaseUser user = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;*/
    return null;
  }

  @override
  Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    /*final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;*/
    return null;
  }

  @override
  Future<FirebaseUser> signInWithGoogleEmailAndPassword() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult =
      await _firebaseAuth.signInWithCredential(credential);

      return authResult.user;
    } catch(e) {
      print(e);
      return null;
    }
  }

  @override
  void signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
