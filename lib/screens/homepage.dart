import 'package:clinique/controller/homepage.controller.dart';
import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/screens/selectedClinic.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

Future<Position> position;

class MapActivity extends StatefulWidget {
  @override
  _MapActivityState createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  GoogleMapController myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final databaseRef = FirebaseDatabase.instance.reference();
  final HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
  }

  String dropdownValue = 'Distance';

  @override
  Widget build(BuildContext context) {
    Widget starReview(int value) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < value ? Icons.star : Icons.star_border,
          );
        }),
      );
    }

    Widget ui(
        int index,
        String img,
        String clinicName,
        String address,
        String doctorName,
        String eveningTime,
        String fees,
        String morningTime,
        String specialization,
        double latitude,
        double longitude,
        int review,
        double distance,
        String docId,
        String count) {
      ModelDoctorInfo modelDoctorInfo;
      return GestureDetector(
        onTap: () {
          if (homePageController.listNew.length != 0) {
            var item = homePageController.listNew[index];
            modelDoctorInfo = new ModelDoctorInfo(
                item.img,
                item.clinicName,
                item.address,
                item.doctorName,
                item.eveningTime,
                item.fees,
                item.morningTime,
                item.specialization,
                item.latitude,
                item.longitude,
                item.distance,
                item.review,
                docId,
                item.count);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectedClinic(modelDoctorInfo)));
          } else {
            var item = homePageController.list[index];
            modelDoctorInfo = new ModelDoctorInfo(
                item.img,
                item.clinicName,
                item.address,
                item.doctorName,
                item.eveningTime,
                item.fees,
                item.morningTime,
                item.specialization,
                item.latitude,
                item.longitude,
                item.distance,
                item.review,
                docId,
                item.count);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectedClinic(modelDoctorInfo)));
          }
        },
        onLongPress: () {
          homePageController.changeCamera(LatLng(latitude, longitude));
        },
        child: Container(
          width: 270,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '$clinicName',
                            style: TextStyle(
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8A1818),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (int.parse(count) >= 10)
                              ? Colors.red
                              : Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff8A1818),
                          radius: 25,
                          child: ClipOval(
                            child: SizedBox(
                              width: 45,
                              height: 45,
                              child: Image.network(img, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name : $doctorName',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Specialist : $specialization',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Time : $morningTime / $eveningTime',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Fees : $fees Rs.',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Address : $address',
                              style: TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Review :',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color: Colors.amber,
                          size: 16,
                        ),
                        child: starReview(review),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // _handleTap(LatLng tappedPoint) {
    //   listNew.clear();

    //   setState(() {
    //     list.forEach((element) {
    //       if (element.latitude == tappedPoint.latitude &&
    //           element.longitude.toString() ==
    //               tappedPoint.longitude.toStringAsPrecision(8)) {
    //         listNew.add(element);
    //       }
    //     });
    //   });
    // }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: GetBuilder<HomePageController>(
            init: HomePageController(),
            builder: (controller) {
              return Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 40,
                                child: TextField(
                                  cursorColor: Color(0xFF9B3D3D),
                                  onChanged: (v) {},
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      borderSide: BorderSide(
                                        color: Color(0xFFD99D9D),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      borderSide: BorderSide(
                                        color: Color(
                                          0xFFAA6262,
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Address / Name',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                textStyle: const TextStyle(fontSize: 18),
                                elevation: 5,
                                primary: Color(0xFF9B3D3D),
                              ),
                              onPressed: () {},
                              child: Text("Enter"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 20,
                        height: 50,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Sort List By :',
                              style: TextStyle(
                                color: Color(0xff8A1818),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              dropdownColor: Colors.white,
                              underline: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 8,
                                    ),
                                    color: Colors.black,
                                  ),
                                  height: 2),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Distance',
                                'Review',
                                'Fees',
                                'Patients'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color(0xff9D9D9D),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                homePageController.listNew.clear();
                                if (dropdownValue == "Distance") {
                                  setState(() {
                                    homePageController.list.sort(
                                      (a, b) =>
                                          a.distance.compareTo(b.distance),
                                    );
                                  });
                                } else if (dropdownValue == "Review") {
                                  setState(() {
                                    homePageController.list.sort(
                                        (a, b) => a.review.compareTo(b.review));
                                  });
                                } else if (dropdownValue == "Fees") {
                                  setState(() {
                                    homePageController.list.sort((a, b) =>
                                        int.parse(a.fees)
                                            .compareTo(int.parse(b.fees)));
                                  });
                                } else {
                                  setState(() {
                                    homePageController.list.sort((a, b) =>
                                        int.parse(a.count)
                                            .compareTo(int.parse(b.count)));
                                  });
                                }
                              },
                              child: Text(
                                'Low-High',
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xff9D9D9D),
                                  ),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(color: Colors.white))),
                              onPressed: () {
                                homePageController.listNew.clear();
                                if (dropdownValue == "Distance") {
                                  setState(() {
                                    homePageController.list.sort((a, b) =>
                                        b.distance.compareTo(a.distance));
                                  });
                                } else if (dropdownValue == "Review") {
                                  setState(() {
                                    homePageController.list.sort(
                                        (a, b) => b.review.compareTo(a.review));
                                  });
                                } else if (dropdownValue == "Fees") {
                                  setState(() {
                                    homePageController.list.sort((a, b) =>
                                        int.parse(b.fees)
                                            .compareTo(int.parse(a.fees)));
                                  });
                                } else {
                                  setState(() {
                                    homePageController.list.sort((a, b) =>
                                        int.parse(b.count)
                                            .compareTo(int.parse(a.count)));
                                  });
                                }
                              },
                              child: Text(
                                'High-Low',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 170,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Obx(() => GoogleMap(
                                  onMapCreated: controller.onMapCreated,
                                  markers:
                                      Set<Marker>.of(controller.markers.values),
                                  onTap: controller.handleTap,
                                  initialCameraPosition:
                                      controller.getCameraPosition,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    controller.myController.animateCamera(
                                        CameraUpdate.newLatLngZoom(
                                            controller.getCenter, 15));
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  backgroundColor: Colors.green,
                                  child: const Icon(Icons.add_location,
                                      size: 30.0),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Obx(() {
                                  print(controller.list.length);
                                  print(controller.listNew.length);
                                  return Container(
                                      height: 170,
                                      child: controller.listNew.length != 0
                                          ? Obx(() {
                                              return ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, index) {
                                                  print("here");
                                                  var item =
                                                      controller.listNew[index];
                                                  return ui(
                                                      index,
                                                      item.img,
                                                      item.clinicName,
                                                      item.address,
                                                      item.doctorName,
                                                      item.eveningTime,
                                                      item.fees,
                                                      item.morningTime,
                                                      item.specialization,
                                                      item.latitude,
                                                      item.longitude,
                                                      item.review,
                                                      item.distance,
                                                      item.docId,
                                                      item.count);
                                                },
                                                itemCount:
                                                    controller.listNew.length,
                                              );
                                            })
                                          : controller.list == null
                                              ? CircularProgressIndicator()
                                              : Obx(() {
                                                  return ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder: (_, index) {
                                                      print(index);
                                                      var item = controller
                                                          .list[index];
                                                      return ui(
                                                          index,
                                                          item.img,
                                                          item.clinicName,
                                                          item.address,
                                                          item.doctorName,
                                                          item.eveningTime,
                                                          item.fees,
                                                          item.morningTime,
                                                          item.specialization,
                                                          item.latitude,
                                                          item.longitude,
                                                          item.review,
                                                          item.distance,
                                                          item.docId,
                                                          item.count);
                                                    },
                                                    itemCount:
                                                        controller.list.length,
                                                  );
                                                }));
                                })),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Obx(() => controller.isListLoading
                      ? Positioned.fill(
                          child: const CircularProgressIndicator()
                              .center()
                              .decorated(
                                color: Colors.black12.withAlpha(20),
                              ),
                        )
                      : SizedBox()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
