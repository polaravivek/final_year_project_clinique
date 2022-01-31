import 'package:clinique/controller/status.controller.dart';
import 'package:clinique/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class StatusScreen extends StatefulWidget {
  final String clinicId;

  const StatusScreen({Key? key, required this.clinicId}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final mainService = Get.find<StatusController>();

  @override
  void initState() {
    // mainService.getAllEvents(widget.clinicId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Status").center(),
        ),
        body: CalendarWidget(
          clinicId: widget.clinicId,
        ));
  }
}
