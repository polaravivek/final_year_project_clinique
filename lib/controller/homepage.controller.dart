import 'dart:async';

import 'package:clinique/model/doctor_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageController extends GetxController {
  final databaseRef = FirebaseDatabase.instance.reference();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  late GoogleMapController myController;

  final loading = false.obs;
  final listLoading = false.obs;
  List<ModelDoctorInfo> list = <ModelDoctorInfo>[].obs;
  List<ModelDoctorInfo> filteredList = <ModelDoctorInfo>[].obs;
  List<ModelDoctorInfo> listNew = <ModelDoctorInfo>[].obs;
  TextEditingController textEditingController = TextEditingController();
  final RxString selectedString = "Home".obs;
  Rx<LatLng> center = LatLng(0, 0).obs;

  Rx<CameraPosition> cameraPosition =
      CameraPosition(target: LatLng(0, 0), zoom: 10).obs;

  bool get isLoading => loading.value;
  bool get isListLoading => listLoading.value;

  LatLng get getCenter => center.value;

  List<ModelDoctorInfo> get getVarList => list;
  List<ModelDoctorInfo> get getVarListNew => listNew;

  CameraPosition get getCameraPosition => cameraPosition.value;

  startLoading() => loading.value = true;
  stopLoading() => loading.value = false;

  startListLoading() => listLoading.value = true;
  stopListLoading() => listLoading.value = false;

  changeCamera(LatLng target) => myController.animateCamera(
        CameraUpdate.newLatLngZoom(target, 16),
      );

  changeSelected(String selectedMenu) => selectedString.value = selectedMenu;

  @override
  void onInit() {
    list.clear();
    listNew.clear();
    super.onInit();
  }

  void handleTap(LatLng tappedPoint) {
    listNew.clear();
    print("called handle tap");

    list.forEach((element) {
      if (element.latitude == tappedPoint.latitude &&
          element.longitude.toString() ==
              tappedPoint.longitude.toStringAsPrecision(8)) {
        listNew.add(element);
      }
    });
  }

  onMapCreated(GoogleMapController controller) async {
    myController = controller;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    center.value = LatLng(position.latitude, position.longitude);
    cameraPosition.value = CameraPosition(target: center.value, zoom: 15.0);

    markers[MarkerId('id-1')] = Marker(
      position: center.value,
      markerId: MarkerId('id-1'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    printFirebase();
    getList();

    myController.animateCamera(
      CameraUpdate.newLatLngZoom(center.value, 15),
    );
  }

  printFirebase() {
    databaseRef
        .child("doctorInfo")
        .child('clinicInfo')
        .get()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> databaseRefIndi =
          snapshot.value as Map<dynamic, dynamic>;
      LatLng pos;
      var count = 1;
      late var lat;
      late var long;

      databaseRefIndi.forEach((key, value) {
        Map<dynamic, dynamic>? info = snapshot.value as Map<dynamic, dynamic>;

        databaseRef
            .child("doctorInfo")
            .child("clinicInfo")
            .child(key.toString())
            .get()
            .then((DataSnapshot snapshot) {
          info = snapshot.value as Map<dynamic, dynamic>;

          info!.forEach((key, value) {
            if (key == "latitude") {
              lat = value;
            } else if (key == "longitude") {
              long = value;
            }
          });

          pos = LatLng(lat, long);

          count++;

          final distance = Geolocator.distanceBetween(center.value.latitude,
              center.value.longitude, pos.latitude, pos.longitude);

          if (distance < 5000) {
            final markerId = MarkerId('id-$count');
            markers[markerId] = Marker(
              markerId: markerId,
              position: pos,
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                print("tapped marker");
                final Marker? tappedMarker = markers[markerId];

                if (tappedMarker != null) {
                  listNew.clear();

                  list.forEach((element) {
                    if (element.latitude!.toStringAsPrecision(7) ==
                            tappedMarker.position.latitude
                                .toStringAsPrecision(7) &&
                        element.longitude!.toStringAsPrecision(7) ==
                            tappedMarker.position.longitude
                                .toStringAsPrecision(7)) {
                      listNew.add(element);
                    }
                  });
                } else {
                  print("Tapped marker is NULL..");
                }
              },
            );
          }
        });
      });
    });
  }

  getList() {
    list.clear();
    listNew.clear();
    startListLoading();
    startLoading();
    databaseRef
        .child("doctorInfo")
        .child("clinicInfo")
        .get()
        .then((DataSnapshot? snapshot) {
      Map<dynamic, dynamic> databaseRefIndi =
          snapshot!.value as Map<dynamic, dynamic>;

      databaseRefIndi.forEach((key, value) {
        final distance = Geolocator.distanceBetween(center.value.latitude,
            center.value.longitude, value["latitude"], value["longitude"]);

        if (distance < 5000) {
          ModelDoctorInfo modelDoctorInfo;

          FirebaseStorage.instance
              .ref()
              .child(value["img"])
              .getDownloadURL()
              .then((url) async {
            var count = 0;

            modelDoctorInfo = new ModelDoctorInfo(
              img: url,
              clinicName: value["clinicName"],
              address: value["address"],
              doctorName: value["name"],
              eveningTime: value["evening time"],
              fees: value["fees"],
              morningTime: value["morning time"],
              specialization: value["specialization"],
              latitude: value["latitude"],
              longitude: value["longitude"],
              distance: distance,
              review: value["review"],
              docId: key,
              count: count.toString(),
            );
            list.add(modelDoctorInfo);
          });
        }
      });
    }).then((value) {
      Future.delayed(Duration(seconds: 3)).then((value) => stopListLoading());
    });
  }
}
