class UserId {
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  UserId({this.id, this.firstName, this.lastName, this.email,});

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'id': id,
      };
}
