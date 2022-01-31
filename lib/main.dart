import 'dart:async';
import 'dart:convert';

import 'package:clinique/main.controller.dart';
import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/screens/homepage.dart';
import 'package:clinique/screens/rating_screen.dart';
import 'package:clinique/screens/selectedClinic.dart';
import 'package:clinique/utils/utils.dart';
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

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print(Map.from(json.decode(message.data["doctorModelInfo"]))["fees"]);
  ModelDoctorInfo modelDoctorInfo = new ModelDoctorInfo.fromMap(
      Map.from(json.decode(message.data["doctorModelInfo"])));

  print("onbackgroundhandler.listen ontap");
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MainController mainController = Get.put(MainController());

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  //This is for token
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.getToken().then((value) => mainController.changeToken(value!));

  // messaging.getToken().then((value) => print(value));

  //*terminated state
  // messaging.getInitialMessage().then((value) {
  //   if (value != null) {
  //     print("getInitial message => ${value.notification.title}");
  //   }
  //   print("getinitialmessage ontap");
  // });

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
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification notification = message.notification;
  //   AndroidNotification android = message.notification?.android;

  //   print(message.data["clinicId"]);
  //   print("getinitiaonMessage.listen ontap");

  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name,
  //               icon: android?.smallIcon, priority: Priority.high
  //               // other properties...
  //               ),
  //         ));
  //   }
  // });

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
      navigatorKey: navigatorKey,
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
    FirebaseMessaging.instance.getInitialMessage().then((value) async {
      print("instance.getInitialMessage() ontap");
      if (value != null &&
          (await Utils.getFcmId(value.messageId!) != value.messageId)) {
        Utils.setFcmId(value.messageId!);

        // final message = value.data["clinicId"];

        print("message from initial message => ${value.data["clinicId"]}");

        ModelDoctorInfo modelDoctorInfo = new ModelDoctorInfo.fromMap(
            Map.from(json.decode(value.data["doctorModelInfo"])));

        if (value.notification!.title == "Thank You For Visit") {
          print("equal");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RatingScreen(
                        clinic: value.data["clinicId"],
                      )));
        } else {
          Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
              builder: (context) => SelectedClinic(modelDoctorInfo)));
        }
      } else {
        startTime();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.notification!.body}");
      print("onMessageOpenedApp: ${message.notification!.title}");

      ModelDoctorInfo modelDoctorInfo = new ModelDoctorInfo.fromMap(
          Map.from(json.decode(message.data["doctorModelInfo"])));

      Utils.setFcmId(message.messageId!);

      // Navigator.popUntil(context, (route) => route is PageRoute);
      print("onMessageOpenedApp.listen ontap");

      if (message.notification != null &&
          message.notification?.android != null) {
        if (message.notification!.title == "Thank You For Visit") {
          print("equal");
          // Navigator.pop(context);
          Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
              builder: (context) => RatingScreen(
                    clinic: message.data["clinicId"],
                  )));
        } else {
          print("here 1231");
          print(
              "message doctormodelinfo => ${message.data["doctorModelInfo"].runtimeType}");
          Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
              builder: (context) => SelectedClinic(modelDoctorInfo)));
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onmessage.listen ontap");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print(message.data["clinicId"]);
      print("getinitiaonMessage.listen ontap");

      if (notification != null && android != null) {
        print("message from ${message.notification!.body}");
        print("message from ${message.notification!.title}");
        print("message from ${message.data["clinicId"]}");
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  icon: android.smallIcon, priority: Priority.high
                  // other properties...
                  ),
            ));
      }
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
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
