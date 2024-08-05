// // class UserData {
// //   String id;
// //   String userId;
// //   List<Picture> pictures;
// //   List<Like> likes;
// //   List<Friend> friends;
// //   List<Gift> gifts;
// //   List<User> users;
// //   String createdAt;
// //   String updatedAt;

// //   UserData({
// //     required this.id,
// //     required this.userId,
// //     required this.pictures,
// //     required this.likes,
// //     required this.friends,
// //     required this.gifts,
// //     required this.users,
// //     required this.createdAt,
// //     required this.updatedAt,
// //   });

// //   factory UserData.fromJson(Map<String, dynamic> json) {
// //     return UserData(
// //       id: json['_id'],
// //       userId: json['userId'],
// //       pictures: (json['pictures'] as List).map((i) => Picture.fromJson(i)).toList(),
// //       likes: (json['likes'] as List).map((i) => Like.fromJson(i)).toList(),
// //       friends: (json['friends'] as List).map((i) => Friend.fromJson(i)).toList(),
// //       gifts: (json['gifts'] as List).map((i) => Gift.fromJson(i)).toList(),
// //       users: (json['user'] as List).map((i) => User.fromJson(i)).toList(),
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //     );
// //   }
// // }
// // class Picture {
// //   String id;
// //   String mediaKey;

// //   Picture({
// //     required this.id,
// //     required this.mediaKey,
// //   });

// //   factory Picture.fromJson(Map<String, dynamic> json) {
// //     return Picture(
// //       id: json['_id'],
// //       mediaKey: json['mediaKey'],
// //     );
// //   }
// // }
// // class Like {
// //   String id;
// //   String socketId;
// //   String firstName;
// //   String lastName;
// //   String email;
// //   dynamic birthday;
// //   String hashedPassword;
// //   String gender;
// //   LocationData location;
// //   bool adminIgnore;
// //   List<dynamic> following;
// //   List<dynamic> blockedUsers;
// //   List<dynamic> hiddenPosts;
// //   List<dynamic> followers;
// //   String referralId;
// //   bool isLocked;
// //   dynamic lockedDate;
// //   bool isRider;
// //   bool isDoctor;
// //   bool isRestaurant;
// //   bool isLoading;
// //   String language;
// //   bool isEmailVerified;
// //   bool isPhoneVerified;
// //   bool isDeleted;
// //   String countryCode;
// //   List<dynamic> auctionUsers;
// //   List<dynamic> installmentsUsers;
// //   bool twitterDocumentation;
// //   String username;
// //   String createdAt;
// //   String updatedAt;
// //   String? chatPassword;
// //   int? phone;

// //   Like({
// //     required this.id,
// //     required this.socketId,
// //     required this.firstName,
// //     required this.lastName,
// //     required this.email,
// //     this.birthday,
// //     required this.hashedPassword,
// //     required this.gender,
// //     required this.location,
// //     required this.adminIgnore,
// //     required this.following,
// //     required this.blockedUsers,
// //     required this.hiddenPosts,
// //     required this.followers,
// //     required this.referralId,
// //     required this.isLocked,
// //     this.lockedDate,
// //     required this.isRider,
// //     required this.isDoctor,
// //     required this.isRestaurant,
// //     required this.isLoading,
// //     required this.language,
// //     required this.isEmailVerified,
// //     required this.isPhoneVerified,
// //     required this.isDeleted,
// //     required this.countryCode,
// //     required this.auctionUsers,
// //     required this.installmentsUsers,
// //     required this.twitterDocumentation,
// //     required this.username,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     this.chatPassword,
// //     this.phone,
// //   });

