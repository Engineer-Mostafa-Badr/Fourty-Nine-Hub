class Metadata {
  String? itemId;
  String? firstName;
  String? lastName;
  String? type;

  Metadata({this.itemId, this.firstName, this.lastName, this.type});

  @override
  String toString() {
    return 'Metadata(itemId: $itemId, firstName: $firstName, lastName: $lastName, type: $type)';
  }

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        itemId: json['itemId'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'firstName': firstName,
        'lastName': lastName,
        'type': type,
      };
}
