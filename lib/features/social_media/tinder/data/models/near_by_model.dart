class NearByModel {
  bool? status;
  Data? data;

  NearByModel({this.status, this.data});

  factory NearByModel.fromJson(Map<String, dynamic> json) {
    return NearByModel(
      status: json['status'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isNearBy;

  Data({this.isNearBy});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      isNearBy: json['isNearBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isNearBy'] = isNearBy;
    return data;
  }
}
