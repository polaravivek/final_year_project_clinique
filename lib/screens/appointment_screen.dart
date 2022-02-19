import 'package:clinique/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key, required this.clinicId}) : super(key: key);

  final String clinicId;

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0x9AAB1818),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xffFFC7C7),
      appBar: AppBar(
        backgroundColor: Color(0xff8A1818),
        title: Text("Appointment").center(),
      ),
      body: CalendarWidget(
        clinicId: widget.clinicId,
        isAppointment: true,
      ),
    );
  }
}
