import 'package:fourtyninehub/features/requests_history/data/models/call_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/driver_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/offer_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/shipping_request_entity.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

class ShippingRequestModel extends ShippingRequestEntity {
  ShippingRequestModel(
      {required super.id,
      required super.fromCoordinates,
      required super.toCoordinates,
      required super.fromAddress,
      required super.toAddress,
      required super.price,
      required super.time,
      required super.distance,
      required super.started,
      required super.ended,
      required super.canceled,
      required super.calls,
      required super.offers,
      required super.driver,
      required super.category,
      required super.moreFromAddressDetails,
      required super.moreToAddressDetails,
      required super.receiverPhone,
      required super.senderPhone});
  factory ShippingRequestModel.fromJson(Map<String, dynamic> json) {
    return ShippingRequestModel(
      id: json['id'],
      fromCoordinates: json['from_coordinates'].cast<double>(),
      toCoordinates: json['to_coordinates'].cast<double>(),
      fromAddress: json['from_address'],
      toAddress: json['to_address'],
      price: json['price'],
      time: json['time'],
      distance: json['distance'],
      started: json['started'],
      ended: json['ended'],
      canceled: json['canceled'] = false,
      calls: json['calls'] != null
          ? (json['calls'] as List).map((e) => CallModel.fromJson(e)).toList()
          : [],
      offers:
          (json['offers'] as List).map((e) => OfferModel.fromJson(e)).toList(),
      driver:
          json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      category: SubCategoryModel.fromJson(json['category']),
      moreFromAddressDetails: json['more_from_address_details'],
      moreToAddressDetails: json['more_to_address_details'],
      senderPhone: json['sender_phone'],
      receiverPhone: json['receiver_phone'],
    );
  }
}
