import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/screens/community/chat/chat.dart';
import 'package:connected_community_app/screens/discover/community_services/service_form.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';

class Service extends StatefulWidget {
  final String type;
  final MyUser user;
  Service({this.type, this.user});
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  Stream serviceStream;

  onLauch() async {
    serviceStream = await DatabaseMethods().getServiceSnapshots(widget.type);
    if (this.mounted) {
      setState(() {});
    }
  }

  genChatRoomId(String uidA, String uidB) {
    return uidA.substring(0, 1).codeUnitAt(0) >
            uidB.substring(0, 1).codeUnitAt(0)
        ? '$uidB\_$uidA'
        : '$uidA\_$uidB';
  }

  void _showNewServicePanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: NewServiceForm(
              user: widget.user,
              type: widget.type,
            ),
          );
        });
  }

  Widget serviceTile(DocumentSnapshot ds) {
    String userId = ds['serviceBy'];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 2.5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(ds['serviceByImg']),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds['service'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            Text(ds['serviceByName'],
                                style:
                                    TextStyle(color: Colors.black54, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      userId != widget.user.uid
                          ? IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                String chatRoomId =
                                    genChatRoomId(userId, widget.user.uid);
                                Map<String, dynamic> chatRoomInfoMap = {
                                  'users': [userId, widget.user.uid],
                                };
                                DatabaseMethods().createChatRoom(
                                    chatRoomId, chatRoomInfoMap);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chat(
                                              profileUrl: ds['serviceByImg'],
                                              name: ds['serviceByName'],
                                              userId: userId,
                                              myUser: widget.user,
                                            )));
                              })
                          : Container(),
                      widget.user.uid == userId ||
                              widget.user.memberType == 'Admin'
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                await DatabaseMethods()
                                    .deleteServiceFromDB(widget.type, ds.id);
                              },
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: Text(ds['serviceDescription']),
            ),
            Container(
              child: ds['serviceImg'] != null
                  ? Image(
                      width: 100,
                      fit: BoxFit.cover,
                      image: NetworkImage(ds['serviceImg']))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget servicesList(context) {
    return StreamBuilder(
        stream: serviceStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return serviceTile(ds);
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
      body: Container(
        child: servicesList(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showNewServicePanel();
        },
      ),
    );
  }
}
