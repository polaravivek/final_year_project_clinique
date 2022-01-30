import 'package:clinique/model/direction_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clinique/constants/.env.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    print(destination.latitude);
    print(destination.longitude);
    print(origin.latitude);
    print(origin.longitude);
    final response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': googleAPIKey,
    });

    if (response.statusCode == 200) {
      print("status 200");
      print(response.data);
      return Directions.fromMap(response.data);
    } else {
      print("status 400");
      return null;
    }
  }
}