// //   factory Like.fromJson(Map<String, dynamic> json) {
// //     return Like(
// //       id: json['_id'],
// //       socketId: json['socketId'],
// //       firstName: json['firstName'],
// //       lastName: json['lastName'],
// //       email: json['email'],
// //       birthday: json['birthday'],
// //       hashedPassword: json['hashedPassword'],
// //       gender: json['gender'],
// //       location: LocationData.fromJson(json['location']),
// //       adminIgnore: json['adminIgnore'],
// //       following: List<dynamic>.from(json['following']),
// //       blockedUsers: List<dynamic>.from(json['blockedUsers']),
// //       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
// //       followers: List<dynamic>.from(json['followers']),
// //       referralId: json['referralId'],
// //       isLocked: json['isLocked'],
// //       lockedDate: json['lockedDate'],
// //       isRider: json['isRider'],
// //       isDoctor: json['isDoctor'],
// //       isRestaurant: json['isRestaurant'],
// //       isLoading: json['isLoading'],
// //       language: json['language'],
// //       isEmailVerified: json['isEmailVerified'],
// //       isPhoneVerified: json['isPhoneVerified'],
// //       isDeleted: json['isDeleted'],
// //       countryCode: json['countryCode'],
// //       auctionUsers: List<dynamic>.from(json['auction_users']),
// //       installmentsUsers: List<dynamic>.from(json['installments_users']),
// //       twitterDocumentation: json['twitter_documentation'],
// //       username: json['username'],
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //       chatPassword: json['chatPassword'],
// //       phone: json['phone'],
// //     );
// //   }
// // }
// // class Friend {
// //   String id;
// //   String socketId;
// //   String firstName;
// //   String lastName;
// //   String email;
// //   dynamic birthday;
// //   String hashedPassword;
// //   String gender;
// //   LocationData location;
// //   bool adminIgnore;
// //   List<dynamic> following;
// //   List<dynamic> blockedUsers;
// //   List<dynamic> hiddenPosts;
// //   List<dynamic> followers;
// //   String referralId;
// //   bool isLocked;
// //   dynamic lockedDate;
// //   bool isRider;
// //   bool isDoctor;
// //   bool isRestaurant;
// //   bool isLoading;
// //   String language;
// //   bool isEmailVerified;
// //   bool isPhoneVerified;
// //   bool isDeleted;
// //   String countryCode;
// //   List<dynamic> auctionUsers;
// //   List<dynamic> installmentsUsers;
// //   bool twitterDocumentation;
// //   String username;
// //   String createdAt;
// //   String updatedAt;
// //   String? chatPassword;
// //   int? phone;

// //   Friend({
// //     required this.id,
// //     required this.socketId,
// //     required this.firstName,
// //     required this.lastName,
// //     required this.email,
// //     this.birthday,
// //     required this.hashedPassword,
// //     required this.gender,
// //     required this.location,
// //     required this.adminIgnore,
// //     required this.following,
// //     required this.blockedUsers,
// //     required this.hiddenPosts,
// //     required this.followers,
// //     required this.referralId,
// //     required this.isLocked,
// //     this.lockedDate,
// //     required this.isRider,
// //     required this.isDoctor,
// //     required this.isRestaurant,
// //     required this.isLoading,
// //     required this.language,
// //     required this.isEmailVerified,
// //     required this.isPhoneVerified,
// //     required this.isDeleted,
// //     required this.countryCode,
// //     required this.auctionUsers,
// //     required this.installmentsUsers,
// //     required this.twitterDocumentation,
// //     required this.username,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     this.chatPassword,
// //     this.phone,
// //   });

// //   factory Friend.fromJson(Map<String, dynamic> json) {
// //     return Friend(
// //       id: json['_id'],
// //       socketId: json['socketId'],
// //       firstName: json['firstName'],
// //       lastName: json['lastName'],
// //       email: json['email'],
// //       birthday: json['birthday'],
// //       hashedPassword: json['hashedPassword'],
// //       gender: json['gender'],
// //       location: LocationData.fromJson(json['location']),
// //       adminIgnore: json['adminIgnore'],
// //       following: List<dynamic>.from(json['following']),
// //       blockedUsers: List<dynamic>.from(json['blockedUsers']),
// //       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
// //       followers: List<dynamic>.from(json['followers']),
// //       referralId: json['referralId'],
// //       isLocked: json['isLocked'],
// //       lockedDate: json['lockedDate'],
// //       isRider: json['isRider'],
// //       isDoctor: json['isDoctor'],
// //       isRestaurant: json['isRestaurant'],
// //       isLoading: json['isLoading'],
// //       language: json['language'],
// //       isEmailVerified: json['isEmailVerified'],
// //       isPhoneVerified: json['isPhoneVerified'],
// //       isDeleted: json['isDeleted'],
// //       countryCode: json['countryCode'],
// //       auctionUsers: List<dynamic>.from(json['auction_users']),
// //       installmentsUsers: List<dynamic>.from(json['installments_users']),
// //       twitterDocumentation: json['twitter_documentation'],
// //       username: json['username'],
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //       chatPassword: json['chatPassword'],
// //       phone: json['phone'],
// //     );
// //   }
// // }
// // class Gift {
// //   String id;
// //   String nameAr;
// //   String nameEn;
// //   Picture picture;

