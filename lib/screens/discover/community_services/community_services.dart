import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/discover/community_services/service_map.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityServices extends StatefulWidget {
  final MyUser user;
  CommunityServices({this.user});
  @override
  _CommunityServicesState createState() => _CommunityServicesState();
}

class _CommunityServicesState extends State<CommunityServices> {
  MyUser user;
  AuthService _auth = AuthService();

  onLauch() async {
    user = await _auth.constructMyUser(widget.user);
    setState(() {});
  }

  @override
  void initState() {
    onLauch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.medical_services),
                      child: Text('Health'),
                    ),
                    Tab(
                      icon: Icon(Icons.room_service),
                      child: Text('Food'),
                    ),
                    Tab(
                      icon: Icon(Icons.engineering),
                      child: Text('Utilities'),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Service(type: 'health', user: user,),
                  Service(type: 'food', user: user,),
                  Service(type: 'utilities', user: user,),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
