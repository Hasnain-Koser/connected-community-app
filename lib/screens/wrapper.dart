import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/Help/help.dart';
import 'package:connected_community_app/screens/authentication/authentication.dart';
import 'package:connected_community_app/screens/community/connectivity.dart';
import 'package:connected_community_app/screens/discover/discover.dart';
import 'package:connected_community_app/screens/home/home.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  final String screen;
  final String page;
  Wrapper({this.screen, this.page});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Widget returnPage(String screen, page, MyUser user, Function changefunc) {
    Map<String, Widget> pages = {
      'Home': Home(
        user: user,
        changefunc: changefunc,
      ),
      'Connectivity': Connectivity(
        page: page,
      ),
      'Discover': Discover(
        page: page,
      ),
      'Help': Help(
        user: user,
      ),
    };
    return pages[screen];
  }

  String currentPage = 'Home';
  String page;

  changeScreenPage(String screen, String reqpage) {
    currentPage = screen;
    page = reqpage;
    setState(() {});
  }

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    currentPage = widget.screen ?? currentPage;
    page = widget.page ?? page;
    if (user != null) {
      return Scaffold(
        body: returnPage(currentPage, page, user, changeScreenPage),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                blurRadius: 5, color: Colors.black26, offset: Offset(0, -3))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    currentPage = 'Home';
                    page = null;
                  });
                },
                child: Ink(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: currentPage == 'Home'
                            ? Border(
                                bottom: BorderSide(
                                    width: 3, color: Colors.blue[700]))
                            : null,
                      ),
                      child: Icon(
                        Icons.home,
                        size: 40,
                        color: Colors.blue[700],
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    currentPage = 'Discover';
                    page = null;
                  });
                },
                child: Ink(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: currentPage == 'Discover'
                            ? Border(
                                bottom: BorderSide(
                                    width: 3, color: Colors.blue[700]))
                            : null,
                      ),
                      child: Icon(
                        CupertinoIcons.compass,
                        size: 40,
                        color: Colors.blue[700],
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    currentPage = 'Connectivity';
                    page = null;
                  });
                },
                child: Ink(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: currentPage == 'Connectivity'
                            ? Border(
                                bottom: BorderSide(
                                    width: 3, color: Colors.blue[700]))
                            : null,
                      ),
                      child: Icon(
                        CupertinoIcons.person_3_fill,
                        size: 40,
                        color: Colors.blue[700],
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    currentPage = 'Help';
                    page = null;
                  });
                },
                child: Ink(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: currentPage == 'Help'
                            ? Border(
                                bottom: BorderSide(
                                    width: 3, color: Colors.blue[700]))
                            : null,
                      ),
                      child: Icon(
                        Icons.help,
                        size: 40,
                        color: Colors.blue[700],
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Authentication();
    }
  }
}
