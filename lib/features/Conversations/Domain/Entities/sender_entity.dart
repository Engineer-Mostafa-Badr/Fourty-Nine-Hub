class SenderEntity {
  final String id;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? profilePicUrl;
  final bool isMe;

  SenderEntity({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.profilePicUrl,
    required this.isMe
});
}