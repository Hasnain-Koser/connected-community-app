import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected_community_app/constants/constant.dart';
import 'package:connected_community_app/models/user_model.dart';
import 'package:connected_community_app/services/auth.dart';
import 'package:connected_community_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Notices extends StatefulWidget {
  final MyUser user;
  Notices({this.user});
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  Stream noticeStream;
  MyUser user;
  AuthService _auth = AuthService();

  onLaunch() async {
    noticeStream = await DatabaseMethods().getNotices();
    user = await _auth.constructMyUser(widget.user);
    if (mounted) {
      setState(() {});
    }
  }

  void _showNewServicePanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(25),
            child: NoticeForm(),
          );
        });
  }

  Widget noticeTile(DocumentSnapshot doc) {
    DateTime now = DateTime.now();
    DateTime timeStamp =
        DateTime.fromMillisecondsSinceEpoch(doc['noticePostTS'].seconds * 1000);
    String postTS = now.year == timeStamp.year &&
            now.month == timeStamp.month &&
            now.day == timeStamp.day
        ? DateFormat.jm().format(timeStamp)
        : DateFormat.yMd().format(timeStamp);

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 10,
          color: Colors.black54,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc['noticeTitle'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(postTS,
                      style: TextStyle(
                          color: Colors.black54, fontStyle: FontStyle.italic)),
                ],
              ),
              user?.memberType == 'Admin'
                  ? InkWell(
                      onTap: () {
                        DatabaseMethods().deleteNotice(doc.id);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/push-pin.png'),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(doc['noticeDescription']),
          doc['noticeImg'] != null
              ? Image(image: NetworkImage(doc['noticeImg']))
              : Container(),
        ],
      ),
    );
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
          stream: noticeStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data.docs[index];
                      return noticeTile(document);
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
              child: Icon(Icons.add),
              onPressed: () {
                _showNewServicePanel();
              },
            )
          : null,
    );
  }
}

class NoticeForm extends StatefulWidget {
  @override
  _NoticeFormState createState() => _NoticeFormState();
}

class _NoticeFormState extends State<NoticeForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String noticeTitle;
    String noticeDesc;
    File image;
    final picker = ImagePicker();

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

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Create a New Notice',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: textInputDecor.copyWith(hintText: 'Notice Title'),
              validator: (value) =>
                  value.isEmpty ? 'Please enter a title' : null,
              onChanged: (value) {
                setState(() {
                  noticeTitle = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration:
                  textInputDecor.copyWith(hintText: 'Notice Description'),
              validator: (value) =>
                  value.isEmpty ? 'Please enter a description' : null,
              onChanged: (value) {
                setState(() {
                  noticeDesc = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: getImage,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: image != null
                        ? FileImage(image)
                        : AssetImage('assets/default-thumbnail.jpg'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                'Add Service',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  String noticeId = randomAlphaNumeric(12);
                  String imageURL = image != null
                      ? await DatabaseMethods()
                          .uploadImageToStorage(image, noticeId)
                      : null;
                  Map<String, dynamic> noticeData = {
                    'noticeTitle': noticeTitle,
                    'noticeDescription': noticeDesc,
                    'noticeImg': imageURL,
                  };
                  await DatabaseMethods().addNotice(noticeId, noticeData);
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
