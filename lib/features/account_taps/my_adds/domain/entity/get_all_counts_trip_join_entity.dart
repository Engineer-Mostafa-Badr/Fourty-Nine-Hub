class GetAllCountsTripJoinEntity {
  final String id;
  final String tripId;
  final String userId;
  final String categoryId;
  final dynamic time;
  final String userIdId;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String status;
  final String createdAt;

  GetAllCountsTripJoinEntity(
      {required this.id,
      required this.tripId,
      required this.userId,
      required this.time,
      required this.userIdId,
      required this.categoryId,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.phone,
      required this.status,
      required this.createdAt});
}
