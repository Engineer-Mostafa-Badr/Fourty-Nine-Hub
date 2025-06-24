// Entities
class RequestTripJoinEntity {
  final int countOfUnreadRequests;
  final bool subscribedPremium;
  final String? subscriptionEndDate;
  final RequestsEntity requests;

  RequestTripJoinEntity({
    required this.countOfUnreadRequests,
    required this.subscribedPremium,
    this.subscriptionEndDate,
    required this.requests,
  });
}

class RequestsEntity {
  final List<RequestDocsEntity> docs;
  final int totalItems;
  final int limit;
  final int totalPages;
  final int page;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  RequestsEntity({
    required this.docs,
    required this.totalItems,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });
}

class RequestDocsEntity {
  final String id;
  final TripEntity trip;
  final UserIdEntity userId;
  final String phone;
  final String allowStatus;
  final bool read;

  RequestDocsEntity({
    required this.id,
    required this.trip,
    required this.userId,
    required this.phone,
    required this.allowStatus,
    required this.read,
  });
}

class TripEntity {
  final String id;
  final String fromAr;
  final String toAr;
  final String fromEn;
  final String toEn;
  final int passengers;
  final int price;
  final int time;
  final bool isRepeat;
  final String status;
  final int views;

  TripEntity({
    required this.id,
    required this.fromAr,
    required this.toAr,
    required this.fromEn,
    required this.toEn,
    required this.passengers,
    required this.price,
    required this.time,
    required this.isRepeat,
    required this.status,
    required this.views,
  });
}

class UserIdEntity {
  final String id;
  final String firstName;
  final String gender;

  UserIdEntity({
    required this.id,
    required this.firstName,
    required this.gender,
  });
}

// Models
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