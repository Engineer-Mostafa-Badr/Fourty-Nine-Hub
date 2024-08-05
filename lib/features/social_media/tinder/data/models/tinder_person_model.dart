// class UserData {
//   String id;
//   String userId;
//   List<Picture> pictures;
//   List<Like> likes;
//   List<Friend> friends;
//   List<Gift> gifts;
//   List<User> users;
//   String createdAt;
//   String updatedAt;

//   UserData({
//     required this.id,
//     required this.userId,
//     required this.pictures,
//     required this.likes,
//     required this.friends,
//     required this.gifts,
//     required this.users,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['_id'],
//       userId: json['userId'],
//       pictures: (json['pictures'] as List).map((i) => Picture.fromJson(i)).toList(),
//       likes: (json['likes'] as List).map((i) => Like.fromJson(i)).toList(),
//       friends: (json['friends'] as List).map((i) => Friend.fromJson(i)).toList(),
//       gifts: (json['gifts'] as List).map((i) => Gift.fromJson(i)).toList(),
//       users: (json['user'] as List).map((i) => User.fromJson(i)).toList(),
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }
// class Picture {
//   String id;
//   String mediaKey;

//   Picture({
//     required this.id,
//     required this.mediaKey,
//   });

//   factory Picture.fromJson(Map<String, dynamic> json) {
//     return Picture(
//       id: json['_id'],
//       mediaKey: json['mediaKey'],
//     );
//   }
// }
// class Like {
//   String id;
//   String socketId;
//   String firstName;
//   String lastName;
//   String email;
//   dynamic birthday;
//   String hashedPassword;
//   String gender;
//   LocationData location;
//   bool adminIgnore;
//   List<dynamic> following;
//   List<dynamic> blockedUsers;
//   List<dynamic> hiddenPosts;
//   List<dynamic> followers;
//   String referralId;
//   bool isLocked;
//   dynamic lockedDate;
//   bool isRider;
//   bool isDoctor;
//   bool isRestaurant;
//   bool isLoading;
//   String language;
//   bool isEmailVerified;
//   bool isPhoneVerified;
//   bool isDeleted;
//   String countryCode;
//   List<dynamic> auctionUsers;
//   List<dynamic> installmentsUsers;
//   bool twitterDocumentation;
//   String username;
//   String createdAt;
//   String updatedAt;
//   String? chatPassword;
//   int? phone;

//   Like({
//     required this.id,
//     required this.socketId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     this.birthday,
//     required this.hashedPassword,
//     required this.gender,
//     required this.location,
//     required this.adminIgnore,
//     required this.following,
//     required this.blockedUsers,
//     required this.hiddenPosts,
//     required this.followers,
//     required this.referralId,
//     required this.isLocked,
//     this.lockedDate,
//     required this.isRider,
//     required this.isDoctor,
//     required this.isRestaurant,
//     required this.isLoading,
//     required this.language,
//     required this.isEmailVerified,
//     required this.isPhoneVerified,
//     required this.isDeleted,
//     required this.countryCode,
//     required this.auctionUsers,
//     required this.installmentsUsers,
//     required this.twitterDocumentation,
//     required this.username,
//     required this.createdAt,
//     required this.updatedAt,
//     this.chatPassword,
//     this.phone,
//   });

