import 'package:clinique/model/doctor_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageController extends GetxController {
  final databaseRef = FirebaseDatabase.instance.reference();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  GoogleMapController myController;

  final loading = false.obs;
  final listLoading = false.obs;
  List<ModelDoctorInfo> list = <ModelDoctorInfo>[].obs;
  List<ModelDoctorInfo> listNew = <ModelDoctorInfo>[].obs;
  Rx<LatLng> center = LatLng(0, 0).obs;

  Rx<CameraPosition> cameraPosition =
      CameraPosition(target: LatLng(0, 0), zoom: 10).obs;

  bool get isLoading => loading.value;
  bool get isListLoading => listLoading.value;

  LatLng get getCenter => center.value;

  CameraPosition get getCameraPosition => cameraPosition.value;

  startLoading() => loading.value = true;
  stopLoading() => loading.value = false;

  startListLoading() => listLoading.value = true;
  stopListLoading() => listLoading.value = false;

  changeCamera(LatLng target) => myController.animateCamera(
        CameraUpdate.newLatLngZoom(target, 17),
      );

  @override
  void onInit() {
    list.clear();
    listNew.clear();
    super.onInit();
  }

  void handleTap(LatLng tappedPoint) {
    listNew.clear();

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

  Future<void> printFirebase() {
    databaseRef
        .child("doctorInfo")
        .child('clinicInfo')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> databaseRefIndi = snapshot.value;
      LatLng pos;
      var count = 1;
      var lat;
      var long;

      databaseRefIndi.forEach((key, value) {
        Map<dynamic, dynamic> info = snapshot.value;

        databaseRef
            .child("doctorInfo")
            .child("clinicInfo")
            .child(key.toString())
            .once()
            .then((DataSnapshot snapshot) {
          info = snapshot.value;

          info.forEach((key, value) {
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

          if (distance < 2000) {
            final markerId = MarkerId('id-$count');

            markers[markerId] = Marker(
              markerId: markerId,
              position: pos,
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                final Marker tappedMarker = markers[markerId];

                if (tappedMarker != null) {
                  listNew.clear();

                  list.forEach((element) {
                    if (element.latitude.toStringAsPrecision(7) ==
                            tappedMarker.position.latitude
                                .toStringAsPrecision(7) &&
                        element.longitude.toStringAsPrecision(7) ==
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
            markers[markerId] = Marker(
              markerId: markerId,
              position: pos,
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                final Marker tappedMarker = markers[markerId];

                if (tappedMarker != null) {
                  listNew.clear();

                  list.forEach((element) {
                    if (element.latitude.toStringAsPrecision(7) ==
                            tappedMarker.position.latitude
                                .toStringAsPrecision(7) &&
                        element.longitude.toStringAsPrecision(7) ==
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

  Future<void> getList() {
    startListLoading();
    list.clear();
    listNew.clear();
    startLoading();
    databaseRef
        .child("doctorInfo")
        .child("clinicInfo")
        .get()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> databaseRefIndi = snapshot.value;
      databaseRefIndi.forEach((key, value) {
        final distance = Geolocator.distanceBetween(center.value.latitude,
            center.value.longitude, value["latitude"], value["longitude"]);

        if (distance < 2000) {
          ModelDoctorInfo modelDoctorInfo;

          FirebaseStorage.instance
              .ref()
              .child(value["img"])
              .getDownloadURL()
              .then((url) async {
            var count = 0;
            _firestore.collection('queue').snapshots().forEach((element) async {
              print("here count");
              list.clear();
              listNew.clear();
              final snap = element.docs;
              for (var sn in snap) {
                if (sn.id.toString() == key.toString()) {
                  count = await sn.get('count');
                }
                print("here $count");
                print("here ${value["clinicName"]}");
                modelDoctorInfo = new ModelDoctorInfo(
                    url,
                    value["clinicName"],
                    value["address"],
                    value["name"],
                    value["evening time"],
                    value["fees"],
                    value["morning time"],
                    value["specialization"],
                    value["latitude"],
                    value["longitude"],
                    distance,
                    value["review"],
                    key,
                    count.toString());
              }
              list.add(modelDoctorInfo);
            });
            stopListLoading();
          });
        }
      });
      print("stop");

      print("length of list => ${list.length}");
    });
  }
}
