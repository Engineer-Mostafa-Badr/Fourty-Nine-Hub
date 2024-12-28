import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'driver_model.dart';

class RequestHistoryRideModel {
  final String? id;
  final List<double>? fromCoordinates;
  final List<double>? toCoordinates;
  final String? fromAddress;
  final String? toAddress;
  final int? price;
  final int? time;
  final int? distance;
  final bool? started;
  final bool? ended;
  final bool? canceled;
  final String? currencyEn;
  final String? currencyAr;
  final int? duration;
  final DriverModel? driver;
  final SubCategoryModel? category;
  final String? userId;
  final String? carModelSocket;
  final String? carModelNoSocket;
  final String? plateInfoSocket;
  final String? platInfoNoSocket;
  final String? riderId;
  final String? subCategoryId;
  final String? carTypeId;
  final String? otp;
  final bool? isPremium;
  final bool? autoAccept;
  final bool? isUserGetCashback;
  final bool? isRiderGetCashback;
  final bool? payedPenalty;
  final int? penalty;
  final bool? freeTripForDriver;
  final String? createdAt;
  final String? updatedAt;
  final String? startTime;
  final String? socketDriverImage;
  final String? noSocketDriverImage;
  final String? socketfirstName;
  final String? noSocketfirstName;
  final String? socketLastName;
  final String? noSocketLastName;
  RequestHistoryRideModel({
    this.id,
    this.fromCoordinates,
    this.toCoordinates,
    this.fromAddress,
    this.noSocketfirstName,
    this.socketfirstName,
    this.carModelNoSocket,
    this.carModelSocket,
    this.platInfoNoSocket,
    this.plateInfoSocket,
    this.socketLastName,
    this.noSocketLastName,
    this.noSocketDriverImage,
    this.socketDriverImage,
    this.currencyAr,
    this.currencyEn,
    this.toAddress,
    this.price,
    this.time,
    this.duration,
    this.distance,
    this.started,
    this.ended,
    this.canceled,
    this.driver,
    this.category,
    this.userId,
    this.riderId,
    this.subCategoryId,
    this.carTypeId,
    this.otp,
    this.isPremium,
    this.autoAccept,
    this.isUserGetCashback,
    this.isRiderGetCashback,
    this.payedPenalty,
    this.penalty,
    this.freeTripForDriver,
    this.createdAt,
    this.updatedAt,
    this.startTime,
  });

  factory RequestHistoryRideModel.fromJson(Map<String, dynamic> json) {
    return RequestHistoryRideModel(
      id: json['_id'] ?? json['id'],
      currencyAr: json['currencyAr'],
      currencyEn: json['currencyEn'],
      socketDriverImage: json['riderId']?['userId']['USER_PROFILE']
          ['profilePictureKey']['mediaKey'],
      noSocketDriverImage: json['driverId']?['userId']['USER_PROFILE']
          ['profilePictureKey']['mediaKey'],
      fromCoordinates: json['startLocation']?['coordinates']?.cast<double>(),
      toCoordinates: json['targetLocation']?['coordinates']?.cast<double>(),
      fromAddress: json['fromTitle'],
      toAddress: json['toTitle'],
      carModelNoSocket: json['driverId']?['carModel'],
      carModelSocket: json['riderId']?['carModel'],
      platInfoNoSocket: json['driverId']?['riderInfoId']['plateInfo'],
      plateInfoSocket: json['riderId']?['riderInfoId']['plateInfo'],
      duration: json['duration'],
      socketfirstName: json['riderId']?['userId']['firstName'],
      socketLastName: json['riderId']?['userId']['lastName'],
      noSocketfirstName: json['driverId']?['userId']['firstName'],
      noSocketLastName: json['driverId']?['userId']['lastName'],
      price: json['price'],
      time: json['duration'],
      distance: json['distance'],
      started: json['status'] == 'in_progress' ? true : null,
      ended: json['status'] == 'completed' ? true : null,
      canceled: json['status'] == 'canceled' ? true : null,
      driver:
          json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      category: json['subCategoryId'] != null
          ? SubCategoryModel.fromJson(json['subCategoryId'])
          : null,
      userId: json['userId']?['_id'],
      riderId: json['riderId']?['_id'],
      subCategoryId: json['subCategoryId']?['_id'],
      carTypeId: json['carTypeId'],
      otp: json['OTP'],
      isPremium: json['isPremium'],
      autoAccept: json['autoAccept'],
      isUserGetCashback: json['isUserGetCashback'],
      isRiderGetCashback: json['isRiderGetCashback'],
      payedPenalty: json['payed_penalty'],
      penalty: json['penalty'],
      freeTripForDriver: json['freeTripForDriver'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      startTime: json['startTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (fromCoordinates != null) {
      data['startLocation'] = {'coordinates': fromCoordinates};
    }
    if (toCoordinates != null) {
      data['targetLocation'] = {'coordinates': toCoordinates};
    }
    data['fromTitle'] = fromAddress;
    data['toTitle'] = toAddress;
    data['price'] = price;
    data['duration'] = time;
    data['distance'] = distance;
    data['status'] = ended == true
        ? 'completed'
        : (started == true ? 'in_progress' : 'not_started');

    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (category != null) {
      data['subCategoryId'] = category!.toJson();
    }
    if (userId != null) {
      data['userId'] = {'_id': userId};
    }
    if (riderId != null) {
      data['riderId'] = {'_id': riderId};
    }
    if (subCategoryId != null) {
      data['subCategoryId'] = {'_id': subCategoryId};
    }
    data['carTypeId'] = carTypeId;
    data['OTP'] = otp;
    data['isPremium'] = isPremium;
    data['autoAccept'] = autoAccept;
    data['isUserGetCashback'] = isUserGetCashback;
    data['isRiderGetCashback'] = isRiderGetCashback;
    data['payed_penalty'] = payedPenalty;
    data['penalty'] = penalty;
    data['freeTripForDriver'] = freeTripForDriver;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['startTime'] = startTime;
    return data;
  }
}
