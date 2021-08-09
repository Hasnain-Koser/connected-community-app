import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/home/userlist.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final MyUser user;
  Profile({this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MyUser user;
  AuthService _auth = AuthService();
  bool open = false;
  double containerWidth = 0.0;
  TextStyle userData = TextStyle(fontSize: 20, color: Colors.black87);

  animateWidth(double width) {
    setState(() {
      containerWidth = width;
      open = !open;
    });
  }

  onLaunch() async {
    user = await _auth.constructMyUser(widget.user);
    setState(() {});
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle profileData = TextStyle(fontSize: 16, color: Colors.grey[300]);
    Widget returnProfileTile(String field, String userValue) {
      return Container(
        padding: EdgeInsets.only(top: 15, right: 15, left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 5,
          //     color: Colors.black87,
          //   )
          // ]
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: Text(field),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    userValue,
                    style: userData,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 0.5,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return user != null
        ? Scaffold(
            appBar: AppBar(
              title: Text("${user.name}'s Profile"),
              backgroundColor: Colors.blue[800],
              elevation: 0,
              actions: [
                Row(
                  children: [
                    Container(
                      child: AnimatedContainer(
                        width: containerWidth,
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          'Edit Profile',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (open) {
                            animateWidth(0);
                            print('open user settings');
                          } else {
                            animateWidth(70);
                          }
                        })
                  ],
                )
              ],
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 30, right: 20, left: 20),
                    width: double.maxFinite,
                    decoration:
                        BoxDecoration(color: Colors.blue[800], boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black87,
                      )
                    ]),
                    child: SafeArea(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profileUrl),
                            radius: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${user.name}',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white.withOpacity(0.85)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${user.flatNumber}',
                            style: profileData,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${user.email}',
                            style: profileData,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            returnProfileTile(
                                'Phone Number', '${user.phoneNumber}'),
                            returnProfileTile(
                                'Member Type', '${user.memberType}'),
                            returnProfileTile('User Id', '${user.uid}'),
                            user.status == null
                                ? returnProfileTile('Status', '')
                                : returnProfileTile('Status', '${user.status}'),
                            user.memberType == 'Admin'
                                ? Container(
                                  margin: EdgeInsets.all(16),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.blue[700]
                                  ),
                                  child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminUserList(
                                                      user: user,
                                                    )));
                                      },
                                      label: Text('Access Users', style: TextStyle(color: Colors.white),),
                                      icon: Icon(Icons.arrow_right, color: Colors.white),
                                    ),
                                )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
