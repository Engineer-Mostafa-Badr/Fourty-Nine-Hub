// // // class UserData {
// // //   String id;
// // //   String userId;
// // //   List<Picture> pictures;
// // //   List<Like> likes;
// // //   List<Friend> friends;
// // //   List<Gift> gifts;
// // //   List<User> users;
// // //   String createdAt;
// // //   String updatedAt;
//
// // //   UserData({
// // //     required this.id,
// // //     required this.userId,
// // //     required this.pictures,
// // //     required this.likes,
// // //     required this.friends,
// // //     required this.gifts,
// // //     required this.users,
// // //     required this.createdAt,
// // //     required this.updatedAt,
// // //   });
//
// // //   factory UserData.fromJson(Map<String, dynamic> json) {
// // //     return UserData(
// // //       id: json['_id'],
// // //       userId: json['userId'],
// // //       pictures: (json['pictures'] as List).map((i) => Picture.fromJson(i)).toList(),
// // //       likes: (json['likes'] as List).map((i) => Like.fromJson(i)).toList(),
// // //       friends: (json['friends'] as List).map((i) => Friend.fromJson(i)).toList(),
// // //       gifts: (json['gifts'] as List).map((i) => Gift.fromJson(i)).toList(),
// // //       users: (json['user'] as List).map((i) => User.fromJson(i)).toList(),
// // //       createdAt: json['createdAt'],
// // //       updatedAt: json['updatedAt'],
// // //     );
// // //   }
// // // }
// // // class Picture {
// // //   String id;
// // //   String mediaKey;
//
// // //   Picture({
// // //     required this.id,
// // //     required this.mediaKey,
// // //   });
//
// // //   factory Picture.fromJson(Map<String, dynamic> json) {
// // //     return Picture(
// // //       id: json['_id'],
// // //       mediaKey: json['mediaKey'],
// // //     );
// // //   }
// // // }
// // // class Like {
// // //   String id;
// // //   String socketId;
// // //   String firstName;
// // //   String lastName;
// // //   String email;
// // //   dynamic birthday;
// // //   String hashedPassword;
// // //   String gender;
// // //   LocationData location;
// // //   bool adminIgnore;
// // //   List<dynamic> following;
// // //   List<dynamic> blockedUsers;
// // //   List<dynamic> hiddenPosts;
// // //   List<dynamic> followers;
// // //   String referralId;
// // //   bool isLocked;
// // //   dynamic lockedDate;
// // //   bool isRider;
// // //   bool isDoctor;
// // //   bool isRestaurant;
// // //   bool isLoading;
// // //   String language;
// // //   bool isEmailVerified;
// // //   bool isPhoneVerified;
// // //   bool isDeleted;
// // //   String countryCode;
// // //   List<dynamic> auctionUsers;
// // //   List<dynamic> installmentsUsers;
// // //   bool twitterDocumentation;
// // //   String username;
// // //   String createdAt;
// // //   String updatedAt;
// // //   String? chatPassword;
// // //   int? phone;
//
// // //   Like({
// // //     required this.id,
// // //     required this.socketId,
// // //     required this.firstName,
// // //     required this.lastName,
// // //     required this.email,
// // //     this.birthday,
// // //     required this.hashedPassword,
// // //     required this.gender,
// // //     required this.location,
// // //     required this.adminIgnore,
// // //     required this.following,
// // //     required this.blockedUsers,
// // //     required this.hiddenPosts,
// // //     required this.followers,
// // //     required this.referralId,
// // //     required this.isLocked,
// // //     this.lockedDate,
// // //     required this.isRider,
// // //     required this.isDoctor,
// // //     required this.isRestaurant,
// // //     required this.isLoading,
// // //     required this.language,
// // //     required this.isEmailVerified,
// // //     required this.isPhoneVerified,
// // //     required this.isDeleted,
// // //     required this.countryCode,
// // //     required this.auctionUsers,
// // //     required this.installmentsUsers,
// // //     required this.twitterDocumentation,
// // //     required this.username,
// // //     required this.createdAt,
// // //     required this.updatedAt,
// // //     this.chatPassword,
// // //     this.phone,
// // //   });
//
// // //   factory Like.fromJson(Map<String, dynamic> json) {
// // //     return Like(
// // //       id: json['_id'],
// // //       socketId: json['socketId'],
// // //       firstName: json['firstName'],
// // //       lastName: json['lastName'],
// // //       email: json['email'],
// // //       birthday: json['birthday'],
// // //       hashedPassword: json['hashedPassword'],
// // //       gender: json['gender'],
// // //       location: LocationData.fromJson(json['location']),
// // //       adminIgnore: json['adminIgnore'],
// // //       following: List<dynamic>.from(json['following']),
// // //       blockedUsers: List<dynamic>.from(json['blockedUsers']),
// // //       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
// // //       followers: List<dynamic>.from(json['followers']),
// // //       referralId: json['referralId'],
// // //       isLocked: json['isLocked'],
// // //       lockedDate: json['lockedDate'],
// // //       isRider: json['isRider'],
// // //       isDoctor: json['isDoctor'],
// // //       isRestaurant: json['isRestaurant'],
// // //       isLoading: json['isLoading'],
// // //       language: json['language'],
// // //       isEmailVerified: json['isEmailVerified'],
// // //       isPhoneVerified: json['isPhoneVerified'],
// // //       isDeleted: json['isDeleted'],
// // //       countryCode: json['countryCode'],
// // //       auctionUsers: List<dynamic>.from(json['auction_users']),
// // //       installmentsUsers: List<dynamic>.from(json['installments_users']),
// // //       twitterDocumentation: json['twitter_documentation'],
// // //       username: json['username'],
// // //       createdAt: json['createdAt'],
// // //       updatedAt: json['updatedAt'],
// // //       chatPassword: json['chatPassword'],
// // //       phone: json['phone'],
// // //     );
// // //   }
// // // }
// // // class Friend {
// // //   String id;
// // //   String socketId;
// // //   String firstName;
// // //   String lastName;
// // //   String email;
// // //   dynamic birthday;
// // //   String hashedPassword;
// // //   String gender;
// // //   LocationData location;
// // //   bool adminIgnore;
// // //   List<dynamic> following;
// // //   List<dynamic> blockedUsers;
// // //   List<dynamic> hiddenPosts;
// // //   List<dynamic> followers;
// // //   String referralId;
// // //   bool isLocked;
// // //   dynamic lockedDate;
// // //   bool isRider;
// // //   bool isDoctor;
// // //   bool isRestaurant;
// // //   bool isLoading;
// // //   String language;
// // //   bool isEmailVerified;
// // //   bool isPhoneVerified;
// // //   bool isDeleted;
// // //   String countryCode;
// // //   List<dynamic> auctionUsers;
// // //   List<dynamic> installmentsUsers;
// // //   bool twitterDocumentation;
// // //   String username;
// // //   String createdAt;
// // //   String updatedAt;
// // //   String? chatPassword;
// // //   int? phone;
//
// // //   Friend({
// // //     required this.id,
// // //     required this.socketId,
// // //     required this.firstName,
// // //     required this.lastName,
// // //     required this.email,
// // //     this.birthday,
// // //     required this.hashedPassword,
// // //     required this.gender,
// // //     required this.location,
// // //     required this.adminIgnore,
// // //     required this.following,
// // //     required this.blockedUsers,
// // //     required this.hiddenPosts,
// // //     required this.followers,
// // //     required this.referralId,
// // //     required this.isLocked,
// // //     this.lockedDate,
// // //     required this.isRider,
// // //     required this.isDoctor,
// // //     required this.isRestaurant,
// // //     required this.isLoading,
// // //     required this.language,
// // //     required this.isEmailVerified,
// // //     required this.isPhoneVerified,
// // //     required this.isDeleted,
// // //     required this.countryCode,
// // //     required this.auctionUsers,
// // //     required this.installmentsUsers,
// // //     required this.twitterDocumentation,
// // //     required this.username,
// // //     required this.createdAt,
// // //     required this.updatedAt,
// // //     this.chatPassword,
// // //     this.phone,
// // //   });
//
// // //   factory Friend.fromJson(Map<String, dynamic> json) {
// // //     return Friend(
// // //       id: json['_id'],
// // //       socketId: json['socketId'],
// // //       firstName: json['firstName'],
// // //       lastName: json['lastName'],
// // //       email: json['email'],
// // //       birthday: json['birthday'],
// // //       hashedPassword: json['hashedPassword'],
// // //       gender: json['gender'],
// // //       location: LocationData.fromJson(json['location']),
// // //       adminIgnore: json['adminIgnore'],
// // //       following: List<dynamic>.from(json['following']),
// // //       blockedUsers: List<dynamic>.from(json['blockedUsers']),
// // //       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
// // //       followers: List<dynamic>.from(json['followers']),
// // //       referralId: json['referralId'],
// // //       isLocked: json['isLocked'],
// // //       lockedDate: json['lockedDate'],
// // //       isRider: json['isRider'],
// // //       isDoctor: json['isDoctor'],
// // //       isRestaurant: json['isRestaurant'],
// // //       isLoading: json['isLoading'],
// // //       language: json['language'],
// // //       isEmailVerified: json['isEmailVerified'],
// // //       isPhoneVerified: json['isPhoneVerified'],
// // //       isDeleted: json['isDeleted'],
// // //       countryCode: json['countryCode'],
// // //       auctionUsers: List<dynamic>.from(json['auction_users']),
// // //       installmentsUsers: List<dynamic>.from(json['installments_users']),
// // //       twitterDocumentation: json['twitter_documentation'],
// // //       username: json['username'],
// // //       createdAt: json['createdAt'],
// // //       updatedAt: json['updatedAt'],
// // //       chatPassword: json['chatPassword'],
// // //       phone: json['phone'],
// // //     );
// // //   }
// // // }
// // // class Gift {
// // //   String id;
// // //   String nameAr;
// // //   String nameEn;
// // //   Picture picture;
//
// // //   Gift({
// // //     required this.id,
// // //     required this.nameAr,
// // //     required this.nameEn,
// // //     required this.picture,
// // //   });
//
// // //   factory Gift.fromJson(Map<String, dynamic> json) {
// // //     return Gift(
// // //       id: json['_id'],
// // //       nameAr: json['nameAr'],
// // //       nameEn: json['nameEn'],
// // //       picture: Picture.fromJson(json['picture']),
// // //     );
// // //   }
// // // }
// // // class User {
// // //   String id;
// // //   String socketId;
// // //   String firstName;
// // //   String lastName;
// // //   String email;
// // //   dynamic birthday;
// // //   String hashedPassword;
// // //   String gender;
// // //   LocationData location;
// // //   bool adminIgnore;
// // //   List<dynamic> following;
// // //   List<dynamic> blockedUsers;
// // //   List<dynamic> hiddenPosts;
// // //   List<dynamic> followers;
// // //   String referralId;
// // //   bool isLocked;
// // //   dynamic lockedDate;
// // //   bool isRider;
// // //   bool isDoctor;
// // //   bool isRestaurant;
// // //   bool isLoading;
// // //   String language;
// // //   bool isEmailVerified;
// // //   bool isPhoneVerified;
// // //   bool isDeleted;
// // //   String countryCode;
// // //   List<dynamic> auctionUsers;
// // //   List<dynamic> installmentsUsers;
// // //   bool twitterDocumentation;
// // //   String username;
// // //   String createdAt;
// // //   String updatedAt;
// // //   String? chatPassword;
// // //   int? phone;
//
// // //   User({
// // //     required this.id,
// // //     required this.socketId,
// // //     required this.firstName,
// // //     required this.lastName,
// // //     required this.email,
// // //     this.birthday,
// // //     required this.hashedPassword,
// // //     required this.gender,
// // //     required this.location,
// // //     required this.adminIgnore,
// // //     required this.following,
// // //     required this.blockedUsers,
// // //     required this.hiddenPosts,
// // //     required this.followers,
// // //     required this.referralId,
// // //     required this.isLocked,
// // //     this.lockedDate,
// // //     required this.isRider,
// // //     required this.isDoctor,
// // //     required this.isRestaurant,
// // //     required this.isLoading,
// // //     required this.language,
// // //     required this.isEmailVerified,
// // //     required this.isPhoneVerified,
// // //     required this.isDeleted,
// // //     required this.countryCode,
// // //     required this.auctionUsers,
// // //     required this.installmentsUsers,
// // //     required this.twitterDocumentation,
// // //     required this.username,
// // //     required this.createdAt,
// // //     required this.updatedAt,
// // //     this.chatPassword,
// // //     this.phone,
// // //   });
//
// // //   factory User.fromJson(Map<String, dynamic> json) {
// // //     return User(
// // //       id: json['_id'],
// // //       socketId: json['socketId'],
// // //       firstName: json['firstName'],
// // //       lastName: json['lastName'],
// // //       email: json['email'],
// // //       birthday: json['birthday'],
// // //       hashedPassword: json['hashedPassword'],
// // //       gender: json['gender'],
// // //       location: LocationData.fromJson(json['location']),
// // //       adminIgnore: json['adminIgnore'],
// // //       following: List<dynamic>.from(json['following']),
// // //       blockedUsers: List<dynamic>.from(json['blockedUsers']),
// // //       hiddenPosts: List<dynamic>.from(json['hiddenPosts']),
// // //       followers: List<dynamic>.from(json['followers']),
// // //       referralId: json['referralId'],
// // //       isLocked: json['isLocked'],
// // //       lockedDate: json['lockedDate'],
// // //       isRider: json['isRider'],
// // //       isDoctor: json['isDoctor'],
// // //       isRestaurant: json['isRestaurant'],
// // //       isLoading: json['isLoading'],
// // //       language: json['language'],
// // //       isEmailVerified: json['isEmailVerified'],
// // //       isPhoneVerified: json['isPhoneVerified'],
// // //       isDeleted: json['isDeleted'],
// // //       countryCode: json['countryCode'],
// // //       auctionUsers: List<dynamic>.from(json['auction_users']),
// // //       installmentsUsers: List<dynamic>.from(json['installments_users']),
// // //       twitterDocumentation: json['twitter_documentation'],
// // //       username: json['username'],
// // //       createdAt: json['createdAt'],
// // //       updatedAt: json['updatedAt'],
// // //       chatPassword: json['chatPassword'],
// // //       phone: json['phone'],
// // //     );
// // //   }
// // // }
// // // class LocationData {
// // //   String type;
// // //   List<int> coordinates;
//
// // //   LocationData({
// // //     required this.type,
// // //     required this.coordinates,
// // //   });
//
// // //   factory LocationData.fromJson(Map<String, dynamic> json) {
// // //     return LocationData(
// // //       type: json['type'],
// // //       coordinates: List<int>.from(json['coordinates']),
// // //     );
// // //   }
// // // }
// // class ApiResponse {
// //   bool status;
// //   List<UserData> data;
//
// //   ApiResponse({
// //     required this.status,
// //     required this.data,
// //   });
//
// //   factory ApiResponse.fromJson(Map<String, dynamic> json) {
// //     return ApiResponse(
// //       status: json['status'],
// //       data: (json['data'] as List).map((i) => UserData.fromJson(i)).toList(),
// //     );
// //   }
// // }
//
// // class UserData {
// //   String id;
// //   String userId;
// //   List<Picture> pictures;
// //   List<Like> likes;
// //   List<Friend> friends;
// //   List<Gift> gifts;
// //   String createdAt;
// //   String updatedAt;
// //   List<User> users;
//
// //   UserData({
// //     required this.id,
// //     required this.userId,
// //     required this.pictures,
// //     required this.likes,
// //     required this.friends,
// //     required this.gifts,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     required this.users,
// //   });
//
// //   factory UserData.fromJson(Map<String, dynamic> json) {
// //     return UserData(
// //       id: json['_id'],
// //       userId: json['userId'],
// //       pictures:
// //           (json['pictures'] as List).map((i) => Picture.fromJson(i)).toList(),
// //       likes: (json['likes'] as List).map((i) => Like.fromJson(i)).toList(),
// //       friends:
// //           (json['friends'] as List).map((i) => Friend.fromJson(i)).toList(),
// //       gifts: (json['gifts'] as List).map((i) => Gift.fromJson(i)).toList(),
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //       users: (json['user'] as List).map((i) => User.fromJson(i)).toList(),
// //     );
// //   }
// // }
//
// // class Picture {
// //   String id;
// //   String mediaKey;
//
// //   Picture({
// //     required this.id,
// //     required this.mediaKey,
// //   });
//
// //   factory Picture.fromJson(Map<String, dynamic> json) {
// //     return Picture(
// //       id: json['_id'],
// //       mediaKey: json['mediaKey'],
// //     );
// //   }
// // }
//
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
//
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
//
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
//
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
//
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
//
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
//
// // class Gift {
// //   String id;
// //   String nameAr;
// //   String nameEn;
// //   Picture picture;
// //   int value;
// //   String createdAt;
// //   String updatedAt;
//
// //   Gift({
// //     required this.id,
// //     required this.nameAr,
// //     required this.nameEn,
// //     required this.picture,
// //     required this.value,
// //     required this.createdAt,
// //     required this.updatedAt,
// //   });
//
// //   factory Gift.fromJson(Map<String, dynamic> json) {
// //     return Gift(
// //       id: json['_id'],
// //       nameAr: json['nameAr'],
// //       nameEn: json['nameEn'],
// //       picture: Picture.fromJson(json['picture']),
// //       value: json['value'],
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //     );
// //   }
// // }
//
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
//
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
//
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
//
// // class LocationData {
// //   String type;
// //   List<int> coordinates;
//
// //   LocationData({
// //     required this.type,
// //     required this.coordinates,
// //   });
//
// //   factory LocationData.fromJson(Map<String, dynamic> json) {
// //     return LocationData(
// //       type: json['type'],
// //       coordinates: List<int>.from(json['coordinates']),
// //     );
// //   }
// // }
// //.............................
// // class UserData {
// //   String? sId;
// //   List<Pictures>? pictures;
// //   User? user;
// //
// //   UserData({this.sId, this.pictures, this.user});
// //
// //   UserData.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     if (json['pictures'] != null) {
// //       pictures = <Pictures>[];
// //       json['pictures'].forEach((v) {
// //         pictures!.add(new Pictures.fromJson(v));
// //       });
// //     }
// //     user = json['user'] != null ? new User.fromJson(json['user']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     if (this.pictures != null) {
// //       data['pictures'] = this.pictures!.map((v) => v.toJson()).toList();
// //     }
// //     if (this.user != null) {
// //       data['user'] = this.user!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Pictures {
// //   String? sId;
// //   String? mediaKey;
// //
// //   Pictures({this.sId, this.mediaKey});
// //
// //   Pictures.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     mediaKey = json['mediaKey'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['mediaKey'] = this.mediaKey;
// //     return data;
// //   }
// // }
// //
// // class User {
// //   String? firstName;
// //   String? lastName;
// //   String? email;
// //   String? gender;
// //   Location? location;
// //
// //   User({this.firstName, this.lastName, this.email, this.gender, this.location});
// //
// //   User.fromJson(Map<String, dynamic> json) {
// //     firstName = json['firstName'];
// //     lastName = json['lastName'];
// //     email = json['email'];
// //     gender = json['gender'];
// //     location = json['location'] != null
// //         ? new Location.fromJson(json['location'])
// //         : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['firstName'] = this.firstName;
// //     data['lastName'] = this.lastName;
// //     data['email'] = this.email;
// //     data['gender'] = this.gender;
// //     if (this.location != null) {
// //       data['location'] = this.location!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Location {
// //   String? type;
// //   List<int>? coordinates;
// //
// //   Location({this.type, this.coordinates});
// //
// //   Location.fromJson(Map<String, dynamic> json) {
// //     type = json['type'];
// //     coordinates = json['coordinates'].cast<int>();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['type'] = this.type;
// //     data['coordinates'] = this.coordinates;
// //     return data;
// //   }
// // }
// //
// //
// // // Model for Api
// // class Api {
// //   bool? status;
// //   List<UserData>? data;
// //
// //   Api({this.status, this.data});
// //
// //   Api.fromJson(Map<String, dynamic> json) {
// //     status = json['status'];
// //     if (json['data'] != null) {
// //       data = <UserData>[];
// //       json['data'].forEach((v) {
// //         data!.add(UserData.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['status'] = status;
// //     if (this.data != null) {
// //       data['data'] = this.data!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //...............
// // class Api {
// //   bool? status;
// //   List<UserData>? data;
// //
// //   Api({this.status, this.data});
// //
// //   Api.fromJson(Map<String, dynamic> json) {
// //     status = json['status'];
// //     if (json['data'] != null) {
// //       data = <UserData>[];
// //       json['data'].forEach((v) {
// //         data!.add(new UserData.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['status'] = this.status;
// //     if (this.data != null) {
// //       data['data'] = this.data!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class UserData {
// //   String? sId;
// //   List<Pictures>? pictures;
// //   User? user;
// //   int? followersCount;
// //   int? followingCount;
// //   int? friendsCount;
// //
// //   UserData(
// //       {this.sId,
// //         this.pictures,
// //         this.user,
// //         this.followersCount,
// //         this.followingCount,
// //         this.friendsCount});
// //
// //   UserData.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     if (json['pictures'] != null) {
// //       pictures = <Pictures>[];
// //       json['pictures'].forEach((v) {
// //         pictures!.add(new Pictures.fromJson(v));
// //       });
// //     }
// //     user = json['user'] != null ? new User.fromJson(json['user']) : null;
// //     followersCount = json['followersCount'];
// //     followingCount = json['followingCount'];
// //     friendsCount = json['friendsCount'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     if (this.pictures != null) {
// //       data['pictures'] = this.pictures!.map((v) => v.toJson()).toList();
// //     }
// //     if (this.user != null) {
// //       data['user'] = this.user!.toJson();
// //     }
// //     data['followersCount'] = this.followersCount;
// //     data['followingCount'] = this.followingCount;
// //     data['friendsCount'] = this.friendsCount;
// //     return data;
// //   }
// // }
// //
// // class Pictures {
// //   String? sId;
// //   String? mediaKey;
// //
// //   Pictures({this.sId, this.mediaKey});
// //
// //   Pictures.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     mediaKey = json['mediaKey'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['mediaKey'] = this.mediaKey;
// //     return data;
// //   }
// // }
// //
// // class User {
// //   String? firstName;
// //   String? lastName;
// //   String? email;
// //   String? birthday;
// //   String? gender;
// //   Location? location;
// //
// //   User(
// //       {this.firstName,
// //         this.lastName,
// //         this.email,
// //         this.birthday,
// //         this.gender,
// //         this.location});
// //
// //   User.fromJson(Map<String, dynamic> json) {
// //     firstName = json['firstName'];
// //     lastName = json['lastName'];
// //     email = json['email'];
// //     birthday = json['birthday'];
// //     gender = json['gender'];
// //     location = json['location'] != null
// //         ? new Location.fromJson(json['location'])
// //         : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['firstName'] = this.firstName;
// //     data['lastName'] = this.lastName;
// //     data['email'] = this.email;
// //     data['birthday'] = this.birthday;
// //     data['gender'] = this.gender;
// //     if (this.location != null) {
// //       data['location'] = this.location!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Location {
// //   String? type;
// //   List<double>? coordinates;
// //
// //   Location({this.type, this.coordinates});
// //
// //   Location.fromJson(Map<String, dynamic> json) {
// //     type = json['type'];
// //     coordinates = json['coordinates'].cast<double>();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['type'] = this.type;
// //     data['coordinates'] = this.coordinates;
// //     return data;
// //   }
// // }
// //------------------------------------------------------
// // class Api {
// //   bool? status;
// //   List<UserData>? data;
// //
// //   Api({this.status, this.data});
// //
// //   Api.fromJson(Map<String, dynamic> json) {
// //     status = json['status'];
// //     if (json['data'] != null) {
// //       data = <UserData>[];
// //       json['data'].forEach((v) {
// //         data!.add(new UserData.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['status'] = this.status;
// //     if (this.data != null) {
// //       data['data'] = this.data!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class UserData {
// //   String? sId;
// //   List<Pictures>? pictures;
// //   User? user;
// //   int? followersCount;
// //   int? followingCount;
// //   int? friendsCount;
// //
// //   UserData(
// //       {this.sId,
// //         this.pictures,
// //         this.user,
// //         this.followersCount,
// //         this.followingCount,
// //         this.friendsCount});
// //
// //   UserData.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     if (json['pictures'] != null) {
// //       pictures = <Pictures>[];
// //       json['pictures'].forEach((v) {
// //         pictures!.add(new Pictures.fromJson(v));
// //       });
// //     }
// //     user = json['user'] != null ? new User.fromJson(json['user']) : null;
// //     followersCount = json['followersCount'];
// //     followingCount = json['followingCount'];
// //     friendsCount = json['friendsCount'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     if (this.pictures != null) {
// //       data['pictures'] = this.pictures!.map((v) => v.toJson()).toList();
// //     }
// //     if (this.user != null) {
// //       data['user'] = this.user!.toJson();
// //     }
// //     data['followersCount'] = this.followersCount;
// //     data['followingCount'] = this.followingCount;
// //     data['friendsCount'] = this.friendsCount;
// //     return data;
// //   }
// // }
// //
// // class Pictures {
// //   String? sId;
// //   String? mediaKey;
// //
// //   Pictures({this.sId, this.mediaKey});
// //
// //   Pictures.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     mediaKey = json['mediaKey'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['mediaKey'] = this.mediaKey;
// //     return data;
// //   }
// // }
// //
// // class User {
// //   String? sId;
// //   String? firstName;
// //   String? lastName;
// //   String? email;
// //   String? birthday;
// //   String? gender;
// //   Location? location;
// //
// //   User(
// //       {this.sId,
// //         this.firstName,
// //         this.lastName,
// //         this.email,
// //         this.birthday,
// //         this.gender,
// //         this.location});
// //
// //   User.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     firstName = json['firstName'];
// //     lastName = json['lastName'];
// //     email = json['email'];
// //     birthday = json['birthday'];
// //     gender = json['gender'];
// //     location = json['location'] != null
// //         ? new Location.fromJson(json['location'])
// //         : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['firstName'] = this.firstName;
// //     data['lastName'] = this.lastName;
// //     data['email'] = this.email;
// //     data['birthday'] = this.birthday;
// //     data['gender'] = this.gender;
// //     if (this.location != null) {
// //       data['location'] = this.location!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Location {
// //   String? type;
// //   List<double>? coordinates;
// //
// //   Location({this.type, this.coordinates});
// //
// //   Location.fromJson(Map<String, dynamic> json) {
// //     type = json['type'];
// //     coordinates = json['coordinates'].cast<double>();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['type'] = this.type;
// //     data['coordinates'] = this.coordinates;
// //     return data;
// //   }
// // }
// import 'dart:convert';
//
// class UserModel {
//   final bool status;
//   final List<UserData> data;
//
//   UserModel({
//     required this.status,
//     required this.data,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       status: json['status'],
//       data: List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'data': List<dynamic>.from(data.map((x) => x.toJson())),
//     };
//   }
// }
//
// class UserData {
//   final String? id;
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? birthday;
//   final String? gender;
//   final Location? location;
//   final UserPicture? profilePicture;
//   final int followersCount;
//   final int followingCount;
//   final int friendsCount;
//   final List<Picture> pictures;
//
//   UserData({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.birthday,
//     this.gender,
//     this.location,
//     this.profilePicture,
//     required this.followersCount,
//     required this.followingCount,
//     required this.friendsCount,
//     required this.pictures,
//   });
//
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['_id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       birthday: json['birthday'],
//       gender: json['gender'],
//       location: json['location'] != null
//           ? Location.fromJson(json['location'])
//           : null,
//       profilePicture: json['profilePicture'] != null
//           ? UserPicture.fromJson(json['profilePicture'])
//           : null,
//       followersCount: json['followersCount'] ?? 0,
//       followingCount: json['followingCount'] ?? 0,
//       friendsCount: json['friendsCount'] ?? 0,
//       pictures: json['pictures'] != null
//           ? List<Picture>.from(
//         json['pictures'].map((x) => Picture.fromJson(x)),
//       )
//           : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'birthday': birthday,
//       'gender': gender,
//       'location': location?.toJson(),
//       'profilePicture': profilePicture?.toJson(),
//       'followersCount': followersCount,
//       'followingCount': followingCount,
//       'friendsCount': friendsCount,
//       'pictures': List<dynamic>.from(pictures.map((x) => x.toJson())),
//     };
//   }
// }
//
// class Location {
//   final String type;
//   final List<double> coordinates;
//
//   Location({
//     required this.type,
//     required this.coordinates,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       type: json['type'],
//       coordinates:
//       List<double>.from(json['coordinates'].map((x) => x.toDouble())),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
//     };
//   }
// }
//
// class UserPicture {
//   final String mediaKey;
//
//   UserPicture({
//     required this.mediaKey,
//   });
//
//   factory UserPicture.fromJson(String json) {
//     return UserPicture(
//       mediaKey: json,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'mediaKey': mediaKey,
//     };
//   }
// }
//
// class Picture {
//   final String id;
//   final String mediaKey;
//
//   Picture({
//     required this.id,
//     required this.mediaKey,
//   });
//
//   factory Picture.fromJson(Map<String, dynamic> json) {
//     return Picture(
//       id: json['_id'],
//       mediaKey: json['mediaKey'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'mediaKey': mediaKey,
//     };
//   }
// }
class UserModel {
  final bool status;
  final List<UserData> data;

  UserModel({
    required this.status,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      data: List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class UserData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? birthday;
  final String? gender;
  final Location? location;
  final String? profilePicture;
  final int followersCount;
  final int followingCount;
  final int friendsCount;
  final List<TinderUserPicture> pictures;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.gender,
    this.location,
    this.profilePicture,
    required this.followersCount,
    required this.followingCount,
    required this.friendsCount,
    required this.pictures,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthday: json['birthday'],
      gender: json['gender'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      profilePicture: json['profilePicture'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      friendsCount: json['friendsCount'] ?? 0,
      pictures: json['pictures'] != null
          ? List<TinderUserPicture>.from(
              json['pictures'].map((x) => TinderUserPicture.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'location': location?.toJson(),
      'profilePicture': profilePicture,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'friendsCount': friendsCount,
      'pictures': List<dynamic>.from(pictures.map((x) => x.toJson())),
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates:
          List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
    };
  }
}

class TinderUserPicture {
  final String id;
  final String mediaKey;

  TinderUserPicture({
    required this.id,
    required this.mediaKey,
  });

  factory TinderUserPicture.fromJson(Map<String, dynamic> json) {
    return TinderUserPicture(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}
