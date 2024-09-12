// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationEntity {
  String? id;
  String? receiverId;
  String? firstName;
  String? lastName;
  //  app services social
  String? filterType;
  String? title;
  String? body;
  Map<String, dynamic>? payload;
  // String? itemId;
  String? path;
  DateTime? createdAt;
  bool? hasNextPage;
  int? nextPageNumber;
  bool? read;
  String? userImageUrl;
  NotificationEntity({
    this.id,
    this.receiverId,
    this.firstName,
    this.lastName,
    this.filterType,
    this.title,
    this.body,
    this.payload,
    // this.itemId,
    this.path,
    this.createdAt,
    this.hasNextPage,
    this.nextPageNumber,
    this.read,
    this.userImageUrl,
  });

  @override
  String toString() {
    return 'NotificationEntity(id: $id, firstName: $firstName, lastName: $lastName, filterType: $filterType, title: $title, body: $body, payload: $payload, path: $path, createdAt: $createdAt , hasNextPage: $hasNextPage, nextPageNumber: $nextPageNumber , read: $read , userImageUrl: $userImageUrl )';
  }
}
