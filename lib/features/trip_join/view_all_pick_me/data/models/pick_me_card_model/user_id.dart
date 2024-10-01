class UserId {
  String? id;
  String? firstName;
  String? email;
  String? gender;

  UserId({this.id, this.firstName, this.email, this.gender});

  @override
  String toString() {
    return 'UserId(id: $id, firstName: $firstName, email: $email, gender: $gender, )';
  }

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'email': email,
        'gender': gender,
        'id': id,
      };
}
