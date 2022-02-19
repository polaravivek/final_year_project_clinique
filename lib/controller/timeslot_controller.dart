import 'package:clinique/controller/calender.controller.dart';
import 'package:clinique/controller/selected_clinic.controller.dart';
import 'package:clinique/main.controller.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeSlotController extends GetxController {
  CalendarScreenController calendarController =
      Get.find<CalendarScreenController>();
  SelectedClinicController selectedClinicController =
      Get.find<SelectedClinicController>();
  MainController mainController = Get.find<MainController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ref = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid;

  final selectedTime = "".obs;

  @override
  void onInit() {
    uid = auth.currentUser!.uid;
    super.onInit();
  }

  void saveInfo() {
    var selectedDate = calendarController.selectedDate.value;
    var timeSelected = selectedTime.value;
    var docId = selectedClinicController.selectedClinicInfo.value.docId;

    String? name;

    print(selectedDate);
    firestore
        .collection("users_appointment_list")
        .doc(auth.currentUser!.uid)
        .collection("list")
        .doc()
        .set({
      "createdAt": Timestamp.now(),
      "docId": docId,
      "appointment_info": {
        "date": selectedDate.toString(),
        "time": timeSelected
      },
    });
    ref.child("userinfo").get().then((DataSnapshot snapshot) {
      var data = snapshot.value as Map<dynamic, dynamic>;
      name = data['$uid']['name'];

      firestore.collection("appointments").doc(docId).set(
        {
          selectedDate.toString(): {
            timeSelected: {
              "name": name,
              "booked": true,
              "token": mainController.token.value
            }
          },
        },
        SetOptions(merge: true),
      ).then((value) {
        print("completed.......................");
      });
    });
  }
}
