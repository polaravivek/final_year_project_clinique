import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinique/controller/homepage.controller.dart';
import 'package:clinique/main.controller.dart';
import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/screens/selectedClinic.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Position>? position;

class MapActivity extends StatefulWidget {
  @override
  _MapActivityState createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  GoogleMapController? myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final databaseRef = FirebaseDatabase.instance.reference();

  MainController mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
  }

  String? dropdownValue = 'Distance';

  @override
  Widget build(BuildContext context) {
    Widget starReview(int? value) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < value! ? Icons.star : Icons.star_border,
          );
        }),
      );
    }

    Widget ui(
        int index,
        String img,
        String? clinicName,
        String? address,
        String? doctorName,
        String? eveningTime,
        String? fees,
        String? morningTime,
        String? specialization,
        double? latitude,
        double? longitude,
        int? review,
        double? distance,
        String? docId,
        String? count,
        HomePageController controller) {
      ModelDoctorInfo modelDoctorInfo;

      return GestureDetector(
        onTap: () {
          if (controller.listNew.length != 0) {
            var item = controller.listNew[index];
            modelDoctorInfo = ModelDoctorInfo(
              address: item.address,
              clinicName: item.clinicName,
              count: item.count,
              distance: item.distance,
              docId: docId,
              doctorName: item.doctorName,
              eveningTime: item.eveningTime,
              fees: item.fees,
              img: item.img,
              latitude: item.latitude,
              longitude: item.longitude,
              morningTime: item.morningTime,
              review: item.review,
              specialization: item.specialization,
            );
            var status = mainController.getStatus(item.docId!);
            mainController.changeStatus(status);
            print(mainController.status);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectedClinic(modelDoctorInfo),
              ),
            );
          } else {
            var item = controller.list[index];
            modelDoctorInfo = ModelDoctorInfo(
              address: item.address,
              clinicName: item.clinicName,
              count: item.count,
              distance: item.distance,
              docId: docId,
              doctorName: item.doctorName,
              eveningTime: item.eveningTime,
              fees: item.fees,
              img: item.img,
              latitude: item.latitude,
              longitude: item.longitude,
              morningTime: item.morningTime,
              review: item.review,
              specialization: item.specialization,
            );
            var status = mainController.getStatus(item.docId!);
            mainController.changeStatus(status);
            print(mainController.status);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectedClinic(modelDoctorInfo)));
          }
        },
        onLongPress: () {
          controller.changeCamera(LatLng(latitude!, longitude!));
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
                      StreamBuilder(
                          stream: controller.firestore
                              .collection('queue')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ).center());
                            }
                            final snap = snapshot.data!.docs;
                            String? status;
                            for (var sn in snap) {
                              if (sn.id == docId) {
                                status = sn.get('status');
                              }
                            }
                            return Text("$status",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (status == "close")
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 15,
                                ));
                          }),
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
                      StreamBuilder(
                          stream: controller.firestore
                              .collection('queue')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ).center());
                            }
                            final snap = snapshot.data!.docs;
                            int? count = 0;
                            for (var sn in snap) {
                              if (sn.id == docId) {
                                count = sn.get('count');
                              }
                            }
                            return Text("$count",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (count! >= 10)
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 17,
                                ));
                          }),
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
                              child: CachedNetworkImage(
                                imageUrl: img,
                                fit: BoxFit.cover,
                              ),
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
                                  controller: controller.textEditingController,
                                  onChanged: (v) {
                                    controller.filteredList = controller.list
                                        .where((element) => (element.address!
                                                .toLowerCase()
                                                .contains(v.toLowerCase()) ||
                                            element.clinicName!
                                                .toLowerCase()
                                                .contains(v.toLowerCase())))
                                        .toList();
                                  },
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.clear).gestures(onTap: () {
                                      controller.filteredList.clear();
                                      controller.textEditingController.clear();
                                    }),
                                    // suffix: Icon(Icons.clear),
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Distance',
                                'Review',
                                'Fees',
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
                                controller.listNew.clear();
                                if (dropdownValue == "Distance") {
                                  setState(() {
                                    controller.list.sort(
                                      (a, b) =>
                                          a.distance!.compareTo(b.distance!),
                                    );
                                  });
                                } else if (dropdownValue == "Review") {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        a.review!.compareTo(b.review!));
                                  });
                                } else if (dropdownValue == "Fees") {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        int.parse(a.fees!)
                                            .compareTo(int.parse(b.fees!)));
                                  });
                                } else {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        int.parse(a.count!)
                                            .compareTo(int.parse(b.count!)));
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
                                controller.listNew.clear();
                                if (dropdownValue == "Distance") {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        b.distance!.compareTo(a.distance!));
                                  });
                                } else if (dropdownValue == "Review") {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        b.review!.compareTo(a.review!));
                                  });
                                } else if (dropdownValue == "Fees") {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        int.parse(b.fees!)
                                            .compareTo(int.parse(a.fees!)));
                                  });
                                } else {
                                  setState(() {
                                    controller.list.sort((a, b) =>
                                        int.parse(b.count!)
                                            .compareTo(int.parse(a.count!)));
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
                                  onTap: (latlang) =>
                                      controller.handleTap(latlang),
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
                                  print(controller.filteredList.length);
                                  return Container(
                                      height: 170,
                                      child: ((controller.filteredList.length ==
                                                      controller.list.length ||
                                                  controller.filteredList
                                                          .length ==
                                                      controller
                                                          .listNew.length) ||
                                              controller.filteredList.length ==
                                                  0)
                                          ? controller.listNew.length != 0
                                              ? Obx(() {
                                                  print(
                                                      "showing from new list");
                                                  return ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder: (_, index) {
                                                      var item = controller
                                                          .listNew[index];
                                                      return ui(
                                                          index,
                                                          item.img!,
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
                                                          item.count,
                                                          controller);
                                                    },
                                                    itemCount: controller
                                                        .listNew.length,
                                                  );
                                                })
                                              : controller.list == null
                                                  ? CircularProgressIndicator()
                                                  : Obx(() {
                                                      print(
                                                          "showing from list");
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (_, index) {
                                                          print(index);
                                                          var item = controller
                                                              .list[index];
                                                          return ui(
                                                              index,
                                                              item.img!,
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
                                                              item.count,
                                                              controller);
                                                        },
                                                        itemCount: controller
                                                            .list.length,
                                                      );
                                                    })
                                          : Obx(() => ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, index) {
                                                  print(
                                                      "showing from filtered list");
                                                  var item = controller
                                                      .filteredList[index];
                                                  return ui(
                                                      index,
                                                      item.img!,
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
                                                      item.count,
                                                      controller);
                                                },
                                                itemCount: controller
                                                    .filteredList.length,
                                              )));
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
