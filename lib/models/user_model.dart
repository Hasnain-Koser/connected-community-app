class MyUser {
  Map<String, dynamic> userDataMap;
  bool emailVerified;
  String name,
      userName,
      email,
      profileUrl,
      uid,
      memberType,
      phoneNumber,
      flatNumber,
      status;
  MyUser(this.userDataMap, this.uid, this.emailVerified);

  construct() {
    name = userDataMap['name'];
    userName = userDataMap['username'];
    email = userDataMap['email'];
    profileUrl = userDataMap['profileUrl'];
    uid = userDataMap['uid'];
    memberType = userDataMap['memberType'];
    phoneNumber = userDataMap['phoneNumber'];
    flatNumber = userDataMap['flat'];
    status = userDataMap['status'];
  }
}
