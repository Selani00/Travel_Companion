import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_journal/models/firebase_user_model.dart';

import 'package:travel_journal/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //Create Stream to listen to auth changes
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //get current user
  getCurrentUser() async {
    try {
      final User? user = _auth.currentUser;
      return user!.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      print("Sign out");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = result.user;
      UserWithCredentials userWithCredentials =
          UserWithCredentials(uid: user!.uid, email: email, username: username);
      bool userCreatedInFirestore =
          await createUserInUsersCollection(userWithCredentials);
      //await SharedPreferenceService().saveUserEmail(email);
      //await SharedPreferenceService().saveUserId(user!.uid);
      if (userCreatedInFirestore) {
        return _userWithFirebaseUserUid(user);
      } else {
        throw Error();
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //CREATE NEW  user
  Future<bool> createUserInUsersCollection(
      UserWithCredentials userWithCredentials) async {
    try {
      await _firestore.collection('Users').add({
        'email': userWithCredentials.email,
        'id': _auth.currentUser!.uid,
        'username': userWithCredentials.username,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //UserWithCredentials return
  

  //gmail signup
  Future<bool> signInWithGoogle() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userDetils = result.user;

    bool gmailuserCreatedInFirestore = await createUserInUsersCollection(
        UserWithCredentials(
            uid: userDetils!.uid,
            email: userDetils.email,
            username: userDetils.displayName));

    if (gmailuserCreatedInFirestore) {
      return true;
    } else {
      return false;
    }
  }
}
