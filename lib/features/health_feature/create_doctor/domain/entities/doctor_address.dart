class DoctorAddressEntity {
  String governorateId;
  String cityId;
  String address;
  double? latitude;
  double? longitude;
  String? governorateNameAr;
  String? governorateNameEn;
  String? cityNameAr;
  String? cityNameEn;
  DoctorAddressEntity({
    required this.governorateId,
    required this.cityId,
    required this.address,
    this.latitude,
    this.longitude,
    this.governorateNameAr,
    this.governorateNameEn,
    this.cityNameAr,
    this.cityNameEn,
  });
}
