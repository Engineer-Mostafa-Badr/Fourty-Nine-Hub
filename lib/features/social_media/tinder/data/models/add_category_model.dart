class AddCategoryModel {
  bool? success;
  Data? data;

  AddCategoryModel({this.success, this.data});

  AddCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
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
        ? new Favorite.fromJson(json['favorite'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.favorite != null) {
      data['favorite'] = this.favorite!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['user_id'] = this.userId;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
