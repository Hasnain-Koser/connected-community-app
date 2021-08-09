import 'dart:async';

import 'package:connected_community_app/screens/home/welcome.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.blue,
          size: 50,
        ),
      ),
      color: Colors.blue[100],
    );
  }
}

class Verify extends StatefulWidget {
  final Map<String, dynamic> data;
  Verify({this.data});
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  Timer timer;
  AuthService _auth = AuthService();
  User currentUser;

  @override
  void initState() {
    currentUser = _auth.getCurrentUser();
    currentUser.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkVerified();
    });
    super.initState();
  }

  checkVerified() async {
    currentUser = _auth.getCurrentUser();
    await currentUser.reload();
    if (currentUser.emailVerified) {
      timer.cancel();
      String downloadUrl = await DatabaseMethods()
          .uploadImageToStorage(widget.data['photoFile'], currentUser.uid);

      Map<String, dynamic> userData = {
        'email': widget.data['email'],
        'username': widget.data['email']
            .substring(0, widget.data['email'].indexOf('@')),
        'uid': currentUser.uid,
        'name': widget.data['name'],
        'memberType': widget.data['memberType'],
        'phoneNumber': widget.data['phoneNumber'],
        'profileUrl': downloadUrl,
        'flat': widget.data['flatNumber'],
        'status': null,
      };
      await DatabaseMethods().addUserToDB(currentUser.uid, userData);
      await _auth.signOut();
      await _auth.signInEmail(widget.data['email'], widget.data['password'], context);
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please Verify your email', style: TextStyle(fontSize: 20),),
            SpinKitThreeBounce(
              color: Colors.blue,
              size: 50,
            ),
          ],
        ),
        color: Colors.blue[100],
      ),
    );
  }
}
