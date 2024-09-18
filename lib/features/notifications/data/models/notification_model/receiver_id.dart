class ReceiverInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? gender;

  ReceiverInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
  });

  @override
  String toString() {
    return 'ReceiverId(id: $id, firstName: $firstName, lastName: $lastName, id: $id, gender: $gender)';
  }

  factory ReceiverInfo.fromJson(Map<String, dynamic> json) => ReceiverInfo(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        gender: json['gender'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
      };
}
