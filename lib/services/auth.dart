
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_up_park/app/user_model.dart';

class AuthService with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
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

  Future registerUserWithEmailAndPassword(String email, String password, firstName, lastName, List<String> groupsFollowing) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      PTUser user = PTUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        admin: 'false',
        groupsFollowing: groupsFollowing,
        id: result.user!.uid,
      );
      _database.collection('users').doc(user.id).set(user.toMap());

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