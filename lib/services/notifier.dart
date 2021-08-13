import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class Notifications {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  getAccessToken() async{
    String accessToken;
    var accountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "private_key_id": "",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\\n-----END PRIVATE KEY-----\n",
      "client_email":
          "",
      "client_id": "",
    });
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    var client = http.Client();
    await obtainAccessCredentialsViaServiceAccount(accountCredentials, scopes, client)
        .then((AccessCredentials credentials) {
      // Access credentials are available in [credentials].
      // print(credentials.accessToken.data);
      accessToken = credentials.accessToken.data;
    });
    return accessToken;
  }

  sendNotif(body) async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "private_key_id": "",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\\n-----END PRIVATE KEY-----\n",
      "client_email":
          "",
      "client_id": "",
    });
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    String accessToken = await getAccessToken();
    print(accessToken);

    await clientViaServiceAccount(accountCredentials, scopes)
        .then((AuthClient client) async {
      // [client] is an authenticated HTTP client.
      http.Response response = await client.post(
        'https://fcm.googleapis.com/v1/projects/connected-community-app-8b5db/messages:send?key=',
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ' + accessToken,
        },
        body: json.encode(body),
      );
      if (response.body != null) {
        print(response.body);
      }
      client.close();
    });
  }

  void initMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  sendEventNotif(String eventTitle, String eventDescription) async {
    Map<String, dynamic> body = {
      "message": {
        'topic': 'eventnotifs',
        "data": {'type': 'event'},
        "notification": {
          "title": "Check out the New Event - $eventTitle",
          "body": eventDescription,
        }
      }
    };
    await sendNotif(body);
  }

  void subscribeToTopics() {
    firebaseMessaging.subscribeToTopic('eventnotifs');
  }

  void unsubscribeFromTopics() {
    firebaseMessaging.unsubscribeFromTopic('eventnotifs');
  }
}
