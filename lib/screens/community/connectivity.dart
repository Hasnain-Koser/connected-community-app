import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/community/chat/chat_home.dart';
import 'package:connected_community_app/screens/community/chat/society_chat.dart';
import 'package:connected_community_app/screens/community/community_post/community_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Connectivity extends StatefulWidget {
  final String page;
  Connectivity({this.page});
  @override
  _ConnectivityState createState() => _ConnectivityState();
}

class _ConnectivityState extends State<Connectivity> {
  Widget returnPage(String screen, MyUser user) {
    Map<String, Widget> pages = {
      'Chat': ChatHome(
        user: user,
      ),
      'SocietyChat': SocietyChat(
        myUser: user,
      ),
      'CommunityPosts': CommunityPosts(user: user),
    };
    return pages[screen];
  }

  List screens = ['Chat', 'SocietyChat', 'CommunityPosts'];

  Widget returnActions(String currentScreen) {
    List myScreens = [];
    myScreens.addAll(screens);
    Map<String, Widget> pages = {
      'Chat': Container(
        child: Row(
          children: [
            Icon(CupertinoIcons.chat_bubble_fill),
            Text('Personal Chat'),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      'SocietyChat': Container(
        child: Row(
          children: [
            Icon(CupertinoIcons.chat_bubble_2_fill),
            Text('Society Chat'),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      'CommunityPosts': Container(
        child: Row(
          children: [
            Icon(Icons.chat),
            Text('Community Posts'),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    };
    myScreens.remove(currentScreen);
    print(myScreens);
    List<Widget> actions = [];
    for (var i = 0; i < myScreens.length; i++) {
      Widget action = InkWell(
        onTap: () {
          setState(() {
            currentPage = myScreens[i];
          });
        },
        child: pages[myScreens[i]],
      );
      actions.add(action);
    }
    return Column(
      children: actions,
    );
  }

  String currentPage = 'Chat';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    currentPage = widget.page ?? currentPage;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [returnActions(currentPage)],
      ),
      body: returnPage(currentPage, user),
    );
  }
}