// //   Gift({
// //     required this.id,
// //     required this.nameAr,
// //     required this.nameEn,
// //     required this.picture,
// //   });

// //   factory Gift.fromJson(Map<String, dynamic> json) {
// //     return Gift(
// //       id: json['_id'],
// //       nameAr: json['nameAr'],
// //       nameEn: json['nameEn'],
// //       picture: Picture.fromJson(json['picture']),
// //     );
// //   }
// // }
// // class User {
// //   String id;
// //   String socketId;
// //   String firstName;
// //   String lastName;
// //   String email;
// //   dynamic birthday;
// //   String hashedPassword;
// //   String gender;
// //   LocationData location;
// //   bool adminIgnore;
// //   List<dynamic> following;
// //   List<dynamic> blockedUsers;
// //   List<dynamic> hiddenPosts;
// //   List<dynamic> followers;
// //   String referralId;
// //   bool isLocked;
// //   dynamic lockedDate;
// //   bool isRider;
// //   bool isDoctor;
// //   bool isRestaurant;
// //   bool isLoading;
// //   String language;
// //   bool isEmailVerified;
// //   bool isPhoneVerified;
// //   bool isDeleted;
// //   String countryCode;
// //   List<dynamic> auctionUsers;
// //   List<dynamic> installmentsUsers;
// //   bool twitterDocumentation;
// //   String username;
// //   String createdAt;
// //   String updatedAt;
// //   String? chatPassword;
// //   int? phone;

// //   User({
// //     required this.id,
// //     required this.socketId,
// //     required this.firstName,
// //     required this.lastName,
// //     required this.email,
// //     this.birthday,
// //     required this.hashedPassword,
// //     required this.gender,
// //     required this.location,
// //     required this.adminIgnore,
// //     required this.following,
// //     required this.blockedUsers,
// //     required this.hiddenPosts,
// //     required this.followers,
// //     required this.referralId,
// //     required this.isLocked,
// //     this.lockedDate,
// //     required this.isRider,
// //     required this.isDoctor,
// //     required this.isRestaurant,
// //     required this.isLoading,
// //     required this.language,
// //     required this.isEmailVerified,
// //     required this.isPhoneVerified,
// //     required this.isDeleted,
// //     required this.countryCode,
// //     required this.auctionUsers,
// //     required this.installmentsUsers,
// //     required this.twitterDocumentation,
// //     required this.username,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     this.chatPassword,
// //     this.phone,
// //   });

// //   factory User.fromJson(Map<String, dynamic> json) {
// //     return User(
// //       id: json['_id'],
// //       socketId: json['socketId'],
// //       firstName: json['firstName'],
// //       lastName: json['lastName'],
// //       email: json['email'],
// //       birthday: json['birthday'],
// //       hashedPassword: json['hashedPassword'],
// //       gender: json['gender'],
// //       location: LocationData.fromJson(json['location']),
// //       adminIgnore: json['adminIgnore'],
// //       following: List<dynamic>.from(json['following']),
// //       blockedUsers: List<dynamic>.from(json['blockedUsers']),
// //       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
// //       followers: List<dynamic>.from(json['followers']),
// //       referralId: json['referralId'],
// //       isLocked: json['isLocked'],
// //       lockedDate: json['lockedDate'],
// //       isRider: json['isRider'],
// //       isDoctor: json['isDoctor'],
// //       isRestaurant: json['isRestaurant'],
// //       isLoading: json['isLoading'],
// //       language: json['language'],
// //       isEmailVerified: json['isEmailVerified'],
// //       isPhoneVerified: json['isPhoneVerified'],
// //       isDeleted: json['isDeleted'],
// //       countryCode: json['countryCode'],
// //       auctionUsers: List<dynamic>.from(json['auction_users']),
// //       installmentsUsers: List<dynamic>.from(json['installments_users']),
// //       twitterDocumentation: json['twitter_documentation'],
// //       username: json['username'],
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //       chatPassword: json['chatPassword'],
// //       phone: json['phone'],
// //     );
// //   }
// // }
// // class LocationData {
// //   String type;
// //   List<int> coordinates;

