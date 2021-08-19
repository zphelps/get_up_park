
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/services/firebase_analytics.dart';

class AuthService with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await analytics.logLogin();
      notifyListeners();
      // User user = result.user;
      // return _userFromFirebaseUser(user);
      return result;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerUserWithEmailAndPassword(String email, String password, String firstName, String lastName, List<String> groupsFollowing, String advisor) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // if(result != null) {
      //   await result.user!.sendEmailVerification();
      // }

      PTUser user = PTUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        admin: 'User',
        groupsFollowing: groupsFollowing,
        id: result.user!.uid,
        datesTriviaCompleted: [],
        advisor: advisor,
        groupsUserCanAccess: [],
      );
      await analytics.setUserProperty(name: 'advisor', value: advisor);
      await _database.collection('users').doc(user.id).set(user.toMap());

      notifyListeners();
      // User user = result.user;
      // return _userFromFirebaseUser(user);
      return result;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      notifyListeners();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

}