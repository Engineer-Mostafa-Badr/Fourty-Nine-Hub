
class MessageSharedContactsEntity {
  String name;
  String phoneNumber;
  String? avatar;
  bool isRegistered = false;
  MessageSharedContactsEntity({required this.name, required this.phoneNumber, this.avatar,});

  toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
    };
  }
}
