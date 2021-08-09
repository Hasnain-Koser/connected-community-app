import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/community/chat/chat.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:video_player/video_player.dart';

class Help extends StatefulWidget {
  final MyUser user;
  Help({this.user});
  @override
  _HelpState createState() => _HelpState();
}


class _HelpState extends State<Help> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  Stream complaintStream;
  MyUser user;
  AuthService _auth = AuthService();
  String type;
  List colors = [
    Colors.green[100],
    Colors.pink[100],
    Colors.amber[100],
    Colors.purple[100]
  ];
  String complaint;

  void _showNewServicePanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: ComplaintForm(
                user: user,
              ));
        });
  }

  onLaunch() async {
    user = await _auth.constructMyUser(widget.user);
    if (user.memberType == 'Admin') {
      type = 'Admin';
      complaintStream = await DatabaseMethods().getAdminComplaints();
    } else {
      type = user.memberType;
      complaintStream = await DatabaseMethods().getUserComplaints(user.uid);
    }
    _controller = VideoPlayerController.asset(
      'assets/Society_Welcome_Video_2.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  genChatRoomId(String uidA, String uidB) {
    return uidA.substring(0, 1).codeUnitAt(0) >
            uidB.substring(0, 1).codeUnitAt(0)
        ? '$uidB\_$uidA'
        : '$uidA\_$uidB';
  }

  Widget complaintTile(DocumentSnapshot doc) {
    int randomIndex = Random().nextInt(colors.length);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: colors[randomIndex],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                                              child: Text(
                          doc['complaintContent'],
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('- ' + doc['complaintByName']),
                    ],
                  ),
                ],
              ),
            ),
          ),
          type == 'Admin'
              ? Container(
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            String chatRoomId = genChatRoomId(
                                doc['complaintBy'], widget.user.uid);
                            Map<String, dynamic> chatRoomInfoMap = {
                              'users': [doc['complaintBy'], widget.user.uid],
                            };
                            DatabaseMethods()
                                .createChatRoom(chatRoomId, chatRoomInfoMap);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                          profileUrl: doc['complaintByImg'],
                                          name: doc['complaintByName'],
                                          userId: doc['complaintBy'],
                                          myUser: widget.user,
                                        )));
                          }),
                      Column(
                        children: [
                          TextButton.icon(
                              onPressed: () async {
                                await DatabaseMethods()
                                    .resolveComplaint(doc.id);
                              },
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              label: Text(
                                'Resolve',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              )),
                          TextButton.icon(
                              onPressed: () async {
                                await DatabaseMethods().cancelComplaint(doc.id);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              label: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    doc['complaintState'],
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: doc['complaintState'] == 'Cancelled'
                            ? Colors.red
                            : Colors.green),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                padding: EdgeInsets.all(10),
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.lightBlue[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Complaints',
                            style: TextStyle(fontSize: 17),
                          ),
                          type != 'Admin'
                              ? IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _showNewServicePanel();
                                  })
                              : Container(),
                        ],
                      ),
                    ),
                    user != null
                        ? Expanded(
                            child: Container(
                              child: StreamBuilder(
                                stream: complaintStream,
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? ListView.builder(
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot document =
                                                snapshot.data.docs[index];
                                            return complaintTile(document);
                                          })
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        );
                                },
                              ),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      color: Colors.cyan[700],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Society Video',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                          FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: Column(
                                    children: [
                                      Expanded(child: VideoPlayer(_controller)),
                                      VideoProgressIndicator(_controller,
                                          allowScrubbing: true)
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    _controller != null
                                        ? _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow
                                        : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        _controller.play();
                                      }
                                    });
                                  }),
                              IconButton(
                                  icon: Icon(Icons.replay),
                                  onPressed: () {
                                    setState(() {
                                      _controller.seekTo(Duration.zero);
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplaintForm extends StatefulWidget {
  final MyUser user;
  ComplaintForm({this.user});
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  String complaint;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Raise A Complaint',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: textInputDecor.copyWith(
                      hintText: 'Describe your Complaint'),
                  validator: (value) =>
                      value.isEmpty ? 'Please enter a Complaint' : null,
                  onChanged: (value) {
                    setState(() {
                      complaint = value;
                    });
                  },
                ),
                ElevatedButton(
                    child: Text(
                      'File Complaint',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String complaintId = randomAlphaNumeric(12);
                        Map<String, dynamic> complaintData = {
                          'complaintBy': widget.user.uid,
                          'complaintByImg': widget.user.profileUrl,
                          'complaintByName': widget.user.name,
                          'complaintContent': complaint,
                          'complaintState': 'Open',
                        };
                        await DatabaseMethods()
                            .addComplaint(complaintId, complaintData);
                        Navigator.pop(context);
                      }
                    }),
              ],
            )),
      ),
    );
  }
}
