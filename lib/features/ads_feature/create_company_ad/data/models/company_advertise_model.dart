class AdvertiseCompanyModel {
  bool? status;
  Data? data;

  AdvertiseCompanyModel({this.status, this.data});

  AdvertiseCompanyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Advertises>? advertises;
  Pagination? pagination;

  Data({this.advertises, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['advertises'] != null) {
      advertises = [];
      json['advertises'].forEach((v) {
        advertises!.add(Advertises.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.advertises != null) {
      data['advertises'] = this.advertises!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Advertises {
  String? sId;
  UserId? userId;
  List<dynamic>? media;
  List<dynamic>? views;
  String? advertisementType;
  String? post;
  int? totalPrice;
  bool? isApproved;
  dynamic endAt;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? viewCount;
  String? description;

  Advertises(
      {this.sId,
        this.userId,
        this.media,
        this.views,
        this.advertisementType,
        this.post,
        this.totalPrice,
        this.isApproved,
        this.endAt,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.viewCount,
        this.description});

  Advertises.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    media = json['media'];
    views = json['views'];
    advertisementType = json['advertisement_type'];
    post = json['post'];
    totalPrice = json['totalPrice'];
    isApproved = json['isApproved'];
    endAt = json['endAt'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    viewCount = json['viewCount'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['media'] = this.media;
    data['views'] = this.views;
    data['advertisement_type'] = this.advertisementType;
    data['post'] = this.post;
    data['totalPrice'] = this.totalPrice;
    data['isApproved'] = this.isApproved;
    data['endAt'] = this.endAt;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['viewCount'] = this.viewCount;
    data['description'] = this.description;
    return data;
  }
}

class UserId {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  bool? twitterDocumentation;
  USERPROFILE? uSERPROFILE;
  String? image;

  UserId(
      {this.sId,
        this.firstName,
        this.lastName,
        this.email,
        this.twitterDocumentation,
        this.uSERPROFILE,
        this.image});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    twitterDocumentation = json['twitter_documentation'];
    uSERPROFILE = json['USER_PROFILE'] != null
        ? USERPROFILE.fromJson(json['USER_PROFILE'])
        : null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['twitter_documentation'] = this.twitterDocumentation;
    if (this.uSERPROFILE != null) {
      data['USER_PROFILE'] = this.uSERPROFILE!.toJson();
    }
    data['image'] = this.image;
    return data;
  }
}

class USERPROFILE {
  String? sId;
  String? userId;
  List<dynamic>? blocked;
  bool? isOnline;
  String? country;
  String? city;
  int? totalLike;
  int? totalView;
  int? totalShare;
  String? createdAt;
  String? updatedAt;
  ProfilePictureKey? profilePictureKey;

  USERPROFILE(
      {this.sId,
        this.userId,
        this.blocked,
        this.isOnline,
        this.country,
        this.city,
        this.totalLike,
        this.totalView,
        this.totalShare,
        this.createdAt,
        this.updatedAt,
        this.profilePictureKey});

  USERPROFILE.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    blocked = json['blocked'];
    isOnline = json['isOnline'];
    country = json['country'];
    city = json['city'];
    totalLike = json['totalLike'];
    totalView = json['totalView'];
    totalShare = json['totalShare'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profilePictureKey = json['profilePictureKey'] != null
        ? ProfilePictureKey.fromJson(json['profilePictureKey'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['blocked'] = this.blocked;
    data['isOnline'] = this.isOnline;
    data['country'] = this.country;
    data['city'] = this.city;
    data['totalLike'] = this.totalLike;
    data['totalView'] = this.totalView;
    data['totalShare'] = this.totalShare;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.profilePictureKey != null) {
      data['profilePictureKey'] = this.profilePictureKey!.toJson();
    }
    return data;
  }
}

class ProfilePictureKey {
  String? sId;
  String? user;
  String? subcategoryId;
  String? mimetype;
  int? size;
  String? mediaKey;
  bool? successUpload;
  String? createdAt;
  String? updatedAt;

  ProfilePictureKey(
      {this.sId,
        this.user,
        this.subcategoryId,
        this.mimetype,
        this.size,
        this.mediaKey,
        this.successUpload,
        this.createdAt,
        this.updatedAt});

  ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    subcategoryId = json['subcategoryId'];
    mimetype = json['mimetype'];
    size = json['size'];
    mediaKey = json['mediaKey'];
    successUpload = json['successUpload'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['subcategoryId'] = this.subcategoryId;
    data['mimetype'] = this.mimetype;
    data['size'] = this.size;
    data['mediaKey'] = this.mediaKey;
    data['successUpload'] = this.successUpload;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;

  Pagination({this.page, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}
