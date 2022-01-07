import 'dart:collection';
import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/screens/route.dart';
import 'package:clinique/widgets/ui.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

var _count = 0;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SelectedClinic extends StatefulWidget {
  SelectedClinic(this.modelDoctorInfo);

  final ModelDoctorInfo modelDoctorInfo;

  @override
  _SelectedClinicState createState() => _SelectedClinicState();
}

class _SelectedClinicState extends State<SelectedClinic> {
  var uid;
  var ref;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final fb = FirebaseDatabase.instance;
    ref = fb.reference();
    uid = auth.currentUser.uid;

    super.initState();
  }

  Widget queueMember(
      String name, String index, Color color1, Color color2, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          child: GradientCard(
            elevation: 1,
            shadowColor: Colors.black26,
            gradient: LinearGradient(colors: [color1, color2]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '$index',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      child: Icon(Icons.import_contacts_sharp),
                      radius: 20,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Center(
                    child: Text(
                      '$name',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    print("dispose selected clinic");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0x9AAB1818),
      ),
    );

    List<String> arr = [];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFC7C7),
        appBar: AppBar(
          backgroundColor: Color(0xff8A1818),
          title: Center(
            child: Text(
              widget.modelDoctorInfo.clinicName.capitalize() + " queue",
              style: TextStyle(color: Colors.white, letterSpacing: 1.2),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        ui(
                            widget.modelDoctorInfo.img,
                            widget.modelDoctorInfo.clinicName,
                            widget.modelDoctorInfo.address,
                            widget.modelDoctorInfo.doctorName.capitalize(),
                            widget.modelDoctorInfo.eveningTime,
                            widget.modelDoctorInfo.fees,
                            widget.modelDoctorInfo.morningTime,
                            widget.modelDoctorInfo.specialization,
                            widget.modelDoctorInfo.latitude,
                            widget.modelDoctorInfo.longitude,
                            widget.modelDoctorInfo.review,
                            widget.modelDoctorInfo.distance,
                            widget.modelDoctorInfo.docId),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Color(0xffFFA8A8),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  "PATIENT COUNT",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff8A1818),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder(
                                    stream: _firestore
                                        .collection('queue')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text("loading....");
                                      }
                                      final snap = snapshot.data.docs;
                                      var count = 0;
                                      for (var sn in snap) {
                                        if (sn.id ==
                                            widget.modelDoctorInfo.docId) {
                                          count = sn.get('count');
                                        }
                                      }
                                      return Text(
                                        "$count",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff8A1818),
                                            fontWeight: FontWeight.bold),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Card(
                          color: Color(0xffFFA8A8),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "EXPECTED TIME",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff8A1818),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder(
                                    stream: _firestore
                                        .collection('queue')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text("loading....");
                                      }
                                      final snap = snapshot.data.docs;

                                      for (var sn in snap) {
                                        if (sn.id ==
                                            widget.modelDoctorInfo.docId) {
                                          _count = sn.get('count');
                                          break;
                                        }
                                      }

                                      return Text(
                                        "${_count * 5} min",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff8A1818),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'ALL MEMBERS',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff8A1818),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 380,
                    child: StreamBuilder(
                      // here 2 change
                      stream: _firestore
                          .collection('queue')
                          .doc('${widget.modelDoctorInfo.docId}')
                          .collection('queue')
                          .orderBy('time')
                          .snapshots(), // here 1 change
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Lottie.asset('assets/lottie/queue.json',
                              width: 300,
                              height: 300,
                              frameRate: FrameRate(30),
                              repeat: true);
                        }

                        final snap = snapshot.data.docs;
                        arr.clear();
                        for (var sn in snap) {
                          LinkedHashMap<String, dynamic> s = sn.data();
                          var name = s['name'];
                          arr.add(name);
                        }

                        if (arr.length == 0) {
                          return queueMember("No member available", "",
                              Colors.white, Colors.white, Colors.black);
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: arr.length,
                            itemBuilder: (_, index) {
                              if (index >= 3) {
                                return queueMember(
                                    "${arr[index]}",
                                    "${index + 1}.",
                                    Colors.white,
                                    Colors.white,
                                    Colors.black);
                              } else {
                                return queueMember(
                                    "${arr[index]}",
                                    "${index + 1}.",
                                    Colors.green,
                                    Colors.lightGreen,
                                    Colors.white);
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 70,
              child: GestureDetector(
                onTap: () {
                  print("tapped");
                  String name;
                  ref.child("userinfo").once().then((DataSnapshot snapshot) {
                    name = snapshot.value['$uid']['name'];
                    _firestore
                        .collection('queue')
                        .doc('${widget.modelDoctorInfo.docId}')
                        .collection('queue')
                        .doc(uid)
                        .get()
                        .then((value) {
                      if (value.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Routing(widget.modelDoctorInfo, name),
                          ),
                        );
                      } else {
                        _firestore
                            .collection('queue')
                            .doc('${widget.modelDoctorInfo.docId}')
                            .collection('queue')
                            .doc(uid)
                            .set({
                          'name': name,
                          'time': DateTime.now().millisecondsSinceEpoch,
                        }).then((value) {});

                        _firestore
                            .collection('queue')
                            .doc('${widget.modelDoctorInfo.docId}')
                            .get()
                            .then((value) {
                          var count = value["count"];
                          _firestore
                              .collection('queue')
                              .doc('${widget.modelDoctorInfo.docId}')
                              .update({'count': ++count}).then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Routing(widget.modelDoctorInfo, name),
                              ),
                            );
                          });
                        });
                      }
                    });
                  });
                },
                child: Card(
                  color: Colors.black87,
                  child: Center(
                    child: Text(
                      'JOIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}