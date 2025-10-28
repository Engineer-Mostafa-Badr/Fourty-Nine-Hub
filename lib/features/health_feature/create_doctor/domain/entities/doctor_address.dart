class DoctorAddressEntity {
  String governorateId;
  String cityId;
  String address;
  double? latitude;
  double? longitude;
  DoctorAddressEntity(
      {required this.governorateId,
      required this.cityId,
      required this.address,
      this.latitude,
      this.longitude});
}
