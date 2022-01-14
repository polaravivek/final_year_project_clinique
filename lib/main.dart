import 'dart:async';

import 'package:clinique/main.controller.dart';
import 'package:clinique/screens/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Register.dart';
import 'screens/login.dart';

var email;

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MainController mainController = Get.put(MainController());

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.getToken().then((value) => mainController.changeToken(value));

  //*terminated state
  messaging.getInitialMessage().then((value) {
    if (value != null) {
      print(value.notification.title);
    }
  });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

//*foreground state
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android?.smallIcon,
              // other properties...
            ),
          ));
    }
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // LocalNotificationService.initialize();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xffAB1818)),
        // scaffoldBackgroundColor: Color(0xffFFC7C7),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/myApp': (_) => MyApp(),
        '/register': (_) => Register(),
        '/login': (_) => Login(),
        '/homepage': (_) => MapActivity(),
      },
      initialRoute: '/myApp',
      onUnknownRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) =>
              Scaffold(body: Center(child: Text('Not Found'))),
        );
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //*terminated state
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        final message = value.data["route"];

        print(message);
        Navigator.popUntil(context, (route) => route is PageRoute);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapActivity()));
      } else {
        print("not showing");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final routeMessage = message.data["route"];
      print("onMessageOpenedApp: $routeMessage");

      // Navigator.popUntil(context, (route) => route is PageRoute);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapActivity(),
        ),
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        print(message.notification.body);
        print(message.notification.title);
      }
    });

    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    if (email == null) {
      Navigator.pushReplacementNamed(context, '/register');
    } else {
      Navigator.pushReplacementNamed(context, '/homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0x9AAB1818),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('assets/images/img.png')),
      ),
    );
  }
}
