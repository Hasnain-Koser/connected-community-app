import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Chat extends StatefulWidget {
  final String userId, name, profileUrl;
  final MyUser myUser;
  Chat({this.userId, this.name, this.profileUrl, this.myUser});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String chatRoomId, messageId = '';
  String bg;
  String myName, myUserName, myProfilePic, myUserId, myEmail;
  Stream messageStream;
  AuthService _auth = AuthService();

  genChatRoomId(String uidA, String uidB) {
    return uidA.substring(0, 1).codeUnitAt(0) >
            uidB.substring(0, 1).codeUnitAt(0)
        ? '$uidB\_$uidA'
        : '$uidA\_$uidB';
  }

  getMyUserData() async {
    MyUser myUser = await _auth.constructMyUser(widget.myUser);
    myName = myUser.name;
    myUserName = myUser.userName;
    myProfilePic = myUser.profileUrl;
    myUserId = myUser.uid;
    myEmail = myUser.email;
    chatRoomId = genChatRoomId(myUserId, widget.userId);
  }

  TextEditingController messageBarController = TextEditingController();

  addMessage(bool sendClick) {
    if (messageBarController.text != '') {
      String message = messageBarController.text;
      DateTime lastMessageTS = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sentBy': myUserId,
        'profileUrl': myProfilePic,
        'timeStamp': lastMessageTS,
        'read': false,
      };
      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }
      DatabaseMethods()
          .addMessageToDB(
              chatRoomId: chatRoomId,
              messageId: messageId,
              data: messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          'lastMessage': message,
          'lastMessageTS': lastMessageTS,
          'lastMessageSentBy': myUserId,
        };
        DatabaseMethods().updateLastMessageSent(chatRoomId, lastMessageInfoMap);
        if (sendClick) {
          messageBarController.text = '';
          messageId = '';
        }
      });
    }
  }

  initializeMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        String next;
        int nextIndex;
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 90, top: 16),
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  print(snapshot.data.docs.length == index + 1);
                  nextIndex =
                      snapshot.data.docs.length == index + 1 ? 0 : index + 1;
                  next = nextIndex != 0
                      ? snapshot.data.docs[nextIndex]['sentBy']
                      : 'nope';
                  bool showProfilePic =
                      next != snapshot.data.docs[index]['sentBy'];
                  print(nextIndex);
                  print(snapshot.data.docs[index]['sentBy']);
                  print(showProfilePic);
                  if (snapshot.data.docs[index]['sentBy'] != myUserId) {
                    DatabaseMethods().updateMessageRead(
                        chatRoomId, snapshot.data.docs[index].id);
                  }
                  return chatMessageTile(ds, showProfilePic);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget chatMessageTile(DocumentSnapshot ds, bool showProfilePic) {
    bool isMyMessage = ds['sentBy'] == myUserId;
    String user = isMyMessage ? 'You' : widget.name;
    DateTime now = DateTime.now();
    DateTime timeStamp =
        DateTime.fromMillisecondsSinceEpoch(ds['timeStamp'].seconds * 1000);
    String lastMessageTS = now.year == timeStamp.year &&
            now.month == timeStamp.month &&
            now.day == timeStamp.day
        ? DateFormat.jm().format(timeStamp)
        : DateFormat.yMd().format(timeStamp);
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !isMyMessage && showProfilePic
            ? Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(ds['profileUrl']),
                  radius: 24,
                ),
              )
            : Container(
                width: 48,
                height: 48,
              ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black26,
                )
              ],
              color: isMyMessage ? Colors.lightGreen[300] : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft:
                    isMyMessage ? Radius.circular(24) : Radius.circular(0),
                bottomRight:
                    isMyMessage ? Radius.circular(0) : Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  ds['message'],
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  user + ' \u2022 ' + lastMessageTS,
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
        isMyMessage && showProfilePic
            ? Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(ds['profileUrl']),
                  radius: 24,
                ),
              )
            : Container(
                width: 48,
                height: 48,
              ),
      ],
    );
  }

  onLaunch() async {
    await getMyUserData();
    await initializeMessages();
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bg = 'https://source.unsplash.com/featured/1080x1920/?nature';
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profileUrl),
            ),
            SizedBox(
              width: 20,
            ),
            Text(widget.name),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(bg), fit: BoxFit.cover)),
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.grey[300],
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageBarController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0),
                        ),
                        hintText: 'Send a Message...',
                      ),
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.green[500],
                        size: 35,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
