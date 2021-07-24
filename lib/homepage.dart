import 'package:clinique/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng _center;
Future<Position> position;

class MapActivity extends StatefulWidget {
  @override
  _MapActivityState createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  GoogleMapController _myController;
  TextEditingController _address;
  Set<Marker> _marker = {};

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _myController = controller;
    setState(() {
      _marker.add(Marker(markerId: MarkerId('id-1'), position: _center));
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  CameraPosition _initialPosition;
  void getCurrentLocation() async {
    position = Geolocator.getLastKnownPosition();
    position.then((value) {
      setState(() {
        _center = LatLng(value.latitude, value.longitude);
      });
    });
    _initialPosition = CameraPosition(target: _center, zoom: 15);
    _determinePosition();
  }

  LatLng getLocation() {
    position = Geolocator.getCurrentPosition();
    position.then((value) {
      setState(() {
        _center = LatLng(value.latitude, value.longitude);
      });
    });
    _marker.add(Marker(markerId: MarkerId('id-1'), position: _center));

    return _center;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  String dropdownValue = 'Distance';

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 70,
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
                  width: MediaQuery.of(context).size.width - 20,
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        'Sort List By :',
                        style: TextStyle(color: Color(0xff8A1818)),
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
                        items: <String>['Distance', 'Review', 'Fees']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 160,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (controller) => _onMapCreated,
                        markers: _marker == null
                            ? _marker.add(Marker(
                                markerId: MarkerId('id-1'), position: _center))
                            : _marker,
                        initialCameraPosition: _initialPosition,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            onPressed: () {
                              print("tapped");
                              _myController.animateCamera(
                                  CameraUpdate.newLatLng(getLocation()));
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.map, size: 30.0),
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
      ),
    );
  }
}
