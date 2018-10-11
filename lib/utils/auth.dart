import 'dart:async';

import 'package:crux/utils/base_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  @override
  Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  @override
  Future<FirebaseUser> signInWithGoogleEmailAndPassword() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user;
  }

  @override
  void signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
