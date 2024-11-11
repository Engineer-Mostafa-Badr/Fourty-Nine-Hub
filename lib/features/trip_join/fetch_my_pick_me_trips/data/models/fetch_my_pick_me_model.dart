class FetchMyPickMeModel {
  final bool status;
  final String message;
  final OrganizedTripsData data;

  FetchMyPickMeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FetchMyPickMeModel.fromJson(Map<String, dynamic> json) {
    return FetchMyPickMeModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: OrganizedTripsData.fromJson(json['data']?['organizedTrips'] ?? {}),
    );
  }
}

class OrganizedTripsData {
  final bool subscribedPremium;
  final int subscriptionEndDate;
  final TripsData trips;

  OrganizedTripsData({
    required this.subscribedPremium,
    required this.subscriptionEndDate,
    required this.trips,
  });

  factory OrganizedTripsData.fromJson(Map<String, dynamic> json) {
    return OrganizedTripsData(
      subscribedPremium: json['subscribedPremium'] ?? false,
      subscriptionEndDate: json['subscriptionEndDate'] ?? 0,
      trips: TripsData.fromJson(json['trips'] ?? {}),
    );
  }
}

class TripsData {
  final List<TripData> docs;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  TripsData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory TripsData.fromJson(Map<String, dynamic> json) {
    return TripsData(
      docs: json['docs'] != null
          ? List<TripData>.from(
              json['docs'].map((trip) => TripData.fromJson(trip)))
          : [],
      totalDocs: json['totalDocs'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      page: json['page'] ?? 0,
      pagingCounter: json['pagingCounter'] ?? 0,
      hasPrevPage: json['hasPrevPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
      prevPage: json['prevPage'],
      nextPage: json['nextPage'],
    );
  }
}

class TripData {
  final String id;
  final String userId;
  final String userEmail;
  final String firstName;
  final String userPhone;
  final String profilePictureUrl;
  final String categoryId;
  final String categoryNameAr;
  final String categoryNameEn;
  final String paymentMethods;
  final String fromEn;
  final String toEn;
  final String fromAr;
  final String toAr;
  final int distance;
  final int duration;
  final double price;
  final String phone;
  final int time;
  final String status;
  final int statusPriority;
  final int countRequests;
  final bool isRepeat;
  final String createdAt;
  final String updatedAt;

  TripData({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.firstName,
    required this.userPhone,
    required this.profilePictureUrl,
    required this.categoryId,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.paymentMethods,
    required this.fromEn,
    required this.toEn,
    required this.fromAr,
    required this.toAr,
    required this.distance,
    required this.duration,
    required this.price,
    required this.phone,
    required this.time,
    required this.status,
    required this.statusPriority,
    required this.countRequests,
    required this.isRepeat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      firstName: json['userId']?['firstName'] ?? '',
      id: json['_id'] ?? '',
      userId: json['userId']?['_id'] ?? '',
      userEmail: json['userId']?['email'] ?? '',
      userPhone: json['userId']?['phone'] ?? '',
      profilePictureUrl: json['userId']?['USER_PROFILE']?['profilePictureKey']
              ?['mediaKey'] ??
          '',
      categoryId: json['categoryId']?['_id'] ?? '',
      categoryNameAr: json['categoryId']?['nameAr'] ?? '',
      categoryNameEn: json['categoryId']?['nameEn'] ?? '',
      paymentMethods: json['categoryId']?['paymentMethods'] ?? '',
      fromEn: json['fromEn'] ?? '',
      toEn: json['toEn'] ?? '',
      fromAr: json['fromAr'] ?? '',
      toAr: json['toAr'] ?? '',
      distance: json['distance'] ?? 0,
      duration: json['duration'] ?? 0,
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
      phone: json['phone'] ?? '',
      time: json['time'] ?? 0,
      status: json['status'] ?? '',
      statusPriority: json['statusPriority'] ?? 0,
      countRequests: json['countRequests'] ?? 0,
      isRepeat: json['isRepeat'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
