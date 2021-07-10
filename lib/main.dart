import 'package:clinique/homepage.dart';
import 'package:clinique/model/UserInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFFB5B5),
        accentColor: Color(0xFFFFB5B5),
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => MyApp(),
        '/login': (context) => Login(),
        '/homepage': (context) => HomePage(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const MaterialColor _buttonTextColor = MaterialColor(0xFFFFB5B5, <int, Color>{
  50: Color(0xFFFFB5B5),
  100: Color(0xFFFFB5B5),
  200: Color(0xFFFFB5B5),
  300: Color(0xFFFFB5B5),
  400: Color(0xFFFFB5B5),
  500: Color(0xFFFFB5B5),
  600: Color(0xFFFFB5B5),
  700: Color(0xFFFFB5B5),
  800: Color(0xFFFFB5B5),
  900: Color(0xFFFFB5B5)
});

class _MyAppState extends State<MyApp> {
  String email, password, name, dob, phoneNo, confirmPass;
  final auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;

  DateTime _date = DateTime.now();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1947),
        lastDate: DateTime(_date.year),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: _buttonTextColor,
              primaryColor: Color(0xFFFFB5B5),
              accentColor: Color(0xFFFFB5B5),
            ),
            child: child,
          );
        });
    {
      if (_datePicker != null && _datePicker != _date) {
        setState(() {
          _date = _datePicker;
          print(_date.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFB5B5),
    ));

    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFFFDDDD),
          primaryColor: Color(0xFFFFDDDD),
          primaryColorDark: Color(0xFFFFB5B5),
          accentColor: Color(0xFFFFFFF)),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0xFF9B3D3D),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 40, right: 60, left: 60, bottom: 10),
                        child: TextField(
                          cursorColor: Color(0xFF9B3D3D),
                          controller: _nameController,
                          onChanged: (v) {
                            name = v.toString();
                          },
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFD99D9D),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFAA6262),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Your Name',
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        child: TextField(
                          cursorColor: Color(0xFF9B3D3D),
                          controller: _dateController,
                          onTap: () {
                            setState(() {
                              _selectDate(context);
                              _dateController.value = TextEditingValue(
                                  text: _date.toString().split(" ").first);
                            });
                          },
                          onChanged: (v) {
                            dob = v.toString();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFD99D9D),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFAA6262),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Pick Date Of Birth",
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        child: TextField(
                          cursorColor: Color(0xFF9B3D3D),
                          controller: _phoneController,
                          onChanged: (v) {
                            phoneNo = v.toString();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFD99D9D),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFAA6262),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Your Phone No.',
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        child: TextField(
                          cursorColor: Color(0xFF9B3D3D),
                          onChanged: (v) {
                            setState(() {
                              email = v.trim();
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFD99D9D),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFAA6262),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Enter Your Email',
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        child: TextField(
                          cursorColor: Color(0xFF9B3D3D),
                          controller: _passwordController,
                          onChanged: (v) {
                            setState(() {
                              password = v.toString();
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFD99D9D),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFAA6262),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Create Password',
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                        child: TextField(
                          cursorColor: Color(0xFF9B3D3D),
                          controller: _confirmPasswordController,
                          onChanged: (v) {
                            confirmPass = v.toString();
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFD99D9D),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFFAA6262),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 18),
                                    elevation: 5,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 30),
                                    primary: Color(0xFF9B3D3D)),
                                onPressed: () async {
                                  final authcreate =
                                      await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  print(authcreate.user.uid);

                                  final refer = ref
                                      .child("userinfo")
                                      .child(auth.currentUser.uid);
                                  UserInfoModel userInfoModel =
                                      new UserInfoModel(name, email, phoneNo,
                                          _dateController.text);
                                  refer.child("name").set(userInfoModel.name);
                                  refer.child("email").set(userInfoModel.email);
                                  refer
                                      .child("phoneNo")
                                      .set(userInfoModel.phoneNo);
                                  refer.child("dob").set(userInfoModel.dob);
                                  Navigator.pushNamed(context, '/homepage');
                                },
                                child: Text("Register"),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Already have,',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Container(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF9B3D3D),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}