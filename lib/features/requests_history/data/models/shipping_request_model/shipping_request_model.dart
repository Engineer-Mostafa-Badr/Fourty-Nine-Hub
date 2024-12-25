class ShippingRequestModel {
  final String id;
  final List<double> fromCoordinates;
  final List<double> toCoordinates;
  final String fromAddress;
  final String toAddress;
  final int price;
  final String time;
  final String status;
  final bool isPremium;
  final String phone;
  final String createdAt;
  final String updatedAt;
  final String currencyEn;
  final String currencyAr;
  final String distance;
  final bool started;
  final bool ended;
  final bool canceled;
  final List calls;
  final List offers;
  final dynamic driver; // This could be a custom model like DriverModel
  final dynamic category; // This could be a custom model like CategoryModel
  final String moreFromAddressDetails;
  final String moreToAddressDetails;
  final String receiverPhone;
  final String senderPhone;

  ShippingRequestModel({
    required this.id,
    required this.fromCoordinates,
    required this.toCoordinates,
    required this.fromAddress,
    required this.toAddress,
    required this.price,
    required this.time,
    required this.status,
    required this.isPremium,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.currencyEn,
    required this.currencyAr,
    required this.distance,
    required this.started,
    required this.ended,
    required this.canceled,
    required this.calls,
    required this.offers,
    required this.driver,
    required this.category,
    required this.moreFromAddressDetails,
    required this.moreToAddressDetails,
    required this.receiverPhone,
    required this.senderPhone,
  });

  factory ShippingRequestModel.fromJson(Map<String, dynamic> json) {
    return ShippingRequestModel(
      id: json['_id'] ?? '', // Fallback to empty string
      fromCoordinates: json['from_coordinates']?.cast<double>() ?? [],
      toCoordinates: json['to_coordinates']?.cast<double>() ?? [],
      fromAddress: json['startLocation'] ?? '',
      toAddress: json['targetLocation'] ?? '',
      price: (json['price'] is int)
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0, // Safely parse as int
      time: json['time'] ?? '',
      status: json['status'] ?? '',
      isPremium: json['isPremium'] ?? false,
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      currencyEn: json['currency']['currencyEn'] ?? '',
      currencyAr: json['currency']['currencyAr'] ?? '',
      distance: json['desc'] ?? '', // Replace with appropriate field
      started: json['started'] ?? false,
      ended: json['ended'] ?? false,
      canceled: json['canceled'] ?? false,
      calls: json['driverRatingsVirtual'] ??
          [], // Assuming no need for actual data
      offers: json['offers'] ?? [],
      driver: json['driverId'], // Can be parsed as DriverModel if necessary
      category:
          json['categoryId'], // Can be parsed as CategoryModel if necessary
      moreFromAddressDetails: '',
      moreToAddressDetails: '',
      receiverPhone: '',
      senderPhone: json['phone'] ?? '',
    );
  }
}
