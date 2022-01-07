import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  void initialize() {
    ///forground notification handling

    FirebaseMessaging.instance.getInitialMessage();
  }
}
