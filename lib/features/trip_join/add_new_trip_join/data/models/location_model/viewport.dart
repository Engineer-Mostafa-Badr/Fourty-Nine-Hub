import 'dart:convert';

import 'northeast.dart';
import 'southwest.dart';

class Viewport {
  Northeast? northeast;
  Southwest? southwest;

  Viewport({this.northeast, this.southwest});

  @override
  String toString() {
    return 'Viewport(northeast: $northeast, southwest: $southwest)';
  }

  factory Viewport.fromMap(Map<String, dynamic> data) => Viewport(
        northeast: data['northeast'] == null
            ? null
            : Northeast.fromMap(data['northeast'] as Map<String, dynamic>),
        southwest: data['southwest'] == null
            ? null
            : Southwest.fromMap(data['southwest'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'northeast': northeast?.toMap(),
        'southwest': southwest?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Viewport].
  factory Viewport.fromJson(String data) {
    return Viewport.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Viewport] to a JSON string.
  String toJson() => json.encode(toMap());
}
