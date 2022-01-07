import 'package:clinique/model/doctor_info.dart';
import 'package:clinique/screens/selectedClinic.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

LatLng _center;
Future<Position> position;

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MapActivity extends StatefulWidget {
  @override
  _MapActivityState createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  GoogleMapController _myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition _cameraPosition;
  final databaseRef = FirebaseDatabase.instance.reference();

  static List<ModelDoctorInfo> list = [];
  static List<ModelDoctorInfo> listNew = [];

  _onMapCreated(GoogleMapController controller) async {
    _myController = controller;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _center = LatLng(position.latitude, position.longitude);
    _cameraPosition = CameraPosition(target: _center, zoom: 15.0);

    markers[MarkerId('id-1')] = Marker(
      position: _center,
      markerId: MarkerId('id-1'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    printFirebase();

    getList();

    _myController.animateCamera(
      CameraUpdate.newLatLngZoom(_center, 15),
    );
  }

  printFirebase() {
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

          final distance = Geolocator.distanceBetween(
              _center.latitude, _center.longitude, pos.latitude, pos.longitude);

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
                      setState(() {
                        listNew.add(element);
                      });
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
    databaseRef
        .child("doctorInfo")
        .child("clinicInfo")
        .get()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> databaseRefIndi = snapshot.value;
      databaseRefIndi.forEach((key, value) {
        final distance = Geolocator.distanceBetween(_center.latitude,
            _center.longitude, value["latitude"], value["longitude"]);

        if (distance < 2000) {
          ModelDoctorInfo modelDoctorInfo;

          FirebaseStorage.instance
              .ref()
              .child(value["img"])
              .getDownloadURL()
              .then((url) async {
            var count = 0;
            _firestore.collection('queue').snapshots().forEach((element) async {
              final snap = element.docs;
              for (var sn in snap) {
                if (sn.id.toString() == key.toString()) {
                  count = await sn.get('count');
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
              }
              setState(() {
                list.add(modelDoctorInfo);
              });
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    list.clear();
    listNew.clear();
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
          if (listNew.length != 0) {
            modelDoctorInfo = new ModelDoctorInfo(
                listNew[index].img,
                listNew[index].clinicName,
                listNew[index].address,
                listNew[index].doctorName,
                listNew[index].eveningTime,
                listNew[index].fees,
                listNew[index].morningTime,
                listNew[index].specialization,
                listNew[index].latitude,
                listNew[index].longitude,
                listNew[index].distance,
                listNew[index].review,
                docId,
                listNew[index].count);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectedClinic(modelDoctorInfo)));
          } else {
            modelDoctorInfo = new ModelDoctorInfo(
                list[index].img,
                list[index].clinicName,
                list[index].address,
                list[index].doctorName,
                list[index].eveningTime,
                list[index].fees,
                list[index].morningTime,
                list[index].specialization,
                list[index].latitude,
                list[index].longitude,
                list[index].distance,
                list[index].review,
                docId,
                list[index].count);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectedClinic(modelDoctorInfo)));
          }
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
                              child: Hero(
                                tag: img,
                                child: Image.network(img, fit: BoxFit.cover),
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

    _handleTap(LatLng tappedPoint) {
      listNew.clear();

      setState(() {
        list.forEach((element) {
          if (element.latitude == tappedPoint.latitude &&
              element.longitude.toString() ==
                  tappedPoint.longitude.toStringAsPrecision(8)) {
            listNew.add(element);
          }
        });
      });
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 30),
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
                      items: <String>['Distance', 'Review', 'Fees', 'Patients']
                          .map<DropdownMenuItem<String>>((String value) {
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
                        listNew.clear();
                        if (dropdownValue == "Distance") {
                          setState(() {
                            list.sort(
                              (a, b) => a.distance.compareTo(b.distance),
                            );
                          });
                        } else if (dropdownValue == "Review") {
                          setState(() {
                            list.sort((a, b) => a.review.compareTo(b.review));
                          });
                        } else if (dropdownValue == "Fees") {
                          setState(() {
                            list.sort((a, b) =>
                                int.parse(a.fees).compareTo(int.parse(b.fees)));
                          });
                        } else {
                          setState(() {
                            list.sort((a, b) => int.parse(a.count)
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
                        listNew.clear();
                        if (dropdownValue == "Distance") {
                          setState(() {
                            list.sort(
                                (a, b) => b.distance.compareTo(a.distance));
                          });
                        } else if (dropdownValue == "Review") {
                          setState(() {
                            list.sort((a, b) => b.review.compareTo(a.review));
                          });
                        } else if (dropdownValue == "Fees") {
                          setState(() {
                            list.sort((a, b) =>
                                int.parse(b.fees).compareTo(int.parse(a.fees)));
                          });
                        } else {
                          setState(() {
                            list.sort((a, b) => int.parse(b.count)
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
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers.values),
                      onTap: _handleTap,
                      initialCameraPosition: _cameraPosition == null
                          ? CameraPosition(
                              target: LatLng(20.5937, 78.9629), zoom: 15)
                          : _cameraPosition,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed: () async {
                            _myController.animateCamera(
                                CameraUpdate.newLatLngZoom(_center, 15));
                          },
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.add_location, size: 30.0),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: new Container(
                        height: 170,
                        child: listNew.length != 0
                            ? new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  return ui(
                                      index,
                                      listNew[index].img,
                                      listNew[index].clinicName,
                                      listNew[index].address,
                                      listNew[index].doctorName,
                                      listNew[index].eveningTime,
                                      listNew[index].fees,
                                      listNew[index].morningTime,
                                      listNew[index].specialization,
                                      listNew[index].latitude,
                                      listNew[index].longitude,
                                      listNew[index].review,
                                      listNew[index].distance,
                                      listNew[index].docId,
                                      listNew[index].count);
                                },
                                itemCount: listNew.length,
                              )
                            : list == null
                                ? CircularProgressIndicator()
                                : new ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      print(index);
                                      return ui(
                                          index,
                                          list[index].img,
                                          list[index].clinicName,
                                          list[index].address,
                                          list[index].doctorName,
                                          list[index].eveningTime,
                                          list[index].fees,
                                          list[index].morningTime,
                                          list[index].specialization,
                                          list[index].latitude,
                                          list[index].longitude,
                                          list[index].review,
                                          list[index].distance,
                                          list[index].docId,
                                          list[index].count);
                                    },
                                    itemCount: list.length,
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
