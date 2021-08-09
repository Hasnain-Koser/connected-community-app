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
      "private_key_id": "486164611f362fb211f76352e37a9bf28fd1f953",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCktVyjIt+TW3GT\nsKPbf2P0Nt3No0T2HRpRoysEhXgdKDC8F9YbUZlUcUSGMDXUZtT0G6suJtOKl02D\nQB5ew3rfAO9yr/GioM+i5d5piRU1S9pYiIitlPuqqg4BmBJn54J4AH+K/t+k88XF\nXh/dxzmQ1XwWGcS2gfyThhgD4AJ35Lz2kswOdKHN3KxypUIlOTDZtpN/GRENkG2c\nw7+sAAEKWbazZJP0Dfn71j2Lm4vMF+s1SDoKE6SnXLdtql6KgRQL7SqIilq0b74s\nWtPaVJZvhKtuqvAnW4tiAUWBKk/xwUUvY/5lHodYEbNZ21oLPAsSGv/PPP0trDl/\nQhc1WNkXAgMBAAECggEABlRSvQMID4slmto1w4sjPNfuBor4wlY0aWDutELi/MEu\n2OuNITSDGB6DD2JfyBLeOBl1bePt2SVXxBc2BVatSPpUciuWfG4QPl9nciuqoMAg\nzI239Kc+GstHe2X6MN8Y3fesRGLna+caQIDxPW/gBxrNFpYbzcFtAqudKtyCbYz7\ny/kMvHzkRS8aJawJ5QM2VbuMQ1o36a/DgDgSoWn3rmerFse/KYHD7xUw6Rz7qKbU\nQcCaCirqKEAdrOkhU06LE/bgdc1MU8uUtajNeB5PY2IgJ0yxXJVhMl4GUBVYiFcO\nqHUPT86X6o7vgAGDGhBzcTqbjItOQFQBLrnyE7zJwQKBgQDVAhLq9JzPXHArwSqP\nl7FI4pHmAYwGBx7pbIAjbV8+i/EkV5vHmQLAnFeQQzPdYM/t2D4TF3GIWHddYSZd\n7tF+sVz9e3QG+Xf+oVXKyn9OG26xbDjiIG7P0ig5nQlWSc9tkqx1DqFmHdcv491p\nH68phJYRwKDWL/fqnBPAPiq+pwKBgQDF87DNc09xjTRHdvSErk7MyQdVzJXzNBsb\nJuNLljCEYbJDUc4z7xCicCn95O8uceU02bX8BLhlODvrgeVht/U7Jl1l7cIlzxTK\nmTW8O9YONz56+5r8hsUzq5NnTCPk84vXncjiuXAUNk1Hag1v+wYkrKRFoU5GeNU/\nUS/t+2JQEQKBgGurU7KuGMF8QTrstj3E+JkV5Ze0unmlicuFy7OcqmMsS6UKH7Uh\ns9F2dZB3V7UUJaZdAuuVkw7PYO6zl7gtanm234FFsN2BplTwajRKbVUm6qoGQS6U\nJE8qNKkCpuCWCKKjXEcDMTQz6zzK2nUzzc+XtF+e1e3Oa2uMnzMyeVrLAoGBAKUb\ngIGsxzuYIl3lS0gLt3A50ONwlDXZZS59fiJCsE8Kycw6xHou0bobQfsiY5liqGIv\noQoGyeKrR9dEbhXWgTYH5ukoqcItelMN/XL2mbEbxQKBMCGnK37Qgk8rg9johuCe\nG7t4HpLNRCHnxDN9tf8K/K2TQJ2pFX0Nc6PVBIhxAoGBAJp8hs7kgaFGYOLR2Pu9\ngQVyYltKEjqt3lx/Q9Eu1lj575IoF8cF3ONraKgod/OIvDmL456WCUMeBLmMYrmG\nJIJ8uZIO2nEEjXz+Z32g7Je0Kv5DOvqqVFTP7eKiGU4gJIGRde3NUZshMX5lnR1i\nIg92ToURqQbNcr46ebrlxDkj\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-aceyg@connected-community-app-8b5db.iam.gserviceaccount.com",
      "client_id": "109429372876200393804",
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
      "private_key_id": "486164611f362fb211f76352e37a9bf28fd1f953",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCktVyjIt+TW3GT\nsKPbf2P0Nt3No0T2HRpRoysEhXgdKDC8F9YbUZlUcUSGMDXUZtT0G6suJtOKl02D\nQB5ew3rfAO9yr/GioM+i5d5piRU1S9pYiIitlPuqqg4BmBJn54J4AH+K/t+k88XF\nXh/dxzmQ1XwWGcS2gfyThhgD4AJ35Lz2kswOdKHN3KxypUIlOTDZtpN/GRENkG2c\nw7+sAAEKWbazZJP0Dfn71j2Lm4vMF+s1SDoKE6SnXLdtql6KgRQL7SqIilq0b74s\nWtPaVJZvhKtuqvAnW4tiAUWBKk/xwUUvY/5lHodYEbNZ21oLPAsSGv/PPP0trDl/\nQhc1WNkXAgMBAAECggEABlRSvQMID4slmto1w4sjPNfuBor4wlY0aWDutELi/MEu\n2OuNITSDGB6DD2JfyBLeOBl1bePt2SVXxBc2BVatSPpUciuWfG4QPl9nciuqoMAg\nzI239Kc+GstHe2X6MN8Y3fesRGLna+caQIDxPW/gBxrNFpYbzcFtAqudKtyCbYz7\ny/kMvHzkRS8aJawJ5QM2VbuMQ1o36a/DgDgSoWn3rmerFse/KYHD7xUw6Rz7qKbU\nQcCaCirqKEAdrOkhU06LE/bgdc1MU8uUtajNeB5PY2IgJ0yxXJVhMl4GUBVYiFcO\nqHUPT86X6o7vgAGDGhBzcTqbjItOQFQBLrnyE7zJwQKBgQDVAhLq9JzPXHArwSqP\nl7FI4pHmAYwGBx7pbIAjbV8+i/EkV5vHmQLAnFeQQzPdYM/t2D4TF3GIWHddYSZd\n7tF+sVz9e3QG+Xf+oVXKyn9OG26xbDjiIG7P0ig5nQlWSc9tkqx1DqFmHdcv491p\nH68phJYRwKDWL/fqnBPAPiq+pwKBgQDF87DNc09xjTRHdvSErk7MyQdVzJXzNBsb\nJuNLljCEYbJDUc4z7xCicCn95O8uceU02bX8BLhlODvrgeVht/U7Jl1l7cIlzxTK\nmTW8O9YONz56+5r8hsUzq5NnTCPk84vXncjiuXAUNk1Hag1v+wYkrKRFoU5GeNU/\nUS/t+2JQEQKBgGurU7KuGMF8QTrstj3E+JkV5Ze0unmlicuFy7OcqmMsS6UKH7Uh\ns9F2dZB3V7UUJaZdAuuVkw7PYO6zl7gtanm234FFsN2BplTwajRKbVUm6qoGQS6U\nJE8qNKkCpuCWCKKjXEcDMTQz6zzK2nUzzc+XtF+e1e3Oa2uMnzMyeVrLAoGBAKUb\ngIGsxzuYIl3lS0gLt3A50ONwlDXZZS59fiJCsE8Kycw6xHou0bobQfsiY5liqGIv\noQoGyeKrR9dEbhXWgTYH5ukoqcItelMN/XL2mbEbxQKBMCGnK37Qgk8rg9johuCe\nG7t4HpLNRCHnxDN9tf8K/K2TQJ2pFX0Nc6PVBIhxAoGBAJp8hs7kgaFGYOLR2Pu9\ngQVyYltKEjqt3lx/Q9Eu1lj575IoF8cF3ONraKgod/OIvDmL456WCUMeBLmMYrmG\nJIJ8uZIO2nEEjXz+Z32g7Je0Kv5DOvqqVFTP7eKiGU4gJIGRde3NUZshMX5lnR1i\nIg92ToURqQbNcr46ebrlxDkj\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-aceyg@connected-community-app-8b5db.iam.gserviceaccount.com",
      "client_id": "109429372876200393804",
    });
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    String accessToken = await getAccessToken();
    print(accessToken);

    await clientViaServiceAccount(accountCredentials, scopes)
        .then((AuthClient client) async {
      // [client] is an authenticated HTTP client.
      http.Response response = await client.post(
        'https://fcm.googleapis.com/v1/projects/connected-community-app-8b5db/messages:send?key=AIzaSyA5KE2KCrSfmYDfL7D9t3zQW9rzuR6ssrU',
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
