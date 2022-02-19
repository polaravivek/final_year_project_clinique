import 'package:clinique/controller/homepage.controller.dart';
import 'package:clinique/main.controller.dart';
import 'package:clinique/screens/homepage.dart';
import 'package:clinique/screens/my_appointment_screen.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer navigationDrawer(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;

  return Drawer(
    backgroundColor: Color(0xffFFC7C7),
    child: GetBuilder<HomePageController>(builder: (controller) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff8A1818),
            ),
            height: height * 0.2,
            width: width,
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() {
            return menuItem(
                "Home",
                controller.selectedString.value == "Home" ? true : false,
                controller,
                context);
          }),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            return menuItem(
                "Appointments",
                controller.selectedString.value == "Appointments"
                    ? true
                    : false,
                controller,
                context);
          }),
        ],
      );
    }),
  );
}

InkWell menuItem(String menuLabel, bool isSelected,
    HomePageController controller, BuildContext context) {
  MainController mainController = Get.find<MainController>();
  return InkWell(
    splashColor: Color(0xffFFC7C7),
    highlightColor: Color(0xffFFC7C7),
    onTap: () {
      print(menuLabel);
      controller.changeSelected(menuLabel);
      if (menuLabel == "Home") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MapActivity(),
          ),
        );
      } else if (menuLabel == "Appointments") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyAppointments(),
          ),
        );
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          menuLabel,
          style: TextStyle(
            fontSize: 18,
          ),
        ).padding(all: 15),
      ],
    )
        .backgroundColor(isSelected
            ? Color(0xff8A1818).withOpacity(0.20)
            : Colors.transparent)
        .clipRRect(all: 15)
        .padding(horizontal: 20),
  );
}
