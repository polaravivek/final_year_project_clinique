import 'dart:convert';

class ModelDoctorInfo {
  final String? clinicName;
  final String? address;
  final String? doctorName;
  final String? eveningTime;
  final String? morningTime;
  final String? specialization;
  final String? docId;
  final String? img;
  final String? fees;
  final String? count;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final int? review;

  ModelDoctorInfo(
      {this.clinicName,
      this.address,
      this.doctorName,
      this.eveningTime,
      this.morningTime,
      this.specialization,
      this.docId,
      this.img,
      this.fees,
      this.count,
      this.latitude,
      this.longitude,
      this.distance,
      this.review});

  Map<String, dynamic> toMap() {
    return {
      'clinicName': clinicName,
      'address': address,
      'doctorName': doctorName,
      'evening time': eveningTime,
      'morning time': morningTime,
      'specialization': specialization,
      'docId': docId,
      'img': img,
      'fees': fees,
      'count': count,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'review': review,
    };
  }

  factory ModelDoctorInfo.fromMap(Map<String, dynamic> map) {
    return ModelDoctorInfo(
      clinicName: map['clinicName'] ?? '',
      address: map['address'] ?? '',
      doctorName: map['doctorName'] ?? '',
      eveningTime: map['evening time'] ?? '',
      morningTime: map['morning time'] ?? '',
      specialization: map['specialization'] ?? '',
      docId: map['docId'] ?? '',
      img: map['img'] ?? '',
      fees: map['fees'] ?? '',
      count: map['count'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      distance: map['distance']?.toDouble() ?? 0.0,
      review: map['review']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelDoctorInfo.fromJson(String source) =>
      ModelDoctorInfo.fromMap(json.decode(source));
}
