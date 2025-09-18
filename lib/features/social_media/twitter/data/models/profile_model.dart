// lib/features/social_media/twitter/domain/entities/twitter_profile_entity.dart

class TwitterProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final DateTime joinedAt;
  final bool isVerified;
  final bool isMe;
  final bool isFollowing;
  final int followersCount;
  final int followingCount;

  // NEW
  final String? gender;       // "male"/"female"/etc
  final int? profileViews;    // e.g. 10

  const TwitterProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.joinedAt,
    required this.isVerified,
    required this.isMe,
    required this.isFollowing,
    required this.followersCount,
    required this.followingCount,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    // NEW
    this.gender,
    this.profileViews,
  });

  String get displayName {
    final full = ('$firstName $lastName').trim();
    return full.isEmpty ? userName : full;
  }

  TwitterProfileEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? userName,
    String? bio,
    String? avatarUrl,
    String? coverUrl,
    DateTime? joinedAt,
    bool? isVerified,
    bool? isMe,
    bool? isFollowing,
    int? followersCount,
    int? followingCount,
    // NEW
    String? gender,
    int? profileViews,
  }) {
    return TwitterProfileEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      isVerified: isVerified ?? this.isVerified,
      isMe: isMe ?? this.isMe,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      // NEW
      gender: gender ?? this.gender,
      profileViews: profileViews ?? this.profileViews,
    );
  }
}
class TwitterProfileModel extends TwitterProfileEntity {
  const TwitterProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.userName,
    required super.joinedAt,
    required super.isVerified,
    required super.isMe,
    required super.isFollowing,
    required super.followersCount,
    required super.followingCount,
    super.bio,
    super.avatarUrl,
    super.coverUrl,
    // NEW
    super.gender,
    super.profileViews,
  });

  static bool _b(v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v.trim().toLowerCase() == 'true' || v == '1';
    return false;
  }

  factory TwitterProfileModel.fromJson(Map<String, dynamic> json, {String? meId}) {
    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final joinedRaw = (json['joinedAt'] ?? json['createdAt'] ?? '').toString();
    final joinedAt = DateTime.tryParse(joinedRaw) ?? DateTime.now();

    final image = (json['image'] ?? json['profilePictureUrl'] ?? '').toString();
    final cover = (json['coverUrl'] ?? json['coverImage'] ?? '').toString();

    final verified = _b(json['isAccountVerified']) ||
        _b(json['verifiedBadge']) ||
        _b(json['twitter_documentation']);

    final followers = int.tryParse('${json['followersCount'] ?? json['followers'] ?? 0}') ?? 0;
    final following = int.tryParse('${json['followingCount'] ?? json['following'] ?? 0}') ?? 0;

    // NEW
    final String? gender = (json['gender'] as String?)?.trim();
    final int? profileViews = () {
      final v = json['profileViews'];
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      if (v is num) return v.toInt();
      return null;
    }();

    return TwitterProfileModel(
      id: id,
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      userName: (json['userName'] ?? json['username'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString().trim().isEmpty ? null : (json['bio'] ?? '').toString(),
      avatarUrl: image.isEmpty ? null : image,
      coverUrl: cover.isEmpty ? null : cover,
      joinedAt: joinedAt,
      isVerified: verified,
      isMe: meId != null && meId == id,
      isFollowing: _b(json['isFollowing']),
      followersCount: followers,
      followingCount: following,
      // NEW
      gender: gender,
      profileViews: profileViews,
    );
  }
}
