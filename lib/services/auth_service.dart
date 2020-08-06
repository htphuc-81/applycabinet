import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter_cabinett/model/Users.dart';
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
  );

  // Email & Password Sign Up
  Future<String> signUp(
      String email, String password, String firstname , String lastname,String username) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = await _firebaseAuth.currentUser();
    // Update the username

    //return currentUser.user.uid;
    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email  verification");
      print(e.message);
    }
    //update the username
    await updateUserName(lastname, authResult.user);
    //return authResult.user.uid;
  }
  Future updateUserName(String lastname, FirebaseUser curentUser)async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = lastname;
    await curentUser.updateProfile(userUpdateInfo);
    await curentUser.reload();
  }
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }
  // Email & Password Sign In
  Future<String> signIn(
      String email, String password) async {
    FirebaseUser user = ( await
    _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    print('user: $user');
    if (user.isEmailVerified) return user.uid;
    return null;

  }
  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
  Future sendPasswordResetEmail(String email)async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

class FirstNameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "FirstName can't be empty";
    }
    if (value.length < 2) {
      return "First Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "First Name must be less than 50 characters long";
    }
    return null;
  }
}
class LastNameValidator{
  static String validate(String value) {
    if (value.isEmpty) {
      return "Last Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}
class UserNameValidator{
  static String validate(String value) {
    if (value.isEmpty) {
      return "User Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}