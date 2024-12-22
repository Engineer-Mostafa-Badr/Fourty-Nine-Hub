import '../../domain/entity/user_search_entity.dart';

class UserSearchModel extends UserSearchEntity {
  UserSearchModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.gender,
      required super.username,
      required super.phone,
      super.image});

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    // Safely access nested fields with null-aware operators
    final userProfile = json['USER_PROFILE'];
    final profilePictureKey = userProfile?['profilePictureKey'];
    final mediaKey = profilePictureKey?['mediaKey'];

    // Set the default image URL if mediaKey is not found
    String image = (mediaKey is String)
        ? mediaKey
        : 'https://media.istockphoto.com/id/1341046662/th/%E0%B9%80%E0%B8%A7%E0%B8%84%E0%B9%80%E0%B8%95%E0%B8%AD%E0%B8%A3%E0%B9%8C/%E0%B9%84%E0%B8%AD%E0%B8%84%E0%B8%AD%E0%B8%99%E0%B9%82%E0%B8%9B%E0%B8%A3%E0%B9%84%E0%B8%9F%E0%B8%A5%E0%B9%8C%E0%B8%A3%E0%B8%B9%E0%B8%9B%E0%B8%A0%E0%B8%B2%E0%B8%9E-%E0%B8%A1%E0%B8%99%E0%B8%B8%E0%B8%A9%E0%B8%A2%E0%B9%8C%E0%B8%AB%E0%B8%A3%E0%B8%B7%E0%B8%AD%E0%B8%84%E0%B8%99%E0%B8%A5%E0%B8%87%E0%B8%99%E0%B8%B2%E0%B8%A1%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B8%AA%E0%B8%B1%E0%B8%8D%E0%B8%A5%E0%B8%B1%E0%B8%81%E0%B8%A9%E0%B8%93%E0%B9%8C%E0%B8%AA%E0%B9%8D%E0%B8%B2%E0%B8%AB%E0%B8%A3%E0%B8%B1%E0%B8%9A%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%AD%E0%B8%AD%E0%B8%81%E0%B9%81%E0%B8%9A%E0%B8%9A%E0%B9%81%E0%B8%A1%E0%B9%88%E0%B9%81%E0%B8%9A%E0%B8%9A.jpg?s=612x612&w=0&k=20&c=4AKj44oKTzug4mOe-bNP9hLOhU_qAWL8GypitfgxFyQ=';

    return UserSearchModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      image: image,
    );
  }
}
