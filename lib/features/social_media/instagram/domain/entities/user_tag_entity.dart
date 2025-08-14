class UserTagEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final int? imageIndex; // إضافة إندكس الصورة
  final TagPosition? position; // إضافة موقع الضغط

  const UserTagEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    this.imageIndex,
    this.position,
  });

  UserTagEntity copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? imageUrl,
    int? imageIndex,
    TagPosition? position,
  }) {
    return UserTagEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      imageUrl: imageUrl ?? this.imageUrl,
      imageIndex: imageIndex ?? this.imageIndex,
      position: position ?? this.position,
    );
  }
}

class TagPosition {
  final double x;
  final double y;

  const TagPosition({
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}