//   factory Like.fromJson(Map<String, dynamic> json) {
//     return Like(
//       id: json['_id'],
//       socketId: json['socketId'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       birthday: json['birthday'],
//       hashedPassword: json['hashedPassword'],
//       gender: json['gender'],
//       location: LocationData.fromJson(json['location']),
//       adminIgnore: json['adminIgnore'],
//       following: List<dynamic>.from(json['following']),
//       blockedUsers: List<dynamic>.from(json['blockedUsers']),
//       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
//       followers: List<dynamic>.from(json['followers']),
//       referralId: json['referralId'],
//       isLocked: json['isLocked'],
//       lockedDate: json['lockedDate'],
//       isRider: json['isRider'],
//       isDoctor: json['isDoctor'],
//       isRestaurant: json['isRestaurant'],
//       isLoading: json['isLoading'],
//       language: json['language'],
//       isEmailVerified: json['isEmailVerified'],
//       isPhoneVerified: json['isPhoneVerified'],
//       isDeleted: json['isDeleted'],
//       countryCode: json['countryCode'],
//       auctionUsers: List<dynamic>.from(json['auction_users']),
//       installmentsUsers: List<dynamic>.from(json['installments_users']),
//       twitterDocumentation: json['twitter_documentation'],
//       username: json['username'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       chatPassword: json['chatPassword'],
//       phone: json['phone'],
//     );
//   }
// }
// class Friend {
//   String id;
//   String socketId;
//   String firstName;
//   String lastName;
//   String email;
//   dynamic birthday;
//   String hashedPassword;
//   String gender;
//   LocationData location;
//   bool adminIgnore;
//   List<dynamic> following;
//   List<dynamic> blockedUsers;
//   List<dynamic> hiddenPosts;
//   List<dynamic> followers;
//   String referralId;
//   bool isLocked;
//   dynamic lockedDate;
//   bool isRider;
//   bool isDoctor;
//   bool isRestaurant;
//   bool isLoading;
//   String language;
//   bool isEmailVerified;
//   bool isPhoneVerified;
//   bool isDeleted;
//   String countryCode;
//   List<dynamic> auctionUsers;
//   List<dynamic> installmentsUsers;
//   bool twitterDocumentation;
//   String username;
//   String createdAt;
//   String updatedAt;
//   String? chatPassword;
//   int? phone;

//   Friend({
//     required this.id,
//     required this.socketId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     this.birthday,
//     required this.hashedPassword,
//     required this.gender,
//     required this.location,
//     required this.adminIgnore,
//     required this.following,
//     required this.blockedUsers,
//     required this.hiddenPosts,
//     required this.followers,
//     required this.referralId,
//     required this.isLocked,
//     this.lockedDate,
//     required this.isRider,
//     required this.isDoctor,
//     required this.isRestaurant,
//     required this.isLoading,
//     required this.language,
//     required this.isEmailVerified,
//     required this.isPhoneVerified,
//     required this.isDeleted,
//     required this.countryCode,
//     required this.auctionUsers,
//     required this.installmentsUsers,
//     required this.twitterDocumentation,
//     required this.username,
//     required this.createdAt,
//     required this.updatedAt,
//     this.chatPassword,
//     this.phone,
//   });

//   factory Friend.fromJson(Map<String, dynamic> json) {
//     return Friend(
//       id: json['_id'],
//       socketId: json['socketId'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       birthday: json['birthday'],
//       hashedPassword: json['hashedPassword'],
//       gender: json['gender'],
//       location: LocationData.fromJson(json['location']),
//       adminIgnore: json['adminIgnore'],
//       following: List<dynamic>.from(json['following']),
//       blockedUsers: List<dynamic>.from(json['blockedUsers']),
//       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
//       followers: List<dynamic>.from(json['followers']),
//       referralId: json['referralId'],
//       isLocked: json['isLocked'],
//       lockedDate: json['lockedDate'],
//       isRider: json['isRider'],
//       isDoctor: json['isDoctor'],
//       isRestaurant: json['isRestaurant'],
//       isLoading: json['isLoading'],
//       language: json['language'],
//       isEmailVerified: json['isEmailVerified'],
//       isPhoneVerified: json['isPhoneVerified'],
//       isDeleted: json['isDeleted'],
//       countryCode: json['countryCode'],
//       auctionUsers: List<dynamic>.from(json['auction_users']),
//       installmentsUsers: List<dynamic>.from(json['installments_users']),
//       twitterDocumentation: json['twitter_documentation'],
//       username: json['username'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       chatPassword: json['chatPassword'],
//       phone: json['phone'],
//     );
//   }
// }
// class Gift {
//   String id;
//   String nameAr;
//   String nameEn;
//   Picture picture;

//   Gift({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.picture,
//   });

