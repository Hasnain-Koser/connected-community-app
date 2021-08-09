import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/community/chat/chat.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHome extends StatefulWidget {
  final MyUser user;
  ChatHome({this.user});
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  bool isSearching = false;
  TextEditingController searchBarTextController = TextEditingController();
  Stream usersStream, chatRoomStream;
  String myName, myUserName, myProfilePic, myUserId, myEmail;
  AuthService _auth = AuthService();

  genChatRoomId(String uidA, String uidB) {
    return uidA.substring(0, 1).codeUnitAt(0) >
            uidB.substring(0, 1).codeUnitAt(0)
        ? '$uidB\_$uidA'
        : '$uidA\_$uidB';
  }

  getMyUserData() async {
    MyUser myUser = await _auth.constructMyUser(widget.user);
    myName = myUser.name;
    myUserName = myUser.userName;
    myProfilePic = myUser.profileUrl;
    myUserId = myUser.uid;
    myEmail = myUser.email;
  }

  onSearch(String val) async {
    usersStream =
        val != myName ? await DatabaseMethods().getSearchedUsers(val) : null;
  }

  Widget userTile({userId, profileUrl, name, email}) {
    return GestureDetector(
      onTap: () {
        String chatRoomId = genChatRoomId(userId, myUserId);
        Map<String, dynamic> chatRoomInfoMap = {
          'users': [userId, myUserId],
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      profileUrl: profileUrl,
                      name: name,
                      userId: userId,
                      myUser: widget.user,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Row(
          children: [
            Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: (profileUrl == null)
                    ? AssetImage('assets/img_avatar.png')
                    : NetworkImage(profileUrl),
              ),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? '',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        email ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  )),
            ),
          ],
        ),
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
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  getChatRoomData() async {
    chatRoomStream = await DatabaseMethods().getRecentChats(myUserId);
    setState(() {});
  }

  onLaunch() async {
    await getMyUserData();
    await getChatRoomData();
  }

  Widget recentChats(context) {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Map<String, dynamic> ds = snapshot.data.docs[index].data();
                print(snapshot.data.docs[index].data());
                return snapshot.data.docs[index].data()['lastMessage'] != null
                    ? ChatRoomTile(
                        documentSnapshot: ds,
                        myUserId: myUserId,
                        documentSnapshotid: snapshot.data.docs[index].id,
                        myUser: widget.user,
                      )
                    : null;
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: isSearching ? usersList(context) : recentChats(context),
            ),
          )
        ],
      ),
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final Map<String, dynamic> documentSnapshot;
  final String myUserId;
  final String documentSnapshotid;
  final MyUser myUser;
  ChatRoomTile(
      {this.documentSnapshot,
      this.myUserId,
      this.documentSnapshotid,
      this.myUser});
  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  String name, profileUrl, userId, lastMessage, chatRoomId, lastMessageTS;
  int unread = 0;

  getUserInfoFromId() async {
    setState(() {});
    userId = widget.documentSnapshotid
        .replaceFirst(widget.myUserId, '')
        .replaceAll('_', '');
    print(widget.documentSnapshotid);
    print(userId);
    DocumentSnapshot userData = await DatabaseMethods().getUserFromDB(userId);
    print(userData);
    dynamic doc = userData.data();
    name = doc['name'];
    profileUrl = doc['profileUrl'];
    lastMessage = widget.documentSnapshot['lastMessage'];
    DateTime now = DateTime.now();
    DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(
        widget.documentSnapshot['lastMessageTS'].seconds * 1000);
    lastMessageTS = now.year == timeStamp.year &&
            now.month == timeStamp.month &&
            now.day == timeStamp.day
        ? DateFormat.jm().format(timeStamp)
        : DateFormat.yMd().format(timeStamp);
    // lastMessageTS = DateFormat.yMd().format(timeStamp);
    print(now);
    print(timeStamp);
    chatRoomId = widget.documentSnapshotid;
    QuerySnapshot unreadMessages =
        await DatabaseMethods().getUnreadMessages(chatRoomId, userId);
    print(unreadMessages.docs);
    unread = unreadMessages.docs.length;
    print(unread);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getUserInfoFromId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      profileUrl: profileUrl,
                      name: name,
                      userId: userId,
                      myUser: widget.myUser,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Container(
          child: Row(
            children: [
              Container(
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: (profileUrl == null)
                      ? AssetImage('assets/img_avatar.png')
                      : NetworkImage(profileUrl),
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? '',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          lastMessage ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    )),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      lastMessageTS ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    if (unread != 0)
                      Container(
                          width: 27,
                          height: 27,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10),
                          // padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: Text(
                            unread.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ))
                    else
                      Container(
                        width: 27,
                        height: 27,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
