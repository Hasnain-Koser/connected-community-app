import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/constants/loading.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/home/welcome.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:connected_community_app/services/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser userFromUser(User user) {
    return user != null
        ? MyUser({'uid': user.uid}, user.uid, user.emailVerified)
        : null;
  }

  Future<MyUser> constructMyUser(MyUser user) async {
    DocumentSnapshot userData = await DatabaseMethods().getUserFromDB(user.uid);
    MyUser newUser;
    if (userData.data() != null) {
      newUser = MyUser(userData.data(), user.uid, user.emailVerified);
      newUser.construct();
    }
    return newUser != null ? newUser : null;
  }

  User getCurrentUser() {
    User currentUser = _auth.currentUser;
    return currentUser;
  }

  Stream<MyUser> get user {
    return _auth.authStateChanges().map(userFromUser);
  }

  Future signInEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
      return userFromUser(user);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future registerEmail(String email, String password, BuildContext context,
      {String name,
      File photoFile,
      String memberType,
      String phoneNumber,
      String flatNumber}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      print(user);
      Map<String, dynamic> userData = {
        'email': email,
        'name': name,
        'memberType': memberType,
        'phoneNumber': phoneNumber,
        'photoFile': photoFile,
        'flatNumber': flatNumber,
        'status': null,
        'password': password,
      };
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Verify(
                    data: userData,
                  )));
      return userFromUser(user);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future signOut() async {
    try {
      Notifications().unsubscribeFromTopics();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
