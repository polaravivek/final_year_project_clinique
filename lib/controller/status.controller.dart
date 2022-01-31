import 'package:clinique/model/event.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusController extends GetxController {
  final RxString clinicTitle = "".obs;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<Event> allEvents = <Event>[].obs;

  Rx<DateTime> _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;

  List<Event> get eventsOfSelectedDate => allEvents;

  void setDate(DateTime date) => _selectedDate.value = date;

  changeClinicName(String clinicName) => clinicTitle.value = clinicName;

  Future<Stream<List<Event>>> getEvents(String uid) async {
    var docs =
        _firestore.collection("custom_status").doc(uid).collection("status");

    var documents = docs.snapshots();

    return documents.map((event) => event.docs
        .map((e) => Event.fromMap({
              ...e.data(),
              'id': e.id,
            }))
        .toList());
  }

  Future<void> getAllEvents(String uid) async {
    var result = getEvents(uid);

    result.then((e) {
      e.listen((event) {
        for (var e in event) {
          print(e.id);
        }
        allEvents.assignAll(event);
      });
    }).then((value) => print("completed"));
  }
}
