class AddCategoryModel {
  bool? success;
  Data? data;

  AddCategoryModel({this.success, this.data});

  AddCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Favorite? favorite;

  Data({this.favorite});

  Data.fromJson(Map<String, dynamic> json) {
    favorite = json['favorite'] != null
        ? Favorite.fromJson(json['favorite'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (favorite != null) {
      data['favorite'] = favorite!.toJson();
    }
    return data;
  }
}

class Favorite {
  String? categoryId;
  String? userId;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Favorite(
      {this.categoryId, this.userId, this.sId, this.createdAt, this.updatedAt});

  Favorite.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    userId = json['user_id'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
