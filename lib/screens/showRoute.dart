import 'dart:collection';

import 'package:clinique/model/direction_model.dart';
import 'package:clinique/direction_repository.dart';
import 'package:clinique/model/doctor_info.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

LatLng _center;

FirebaseFirestore _firestore = FirebaseFirestore.instance;
var uid;
var ref;

class ShowRouting extends StatefulWidget {
  final ModelDoctorInfo modelDoctorInfo;
  final String name;

  const ShowRouting(this.modelDoctorInfo, this.name);

  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<ShowRouting> {
  GoogleMapController _myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Polyline> _polyline = {};
  CameraPosition _cameraPosition;
  Directions _info;
  bool isLoading = true;

  _onMapCreated(GoogleMapController controller) async {
    _myController = controller;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    _center = LatLng(position.latitude, position.longitude);
    _cameraPosition = CameraPosition(target: _center, zoom: 16.0);

    markers[MarkerId('id-1')] = Marker(
      position: _center,
      markerId: MarkerId('id-1'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    printFirebase();

    _myController.animateCamera(
      CameraUpdate.newLatLngZoom(_center, 16),
    );
  }

  Future<LatLng> _findCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: _center, zoom: 16.0);

      markers[MarkerId('id-1')] = Marker(
        position: _center,
        markerId: MarkerId('id-1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });

    printFirebase();

    return _center;
  }

  printFirebase() async {
    LatLng pos = LatLng(
        widget.modelDoctorInfo.latitude, widget.modelDoctorInfo.longitude);
    final markerId = MarkerId('id-2');
    markers[MarkerId('id-2')] = Marker(
      markerId: markerId,
      position: pos,
      icon: BitmapDescriptor.defaultMarker,
    );

    final directions = await DirectionsRepository()
        .getDirections(origin: _center, destination: pos);

    print("directions ${directions.totalDistance}");

    setState(() {
      _info = directions;
    });
    if (_info != null) {
      _polyline.add(
        Polyline(
          polylineId: PolylineId('overview_polyline'),
          color: Colors.red,
          width: 5,
          points: _info.polylinePoints
              .map(
                (e) => LatLng(e.latitude, e.longitude),
              )
              .toList(),
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    ref = FirebaseDatabase.instance.reference();
    uid = auth.currentUser.uid;

    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    _firestore.terminate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0x9AAB1818),
          statusBarBrightness: Brightness.light),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: StreamBuilder(
            stream: _firestore
                .collection('queue')
                .doc('${widget.modelDoctorInfo.docId}')
                .collection('queue')
                .orderBy('time')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text('YOUR CURRENT NUMBER : loading...');
              }

              int count = 0;
              final snap = snapshot.data.docs;
              for (var sn in snap) {
                count++;
                LinkedHashMap<String, dynamic> s = sn.data();
                if (widget.name == s['name']) {
                  break;
                }
              }
              return Row(
                children: [
                  Text(
                    "YOUR CURRENT NUMBER : ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "$count",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w900),
                  ),
                ],
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        polylines: _polyline,
                        onMapCreated: _onMapCreated,
                        markers: Set<Marker>.of(markers.values),
                        initialCameraPosition: _cameraPosition == null
                            ? CameraPosition(target: LatLng(20.5937, 78.9629))
                            : _cameraPosition,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            onPressed: () async {
                              _myController.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      await _findCurrentLocation(), 16));
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.add_location, size: 30.0),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 10,
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_info?.totalDistance} ( ${_info?.totalDuration} )',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      textStyle: const TextStyle(fontSize: 18),
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12)),
                                  onPressed: () {
                                    _firestore
                                        .collection('queue')
                                        .doc('${widget.modelDoctorInfo.docId}')
                                        .collection('queue')
                                        .orderBy('time')
                                        .get()
                                        .then((value) {
                                      var elem = value.docs.first;
                                      // print(elem.data());
                                      elem.reference.delete().then((value) {
                                        _firestore
                                            .collection('queue')
                                            .doc(
                                                '${widget.modelDoctorInfo.docId}')
                                            .get()
                                            .then((value) {
                                          var count = value["count"];

                                          _firestore
                                              .collection('queue')
                                              .doc(
                                                  '${widget.modelDoctorInfo.docId}')
                                              .update({'count': --count}).then(
                                                  (value) {
                                            Navigator.pop(context);
                                          });
                                        });
                                      });
                                    });
                                  },
                                  child: Text(
                                    'LEAVE QUEUE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            (isLoading)
                ? Positioned.fill(
                    child: const CircularProgressIndicator().center().decorated(
                          color: Colors.black12.withAlpha(20),
                        ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
