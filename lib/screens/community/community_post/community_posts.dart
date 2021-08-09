import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class CommunityPosts extends StatefulWidget {
  final MyUser user;
  CommunityPosts({this.user});
  @override
  _CommunityPostsState createState() => _CommunityPostsState();
}

class _CommunityPostsState extends State<CommunityPosts> {
  AuthService _auth = AuthService();
  MyUser user;
  Stream communityPosts;
  final _formKey = GlobalKey<FormState>();
  String postContent;
  String postedBy;
  String postedByImg;
  String imageUrl;
  File image;
  final picker = ImagePicker();
  TextEditingController descController = TextEditingController();

  Widget posts() {
    return Container();
  }

  Widget addPost() {
    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 8,
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundImage: user != null
                          ? NetworkImage(user.profileUrl)
                          : AssetImage('assets/img_avatar.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: getImage,
                    ),
                  ),
                  image != null
                      ? Container(
                          height: 50,
                          width: 50,
                          child: Image(
                            fit: BoxFit.cover,
                            image: FileImage(image),
                          ),
                        )
                      : Container(),
                ],
              ),
              Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: descController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          maxLength: 100,
                          decoration: textInputDecor.copyWith(
                              hintText: 'Share Something...'),
                          validator: (value) => value.isEmpty
                              ? 'Please enter a Description'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              postContent = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            String postId = randomAlphaNumeric(12);
                            imageUrl = await DatabaseMethods()
                                .uploadImageToStorage(image, postId);
                            postedBy = user.uid;
                            postedByImg = user.profileUrl;
                            DateTime postTS = DateTime.now();
                            Map<String, dynamic> postData = {
                              'postContent': postContent,
                              'postContentImg': imageUrl,
                              'postedBy': postedBy,
                              'postedByName': user.name,
                              'postedByImg': postedByImg,
                              'postTS': postTS,
                              'likes': {'number': 0, 'users': []},
                              'hearts': {
                                'number': 0,
                                'users': [],
                              },
                            };
                            await DatabaseMethods()
                                .addPostToDB(postId, postData);
                            image = null;
                            imageUrl = null;
                            descController.text = '';
                            postId = '';
                            setState(() {});
                          }),
                    ],
                  )),
            ],
          )),
    );
  }

  onLaunch() async {
    user = await _auth.constructMyUser(widget.user);
    print(user.profileUrl);
    communityPosts = await DatabaseMethods().getPosts();
    setState(() {});
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          addPost(),
          StreamBuilder(
              stream: communityPosts,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            DateTime timeStamp =
                                DateTime.fromMillisecondsSinceEpoch(
                                    ds['postTS'].seconds * 1000);
                            String time = DateFormat.jm().format(timeStamp);
                            String date = DateFormat.yMd().format(timeStamp);
                            return PostTile(
                                ds: ds, date: date, time: time, user: user);
                          },
                        ),
                      )
                    : CircularProgressIndicator();
              }),
        ],
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  const PostTile({
    Key key,
    @required this.ds,
    @required this.date,
    @required this.time,
    @required this.user,
  }) : super(key: key);

  final DocumentSnapshot ds;
  final String date;
  final String time;
  final MyUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 2.5,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(ds['postedByImg']),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds['postedByName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            Text('$date at $time',
                                style:
                                    TextStyle(color: Colors.black54, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton.icon(
                      icon: Icon(
                        ds['hearts']['users'].contains(user.uid)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        if (ds['hearts']['users'].contains(user.uid)) {
                          await DatabaseMethods().updateUnheartPost(
                              ds.id, ds['hearts']['number'] - 1, user.uid);
                        } else {
                          await DatabaseMethods().updateHeartPost(
                              ds.id, ds['hearts']['number'] + 1, user.uid);
                        }
                      },
                      label: Text(ds['hearts']['number'].toString()),
                    ),
                    TextButton.icon(
                      icon: Icon(
                        ds['likes']['users'].contains(user.uid)
                            ? CupertinoIcons.hand_thumbsup_fill
                            : CupertinoIcons.hand_thumbsup,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        if (ds['likes']['users'].contains(user.uid)) {
                          await DatabaseMethods().updateUnlikePost(
                              ds.id, ds['likes']['number'] - 1, user.uid);
                        } else {
                          await DatabaseMethods().updateLikePost(
                              ds.id, ds['likes']['number'] + 1, user.uid);
                        }
                      },
                      label: Text(ds['likes']['number'].toString()),
                    ),
                    user.uid == ds['postedBy'] || user.memberType == "Admin"
                        ? IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              await DatabaseMethods().deletePost(ds.id);
                            },
                          )
                        : Container(),
                  ],
                )
              ],
            ),
            Container(
              child: Text(ds['postContent']),
            ),
            SizedBox(height: 16,),
            Container(
              child: Image(
                  width: 100,
                  fit: BoxFit.cover,
                  image: NetworkImage(ds['postContentImg'])),
            ),
          ],
        ),
      ),
    );
  }
}
