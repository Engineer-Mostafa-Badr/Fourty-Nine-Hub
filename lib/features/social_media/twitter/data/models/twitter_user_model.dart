import '../../domain/entities/twitter_user_entity.dart';

class TwitterUserModel extends TwitterUserEntity {
  // Optional extras not present on TwitterUserEntity
  final String? gender;
  final int? profileViews;
  final DateTime? joinedAt;          // alias of createdAt from backend ("joinedAt")
  final bool? isAccountVerified;      // raw flag from backend
  final String? profilePictureUrl;    // raw url from backend (also copied into image)

  TwitterUserModel({
    // entity fields
    required super.id,
    required super.firstName,
    required super.lastName,
    super.userName,
    required super.createdAt,
    super.image,
    required super.email,
    required super.isDocumented,
    required super.hasStory,
    // model-only extras
    this.gender,
    this.profileViews,
    this.joinedAt,
    this.isAccountVerified,
    this.profilePictureUrl,
  });

  /// Capitalize helper
  static String _cap(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Pull a nested mediaKey if present
  static String? _mediaKeyFromUserProfile(Map<String, dynamic> map, String key) {
    final up = map['USER_PROFILE'];
    if (up is Map<String, dynamic>) {
      // Try profilePictureUrl.mediaKey
      final ppu = up['profilePictureUrl'];
      if (ppu is Map<String, dynamic>) {
        final mk = ppu['mediaKey']?.toString();
        if (mk != null && mk.trim().isNotEmpty) return mk.trim();
      }
      // Try profilePictureKey.mediaKey (older shape you had)
      final ppk = up['profilePictureKey'];
      if (ppk is Map<String, dynamic>) {
        final mk = ppk['mediaKey']?.toString();
        if (mk != null && mk.trim().isNotEmpty) return mk.trim();
      }
    }
    return null;
  }

  /// Choose best avatar candidate
  static String _bestImage(Map<String, dynamic> m) {
    // 1) image
    final img = (m['image'] ?? '').toString().trim();
    if (img.isNotEmpty) return img;

    // 2) profilePictureUrl (direct string)
    final ppu = (m['profilePictureUrl'] ?? '').toString().trim();
    if (ppu.isNotEmpty) return ppu;

    // 3) USER_PROFILE.profilePictureUrl.mediaKey || profilePictureKey.mediaKey
    final mk = _mediaKeyFromUserProfile(m, 'profilePictureUrl');
    if (mk != null && mk.isNotEmpty) return mk;

    return '';
  }

  factory TwitterUserModel.fromJson(dynamic json) {
    if (json is String) {
      return TwitterUserModel(
        id: json,
        firstName: '',
        lastName: '',
        email: '',
        isDocumented: false,
        hasStory: false,
        createdAt: DateTime.now(),
      );
    }

    if (json is Map<String, dynamic>) {
      // IDs
      final id = (json['_id'] ?? json['id'] ?? json['userId'] ?? '').toString();

      // Names
      final rawFirst = (json['firstName'] ?? '').toString();
      final rawLast  = (json['lastName'] ?? '').toString();

      // Username / handle
      final handle = (json['username'] ?? json['userName'] ?? '').toString();

      // Email
      final email = (json['email'] ?? '').toString();

      // Avatar
      final image = _bestImage(json);

      // Verification → isDocumented
      final isDocumented = (json['verifiedBadge'] as bool?) ??
          (json['twitter_documentation'] as bool?) ??
          (json['isAccountVerified'] as bool?) ??
          false;

      // createdAt (fallback to joinedAt)
      final createdAtStr = (json['createdAt'] ?? json['joinedAt'] ?? '').toString();
      final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();

      // Extras (kept on model only)
      final String? gender = json['gender']?.toString();
      final int? profileViews = () {
        final v = json['profileViews'];
        if (v is int) return v;
        if (v is String) return int.tryParse(v);
        return null;
      }();
      final String? joinedAtStr = json['joinedAt']?.toString();
      final DateTime? joinedAt = joinedAtStr != null ? DateTime.tryParse(joinedAtStr) : null;
      final bool? isAccountVerified = json['isAccountVerified'] is bool ? json['isAccountVerified'] as bool : null;
      final String? profilePictureUrl = (json['profilePictureUrl'] ?? '').toString().trim().isNotEmpty
          ? (json['profilePictureUrl'] as String)
          : null;

      return TwitterUserModel(
        id: id,
        firstName: _cap(rawFirst),
        lastName: _cap(rawLast),
        userName: handle,
        image: image,
        email: email,
        hasStory: (json['hasStory'] as bool?) ?? false,
        isDocumented: isDocumented,
        createdAt: createdAt,
        // extras
        gender: gender,
        profileViews: profileViews,
        joinedAt: joinedAt,
        isAccountVerified: isAccountVerified,
        profilePictureUrl: profilePictureUrl,
      );
    }

    // Fallback
    return TwitterUserModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      isDocumented: false,
      hasStory: false,
      createdAt: DateTime.now(),
    );
  }

  /// ✅ Safe handle
  String get handle {
    if ((userName ?? '').trim().isNotEmpty) return userName!.trim();
    if ((email ?? '').contains('@')) return email!.split('@').first;
    return id;
  }

  /// ✅ Safe avatar
  String? get avatar {
    if ((image ?? '').trim().isNotEmpty) return image!.trim();
    if ((profilePictureUrl ?? '').trim().isNotEmpty) return profilePictureUrl!.trim();
    return null;
  }
}
