// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripJoinRequestHistoryEntity {
  String? id;
  String? userIdStr;
  String? firstName;
  String? gender;
  String? allowStatus;
  bool? hasNextPage;
  int? nextPage;
  String? paymentType;
  String? phone;
  TripJoinRequestHistoryEntity({
    this.id,
    this.userIdStr,
    this.firstName,
    this.gender,
    this.allowStatus,
    this.hasNextPage,
    this.nextPage,
    this.paymentType,
    this.phone,
  });

  @override
  String toString() {
    return 'TripJoinRequestHistoryEntity(id: $id, userId: $userIdStr , firstName: $firstName, gender: $gender, allowStatus: $allowStatus, hasNextPage: $hasNextPage, nextPage: $nextPage, paymentType: $paymentType, phone: $phone)';
  }
}
