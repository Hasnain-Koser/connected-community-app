import 'package:connected_community_app/screens/authentication/register.dart';
import 'package:connected_community_app/screens/authentication/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cover extends StatefulWidget {
  @override
  _CoverState createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/society_cover_picture.jpg'))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 5)
                      ]),
                  child: Image(
                    height: 150,
                    width: 270,
                    image: AssetImage('assets/logo.jpg'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  color: Colors.black87,
                  child: Text(
                    'Welcome To Rohan Mithila',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.none,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.normal,
                        ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(color: Colors.black54, blurRadius: 5)
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            CupertinoIcons.arrow_right_circle_fill,
                            color: Colors.white,
                          ),
                        ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.blue[700],
                        boxShadow: [
                          BoxShadow(color: Colors.black54, blurRadius: 5)
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            CupertinoIcons.arrow_right_circle_fill,
                            color: Colors.white,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
