import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

Widget appoinmentUi(
    {String? img,
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
    String? appointmentTime,
    String? appointmentDate,
    String? uid,
    Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 5),
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
                          child: img != null
                              ? CachedNetworkImage(
                                  imageUrl: img,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset("assets/images/img.png")),
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
              children: [
                Text(
                  "Review : ",
                  style: TextStyle(
                      color: Color(0xff8A1818), fontWeight: FontWeight.bold),
                ),
                starReview(review ?? 1)
              ],
            ).padding(top: 10, left: 20),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Appointment Date : ",
                      style: TextStyle(
                          color: Color(0xff8A1818),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(appointmentDate ?? ""),
                  ],
                ).padding(top: 10, left: 20),
                Row(
                  children: [
                    Text(
                      "Appointment Time : ",
                      style: TextStyle(
                          color: Color(0xff8A1818),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(appointmentTime ?? ""),
                  ],
                ).padding(top: 10, left: 20),
              ],
            ),
          ],
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