// //   LocationData({
// //     required this.type,
// //     required this.coordinates,
// //   });

// //   factory LocationData.fromJson(Map<String, dynamic> json) {
// //     return LocationData(
// //       type: json['type'],
// //       coordinates: List<int>.from(json['coordinates']),
// //     );
// //   }
// // }
// class ApiResponse {
//   bool status;
//   List<UserData> data;

//   ApiResponse({
//     required this.status,
//     required this.data,
//   });

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       status: json['status'],
//       data: (json['data'] as List).map((i) => UserData.fromJson(i)).toList(),
//     );
//   }
// }

// class UserData {
//   String id;
//   String userId;
//   List<Picture> pictures;
//   List<Like> likes;
//   List<Friend> friends;
//   List<Gift> gifts;
//   String createdAt;
//   String updatedAt;
//   List<User> users;

//   UserData({
//     required this.id,
//     required this.userId,
//     required this.pictures,
//     required this.likes,
//     required this.friends,
//     required this.gifts,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.users,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['_id'],
//       userId: json['userId'],
//       pictures:
//           (json['pictures'] as List).map((i) => Picture.fromJson(i)).toList(),
//       likes: (json['likes'] as List).map((i) => Like.fromJson(i)).toList(),
//       friends:
//           (json['friends'] as List).map((i) => Friend.fromJson(i)).toList(),
//       gifts: (json['gifts'] as List).map((i) => Gift.fromJson(i)).toList(),
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       users: (json['user'] as List).map((i) => User.fromJson(i)).toList(),
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
//   int value;
//   String createdAt;
//   String updatedAt;

//   Gift({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.picture,
//     required this.value,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Gift.fromJson(Map<String, dynamic> json) {
//     return Gift(
//       id: json['_id'],
//       nameAr: json['nameAr'],
//       nameEn: json['nameEn'],
//       picture: Picture.fromJson(json['picture']),
//       value: json['value'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
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
import 'dart:convert';

// Model for Pictures
class Picture {
  String? id;
  String? mediaKey;

  Picture({this.id, this.mediaKey});

  Picture.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    mediaKey = json['mediaKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['mediaKey'] = mediaKey;
    return data;
  }
}

// Model for Location
class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

// Model for Likes
class Likes {
  String? id;
  String? socketId;
  String? firstName;
  String? lastName;
  String? email;
  String? birthday;
  String? hashedPassword;
  String? gender;
  Location? location;
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

  Likes({
    this.id,
    this.socketId,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.hashedPassword,
    this.gender,
    this.location,
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
  });

