import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/constants/loading.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Rohan Mithila - Sign In'),
              centerTitle: true,
              backgroundColor: Colors.cyan[700],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal:20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/Sign_In_bg.jpg')
                  )
                ),
                child: SingleChildScrollView(
                                  child: Container(
                                    child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
            Expanded(
                                      child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 5,
                              )
                            ],
                            borderRadius: BorderRadius.circular(16)
                          ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text('Email: ', style: TextStyle(color: Colors.white, fontSize: 19),),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecor.copyWith(hintText: 'Email'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter an Email' : null,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Password: ', style: TextStyle(color: Colors.white, fontSize: 19),),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecor.copyWith(hintText: 'Password'),
                        obscureText: true,
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
                    ],
                  ),
              ),
            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
            if (_formKey.currentState.validate()) {
              setState(() {
                  loading = true;
              });
              dynamic result =
                    await _auth.signInEmail(email, password, context);
              print(result);
              Notifications().subscribeToTopics();
              if (result != MyUser && mounted) {
                  loading = false;
                  error = result
                      .toString()
                      .substring(result.toString().indexOf("]") + 1);
                  Notifications().unsubscribeFromTopics();
                  setState(() {});
              }
              Navigator.pop(context);
            }
                          },
                          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[900],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        SizedBox(width: 35,),
                        Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.white,),
                      ],
                    ),
                  ),
              ],
            ),
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
          );
  }
}
