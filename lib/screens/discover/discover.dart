import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/discover/community_services/community_services.dart';
import 'package:connected_community_app/screens/discover/event_timeline/timeline.dart';
import 'package:connected_community_app/screens/discover/notice_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Discover extends StatefulWidget {
  final String page;
  Discover({this.page});
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  int selection = 0;

  returnPage(int number, MyUser user) {
    Map<int, Widget> pages = {
      0: TimeLine(
        user: user,
      ),
      1: Notices(user: user,),
      2: CommunityServices(user: user),
    };

    return pages[number];
  }

  int pageToInt(String page) {
    Map<String, int> pagestr = {
      'Timeline': 0,
      'Notice Board': 1,
      'Community Service': 2
    };
    return pagestr[page];
  }

  @override
  void initState() {
    selection = widget.page != null ? pageToInt(widget.page) : selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 50),
            child: CupertinoSlidingSegmentedControl(
              backgroundColor: Colors.black12,
              children: <int, Widget>{
                0: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Event Timeline',
                      style: TextStyle(
                          color: selection != 0 ? Colors.white : Colors.black87,
                          fontSize: 17),
                    )),
                1: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Notice Board',
                      style: TextStyle(
                          color: selection != 1 ? Colors.white : Colors.black87,
                          fontSize: 17),
                    )),
                2: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Services',
                      style: TextStyle(
                          color: selection != 2 ? Colors.white : Colors.black87,
                          fontSize: 17),
                    )),
              },
              onValueChanged: (int selected) {
                selection = selected;
                setState(() {});
              },
              groupValue: selection,
            ),
          ),
          centerTitle: true,
        ),
        body: returnPage(selection, user),
      ),
    );
  }
}
