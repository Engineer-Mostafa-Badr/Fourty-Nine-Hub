class AdvertisePriceModel {
  bool? status;
  Data? data;

  AdvertisePriceModel({this.status, this.data});

  AdvertisePriceModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  int? advertisementPhotoPrice;
  int? advertisementPostPrice;
  int? advertisementPostAndPhotoPrice;
  int? advertisementReelPrice;

  Data(
      {this.sId,
        this.advertisementPhotoPrice,
        this.advertisementPostPrice,
        this.advertisementPostAndPhotoPrice,
        this.advertisementReelPrice});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    advertisementPhotoPrice = json['advertisementPhotoPrice'];
    advertisementPostPrice = json['advertisementPostPrice'];
    advertisementPostAndPhotoPrice = json['advertisementPostAndPhotoPrice'];
    advertisementReelPrice = json['advertisementReelPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['advertisementPhotoPrice'] = this.advertisementPhotoPrice;
    data['advertisementPostPrice'] = this.advertisementPostPrice;
    data['advertisementPostAndPhotoPrice'] =
        this.advertisementPostAndPhotoPrice;
    data['advertisementReelPrice'] = this.advertisementReelPrice;
    return data;
  }
}
