import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/home/profile.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final Function changefunc;
  final MyUser user;
  Home({this.user, this.changefunc});
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  MyUser user;
  Stream chatStream;
  List<Map<String, dynamic>> updates;
  List colors = [
    Colors.green,
    Colors.lightBlue,
    Colors.pink,
    Colors.amber,
    Colors.purple
  ];

  List<Widget> listToWidgets() {
    List<Widget> widgets = [];
    for (var i = 0; i < updates.length; i++) {
      Map<String, dynamic> update = updates[i];
      int randomIndex = Random().nextInt(colors.length);
      Widget widgetTile = InkWell(
        onTap: () {
          update['type'] == 'event'
              ? widget.changefunc('Discover', 'Timeline')
              : widget.changefunc('Connectivity', 'CommunityPosts');
        },
        child: Container(
          width: 125,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors[randomIndex][200],
                  colors[randomIndex],
                ]),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        update['title'],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        update['data'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text('Community Post'),
                ),
              ]),
        ),
      );
      widgets.add(widgetTile);
    }
    return widgets;
  }

  onLaunch() async {
    user = await _auth.constructMyUser(widget.user);
    if (user != null) {
      chatStream = await DatabaseMethods().getHomeMessages(user.uid);
    }
    updates = await DatabaseMethods().getNotifFromDB();
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.lightBlue[700], Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        ),
        SafeArea(
          child: Column(
            children: [
              user != null
                  ? Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.yellow[700],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile(
                                              user: user,
                                            )));
                              },
                              child: Container(
                                  child: Row(children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profileUrl),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${user.name}\'s Profile',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ]))),
                          IconButton(
                              icon: Icon(Icons.logout),
                              onPressed: () => _auth.signOut())
                        ],
                      ),
                    )
                  : Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                    ),
              Container(
                height: 140,
                width: 500,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                      )
                    ]),
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: updates != null
                          ? listToWidgets()
                          : [
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 310,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Notifications',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              widget.changefunc('Connectivity', 'Chat');
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.indigo[300],
                              ),
                              height: 230,
                              child: Column(
                                children: [
                                  Padding(
                                    child: Text(
                                      'Chat',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  StreamBuilder(
                                    stream: chatStream,
                                    builder: (context, snapshot) {
                                      return snapshot.hasData
                                          ? ListView.builder(
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                DocumentSnapshot doc =
                                                    snapshot.data.docs[index];
                                                return Tile(
                                                  documentSnapshot: doc,
                                                  type: 'chat',
                                                );
                                              })
                                          : Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              widget.changefunc(
                                  'Discover', 'Community Service');
                            },
                            child: Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.lightGreen,
                                ),
                                height: 230,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Services',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.medical_services,
                                                    size: 40,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          'Get to know about the various medical services within your community.')),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                        'Hungry? want some snacks or a meal, Look at what your community has to offer to you.'),
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Icon(
                                                    Icons.room_service,
                                                    size: 40,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.engineering,
                                                    size: 40,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          'See how your community can help you fix your technical issues, or provide other services to help you out.')),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                'You can too offer a service to your community by setting it up on the services page.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
    // return Container(
    //   color: Colors.white,
    //   child: Column(
    //     children: [
    //       Container(
    //         height: 100,
    //       ),
    //       GestureDetector(
    //         onTap: () {
    //           AuthService().signOut();
    //         },
    //         child: Icon(Icons.logout),
    //       ),
    //       TextButton(
    //           onPressed: () {
    //             Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: user,)));
    //           },
    //           child: Text('Profile'))
    //     ],
    //   ),
    // );
  }
}

class Tile extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String type;
  Tile({this.documentSnapshot, this.type});
  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  DocumentSnapshot user;
  String name;
  String data;

  getUser() async {
    if (widget.type == 'chat') {
      user = await DatabaseMethods()
          .getUserFromDB(widget.documentSnapshot['lastMessageSentBy']);
      name = user['name'];
      data = widget.documentSnapshot['lastMessage'];
    } else if (widget.type == 'service') {
      name = widget.documentSnapshot['serviceByName'];
      data = widget.documentSnapshot['service'];
    }
  }

  onLaunch() async {
    await getUser();
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(8),
      color: widget.type == 'chat' ? Colors.lightBlue[200] : Colors.orange[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            data != null ? data : '',
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            name != null ? '- $name' : '',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
