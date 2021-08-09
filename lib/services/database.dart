import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final storage = FirebaseStorage.instance;

  getNotifFromDB() async {
    List<Map<String, dynamic>> notifs = [];
    QuerySnapshot events = await FirebaseFirestore.instance
        .collection('timelineEvents')
        .orderBy('scheduledDate')
        .where('scheduledDate', isGreaterThanOrEqualTo: DateTime.now())
        .limit(3)
        .get();
    for (var i = 0; i < events.docs.length; i++) {
      if (events.docs.length > 0) {
        Map<String, dynamic> notif = {};
        notif['title'] = events.docs[i]['title'];
        notif['data'] = events.docs[i]['description'];
        notif['type'] = 'event';
        notifs.add(notif);
      }
    }
    QuerySnapshot posts = await FirebaseFirestore.instance
        .collection('communityPosts')
        .orderBy('postTS')
        .limit(3)
        .get();
    for (var i = 0; i < posts.docs.length; i++) {
      if (posts.docs.length > 0) {
        Map<String, dynamic> notif = {};
        notif['title'] = posts.docs[i]['postContent'];
        notif['data'] = posts.docs[i]['postedByName'];
        notif['img'] = posts.docs[i]['postContentImg'];
        notif['type'] = 'post';
        notifs.add(notif);
      }
    }
    return notifs;
  }

  Future<Stream<QuerySnapshot>> getUserComplaints(String uid) async {
    return FirebaseFirestore.instance
        .collection('complaints')
        .where('complaintBy', isEqualTo: uid)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAdminComplaints() async {
    return FirebaseFirestore.instance
        .collection('complaints')
        .where('complaintState', isEqualTo: 'Open')
        .snapshots();
  }

  addComplaint(String id, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection('complaints')
        .doc(id)
        .set(data);
  }

  resolveComplaint(id) async {
    return await FirebaseFirestore.instance
        .collection('complaints')
        .doc(id)
        .update({'complaintState': 'Resolved'});
  }

  Future<Stream<QuerySnapshot>> getNotices() async {
    return FirebaseFirestore.instance
        .collection('notices')
        .orderBy('noticePostTS', descending: true)
        .limit(5)
        .snapshots();
  }

  deleteNotice(String id) async {
    return await FirebaseFirestore.instance
        .collection('notices')
        .doc(id)
        .delete();
  }

  addNotice(String id, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection('notices')
        .doc(id)
        .set(data);
  }

  cancelComplaint(id) async {
    return await FirebaseFirestore.instance
        .collection('complaints')
        .doc(id)
        .update({'complaintState': 'Cancelled'});
  }

  addUserToDB(String uid, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(data);
  }

  getUserFromDB(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  updateUserDataToDB(String uid, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(data);
  }

  Future<String> uploadImageToStorage(File image, String uid) async {
    TaskSnapshot taskSnapshot =
        await storage.ref().child('images/$uid').putFile(image);
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<Stream<QuerySnapshot>> getTimelineEvents() async {
    return FirebaseFirestore.instance
        .collection('timelineEvents')
        .orderBy('scheduledDate', descending: true)
        .snapshots();
  }

  addEventToTimeline({String eventId, Map<String, dynamic> data}) async {
    return await FirebaseFirestore.instance
        .collection('timelineEvents')
        .doc(eventId)
        .set(data);
  }

  Future<Stream<QuerySnapshot>> getPosts() async {
    return FirebaseFirestore.instance
        .collection('communityPosts')
        .orderBy('postTS', descending: true)
        .snapshots();
  }

  addPostToDB(String postid, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection('communityPosts')
        .doc(postid)
        .set(data);
  }

  updateLikePost(String postId, int likeNumber, String userId) async {
    return await FirebaseFirestore.instance
        .collection('communityPosts')
        .doc(postId)
        .update({
      'likes.number': likeNumber,
      'likes.users': FieldValue.arrayUnion([userId]),
    });
  }

  updateUnlikePost(String postId, int likeNumber, String userId) async {
    return await FirebaseFirestore.instance
        .collection('communityPosts')
        .doc(postId)
        .update({
      'likes.number': likeNumber,
      'likes.users': FieldValue.arrayRemove([userId]),
    });
  }

  updateHeartPost(String postId, int likeNumber, String userId) async {
    return await FirebaseFirestore.instance
        .collection('communityPosts')
        .doc(postId)
        .update({
      'hearts.number': likeNumber,
      'hearts.users': FieldValue.arrayUnion([userId]),
    });
  }

  updateUnheartPost(String postId, int likeNumber, String userId) async {
    return await FirebaseFirestore.instance
        .collection('communityPosts')
        .doc(postId)
        .update({
      'hearts.number': likeNumber,
      'hearts.users': FieldValue.arrayRemove([userId]),
    });
  }

  deletePost(String postId) async {
    return await FirebaseFirestore.instance
        .collection('communityPosts')
        .doc(postId)
        .delete();
  }

  Future<Stream<QuerySnapshot>> getSearchedUsers(String name) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAZUsers() async {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .snapshots();
  }

  Future addMessageToDB(
      {String chatRoomId, String messageId, Map<String, dynamic> data}) async {
    return await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .set(data);
  }

  Future addServiceToDB(
      String type, String serviceId, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection('services')
        .doc(type)
        .collection(type + '_services')
        .doc(serviceId)
        .set(data);
  }

  Future deleteServiceFromDB(String type, String serviceId) async {
    return await FirebaseFirestore.instance
        .collection('services')
        .doc(type)
        .collection(type + '_services')
        .doc(serviceId)
        .delete();
  }

  addSocietyMessageToDB({String messageId, Map<String, dynamic> data}) async {
    return await FirebaseFirestore.instance
        .collection('societyChatroom')
        .doc(messageId)
        .set(data);
  }

  updateLastMessageSent(String chatRoomId, Map<String, dynamic> data) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update(data);
  }

  updateMessageRead(String chatroomId, String messageId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId)
        .update({'read': true});
  }

  createChatRoom(String chatRoomId, Map data) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(data);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getSocietyChatMessages() async {
    return FirebaseFirestore.instance
        .collection('societyChatroom')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getServiceSnapshots(String type) async {
    return FirebaseFirestore.instance
        .collection('services')
        .doc(type)
        .collection(type + '_services')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getRecentChats(String myId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .orderBy('lastMessageTS', descending: true)
        .where('users', arrayContains: myId)
        .snapshots();
  }

  Future<QuerySnapshot> getUnreadMessages(
      String chatRoomId, String userName) async {
    return await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('sentBy', isEqualTo: userName)
        .where('read', isEqualTo: false)
        .get();
  }

  Future<Stream<QuerySnapshot>> getHomeMessages(String userId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContains: userId)
        .where('lastMessageSentBy', isNotEqualTo: userId)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: userName)
        .get();
  }
}
