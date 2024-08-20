class FavoritesResponse {
  bool? success;
  Data? data;

  FavoritesResponse({this.success, this.data});

  FavoritesResponse.fromJson(Map<String, dynamic> json) {
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
  List<Favorites>? favorites;

  Data({this.favorites});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['favorites'] != null) {
      favorites = <Favorites>[];
      json['favorites'].forEach((v) {
        favorites!.add(Favorites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (favorites != null) {
      data['favorites'] = favorites!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Favorites {
  String? sId;
  CategoryId? categoryId;
  UserId? userId;
  String? createdAt;
  String? updatedAt;

  Favorites(
      {this.sId, this.categoryId, this.userId, this.createdAt, this.updatedAt});

  Favorites.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryId = json['category_id'] != null
        ? CategoryId.fromJson(json['category_id'])
        : null;
    userId = json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (categoryId != null) {
      data['category_id'] = categoryId!.toJson();
    }
    if (userId != null) {
      data['user_id'] = userId!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class CategoryId {
  String? sId;
  String? banner;
  String? cover;
  int? index;
  String? createdAt;
  String? updatedAt;
  String? nameAr;
  String? nameEn;
  String? nameCode;
  bool? isHidden;
  bool? enableInstallmentAndAuction;

  CategoryId(
      {this.sId,
      this.banner,
      this.cover,
      this.index,
      this.createdAt,
      this.updatedAt,
      this.nameAr,
      this.nameEn,
      this.nameCode,
      this.isHidden,
      this.enableInstallmentAndAuction});

  CategoryId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    banner = json['banner'];
    cover = json['cover'];
    index = json['index'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    nameAr = json['nameAr'];
    nameEn = json['nameEn'];
    nameCode = json['nameCode'];
    isHidden = json['isHidden'];
    enableInstallmentAndAuction = json['EnableInstallmentAndAuction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['banner'] = banner;
    data['cover'] = cover;
    data['index'] = index;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['nameAr'] = nameAr;
    data['nameEn'] = nameEn;
    data['nameCode'] = nameCode;
    data['isHidden'] = isHidden;
    data['EnableInstallmentAndAuction'] = enableInstallmentAndAuction;
    return data;
  }
}

class UserId {
  Location? location;
  String? sId;
  String? socketId;
  String? firstName;
  String? lastName;
  String? email;
  String? birthday;
  String? hashedPassword;
  String? gender;
  bool? adminIgnore;
  List<dynamic>? following;
  List<dynamic>? blockedUsers;
  List<dynamic>? hiddenPosts;
  List<dynamic>? followers;
  String? referralId;
  bool? isLocked;
  String? lockedDate;
  bool? isRider;
  bool? isDoctor;
  bool? isRestaurant;
  bool? isLoading;
  String? language;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? isDeleted;
  String? countryCode;
  List<String>? auctionUsers;
  List<String>? installmentsUsers;
  bool? twitterDocumentation;
  String? username;
  String? createdAt;
  String? updatedAt;
  String? chatPassword;
  String? id;

  UserId(
      {this.location,
      this.sId,
      this.socketId,
      this.firstName,
      this.lastName,
      this.email,
      this.birthday,
      this.hashedPassword,
      this.gender,
      this.adminIgnore,
      this.following,
      this.blockedUsers,
      this.hiddenPosts,
      this.followers,
      this.referralId,
      this.isLocked,
      this.lockedDate,
      this.isRider,
      this.isDoctor,
      this.isRestaurant,
      this.isLoading,
      this.language,
      this.isEmailVerified,
      this.isPhoneVerified,
      this.isDeleted,
      this.countryCode,
      this.auctionUsers,
      this.installmentsUsers,
      this.twitterDocumentation,
      this.username,
      this.createdAt,
      this.updatedAt,
      this.chatPassword,
      this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    socketId = json['socketId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthday = json['birthday'];
    hashedPassword = json['hashedPassword'];
    gender = json['gender'];
    adminIgnore = json['adminIgnore'];

    following =
        json['following'] != null ? List<dynamic>.from(json['following']) : [];
    blockedUsers = json['blockedUsers'] != null
        ? List<dynamic>.from(json['blockedUsers'])
        : [];
    hiddenPosts = json['hiddenPosts'] != null
        ? List<dynamic>.from(json['hiddenPosts'])
        : [];
    followers =
        json['followers'] != null ? List<dynamic>.from(json['followers']) : [];

    referralId = json['referralId'];
    isLocked = json['isLocked'];
    lockedDate = json['lockedDate'];
    isRider = json['isRider'];
    isDoctor = json['isDoctor'];
    isRestaurant = json['isRestaurant'];
    isLoading = json['isLoading'];
    language = json['language'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    isDeleted = json['isDeleted'];
    countryCode = json['countryCode'];
    auctionUsers = json['auction_users'] != null
        ? List<String>.from(json['auction_users'])
        : [];
    installmentsUsers = json['installments_users'] != null
        ? List<String>.from(json['installments_users'])
        : [];
    twitterDocumentation = json['twitter_documentation'];
    username = json['username'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chatPassword = json['chatPassword'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['socketId'] = socketId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthday'] = birthday;
    data['hashedPassword'] = hashedPassword;
    data['gender'] = gender;
    data['adminIgnore'] = adminIgnore;
    data['following'] = following ?? [];
    data['blockedUsers'] = blockedUsers ?? [];
    data['hiddenPosts'] = hiddenPosts ?? [];
    data['followers'] = followers ?? [];
    data['referralId'] = referralId;
    data['isLocked'] = isLocked;
    data['lockedDate'] = lockedDate;
    data['isRider'] = isRider;
    data['isDoctor'] = isDoctor;
    data['isRestaurant'] = isRestaurant;
    data['isLoading'] = isLoading;
    data['language'] = language;
    data['isEmailVerified'] = isEmailVerified;
    data['isPhoneVerified'] = isPhoneVerified;
    data['isDeleted'] = isDeleted;
    data['countryCode'] = countryCode;
    data['auction_users'] = auctionUsers;
    data['installments_users'] = installmentsUsers;
    data['twitter_documentation'] = twitterDocumentation;
    data['username'] = username;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['chatPassword'] = chatPassword;
    data['id'] = id;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
