class DriverEntity {
  final int id;
  final String name;
  final String phone;

  final String email;
  final String profileImage;
  final String carSign;
  final String carImage;
  final num rate;
  final num numberOfReviews;
  final List<double> location;

  DriverEntity(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.profileImage,
      required this.carSign,
      required this.carImage,
      required this.rate,
      required this.location,
      required this.numberOfReviews});
}
