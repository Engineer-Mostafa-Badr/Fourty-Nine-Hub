import 'package:fourtyninehub/features/requests_history/data/models/call_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/offer_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

import 'driver_model.dart';

class TripModel extends TripEntity {
  TripModel(
      {required super.id,
      required super.fromCoordinates,
      required super.toCoordinates,
      required super.fromAddress,
      required super.toAddress,
      required super.price,
      required super.time,
      required super.distance,
      required super.calls,
      required super.offers,
      required super.driver,
      required super.category,
      required super.started,
      required super.ended,
      required super.canceled});

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
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
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_coordinates'] = fromCoordinates;
    data['to_coordinates'] = toCoordinates;
    data['from_address'] = fromAddress;
    data['to_address'] = toAddress;
    data['price'] = price;
    data['time'] = time;
    data['distance'] = distance;
    if (calls != null) {
      data['calls'] = calls!.map((v) => v.toJson()).toList();
    }
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}