//   factory Gift.fromJson(Map<String, dynamic> json) {
//     return Gift(
//       id: json['_id'],
//       nameAr: json['nameAr'],
//       nameEn: json['nameEn'],
//       picture: Picture.fromJson(json['picture']),
//     );
//   }
// }
// class User {
//   String id;
//   String socketId;
//   String firstName;
//   String lastName;
//   String email;
//   dynamic birthday;
//   String hashedPassword;
//   String gender;
//   LocationData location;
//   bool adminIgnore;
//   List<dynamic> following;
//   List<dynamic> blockedUsers;
//   List<dynamic> hiddenPosts;
//   List<dynamic> followers;
//   String referralId;
//   bool isLocked;
//   dynamic lockedDate;
//   bool isRider;
//   bool isDoctor;
//   bool isRestaurant;
//   bool isLoading;
//   String language;
//   bool isEmailVerified;
//   bool isPhoneVerified;
//   bool isDeleted;
//   String countryCode;
//   List<dynamic> auctionUsers;
//   List<dynamic> installmentsUsers;
//   bool twitterDocumentation;
//   String username;
//   String createdAt;
//   String updatedAt;
//   String? chatPassword;
//   int? phone;

//   User({
//     required this.id,
//     required this.socketId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     this.birthday,
//     required this.hashedPassword,
//     required this.gender,
//     required this.location,
//     required this.adminIgnore,
//     required this.following,
//     required this.blockedUsers,
//     required this.hiddenPosts,
//     required this.followers,
//     required this.referralId,
//     required this.isLocked,
//     this.lockedDate,
//     required this.isRider,
//     required this.isDoctor,
//     required this.isRestaurant,
//     required this.isLoading,
//     required this.language,
//     required this.isEmailVerified,
//     required this.isPhoneVerified,
//     required this.isDeleted,
//     required this.countryCode,
//     required this.auctionUsers,
//     required this.installmentsUsers,
//     required this.twitterDocumentation,
//     required this.username,
//     required this.createdAt,
//     required this.updatedAt,
//     this.chatPassword,
//     this.phone,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       socketId: json['socketId'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       birthday: json['birthday'],
//       hashedPassword: json['hashedPassword'],
//       gender: json['gender'],
//       location: LocationData.fromJson(json['location']),
//       adminIgnore: json['adminIgnore'],
//       following: List<dynamic>.from(json['following']),
//       blockedUsers: List<dynamic>.from(json['blockedUsers']),
//       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
//       followers: List<dynamic>.from(json['followers']),
//       referralId: json['referralId'],
//       isLocked: json['isLocked'],
//       lockedDate: json['lockedDate'],
//       isRider: json['isRider'],
//       isDoctor: json['isDoctor'],
//       isRestaurant: json['isRestaurant'],
//       isLoading: json['isLoading'],
//       language: json['language'],
//       isEmailVerified: json['isEmailVerified'],
//       isPhoneVerified: json['isPhoneVerified'],
//       isDeleted: json['isDeleted'],
//       countryCode: json['countryCode'],
//       auctionUsers: List<dynamic>.from(json['auction_users']),
//       installmentsUsers: List<dynamic>.from(json['installments_users']),
//       twitterDocumentation: json['twitter_documentation'],
//       username: json['username'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       chatPassword: json['chatPassword'],
//       phone: json['phone'],
//     );
//   }
// }
// class LocationData {
//   String type;
//   List<int> coordinates;

//   LocationData({
//     required this.type,
//     required this.coordinates,
//   });

//   factory LocationData.fromJson(Map<String, dynamic> json) {
//     return LocationData(
//       type: json['type'],
//       coordinates: List<int>.from(json['coordinates']),
//     );
//   }
// }
class ApiResponse {
  bool status;
  List<UserData> data;

  ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      data: (json['data'] as List).map((i) => UserData.fromJson(i)).toList(),
    );
  }
}

class UserData {
  String id;
  String userId;
  List<Picture> pictures;
  List<Like> likes;
  List<Friend> friends;
  List<Gift> gifts;
  String createdAt;
  String updatedAt;
  List<User> users;

  UserData({
    required this.id,
    required this.userId,
    required this.pictures,
    required this.likes,
    required this.friends,
    required this.gifts,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      userId: json['userId'],
      pictures:
          (json['pictures'] as List).map((i) => Picture.fromJson(i)).toList(),
      likes: (json['likes'] as List).map((i) => Like.fromJson(i)).toList(),
      friends:
          (json['friends'] as List).map((i) => Friend.fromJson(i)).toList(),
      gifts: (json['gifts'] as List).map((i) => Gift.fromJson(i)).toList(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      users: (json['user'] as List).map((i) => User.fromJson(i)).toList(),
    );
  }
}

class Picture {
  String id;
  String mediaKey;

