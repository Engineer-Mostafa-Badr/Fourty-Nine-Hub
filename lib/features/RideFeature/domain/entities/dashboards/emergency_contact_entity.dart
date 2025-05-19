class EmergencyContactEntity {
  final String id;
  final String name;
  final String phoneNumber;

  EmergencyContactEntity({required this.id, required this.name, required this.phoneNumber});

  //toJson
  Map<String, dynamic> toJson() => {'name': name, 'phoneNumber': phoneNumber};
}