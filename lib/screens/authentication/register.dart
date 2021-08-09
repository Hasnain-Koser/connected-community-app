import 'dart:async';
import 'dart:io';

import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/constants/loading.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  File image;
  final picker = ImagePicker();
  bool loading = false;

  String email = '';
  String password = '';
  String name = '';
  String profileUrl = '';
  String memberType = 'Resident';
  String phoneNumber = '';
  String flatNumber = '';
  String error = '';

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Rohan Mithila - Sign Up'),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/Register_bg.jpg'))),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[600],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 5,
                            )
                          ],
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration:
                                textInputDecor.copyWith(hintText: 'Email'),
                            validator: (value) =>
                                value.isEmpty ? 'Enter an Email' : null,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration:
                                textInputDecor.copyWith(hintText: 'Password'),
                            validator: (value) => value.length < 8
                                ? 'Password should be atleast 8 characters long'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration:
                                textInputDecor.copyWith(hintText: 'Name'),
                            validator: (value) =>
                                value.isEmpty ? 'Enter your Name' : null,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecor.copyWith(
                                hintText: 'Phone Number'),
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Enter a valid Phone Number'
                                  : null;
                            },
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecor.copyWith(
                                hintText: 'Flat Number'),
                            validator: (value) => value.isEmpty
                                ? 'Enter a valid Flat Number'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                flatNumber = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: getImage,
                            child: CircleAvatar(
                              backgroundImage: image != null
                                  ? FileImage(image)
                                  : AssetImage('assets/img_avatar.png'),
                              radius: 200,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green[400];
                                  return Colors
                                      .green; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _auth.registerEmail(
                                    email, password, context,
                                    name: name,
                                    photoFile: image,
                                    memberType: memberType,
                                    phoneNumber: phoneNumber,
                                    flatNumber: flatNumber);
                                Notifications().subscribeToTopics();
                                if (result != MyUser && this.mounted) {
                                  setState(() {
                                    error = result.toString().substring(
                                        result.toString().indexOf("]") + 1);
                                    Notifications().unsubscribeFromTopics();
                                    loading = false;
                                  });
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
