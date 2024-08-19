import 'dart:convert';

import 'package:fourtyninehub/features/trip_join/domain/entities/location_entity.dart';

import 'address_component.dart';
import 'geometry.dart';

class LocationModel extends LocationEntity {
  List<AddressComponent>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  bool? partialMatch;
  String? placeId;
  List<dynamic>? types;

  LocationModel({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.partialMatch,
    this.placeId,
    this.types,
  }) : super(
          id: placeId,
          coordinates: [geometry?.location?.lat, geometry?.location?.lng],
          address: formattedAddress,
        );

  @override
  String toString() {
    return 'LocationModel(addressComponents: $addressComponents, formattedAddress: $formattedAddress, geometry: $geometry, partialMatch: $partialMatch, placeId: $placeId, types: $types)';
  }

  factory LocationModel.fromMap(Map<String, dynamic> data) => LocationModel(
        addressComponents: (data['address_components'] as List<dynamic>?)
            ?.map((e) => AddressComponent.fromMap(e as Map<String, dynamic>))
            .toList(),
        formattedAddress: data['formatted_address'] as String?,
        geometry: data['geometry'] == null ? null : Geometry.fromMap(data['geometry'] as Map<String, dynamic>),
        partialMatch: data['partial_match'] as bool?,
        placeId: data['place_id'] as String?,
        types: data['types'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'address_components': addressComponents?.map((e) => e.toMap()).toList(),
        'formatted_address': formattedAddress,
        'geometry': geometry?.toMap(),
        'partial_match': partialMatch,
        'place_id': placeId,
        'types': types,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LocationModel].
  factory LocationModel.fromJson(String data) {
    return LocationModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LocationModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
