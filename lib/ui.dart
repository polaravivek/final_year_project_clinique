import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/doctor_info.dart';

Widget UI(
    String clinicName,
    String address,
    String doctorName,
    String eveningTime,
    int fees,
    String morningTime,
    String specialization,
    double latitude,
    double longitude,
    int review,
    double distance,
    String uid) {
  ModelDoctorInfo modelDoctorInfo;
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 5),
    child: Container(
      child: Card(
        color: Color(0xffFFA8A8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8A1818),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Specialist : $specialization',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Time : $morningTime / $eveningTime',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Fees : $fees Rs.',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Address : $address',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

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
