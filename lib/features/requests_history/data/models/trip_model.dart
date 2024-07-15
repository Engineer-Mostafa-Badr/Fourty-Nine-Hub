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
      required super.passengers,
      required super.ended,
      required super.canceled});

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? json['_id'],
      fromCoordinates: json['startLocation']['coordinates'].cast<double>(),
      toCoordinates: json['targetLocation']['coordinates'].cast<double>(),
      fromAddress: json['from'] ?? json['fromTitle'],
      toAddress: json['to'] ?? json['toTitle'],
      price: json['price'],
      time: json['duration'],
      distance: json['distance'],
      started: json['started'] ?? false,
      ended: json['ended'] ?? false,
      canceled: json['canceled'] = false,
      passengers: json['passengers'] ?? 0,
      calls: json['calls'] != null
          ? (json['calls'] as List).map((e) => CallModel.fromJson(e)).toList()
          : [],
      offers: json['offers'] == null
          ? []
          : (json['offers'] as List)
              .map((e) => OfferModel.fromJson(e))
              .toList(),
      driver:
          json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      category: json['category'] == null
          ? null
          : SubCategoryModel.fromJson(json['category']),
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
