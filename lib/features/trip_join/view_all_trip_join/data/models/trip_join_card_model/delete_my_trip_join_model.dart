import '../../../domain/entities/delete_my_trip_join_entity.dart';

class DeleteMyTripJoinModel extends DeleteMyTripJoinEntity {
  DeleteMyTripJoinModel({
    super.status,
    super.message,
  });

  factory DeleteMyTripJoinModel.fromJson(Map<String, dynamic> json) {
    return DeleteMyTripJoinModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
