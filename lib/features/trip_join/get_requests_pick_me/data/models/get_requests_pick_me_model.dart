class GetRequestsPickMeModel {
  final bool? status;
  final String? message;
  final List<TripDataWithRequests>? requests;
  final bool? subscriptionPremium;
  final bool? subscriptionRegular;
  final int? endPremium;
  final int? endRegular;

  GetRequestsPickMeModel({
    this.status,
    this.message,
    this.requests,
    this.subscriptionPremium,
    this.subscriptionRegular,
    this.endPremium,
    this.endRegular,
  });

  factory GetRequestsPickMeModel.fromJson(Map<String, dynamic> json) {
    return GetRequestsPickMeModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      requests: (json['data']['requests'] as List?)
          ?.map((tripData) => TripDataWithRequests.fromJson(tripData))
          .toList(),
      subscriptionPremium: json['data']['subscriptionPremium'] as bool?,
      subscriptionRegular: json['data']['subscriptionRegular'] as bool?,
      endPremium: json['data']['endPremium'] as int?,
      endRegular: json['data']['endRegular'] as int?,
    );
  }
}

class TripDataWithRequests {
  final Trip? trip;
  final List<PickMeRequest>? requests;

  TripDataWithRequests({
    this.trip,
    this.requests,
  });

  factory TripDataWithRequests.fromJson(Map<String, dynamic> json) {
    return TripDataWithRequests(
      trip: json['trip'] != null ? Trip.fromJson(json['trip']) : null,
      requests: (json['requests'] as List?)
          ?.map((request) => PickMeRequest.fromJson(request))
          .toList(),
    );
  }
}

class Trip {
  final String? id;
  final String? userId;
  final String? categoryId;
  final String? fromEn;
  final String? toEn;
  final String? fromAr;
  final String? toAr;
  final int? distance;
  final int? duration;
  final double? price;
  final String? phone;
  final int? time;
  final String? status;
  final int? statusPriority;
  final int? countRequests;
  final bool? isRepeat;
  final String? createdAt;
  final String? updatedAt;

  Trip({
    this.id,
    this.userId,
    this.categoryId,
    this.fromEn,
    this.toEn,
    this.fromAr,
    this.toAr,
    this.distance,
    this.duration,
    this.price,
    this.phone,
    this.time,
    this.status,
    this.statusPriority,
    this.countRequests,
    this.isRepeat,
    this.createdAt,
    this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      fromEn: json['fromEn'] as String?,
      toEn: json['toEn'] as String?,
      fromAr: json['fromAr'] as String?,
      toAr: json['toAr'] as String?,
      distance: json['distance'] as int?,
      duration: json['duration'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      time: json['time'] as int?,
      status: json['status'] as String?,
      statusPriority: json['statusPriority'] as int?,
      countRequests: json['countRequests'] as int?,
      isRepeat: json['isRepeat'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

class PickMeRequest {
  final String? id;
  final String? userId;
  final String? tripId;
  final String? phone;
  final bool? isPremium;
  final String? createdAt;
  final String? updatedAt;
  final String? firstName;
  final String? gender;
  PickMeRequest({
    this.gender,
    this.firstName,
    this.id,
    this.userId,
    this.tripId,
    this.phone,
    this.isPremium,
    this.createdAt,
    this.updatedAt,
  });

  factory PickMeRequest.fromJson(Map<String, dynamic> json) {
    return PickMeRequest(
      id: json['_id'] as String?,
      firstName: json['userId']?['firstName'] as String?,
      userId: json['userId']?['_id'] as String?,
      tripId: json['trip'] as String?,
      phone: json['phone'] as String?,
      isPremium: json['isPremium'] as bool?,
      createdAt: json['createdAt'] as String?,
      gender: json['gender'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
