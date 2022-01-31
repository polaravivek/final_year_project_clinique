import 'package:clinique/controller/status.controller.dart';
import 'package:clinique/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  StatusController mainController = Get.find<StatusController>();

  @override
  Widget build(BuildContext context) {
    final selectedEvents = mainController.eventsOfSelectedDate;
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          "No Event Found",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }

    return Obx(() => SfCalendar(
          view: CalendarView.timelineDay,
          dataSource: EventDataSouce(mainController.allEvents),
          initialDisplayDate: mainController.selectedDate,
          todayHighlightColor: Colors.black,
        ));
  }
}
