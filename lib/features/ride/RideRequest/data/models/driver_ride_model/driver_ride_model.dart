import 'rider_info_id.dart';

class DriverRideModel {
  String? id;
  String? driverFirstName;
  String? driverLastName;
  String? userId;
  bool? adminIgnore;
  RiderInfoId? riderInfoId;
  String? categoryId;
  int? pricingPerKm;
  String? city;
  String? phone;
  bool? comfort;
  bool? isDeleted;
  bool? isApproved;
  String? carTypeId;
  String? subscriptionType;
  DateTime? birthDate;
  String? carModel;
  String? driverPictureKey;
  bool? isSocketCategory;

  DriverRideModel({
    this.id,
    this.driverFirstName,
    this.driverLastName,
    this.userId,
    this.adminIgnore,
    this.birthDate,
    this.riderInfoId,
    this.categoryId,
    this.pricingPerKm,
    this.city,
    this.phone,
    this.comfort,
    this.isDeleted,
    this.isApproved,
    this.carTypeId,
    this.subscriptionType,
    this.carModel,
    this.driverPictureKey,
    this.isSocketCategory,
  });

  factory DriverRideModel.fromJson(Map<String, dynamic> json) {
    return DriverRideModel(
      id: json['_id'] as String?,
      driverFirstName: json['driverFirstName'] as String?,
      driverLastName: json['driverLastName'] as String?,
      userId: json['userId'] as String?,
      adminIgnore: json['adminIgnore'] as bool?,
      riderInfoId: json['riderInfoId'] == null
          ? null
          : RiderInfoId.fromJson(json['riderInfoId'] as Map<String, dynamic>),
      categoryId: json['categoryId'] as String?,
      pricingPerKm: json['pricingPerKm'] as int?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      birthDate: DateTime.tryParse(json['birthDate'].toString()),
      comfort: json['comfort'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      isApproved: json['isApproved'] as bool?,
      carTypeId: json['carTypeId'] as String?,
      subscriptionType: json['subscriptionType'] as String?,
      carModel: json['carModel'] as String?,
      driverPictureKey: json['driverPictureKey'] as String?,
      isSocketCategory: json['isSocketCategory'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'driverFirstName': driverFirstName,
        'driverLastName': driverLastName,
        'userId': userId,
        'adminIgnore': adminIgnore,
        'riderInfoId': riderInfoId?.toJson(),
        'categoryId': categoryId,
        'pricingPerKm': pricingPerKm,
        'city': city,
        'phone': phone,
        'comfort': comfort,
        'isDeleted': isDeleted,
        'isApproved': isApproved,
        'carTypeId': carTypeId,
        'subscriptionType': subscriptionType,
        'carModel': carModel,
        'driverPictureKey': driverPictureKey,
        'isSocketCategory': isSocketCategory,
      };
}
