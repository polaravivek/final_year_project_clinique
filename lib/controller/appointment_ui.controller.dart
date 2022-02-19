import 'package:clinique/model/doctor_info.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class AppointmentUiController extends GetxController {
  final docId;
  final List<ModelDoctorInfo> modelDoctorInfo = <ModelDoctorInfo>[].obs;
  final databaseRef = FirebaseDatabase.instance.reference();

  AppointmentUiController(this.docId);

  @override
  void onInit() {
    getDocInfo();
    super.onInit();
  }

  getDocInfo() {
    databaseRef
        .child("doctorInfo")
        .child('clinicInfo')
        .child(docId)
        .get()
        .then((snapshot) {
      var databaseRef = snapshot!.value;
      modelDoctorInfo.add(ModelDoctorInfo.fromMap(Map.from(databaseRef)));
      print(modelDoctorInfo[0].clinicName);
    });
  }
}
