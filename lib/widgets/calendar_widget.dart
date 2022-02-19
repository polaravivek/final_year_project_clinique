import 'package:clinique/controller/calender.controller.dart';
import 'package:clinique/controller/status.controller.dart';
import 'package:clinique/model/event.dart';
import 'package:clinique/screens/time_slot_screen.dart';
import 'package:clinique/widgets/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final String clinicId;
  final bool isAppointment;

  CalendarWidget({Key? key, required this.clinicId, this.isAppointment = false})
      : super(key: key);

  final mainService = Get.find<StatusController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarScreenController>(
      init: CalendarScreenController(),
      builder: (controller) {
        return SfCalendar(
          dataSource: EventDataSouce(mainService.allEvents),
          view: CalendarView.month,
          initialSelectedDate: DateTime.now(),
          cellBorderColor: Colors.transparent,
          onLongPress: (details) {
            mainService.setDate(details.date!);
            showModalBottomSheet(
                context: context, builder: (context) => TaskWidget());
          },
          onTap: (calendarTapDetails) {
            if (isAppointment) {
              controller.changeSelectedDate(calendarTapDetails.date!);
              print("date => ${calendarTapDetails.date}");
              controller.getAllAlreadyTakenSlots();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TimeSlotScreen()));
            }
          },
        );
      },
    );
  }
}

class EventDataSouce extends CalendarDataSource {
  EventDataSouce(List<Event> status) {
    this.appointments = status;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  Color getColor(int index) => Colors.redAccent;

  @override
  String getSubject(int index) => getEvent(index).title;
}
