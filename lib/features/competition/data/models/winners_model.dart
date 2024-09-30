class WinnersModel {
  final bool? status;
  final String? message;
  final List<DataWinners>? data;

  WinnersModel({
    this.status,
    this.message,
    this.data,
  });

  factory WinnersModel.fromJson(Map<String, dynamic> json) {
    return WinnersModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => DataWinners.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class DataWinners {
  final String? id;
  final CompetitionId? competitionId;
  final UserId? userId;
  final double? profit;

  DataWinners({
    this.id,
    this.competitionId,
    this.userId,
    this.profit,
  });

  factory DataWinners.fromJson(Map<String, dynamic> json) {
    return DataWinners(
      id: json['_id'] as String?,
      competitionId: json['competition_id'] != null
          ? CompetitionId.fromJson(
              json['competition_id'] as Map<String, dynamic>)
          : null,
      userId: json['user_id'] != null
          ? UserId.fromJson(json['user_id'] as Map<String, dynamic>)
          : null,
      profit: (json['profit'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'competition_id': competitionId?.toJson(),
      'user_id': userId?.toJson(),
      'profit': profit,
    };
  }
}

class CompetitionId {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionEn;
  final String? descriptionAr;
  final int? maxRequests;

  CompetitionId({
    this.id,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.maxRequests,
  });

  factory CompetitionId.fromJson(Map<String, dynamic> json) {
    return CompetitionId(
      id: json['_id'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      maxRequests: json['maxRequests'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'maxRequests': maxRequests,
    };
  }
}

class UserId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final UserProfile? userProfile;
  String get fullName => '$firstName $lastName';

  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.userProfile,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      userProfile: json['USER_PROFILE'] != null
          ? UserProfile.fromJson(json['USER_PROFILE'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'USER_PROFILE': userProfile?.toJson(),
    };
  }
}

class UserProfile {
  final ProfilePictureKey? profilePictureKey;

  UserProfile({
    this.profilePictureKey,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profilePictureKey: json['profilePictureKey'] != null
          ? ProfilePictureKey.fromJson(
              json['profilePictureKey'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profilePictureKey': profilePictureKey?.toJson(),
    };
  }
}

class ProfilePictureKey {
  final String? mediaKey;

  ProfilePictureKey({
    this.mediaKey,
  });

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKey(
      mediaKey: json['mediaKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaKey': mediaKey,
    };
  }
}
