class MapBoxSearchModel {
  List<double>? coordinates;

  MapBoxSearchModel({this.coordinates});
  factory MapBoxSearchModel.fromJson(Map<String, dynamic> json) {
    return MapBoxSearchModel(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map<double>((e) => e.toDouble())
          .toList(),
    );
  }
  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
      };
}
