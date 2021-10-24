import 'dart:collection';

import 'dart:ui';

import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
  static bool isUsed = false;
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
            elevation: 2,
            shadowColor: Colors.black54,
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
  Widget build(BuildContext context) {
    List<String> arr = new List<String>();
    int length = 0;
    return Scaffold(
      backgroundColor: Color(0xffFFC7C7),
      appBar: AppBar(
        backwardsCompatibility: false,
        backgroundColor: Color(0xff8A1818),
        title: Center(
          child: Text(
            widget.modelDoctorInfo.clinicName.capitalize() + " queue",
            style: TextStyle(color: Colors.white),
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
                      UI(
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
                Divider(
                  color: Color(0xff848484),
                  thickness: 2,
                  indent: 80,
                  endIndent: 80,
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
                        elevation: 8,
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
                        elevation: 8,
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
                              Text(
                                "1 hour",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff8A1818),
                                    fontWeight: FontWeight.bold),
                              ),
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
                    'TOP 3 MEMBERS',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff8A1818),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 380,
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('queue')
                        .doc('${widget.modelDoctorInfo.docId}')
                        .collection('queue')
                        .orderBy('time')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Lottie.asset('assets/lottie/queue.json',
                            width: 300,
                            height: 300,
                            frameRate: FrameRate(60),
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
                            print("index is $index");
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
            child: Card(
              color: Colors.black87,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    isUsed = true;
                    String name;
                    int count = 0;
                    ref.child("userinfo").once().then((DataSnapshot snapshot) {
                      name = snapshot.value['$uid']['name'];
                      _firestore
                          .collection('queue')
                          .doc('${widget.modelDoctorInfo.docId}')
                          .collection('queue')
                          .doc("$uid")
                          .set({
                        'name': name,
                        'time': DateTime.now().millisecondsSinceEpoch,
                      }).then((value) => print("user added"));
                    });

                    _firestore
                        .collection('queue')
                        .doc('${widget.modelDoctorInfo.docId}')
                        .collection('queue')
                        .doc("$uid")
                        .snapshots()
                        .listen((event) {
                      if (event.exists) {
                      } else {
                        _firestore.runTransaction((transaction) async {
                          DocumentSnapshot freshSnap = await transaction.get(
                              _firestore
                                  .collection('queue')
                                  .doc('${widget.modelDoctorInfo.docId}'));
                          await transaction.update(freshSnap.reference, {
                            'count': freshSnap['count'] + 1,
                          });
                        });
                      }
                    });
                  },
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
    );
  }
}
