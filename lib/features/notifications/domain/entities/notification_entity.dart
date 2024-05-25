class NotificationEntity {
  final int id;
  final String message;
  final int itemId;
  final String? route;
  final DateTime createdAt;
  NotificationEntity({
    required this.id,
    required this.message,
    required this.itemId,
    this.route,
    required this.createdAt,
  });
}
