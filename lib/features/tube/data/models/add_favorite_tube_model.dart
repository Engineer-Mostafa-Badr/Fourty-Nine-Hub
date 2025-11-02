import '../../domain/entities/add_favorite_tube_entity.dart';

class AddFavoriteTubeModel extends AddFavoriteTubeEntity {
  const AddFavoriteTubeModel({
    super.status,
    super.message,
  });

  factory AddFavoriteTubeModel.fromJson(Map<String, dynamic> json) {
    return AddFavoriteTubeModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
