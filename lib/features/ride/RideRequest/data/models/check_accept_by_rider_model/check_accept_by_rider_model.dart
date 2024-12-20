// import 'rider_location.dart';
// import 'start_location.dart';
// import 'target_location.dart';
// import 'user_location.dart';

// class CheckAcceptByRiderModel {
//   StartLocation? startLocation;
//   TargetLocation? targetLocation;
//   String? id;
//   String? userId;
//   dynamic riderId;
//   String? subCategoryId;
//   dynamic carTypeId;
//   String? fromTitle;
//   String? toTitle;
//   int? profit;
//   bool? autoAccept;
//   bool? isPremium;
//   UserLocation? userLocation;
//   RiderLocation? riderLocation;
//   int? distance;
//   int? duration;
//   int? passengers;
//   int? price;
//   int? calculateB;
//   String? paymentMethod;
//   String? status;
//   int? penalty;
//   bool? payedPenalty;
//   bool? isUserGetCashback;
//   bool? isRiderGetCashback;
//   String? otp;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   CheckAcceptByRiderModel({
//     this.startLocation,
//     this.targetLocation,
//     this.id,
//     this.userId,
//     this.riderId,
//     this.subCategoryId,
//     this.carTypeId,
//     this.fromTitle,
//     this.toTitle,
//     this.profit,
//     this.autoAccept,
//     this.isPremium,
//     this.userLocation,
//     this.riderLocation,
//     this.distance,
//     this.duration,
//     this.passengers,
//     this.price,
//     this.calculateB,
//     this.paymentMethod,
//     this.status,
//     this.penalty,
//     this.payedPenalty,
//     this.isUserGetCashback,
//     this.isRiderGetCashback,
//     this.otp,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory CheckAcceptByRiderModel.fromJson(Map<String, dynamic> json) {
//     return CheckAcceptByRiderModel(
//       startLocation: json['startLocation'] == null
//           ? null
//           : StartLocation.fromJson(
//               json['startLocation'] as Map<String, dynamic>),
//       targetLocation: json['targetLocation'] == null
//           ? null
//           : TargetLocation.fromJson(
//               json['targetLocation'] as Map<String, dynamic>),
//       id: json['_id'] as String?,
//       userId: json['userId'] as String?,
//       riderId: json['riderId'] as dynamic,
//       subCategoryId: json['subCategoryId'] as String?,
//       carTypeId: json['carTypeId'] as dynamic,
//       fromTitle: json['fromTitle'] as String?,
//       toTitle: json['toTitle'] as String?,
//       profit: json['profit'] as int?,
//       autoAccept: json['autoAccept'] as bool?,
//       isPremium: json['isPremium'] as bool?,
//       userLocation: json['userLocation'] == null
//           ? null
//           : UserLocation.fromJson(json['userLocation'] as Map<String, dynamic>),
//       riderLocation: json['riderLocation'] == null
//           ? null
//           : RiderLocation.fromJson(
//               json['riderLocation'] as Map<String, dynamic>),
//       distance: json['distance'] as int?,
//       duration: json['duration'] as int?,
//       passengers: json['passengers'] as int?,
//       price: json['price'] as int?,
//       calculateB: json['calculateB'] as int?,
//       paymentMethod: json['paymentMethod'] as String?,
//       status: json['status'] as String?,
//       penalty: json['penalty'] as int?,
//       payedPenalty: json['payed_penalty'] as bool?,
//       isUserGetCashback: json['isUserGetCashback'] as bool?,
//       isRiderGetCashback: json['isRiderGetCashback'] as bool?,
//       otp: json['OTP'] as String?,
//       createdAt: json['createdAt'] == null
//           ? null
//           : DateTime.parse(json['createdAt'] as String),
//       updatedAt: json['updatedAt'] == null
//           ? null
//           : DateTime.parse(json['updatedAt'] as String),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'startLocation': startLocation?.toJson(),
//         'targetLocation': targetLocation?.toJson(),
//         '_id': id,
//         'userId': userId,
//         'riderId': riderId,
//         'subCategoryId': subCategoryId,
//         'carTypeId': carTypeId,
//         'fromTitle': fromTitle,
//         'toTitle': toTitle,
//         'profit': profit,
//         'autoAccept': autoAccept,
//         'isPremium': isPremium,
//         'userLocation': userLocation?.toJson(),
//         'riderLocation': riderLocation?.toJson(),
//         'distance': distance,
//         'duration': duration,
//         'passengers': passengers,
//         'price': price,
//         'calculateB': calculateB,
//         'paymentMethod': paymentMethod,
//         'status': status,
//         'penalty': penalty,
//         'payed_penalty': payedPenalty,
//         'isUserGetCashback': isUserGetCashback,
//         'isRiderGetCashback': isRiderGetCashback,
//         'OTP': otp,
//         'createdAt': createdAt?.toIso8601String(),
//         'updatedAt': updatedAt?.toIso8601String(),
//       };
// }
class Location {
  String type;
  List<double>? coordinates;

