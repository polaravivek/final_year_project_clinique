class ModelDoctorInfo {
  final String clinicName,
      address,
      doctorName,
      eveningTime,
      morningTime,
      specialization,
      docId;
  final double latitude, longitude, distance;
  final int fees, review;

  ModelDoctorInfo(
    this.clinicName,
    this.address,
    this.doctorName,
    this.eveningTime,
    this.fees,
    this.morningTime,
    this.specialization,
    this.latitude,
    this.longitude,
    this.distance,
    this.review,
    this.docId,
  );
}
