import 'package:clinique/screens/homepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingController extends GetxController {
  final Rx<double> ratingStar = 1.0.obs;
  final RxBool loading = false.obs;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool get isLoading => loading.value;

  startLoading() => loading.value = true;
  stopLoading() => loading.value = false;

  changedRatingStart(double rating) => ratingStar.value = rating;

  saveRating(String? clinicId, BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Thank You For The Feedback'),
    );
    _firebaseFirestore
        .collection("ratings")
        .doc(clinicId)
        .collection("rating")
        .doc()
        .set({"rating": ratingStar.value}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MapActivity()));
    });
  }
}
