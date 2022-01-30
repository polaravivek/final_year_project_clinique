import 'package:clinique/main.controller.dart';
import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/screens/showRoute.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class SelectedClinicController extends GetxController {
  final loading = false.obs;
  var uid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final num = 0.obs;
  final MainController mainController = Get.find<MainController>();

  @override
  void onInit() {
    uid = auth.currentUser!.uid;
    super.onInit();
  }

  final ref = FirebaseDatabase.instance.reference();

  bool get isLoading => loading.value;

  int get number => num.value;

  startLoading() => loading.value = true;
  stopLoading() => loading.value = false;

  joinQueue({BuildContext? context, ModelDoctorInfo? modelDoctorInfo}) {
    startLoading();
    print("tapped");
    String? name;
    ref.child("userinfo").once().then((DataSnapshot snapshot) {
      name = snapshot.value['$uid']['name'];
      print(name);
      _firestore
          .collection('queue')
          .doc('${modelDoctorInfo!.docId}')
          .collection('queue')
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          print("true");
          stopLoading();
          Navigator.push(
            context!,
            MaterialPageRoute(
              builder: (context) => ShowRouting(modelDoctorInfo, name),
            ),
          );
        } else {
          _firestore
              .collection('queue')
              .doc('${modelDoctorInfo.docId}')
              .collection('queue')
              .doc(uid)
              .set({
            'name': name,
            'time': DateTime.now().millisecondsSinceEpoch,
            'token': mainController.token.value
          }).then((value) {
            print("added");
          });

          _firestore
              .collection('queue')
              .doc('${modelDoctorInfo.docId}')
              .get()
              .then((value) {
            var count = value["count"];
            _firestore
                .collection('queue')
                .doc('${modelDoctorInfo.docId}')
                .update({'count': ++count}).then((value) {
              stopLoading();
              Navigator.push(
                context!,
                MaterialPageRoute(
                  builder: (context) => ShowRouting(modelDoctorInfo, name),
                ),
              );
            });
          });
        }
      });
    });
  }
}
