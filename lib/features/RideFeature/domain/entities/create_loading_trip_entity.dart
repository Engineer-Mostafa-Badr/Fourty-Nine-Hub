class CreateLoadingTripEntity {
  final String driverId;
  final String userId;
  final String categoryId;
  final String startLocation;
  final String targetLocation;
  final String status;
  final int price;
  final String time;
  final String desc;
  final bool isPremium;
  final bool adminIgnore;
  final String phone;
  final double rate;
  final String sId;
  final String id;

  CreateLoadingTripEntity(
      {required this.driverId,
      required this.userId,
      required this.categoryId,
      required this.startLocation,
      required this.targetLocation,
      required this.status,
      required this.price,
      required this.time,
      required this.desc,
      required this.isPremium,
      required this.adminIgnore,
      required this.phone,
      required this.rate,
      required this.sId,
      required this.id});
}
