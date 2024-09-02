import 'dart:convert';

import 'location.dart';
import 'viewport.dart';

class Geometry {
  Location? location;
  String? locationType;
  Viewport? viewport;

  Geometry({this.location, this.locationType, this.viewport});

  @override
  String toString() {
    return 'Geometry(location: $location, locationType: $locationType, viewport: $viewport)';
  }

  factory Geometry.fromMap(Map<String, dynamic> data) => Geometry(
        location: data['location'] == null
            ? null
            : Location.fromMap(data['location'] as Map<String, dynamic>),
        locationType: data['location_type'] as String?,
        viewport: data['viewport'] == null
            ? null
            : Viewport.fromMap(data['viewport'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'location': location?.toMap(),
        'location_type': locationType,
        'viewport': viewport?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Geometry].
  factory Geometry.fromJson(String data) {
    return Geometry.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Geometry] to a JSON string.
  String toJson() => json.encode(toMap());
}
