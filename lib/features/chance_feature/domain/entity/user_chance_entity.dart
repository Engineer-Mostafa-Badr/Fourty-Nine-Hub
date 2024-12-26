class UserChanceEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool twitterDocumentation;
  final String image;

  UserChanceEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.twitterDocumentation,
      required this.image});
}
