import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppointmentController extends GetxController {
  final loading = true.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  final appointmentList = [].obs;

  // StreamSubscription? appointment;
  startLoading() => loading.value = true;
  stopLoading() => loading.value = false;

  @override
  void onInit() {
    fetchMyAppointments();
    super.onInit();
  }

  fetchMyAppointments() {
    startLoading();

    firebaseFirestore
        .collection("users_appointment_list")
        .doc(fireAuth.currentUser!.uid)
        .collection("list")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .forEach((element) {
      var doc = element.docs;
      appointmentList.assignAll(
        doc.map((e) {
          return e.data();
        }),
      );
    });
    stopLoading();
  }
}
