class NearByModel {
  bool? status;
  Data? data;

  NearByModel({this.status, this.data});

  NearByModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isNearBy;

  Data({this.isNearBy});

  Data.fromJson(Map<String, dynamic> json) {
    isNearBy = json['isNearBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNearBy'] = this.isNearBy;
    return data;
  }
}
