import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SelectedClinic extends StatelessWidget {
  SelectedClinic(this.modelDoctorInfo);

  Widget queueMember(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          child: Card(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
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
                          color: Colors.white,
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

  final ModelDoctorInfo modelDoctorInfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFC7C7),
      appBar: AppBar(
        backwardsCompatibility: false,
        backgroundColor: Color(0xff8A1818),
        title: Center(
          child: Text(
            modelDoctorInfo.clinicName.capitalize() + " queue",
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
                          modelDoctorInfo.clinicName,
                          modelDoctorInfo.address,
                          modelDoctorInfo.doctorName.capitalize(),
                          modelDoctorInfo.eveningTime,
                          modelDoctorInfo.fees,
                          modelDoctorInfo.morningTime,
                          modelDoctorInfo.specialization,
                          modelDoctorInfo.latitude,
                          modelDoctorInfo.longitude,
                          modelDoctorInfo.review,
                          modelDoctorInfo.distance,
                          modelDoctorInfo.docId),
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
                                      if (sn.id == modelDoctorInfo.docId) {
                                        count = sn.get('count');
                                      }
                                    }
                                    return Text(
                                      "${count.toString()}",
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
                  height: 300,
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('queue')
                        .doc('${modelDoctorInfo.docId}')
                        .collection('queue')
                        .orderBy('time')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      final snap = snapshot.data.docs;
                      List<String> arr = new List<String>();
                      for (var sn in snap) {
                        LinkedHashMap<String, dynamic> s = sn.data();
                        var name = s['name'];
                        arr.add(name);
                      }
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 3,
                          itemBuilder: (_, index) {
                            print("ar ${arr[index]}");
                            return queueMember("${arr[index]}");
                          });
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
                child: Text(
                  'JOIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
