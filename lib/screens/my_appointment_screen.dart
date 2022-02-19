import 'package:clinique/controller/appointment_ui.controller.dart';
import 'package:clinique/controller/my_appointment.controller.dart';
import 'package:clinique/screens/selectedClinic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:clinique/widgets/appointment_ui.dart';
import 'package:clinique/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppointments extends StatelessWidget {
  const MyAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MyAppointmentController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Appointments").center(),
            ),
            drawer: navigationDrawer(context),
            body: Obx(() {
              if (controller.loading.value) {
                return CircularProgressIndicator().padding(top: 20);
              } else if (controller.appointmentList.isEmpty) {
                return Text("No Appointment Found");
              }
              return ListView.builder(
                  itemCount: controller.appointmentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var appointmentInfo =
                        controller.appointmentList[index]["appointment_info"];
                    var docId = controller.appointmentList[index]["docId"];
                    var createdAt =
                        controller.appointmentList[index]["createdAt"];
                    print("docid => $docId");
                    return GetX<AppointmentUiController>(
                        init: AppointmentUiController(docId),
                        tag: createdAt.toString(),
                        builder: (appointmentUiController) {
                          if (appointmentUiController.modelDoctorInfo.isEmpty) {
                            return CircularProgressIndicator().center();
                          }
                          var model =
                              appointmentUiController.modelDoctorInfo.first;
                          return FutureBuilder(
                              future: FirebaseStorage.instance
                                  .ref()
                                  .child(model.img!)
                                  .getDownloadURL(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator().center();
                                }
                                return appoinmentUi(
                                        img: snapshot.data,
                                        address: model.address,
                                        clinicName: model.clinicName,
                                        doctorName: model.doctorName,
                                        eveningTime: model.eveningTime,
                                        morningTime: model.morningTime,
                                        fees: model.fees,
                                        review: model.review,
                                        specialization: model.specialization,
                                        latitude: model.latitude,
                                        longitude: model.longitude,
                                        appointmentDate: appointmentInfo["date"]
                                            .toString()
                                            .split(' ')[0],
                                        appointmentTime:
                                            appointmentInfo["time"])
                                    .gestures(onTap: () {
                                  var modelcopy = model.copyWith(
                                      docId: docId, img: snapshot.data);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SelectedClinic(modelcopy),
                                    ),
                                  );
                                });
                              });
                        });
                  });
            }),
          );
        },
      ),
    );
  }
}
