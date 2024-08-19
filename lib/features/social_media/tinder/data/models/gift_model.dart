// class GiftApi {
//   bool? status;
//   List<GiftData>? data;
//
//   GiftApi({this.status, this.data});
//
//   GiftApi.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['data'] != null) {
//       data = <GiftData>[];
//       json['data'].forEach((v) {
//         data!.add(new GiftData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class GiftData {
//   String? sId;
//   String? picture;
//   int? value;
//   String? createdAt;
//   String? updatedAt;
//   String? nameAr;
//   String? nameEn;
//
//   GiftData(
//       {this.sId,
//         this.picture,
//         this.value,
//         this.createdAt,
//         this.updatedAt,
//         this.nameAr,
//         this.nameEn});
//
//   GiftData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     picture = json['picture'];
//     value = json['value'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     nameAr = json['nameAr'];
//     nameEn = json['nameEn'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['picture'] = this.picture;
//     data['value'] = this.value;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['nameAr'] = this.nameAr;
//     data['nameEn'] = this.nameEn;
//     return data;
//   }
// }

class GiftApi {
  bool? status;
  List<GiftData>? data;

  GiftApi({this.status, this.data});

  GiftApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GiftData>[];
      json['data'].forEach((v) {
        data!.add(new GiftData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GiftData {
  String? sId;
  String? nameAr;
  String? nameEn;
  int? value;
  String? picture;

  GiftData({this.sId, this.nameAr, this.nameEn, this.value, this.picture});

  GiftData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nameAr = json['nameAr'];
    nameEn = json['nameEn'];
    value = json['value'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['nameAr'] = this.nameAr;
    data['nameEn'] = this.nameEn;
    data['value'] = this.value;
    data['picture'] = this.picture;
    return data;
  }
}
