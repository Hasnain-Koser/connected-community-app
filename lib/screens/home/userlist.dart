import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/community/chat/chat.dart';
import 'package:connected_community_app/screens/home/profile.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';

class AdminUserList extends StatefulWidget {
  final MyUser user;
  AdminUserList({this.user});
  @override
  _AdminUserListState createState() => _AdminUserListState();
}

class _AdminUserListState extends State<AdminUserList> {
  bool isSearching = false;
  Stream allUsers;
  Stream usersStream;

  TextEditingController searchBarTextController = TextEditingController();

  onSearch(String val) async {
    usersStream = val != widget.user.name
        ? await DatabaseMethods().getSearchedUsers(val)
        : null;
  }

  onLauch() async {
    allUsers = await DatabaseMethods().getAZUsers();
    setState(() {});
  }

  genChatRoomId(String uidA, String uidB) {
    return uidA.substring(0, 1).codeUnitAt(0) >
            uidB.substring(0, 1).codeUnitAt(0)
        ? '$uidB\_$uidA'
        : '$uidA\_$uidB';
  }

  Widget userTile({userId, profileUrl, name, flatNo}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Container(
            child: CircleAvatar(
              radius: 27,
              backgroundImage: (profileUrl == null)
                  ? AssetImage('assets/img_avatar.png')
                  : NetworkImage(profileUrl),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Text(
                  name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                flatNo ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black54),
              ),
            ]),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      String chatRoomId =
                          genChatRoomId(userId, widget.user.uid);
                      Map<String, dynamic> chatRoomInfoMap = {
                        'users': [userId, widget.user.uid],
                      };
                      DatabaseMethods()
                          .createChatRoom(chatRoomId, chatRoomInfoMap);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                    profileUrl: profileUrl,
                                    name: name,
                                    userId: userId,
                                    myUser: widget.user,
                                  )));
                    }),
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () async {
                      MyUser user = MyUser({}, userId, true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                    user: user,
                                  )));
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget usersList(context) {
    return StreamBuilder(
        stream: usersStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> ds = snapshot.data.docs[index].data();
                    return userTile(
                      userId: snapshot.data.docs[index].id,
                      name: ds['name'],
                      profileUrl: ds['profileUrl'],
                      flatNo: ds['flat'],
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget a_zusers(context) {
    return StreamBuilder(
        stream: allUsers,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> ds = snapshot.data.docs[index].data();
                    return userTile(
                      userId: snapshot.data.docs[index].id,
                      name: ds['name'],
                      profileUrl: ds['profileUrl'],
                      flatNo: ds['flat'],
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  void initState() {
    onLauch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? Container(
                        margin: EdgeInsets.only(left: 20),
                        // padding: EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              isSearching = false;
                              searchBarTextController.clear();
                            });
                          },
                        ),
                      )
                    : Container(),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey[300],
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: searchBarTextController,
                          onChanged: (value) async {
                            setState(() {
                              if (value.isNotEmpty) {
                                isSearching = true;
                                onSearch(value);
                              }
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search Users',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      )
                    ],
                  ),
                )),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white.withOpacity(0.95),
                ),
                child: isSearching ? usersList(context) : a_zusers(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
