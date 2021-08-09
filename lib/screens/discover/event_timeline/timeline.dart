import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/discover/event_timeline/eventform.dart';
import 'package:connected_community_app/screens/discover/event_timeline/timelinetile.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLine extends StatefulWidget {
  final MyUser user;
  const TimeLine({
    this.user,
    Key key,
  }) : super(key: key);

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  AuthService _auth = AuthService();
  MyUser user;
  Stream events;

  void _showNewEventPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: AddEventForm(),
          );
        });
  }

  onLaunch() async {
    user = await _auth.constructMyUser(widget.user);
    events = await DatabaseMethods().getTimelineEvents();
    setState(() {});
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: events,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(
                          ds['scheduledDate'].seconds * 1000);
                      String time = DateFormat('hh:mm aa').format(timeStamp);
                      String date = DateFormat('dd/MM/yy').format(timeStamp);
                      return TimelineTile(
                        title: ds["title"],
                        description: ds['description'],
                        type: ds['type'],
                        date: date,
                        time: time,
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
      floatingActionButton: user?.memberType == 'Admin'
          ? FloatingActionButton(
              child: Container(
                child: Icon(Icons.add),
              ),
              onPressed: () {
                _showNewEventPanel();
              },
            )
          : null,
    );
  }
}
