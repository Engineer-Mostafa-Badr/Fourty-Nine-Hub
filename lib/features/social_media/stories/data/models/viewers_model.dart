
// Define the main JSON structure
class ViewersResponse {
  final bool status;
  final List<UserData> data;

  ViewersResponse({
    required this.status,
    required this.data,
  });

  // Parse JSON data
  // factory ViewersResponse.fromJson(String str) =>
  //     ViewersResponse.fromMap(json.decode(str));
  //
  // Convert from map to object
  factory ViewersResponse.fromJson(Map<String, dynamic> json) => ViewersResponse(
        status: json["status"] ?? false, // Default to false if missing
        data: json["data"] != null
            ? List<UserData>.from(json["data"].map((x) => UserData.fromMap(x)))
            : [], // Default to an empty list if "data" is missing
      );
}

// Define user data structure
class UserData {
  final String id;
  final UserViews user;
  final String? story; // Optional field
  final DateTime? createdAt; // Optional field
  final DateTime? updatedAt; // Optional field

  UserData({
    required this.id,
    required this.user,
    this.story,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        id: json["_id"] ?? '',
        // Default to an empty string if missing
        user: UserViews.fromMap(json["user"] ?? {}),
        // Default to an empty map if "user" is missing
        story: json["story"],
        // Nullable, no default value needed
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        // Nullable
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null, // Nullable
      );
}

// Define the user structure
class UserViews {
  final String id;
  final String? firstName; // Optional field
  final String? lastName; // Optional field
  final String? gender; // Optional field
  final UserProfile? profile; // Optional field

  UserViews({
    required this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.profile,
  });

  factory UserViews.fromMap(Map<String, dynamic> json) => UserViews(
        id: json["_id"] ?? '',
        // Required field
        firstName: json["firstName"],
        // Nullable
        lastName: json["lastName"],
        // Nullable
        gender: json["gender"],
        // Nullable
        profile: json["USER_PROFILE"] != null
            ? UserProfile.fromMap(json["USER_PROFILE"])
            : null, // Nullable
      );
}

// Define the user profile structure
class UserProfile {
  final String id;
  final String userId;
  final ProfilePicture? profilePicture; // Optional field

  UserProfile({
    required this.id,
    required this.userId,
    this.profilePicture,
  });

  factory UserProfile.fromMap(Map<String, dynamic> json) => UserProfile(
        id: json["_id"] ?? '', // Required
        userId: json["userId"] ?? '', // Required
        profilePicture: json["profilePictureKey"] != null
            ? ProfilePicture.fromMap(json["profilePictureKey"])
            : null, // Nullable
      );
}

// Define the profile picture structure
class ProfilePicture {
  final String id;
  final String? mediaKey; // Optional field

  ProfilePicture({
    required this.id,
    this.mediaKey,
  });

  factory ProfilePicture.fromMap(Map<String, dynamic> json) => ProfilePicture(
        id: json["_id"] ?? '', // Required
        mediaKey: json["mediaKey"], // Nullable
      );
}
