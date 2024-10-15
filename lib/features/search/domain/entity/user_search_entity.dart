class UserSearchEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String username;
  final String phone;
  final String? image;

  UserSearchEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.gender,
      required this.username,
      required this.phone,
       this.image});
}
