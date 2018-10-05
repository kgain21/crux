import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<FirebaseUser> signInWithGoogleEmailAndPassword();

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<String> currentUser();

  Future<void> signOut(BuildContext context);
}