  Likes.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    socketId = json['socketId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthday = json['birthday'];
    hashedPassword = json['hashedPassword'];
    gender = json['gender'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    adminIgnore = json['adminIgnore'];
    following = json['following'];
    blockedUsers = json['blockedUsers'];
    hiddenPosts = json['hiddenPosts'];
    followers = json['followers'];
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
        : null;
    installmentsUsers = json['installments_users'] != null
        ? List<String>.from(json['installments_users'])
        : null;
    twitterDocumentation = json['twitter_documentation'];
    username = json['username'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chatPassword = json['chatPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['socketId'] = socketId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthday'] = birthday;
    data['hashedPassword'] = hashedPassword;
    data['gender'] = gender;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['adminIgnore'] = adminIgnore;
    data['following'] = following;
    data['blockedUsers'] = blockedUsers;
    data['hiddenPosts'] = hiddenPosts;
    data['followers'] = followers;
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
    return data;
  }
}

// Model for Friends
class Friends extends Likes {
  int? phone;

  Friends({
    String? id,
    String? socketId,
    String? firstName,
    String? lastName,
    String? email,
    String? birthday,
    String? hashedPassword,
    String? gender,
    Location? location,
    bool? adminIgnore,
    List<dynamic>? following,
    List<dynamic>? blockedUsers,
    List<dynamic>? hiddenPosts,
    List<dynamic>? followers,
    String? referralId,
    bool? isLocked,
    String? lockedDate,
    bool? isRider,
    bool? isDoctor,
    bool? isRestaurant,
    bool? isLoading,
    String? language,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isDeleted,
    String? countryCode,
    List<String>? auctionUsers,
    List<String>? installmentsUsers,
    bool? twitterDocumentation,
    String? username,
    String? createdAt,
    String? updatedAt,
    String? chatPassword,
    this.phone,
  }) : super(
          id: id,
          socketId: socketId,
          firstName: firstName,
          lastName: lastName,
          email: email,
          birthday: birthday,
          hashedPassword: hashedPassword,
          gender: gender,
          location: location,
          adminIgnore: adminIgnore,
          following: following,
          blockedUsers: blockedUsers,
          hiddenPosts: hiddenPosts,
          followers: followers,
          referralId: referralId,
          isLocked: isLocked,
          lockedDate: lockedDate,
          isRider: isRider,
          isDoctor: isDoctor,
          isRestaurant: isRestaurant,
          isLoading: isLoading,
          language: language,
          isEmailVerified: isEmailVerified,
          isPhoneVerified: isPhoneVerified,
          isDeleted: isDeleted,
          countryCode: countryCode,
          auctionUsers: auctionUsers,
          installmentsUsers: installmentsUsers,
          twitterDocumentation: twitterDocumentation,
          username: username,
          createdAt: createdAt,
          updatedAt: updatedAt,
          chatPassword: chatPassword,
        );

  Friends.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    phone = json['phone'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['phone'] = phone;
    return data;
  }
}

// Model for Gifts
class Gifts {
  String? id;
  String? nameAr;
  String? nameEn;
  Picture? picture;
  int? value;
  String? createdAt;
  String? updatedAt;

  Gifts({
    this.id,
    this.nameAr,
    this.nameEn,
    this.picture,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  Gifts.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    nameAr = json['nameAr'];
    nameEn = json['nameEn'];
    picture =
        json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['nameAr'] = nameAr;
    data['nameEn'] = nameEn;
    if (picture != null) {
      data['picture'] = picture!.toJson();
    }
    data['value'] = value;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

// Model for UserData
class UserData {
  String? id;
  String? userId;
  List<Picture>? pictures;
  List<Likes>? likes;
  List<Friends>? friends;
  List<Gifts>? gifts;
  String? createdAt;
  String? updatedAt;
  List<User>? user;

  UserData({
    this.id,
    this.userId,
    this.pictures,
    this.likes,
    this.friends,
    this.gifts,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    if (json['pictures'] != null) {
      pictures = <Picture>[];
      json['pictures'].forEach((v) {
        pictures!.add(Picture.fromJson(v));
      });
    }
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(Likes.fromJson(v));
      });
    }
    if (json['friends'] != null) {
      friends = <Friends>[];
      json['friends'].forEach((v) {
        friends!.add(Friends.fromJson(v));
      });
    }
    if (json['gifts'] != null) {
      gifts = <Gifts>[];
      json['gifts'].forEach((v) {
        gifts!.add(Gifts.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    if (friends != null) {
      data['friends'] = friends!.map((v) => v.toJson()).toList();
    }
    if (gifts != null) {
      data['gifts'] = gifts!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Model for User
class User {
  String? id;
  String? socketId;
  String? firstName;
  String? lastName;
  String? email;
  String? birthday;
  String? hashedPassword;
  String? gender;
  Location? location;
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
  int? phone;

  User({
    this.id,
    this.socketId,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.hashedPassword,
    this.gender,
    this.location,
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
    this.phone,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    socketId = json['socketId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthday = json['birthday'];
    hashedPassword = json['hashedPassword'];
    gender = json['gender'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    adminIgnore = json['adminIgnore'];
    following = json['following'];
    blockedUsers = json['blockedUsers'];
    hiddenPosts = json['hiddenPosts'];
    followers = json['followers'];
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
        : null;
    installmentsUsers = json['installments_users'] != null
        ? List<String>.from(json['installments_users'])
        : null;
    twitterDocumentation = json['twitter_documentation'];
    username = json['username'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chatPassword = json['chatPassword'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['socketId'] = socketId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthday'] = birthday;
    data['hashedPassword'] = hashedPassword;
    data['gender'] = gender;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['adminIgnore'] = adminIgnore;
    data['following'] = following;
    data['blockedUsers'] = blockedUsers;
    data['hiddenPosts'] = hiddenPosts;
    data['followers'] = followers;
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
    data['phone'] = phone;
    return data;
  }
}

// Model for Api
class Api {
  bool? status;
  List<UserData>? data;

  Api({this.status, this.data});

  Api.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
