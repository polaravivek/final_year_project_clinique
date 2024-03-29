import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget ui(
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
    String? uid,
    Function()? onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 5),
    child: Container(
      child: Card(
        color: Color(0xffFFA8A8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      backgroundColor: Color(0xff8A1818),
                      radius: 35,
                      child: ClipOval(
                        child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CachedNetworkImage(
                              imageUrl: img,
                              fit: BoxFit.cover,
                            )),
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
                          'Dr. $doctorName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Future Clinic Status Click Me : ",
                    style: TextStyle(
                        color: Color(0xff8A1818), fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    color: Color(0xff8A1818),
                    icon: Icon(Icons.arrow_forward),
                    onPressed: onTap,
                  )
                ],
              )
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
