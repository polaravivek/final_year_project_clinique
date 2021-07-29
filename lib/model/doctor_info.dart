class ModelDoctorInfo {
  final String clinicName,
      address,
      doctorName,
      eveningTime,
      morningTime,
      specialization;
  final double latitude, longitude;
  final int fees;

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
  );
}
