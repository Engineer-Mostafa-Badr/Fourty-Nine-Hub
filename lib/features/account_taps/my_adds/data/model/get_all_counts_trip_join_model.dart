import '../../domain/entity/get_all_counts_trip_join_entity.dart';

class GetAllCountsTripJoinModel extends GetAllCountsTripJoinEntity {
  GetAllCountsTripJoinModel(
      {required super.id,
      required super.tripId,
      required super.userId,
      required super.time,
      required super.userIdId,
      required super.firstName,
      required super.lastName,
      required super.gender,
      required super.categoryId,
      required super.phone,
      required super.status,
      required super.createdAt});

  factory GetAllCountsTripJoinModel.fromJson(Map<String, dynamic> json) {
      return GetAllCountsTripJoinModel(
          id: json['_id'] ??'',
          tripId: json['trip']['_id'] ??'',
          categoryId: json['trip']['categoryId'] ??'',
          userId: json['trip']['userId']['_id'] ??'',
          time: json['trip']['time'], // dynamic type, can be any
          userIdId: json['userId']['_id'] ??'',
          firstName: json['userId']['firstName'] ??'',
          lastName: json['userId']['lastName'] ??'',
          gender: json['userId']['gender'] ??'',
          phone: json['userId']['phone'] ??'',
          status: json['status'] ??'',
          createdAt: json['createdAt'] ??'',
      );
  }
}
