class UserProfile {
  String? id;
  String? userId;
  String? profilePictureKey;

  UserProfile({this.id, this.userId, this.profilePictureKey});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        profilePictureKey: json['profilePictureKey'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'profilePictureKey': profilePictureKey,
      };
}
