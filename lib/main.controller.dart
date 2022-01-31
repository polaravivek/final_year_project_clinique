import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainController extends GetxController {
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  final token = "".obs;
  final status = "".obs;

  changeToken(String id) => token.value = id;
  changeStatus(Future<String> clinicStatus) async =>
      status.value = await clinicStatus;

  Future<String> getStatus(String uid) async {
    String status = await firebaseFireStore
        .collection("queue")
        .doc(uid)
        .get()
        .then((value) {
      return value["status"].toString();
    });

    return status;
  }
}
