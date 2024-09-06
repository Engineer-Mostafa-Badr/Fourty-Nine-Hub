class ReceiverId {
  String? id;
  String? firstName;
  String? lastName;

  ReceiverId({this.id, this.firstName, this.lastName});

  @override
  String toString() {
    return 'ReceiverId(id: $id, firstName: $firstName, lastName: $lastName, id: $id)';
  }

  factory ReceiverId.fromJson(Map<String, dynamic> json) => ReceiverId(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
      };
}