  Picture({
    required this.id,
    required this.mediaKey,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}

class Like {
  String id;
  String socketId;
  String firstName;
  String lastName;
  String email;
  dynamic birthday;
  String hashedPassword;
  String gender;
  LocationData location;
  bool adminIgnore;
  List<dynamic> following;
  List<dynamic> blockedUsers;
  List<dynamic> hiddenPosts;
  List<dynamic> followers;
  String referralId;
  bool isLocked;
  dynamic lockedDate;
  bool isRider;
  bool isDoctor;
  bool isRestaurant;
  bool isLoading;
  String language;
  bool isEmailVerified;
  bool isPhoneVerified;
  bool isDeleted;
  String countryCode;
  List<dynamic> auctionUsers;
  List<dynamic> installmentsUsers;
  bool twitterDocumentation;
  String username;
  String createdAt;
  String updatedAt;
  String? chatPassword;
  int? phone;

  Like({
    required this.id,
    required this.socketId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthday,
    required this.hashedPassword,
    required this.gender,
    required this.location,
    required this.adminIgnore,
    required this.following,
    required this.blockedUsers,
    required this.hiddenPosts,
    required this.followers,
    required this.referralId,
    required this.isLocked,
    this.lockedDate,
    required this.isRider,
    required this.isDoctor,
    required this.isRestaurant,
    required this.isLoading,
    required this.language,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isDeleted,
    required this.countryCode,
    required this.auctionUsers,
    required this.installmentsUsers,
    required this.twitterDocumentation,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.chatPassword,
    this.phone,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['_id'],
      socketId: json['socketId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthday: json['birthday'],
      hashedPassword: json['hashedPassword'],
      gender: json['gender'],
      location: LocationData.fromJson(json['location']),
      adminIgnore: json['adminIgnore'],
      following: List<dynamic>.from(json['following']),
      blockedUsers: List<dynamic>.from(json['blockedUsers']),
      hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
      followers: List<dynamic>.from(json['followers']),
      referralId: json['referralId'],
      isLocked: json['isLocked'],
      lockedDate: json['lockedDate'],
      isRider: json['isRider'],
      isDoctor: json['isDoctor'],
      isRestaurant: json['isRestaurant'],
      isLoading: json['isLoading'],
      language: json['language'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      isDeleted: json['isDeleted'],
      countryCode: json['countryCode'],
      auctionUsers: List<dynamic>.from(json['auction_users']),
      installmentsUsers: List<dynamic>.from(json['installments_users']),
      twitterDocumentation: json['twitter_documentation'],
      username: json['username'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      chatPassword: json['chatPassword'],
      phone: json['phone'],
    );
  }
}

class Friend {
  String id;
  String socketId;
  String firstName;
  String lastName;
  String email;
  dynamic birthday;
  String hashedPassword;
  String gender;
  LocationData location;
  bool adminIgnore;
  List<dynamic> following;
  List<dynamic> blockedUsers;
  List<dynamic> hiddenPosts;
  List<dynamic> followers;
  String referralId;
  bool isLocked;
  dynamic lockedDate;
  bool isRider;
  bool isDoctor;
  bool isRestaurant;
  bool isLoading;
  String language;
  bool isEmailVerified;
  bool isPhoneVerified;
  bool isDeleted;
  String countryCode;
  List<dynamic> auctionUsers;
  List<dynamic> installmentsUsers;
  bool twitterDocumentation;
  String username;
  String createdAt;
  String updatedAt;
  String? chatPassword;
  int? phone;

  Friend({
    required this.id,
    required this.socketId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthday,
    required this.hashedPassword,
    required this.gender,
    required this.location,
    required this.adminIgnore,
    required this.following,
    required this.blockedUsers,
    required this.hiddenPosts,
    required this.followers,
    required this.referralId,
    required this.isLocked,
    this.lockedDate,
    required this.isRider,
    required this.isDoctor,
    required this.isRestaurant,
    required this.isLoading,
    required this.language,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isDeleted,
    required this.countryCode,
    required this.auctionUsers,
    required this.installmentsUsers,
    required this.twitterDocumentation,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.chatPassword,
    this.phone,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['_id'],
      socketId: json['socketId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthday: json['birthday'],
      hashedPassword: json['hashedPassword'],
      gender: json['gender'],
      location: LocationData.fromJson(json['location']),
      adminIgnore: json['adminIgnore'],
      following: List<dynamic>.from(json['following']),
      blockedUsers: List<dynamic>.from(json['blockedUsers']),
      hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
      followers: List<dynamic>.from(json['followers']),
      referralId: json['referralId'],
      isLocked: json['isLocked'],
      lockedDate: json['lockedDate'],
      isRider: json['isRider'],
      isDoctor: json['isDoctor'],
      isRestaurant: json['isRestaurant'],
      isLoading: json['isLoading'],
      language: json['language'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      isDeleted: json['isDeleted'],
      countryCode: json['countryCode'],
      auctionUsers: List<dynamic>.from(json['auction_users']),
      installmentsUsers: List<dynamic>.from(json['installments_users']),
      twitterDocumentation: json['twitter_documentation'],
      username: json['username'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      chatPassword: json['chatPassword'],
      phone: json['phone'],
    );
  }
}

class Gift {
  String id;
  String nameAr;
  String nameEn;
  Picture picture;
  int value;
  String createdAt;
  String updatedAt;

  Gift({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.picture,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      picture: Picture.fromJson(json['picture']),
      value: json['value'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class User {
  String id;
  String socketId;
  String firstName;
  String lastName;
  String email;
  dynamic birthday;
  String hashedPassword;
  String gender;
  LocationData location;
  bool adminIgnore;
  List<dynamic> following;
  List<dynamic> blockedUsers;
  List<dynamic> hiddenPosts;
  List<dynamic> followers;
  String referralId;
  bool isLocked;
  dynamic lockedDate;
  bool isRider;
  bool isDoctor;
  bool isRestaurant;
  bool isLoading;
  String language;
  bool isEmailVerified;
  bool isPhoneVerified;
  bool isDeleted;
  String countryCode;
  List<dynamic> auctionUsers;
  List<dynamic> installmentsUsers;
  bool twitterDocumentation;
  String username;
  String createdAt;
  String updatedAt;
  String? chatPassword;
  int? phone;

  User({
    required this.id,
    required this.socketId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthday,
    required this.hashedPassword,
    required this.gender,
    required this.location,
    required this.adminIgnore,
    required this.following,
    required this.blockedUsers,
    required this.hiddenPosts,
    required this.followers,
    required this.referralId,
    required this.isLocked,
    this.lockedDate,
    required this.isRider,
    required this.isDoctor,
    required this.isRestaurant,
    required this.isLoading,
    required this.language,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isDeleted,
    required this.countryCode,
    required this.auctionUsers,
    required this.installmentsUsers,
    required this.twitterDocumentation,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.chatPassword,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      socketId: json['socketId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthday: json['birthday'],
      hashedPassword: json['hashedPassword'],
      gender: json['gender'],
      location: LocationData.fromJson(json['location']),
      adminIgnore: json['adminIgnore'],
      following: List<dynamic>.from(json['following']),
      blockedUsers: List<dynamic>.from(json['blockedUsers']),
      hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
      followers: List<dynamic>.from(json['followers']),
      referralId: json['referralId'],
      isLocked: json['isLocked'],
      lockedDate: json['lockedDate'],
      isRider: json['isRider'],
      isDoctor: json['isDoctor'],
      isRestaurant: json['isRestaurant'],
      isLoading: json['isLoading'],
      language: json['language'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      isDeleted: json['isDeleted'],
      countryCode: json['countryCode'],
      auctionUsers: List<dynamic>.from(json['auction_users']),
      installmentsUsers: List<dynamic>.from(json['installments_users']),
      twitterDocumentation: json['twitter_documentation'],
      username: json['username'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      chatPassword: json['chatPassword'],
      phone: json['phone'],
    );
  }
}

class LocationData {
  String type;
  List<int> coordinates;

  LocationData({
    required this.type,
    required this.coordinates,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      type: json['type'],
      coordinates: List<int>.from(json['coordinates']),
    );
  }
}
