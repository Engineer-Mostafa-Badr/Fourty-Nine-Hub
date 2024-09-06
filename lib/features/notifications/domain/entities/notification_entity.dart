// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationEntity {
  String? id;
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
  NotificationEntity({
    this.id,
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
  });

  @override
  String toString() {
    return 'NotificationEntity(id: $id, firstName: $firstName, lastName: $lastName, filterType: $filterType, title: $title, body: $body, payload: $payload, path: $path, createdAt: $createdAt , hasNextPage: $hasNextPage, nextPageNumber: $nextPageNumber )';
  }
}
