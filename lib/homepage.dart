import 'package:clinique/model/doctor_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

LatLng _center;
Future<Position> position;

class MapActivity extends StatefulWidget {
  @override
  _MapActivityState createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  GoogleMapController _myController;
  Set<Marker> _marker = {};
  CameraPosition _cameraPosition;
  final databaseRef = FirebaseDatabase.instance.reference();

  List<ModelDoctorInfo> list = List();

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _myController = controller;

    await _determinePosition();

    _myController.animateCamera(
      CameraUpdate.newLatLngZoom(_center, 17),
    );
    _marker.add(
      Marker(
        markerId: MarkerId('id-1'),
        position: _center,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
  }

  Future<void> printFirebase() async {
    await databaseRef.child("doctorInfo").get().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> databaseRefIndi = snapshot.value;
      LatLng pos;
      var count = 1;
      var lat;
      var long;
      databaseRefIndi.forEach((key, value) {
        Map<dynamic, dynamic> info = snapshot.value;
        databaseRef
            .child("doctorInfo")
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
          setState(() {
            _marker.add(
              Marker(
                markerId: MarkerId('id-$count'),
                position: pos,
                icon: BitmapDescriptor.defaultMarker,
              ),
            );
          });
        });
      });
    });
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      print("here");
      _center = LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: _center, zoom: 15.0);

      _marker.add(
        Marker(
          position: _center,
          markerId: MarkerId('id-1'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }

  Future<void> getList() async {
    await databaseRef.child("doctorInfo").get().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> databaseRefIndi = snapshot.value;
      databaseRefIndi.forEach((key, value) {
        print(value["name"]);
        ModelDoctorInfo modelDoctorInfo = new ModelDoctorInfo(
            value["clinicName"],
            value["address"],
            value["name"],
            value["evening time"],
            value["fees"],
            value["morning time"],
            value["specialization"],
            value["latitude"],
            value["longitude"]);

        setState(() {
          list.add(modelDoctorInfo);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _determinePosition();
    printFirebase();
    getList();
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

    Widget UI(
        String clinicName,
        String address,
        String doctorName,
        String eveningTime,
        int fees,
        String morningTime,
        String specialization,
        double latitude,
        double longitude) {
      return Container(
        width: 270,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$clinicName',
                  style: TextStyle(
                    color: Color(0xff8A1818),
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        child: Icon(Icons.import_contacts_sharp),
                        radius: 25,
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
                            ),
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
                      child: starReview(2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                        items: <String>['Distance', 'Review', 'Fees']
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
                                TextStyle(color: Colors.white))),
                        onPressed: () {},
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
                        onPressed: () {},
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
                        markers: _marker,
                        initialCameraPosition: _cameraPosition == null
                            ? CameraPosition(target: LatLng(0, 0))
                            : _cameraPosition,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            onPressed: () async {
                              print("tapped");
                              _determinePosition();
                              // await printFirebase();
                              // await getList();
                              _myController.animateCamera(
                                  CameraUpdate.newLatLngZoom(_center, 16));
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.map, size: 30.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: new Container(
                          height: 170,
                          child: list.length == 0
                              ? Text("data is null")
                              : new ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    return UI(
                                        list[index].clinicName,
                                        list[index].address,
                                        list[index].doctorName,
                                        list[index].eveningTime,
                                        list[index].fees,
                                        list[index].morningTime,
                                        list[index].specialization,
                                        list[index].latitude,
                                        list[index].longitude);
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
      ),
    );
  }
}
