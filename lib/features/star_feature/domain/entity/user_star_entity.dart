class UserStarEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final num viewNumber;
  final num averageRating;
  final String gender;

  UserStarEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.viewNumber,
    required this.averageRating,
    this.gender = 'male', // Default to male
  });
}
