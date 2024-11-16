class GetLatAndLongModel {
  final bool status;
  final LatLongData data;

  GetLatAndLongModel({required this.status, required this.data});

  factory GetLatAndLongModel.fromJson(Map<String, dynamic> json) {
    return GetLatAndLongModel(
      status: json['status'],
      data: LatLongData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class LatLongData {
  final double lat;
  final double lng;
  final String address;
  final String type;

  LatLongData({
    required this.lat,
    required this.lng,
    required this.address,
    required this.type,
  });

  factory LatLongData.fromJson(Map<String, dynamic> json) {
    return LatLongData(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      address: json['address'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      'type': type,
    };
  }
}