  Location({required this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String,
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

class CheckAcceptByRiderModel {
  Location? startLocation;
  Location? targetLocation;
  String? id;
  String? userId;
  dynamic riderId;
  String? subCategoryId;
  dynamic carTypeId;
  String? fromTitle;
  String? toTitle;
  int? profit;
  bool? autoAccept;
  bool? isPremium;
  int? distance;
  int? duration;
  int? passengers;
  double? price;
  int? calculateB;
  String? paymentMethod;
  String? status;
  int? penalty;
  bool? payedPenalty;
  bool? isUserGetCashback;
  bool? isRiderGetCashback;
  String? otp;
  DateTime? createdAt;
  DateTime? updatedAt;

  CheckAcceptByRiderModel({
    this.startLocation,
    this.targetLocation,
    this.id,
    this.userId,
    this.riderId,
    this.subCategoryId,
    this.carTypeId,
    this.fromTitle,
    this.toTitle,
    this.profit,
    this.autoAccept,
    this.isPremium,
    this.distance,
    this.duration,
    this.passengers,
    this.price,
    this.calculateB,
    this.paymentMethod,
    this.status,
    this.penalty,
    this.payedPenalty,
    this.isUserGetCashback,
    this.isRiderGetCashback,
    this.otp,
    this.createdAt,
    this.updatedAt,
  });

  factory CheckAcceptByRiderModel.fromJson(Map<String, dynamic> json) {
    return CheckAcceptByRiderModel(
      startLocation: json['startLocation'] == null
          ? null
          : Location.fromJson(json['startLocation']),
      targetLocation: json['targetLocation'] == null
          ? null
          : Location.fromJson(json['targetLocation']),
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      riderId: json['riderId'],
      subCategoryId: json['subCategoryId'] as String?,
      carTypeId: json['carTypeId'],
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      profit: json['profit'] as int?,
      autoAccept: json['autoAccept'] as bool?,
      isPremium: json['isPremium'] as bool?,
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      passengers: json['passengers'] as int?,
      price: double.parse(json['price'].toString()),
      calculateB: json['calculateB'] as int?,
      paymentMethod: json['paymentMethod'] as String?,
      status: (json['status'].toString()) as String?,
      penalty: json['penalty'] as int?,
      payedPenalty: json['payed_penalty'] as bool?,
      isUserGetCashback: json['isUserGetCashback'] as bool?,
      isRiderGetCashback: json['isRiderGetCashback'] as bool?,
      otp: json['OTP'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'startLocation': startLocation?.toJson(),
        'targetLocation': targetLocation?.toJson(),
        '_id': id,
        'userId': userId,
        'riderId': riderId,
        'subCategoryId': subCategoryId,
        'carTypeId': carTypeId,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'profit': profit,
        'autoAccept': autoAccept,
        'isPremium': isPremium,
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'calculateB': calculateB,
        'paymentMethod': paymentMethod,
        'status': status,
        'penalty': penalty,
        'payed_penalty': payedPenalty,
        'isUserGetCashback': isUserGetCashback,
        'isRiderGetCashback': isRiderGetCashback,
        'OTP': otp,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
