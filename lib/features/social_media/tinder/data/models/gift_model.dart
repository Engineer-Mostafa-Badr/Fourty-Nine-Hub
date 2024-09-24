class GiftApi {
  bool? status;
  GiftsData? data;

  GiftApi({this.status, this.data});

  GiftApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? GiftsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['status'] = status;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class GiftsData {
  List<GiftData>? gifts;
  int? length;

  GiftsData({this.gifts, this.length});

  GiftsData.fromJson(Map<String, dynamic> json) {
    if (json['gifts'] != null) {
      gifts = <GiftData>[];
      json['gifts'].forEach((v) {
        gifts!.add(GiftData.fromJson(v));
      });
    }
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (gifts != null) {
      json['gifts'] = gifts!.map((v) => v.toJson()).toList();
    }
    json['length'] = length;
    return json;
  }
}

class GiftData {
  String? sId;
  String? nameAr;
  String? nameEn;
  int? value;
  String? picture;
  int? currentValue;
  int? maximumGoal;

  GiftData({
    this.sId,
    this.nameAr,
    this.nameEn,
    this.value,
    this.picture,
    this.currentValue = 0,
    this.maximumGoal = 100,
  });

  GiftData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nameAr = json['nameAr'];
    nameEn = json['nameEn'];
    value = json['value'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['_id'] = sId;
    json['nameAr'] = nameAr;
    json['nameEn'] = nameEn;
    json['value'] = value;
    json['picture'] = picture;
    return json;
  }

  GiftData copyWith({
    String? sId,
    String? nameAr,
    String? nameEn,
    int? value,
    String? picture,
    int? currentValue,
    int? maximumGoal,
  }) {
    return GiftData(
      sId: sId ?? this.sId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      value: value ?? this.value,
      picture: picture ?? this.picture,
      currentValue: currentValue ?? this.currentValue,
      maximumGoal: maximumGoal ?? this.maximumGoal,
    );
  }
}
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
//         data!.add(GiftData.fromJson(v));
//       });
//     }
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class GiftData {
//   String? sId;
//   String? nameAr;
//   String? nameEn;
//   int? value;
//   String? picture;
//   int? currentValue;
//   int? maximumGoal;
//   int? length;
//
//   GiftData({
//     this.sId,
//     this.nameAr,
//     this.nameEn,
//     this.value,
//     this.picture,
//     this.currentValue = 0,
//     this.maximumGoal = 100,
//     this.length,
//   });
//
//   GiftData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     nameAr = json['nameAr'];
//     nameEn = json['nameEn'];
//     value = json['value'];
//     picture = json['picture'];
//     // length = json['length'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['nameAr'] = nameAr;
//     data['nameEn'] = nameEn;
//     data['value'] = value;
//     data['picture'] = picture;
//     return data;
//   }
//   GiftData copyWith({
//     String? sId,
//     String? nameAr,
//     String? nameEn,
//     int? value,
//     String? picture,
//     int? currentValue,
//     int? maximumGoal,
//   }) {
//     return GiftData(
//       sId: sId ?? this.sId,
//       nameAr: nameAr ?? this.nameAr,
//       nameEn: nameEn ?? this.nameEn,
//       value: value ?? this.value,
//       picture: picture ?? this.picture,
//       currentValue: currentValue ?? this.currentValue,
//       maximumGoal: maximumGoal ?? this.maximumGoal,
//     );
//   }
//   static int calculateLength(List<GiftData> gifts) {
//     return gifts.length;
//   }
// }
