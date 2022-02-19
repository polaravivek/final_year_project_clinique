import 'package:clinique/controller/timeslot_controller.dart';
import 'package:clinique/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/services.dart';

class TimeSlotScreen extends StatefulWidget {
  const TimeSlotScreen({Key? key}) : super(key: key);

  @override
  _TimeSlotScreenState createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0x9AAB1818),
      ),
    );
    return GetBuilder<TimeSlotController>(
        init: TimeSlotController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff8A1818),
              title: Text("Time Slot Booking").center(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: Utils.TimeSlot.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Obx(() {
                        return GestureDetector(
                          onTap: (controller.calendarController.appointmentData[
                                      Utils.TimeSlot.elementAt(index)] !=
                                  null)
                              ? (controller.calendarController.appointmentData[
                                          Utils.TimeSlot.elementAt(index)]
                                      ["booked"])
                                  ? null
                                  : () {
                                      controller.selectedTime.value =
                                          Utils.TimeSlot.elementAt(index);
                                    }
                              : () {
                                  controller.selectedTime.value =
                                      Utils.TimeSlot.elementAt(index);
                                },
                          child: Obx(() => Card(
                                color: (controller.calendarController
                                                .appointmentData[
                                            Utils.TimeSlot.elementAt(index)] !=
                                        null)
                                    ? (controller.calendarController
                                                    .appointmentData[
                                                Utils.TimeSlot.elementAt(index)]
                                            ["booked"])
                                        ? Colors.white54
                                        : Colors.white
                                    : Colors.white,
                                child: Obx(() => GridTile(
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${Utils.TimeSlot.elementAt(index)}"),
                                            Text("Available")
                                          ],
                                        ),
                                      ),
                                      header: controller.selectedTime.value ==
                                              Utils.TimeSlot.elementAt(index)
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : null,
                                    )),
                              )),
                        );
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.saveInfo();
                  },
                  child: Text("Confirm"),
                ).padding(vertical: 10)
              ],
            ),
          );
        });
  }
}
