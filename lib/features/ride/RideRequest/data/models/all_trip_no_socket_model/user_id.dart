class UserId {
  String? id;
  String? firstName;
  String? email;
  String? gender;
  String? phone;

  UserId({
    this.id,
    this.firstName,
    this.email,
    this.gender,
    this.phone,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'email': email,
        'gender': gender,
        'phone': phone,
      };
}
