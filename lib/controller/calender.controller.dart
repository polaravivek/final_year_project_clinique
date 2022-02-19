import 'package:clinique/controller/selected_clinic.controller.dart';
import 'package:clinique/screens/showRoute.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreenController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  SelectedClinicController selectedClinicController =
      Get.find<SelectedClinicController>();
  RxMap appointmentData = {}.obs;

  changeSelectedDate(DateTime date) => selectedDate.value = date;

  getAllAlreadyTakenSlots() {
    var result = firebaseFirestore
        .collection("appointments")
        .doc(selectedClinicController.selectedClinicInfo.value.docId)
        .snapshots()
        .map((doc) => doc.data());

    result.listen((data) {
      if (data != null) {
        if (data[selectedDate.value.toString()] != null) {
          appointmentData.value = data[selectedDate.value.toString()];
        }
      }
    });
  }
}
