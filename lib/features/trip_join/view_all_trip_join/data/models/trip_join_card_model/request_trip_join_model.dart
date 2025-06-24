
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/request_trip_join_entity.dart';

class RequestTripJoinModel extends RequestTripJoinEntity {
  RequestTripJoinModel({
    required int countOfUnreadRequests,
    required bool subscribedPremium,
    String? subscriptionEndDate,
    required RequestsModel requests,
  }) : super(
    countOfUnreadRequests: countOfUnreadRequests,
    subscribedPremium: subscribedPremium,
    subscriptionEndDate: subscriptionEndDate,
    requests: requests,
  );

  factory RequestTripJoinModel.fromJson(Map<String, dynamic> json) {
    return RequestTripJoinModel(
      countOfUnreadRequests: json['data']['countOfUnreadRequests'] ?? 0,
      subscribedPremium: json['data']['subscribedPremium'] ?? false,
      subscriptionEndDate: json['data']['subscriptionEndDate'],
      requests: RequestsModel.fromJson(json['data']),
    );
  }
}

class RequestsModel extends RequestsEntity {
  RequestsModel({
    required List<RequestDocsModel> docs,
    required int totalItems,
    required int limit,
    required int totalPages,
    required int page,
    required bool hasPrevPage,
    required bool hasNextPage,
    int? prevPage,
    int? nextPage,
  }) : super(
    docs: docs,
    totalItems: totalItems,
    limit: limit,
    totalPages: totalPages,
    page: page,
    hasPrevPage: hasPrevPage,
    hasNextPage: hasNextPage,
    prevPage: prevPage,
    nextPage: nextPage,
  );

  factory RequestsModel.fromJson(Map<String, dynamic> json) {
    final requestList = (json['requests'] as List<dynamic>)
        .map((e) => RequestDocsModel.fromJson(e))
        .toList();

    final pagination = json['pagination'];

    return RequestsModel(
      docs: requestList,
      totalItems: pagination['totalItems'] ?? 0,
      limit: pagination['limit'] ?? 0,
      totalPages: pagination['totalPages'] ?? 0,
      page: pagination['page'] ?? 0,
      hasPrevPage: pagination['hasPrevPage'] ?? false,
      hasNextPage: pagination['hasNextPage'] ?? false,
      prevPage: pagination['prevPage'],
      nextPage: pagination['nextPage'],
    );
  }
}

class RequestDocsModel extends RequestDocsEntity {
  RequestDocsModel({
    required String id,
    required TripModel trip,
    required UserIdModel userId,
    required String phone,
    required String allowStatus,
    required bool read,
  }) : super(
    id: id,
    trip: trip,
    userId: userId,
    phone: phone,
    allowStatus: allowStatus,
    read: read,
  );

  factory RequestDocsModel.fromJson(Map<String, dynamic> json) {
    return RequestDocsModel(
      id: json['_id'] ?? '',
      trip: TripModel.fromJson(json['trip']),
      userId: UserIdModel.fromJson(json['userId']),
      phone: json['phone'] ?? '',
      allowStatus: json['allowStatus'] ?? '',
      read: json['read'] ?? false,
    );
  }
}

class TripModel extends TripEntity {
  TripModel({
    required String id,
    required String fromAr,
    required String toAr,
    required String fromEn,
    required String toEn,
    required int passengers,
    required int price,
    required int time,
    required bool isRepeat,
    required String status,
    required int views,
  }) : super(
    id: id,
    fromAr: fromAr,
    toAr: toAr,
    fromEn: fromEn,
    toEn: toEn,
    passengers: passengers,
    price: price,
    time: time,
    isRepeat: isRepeat,
    status: status,
    views: views,
  );

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['_id'] ?? '',
      fromAr: json['fromAr'] ?? '',
      toAr: json['toAr'] ?? '',
      fromEn: json['fromEn'] ?? '',
      toEn: json['toEn'] ?? '',
      status: json['status'] ?? '',
      passengers: json['passengers'] ?? 0,
      price: json['price'] ?? 0,
      time: json['time'] ?? 0,
      isRepeat: json['isRepeat'] ?? false,
      views: json['views'] ?? 0,
    );
  }
}

class UserIdModel extends UserIdEntity {
  UserIdModel({
    required String id,
    required String firstName,
    required String gender,
  }) : super(
    id: id,
    firstName: firstName,
    gender: gender,
  );

  factory UserIdModel.fromJson(Map<String, dynamic> json) {
    return UserIdModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}