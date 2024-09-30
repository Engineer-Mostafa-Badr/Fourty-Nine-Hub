import '../../domain/entities/toggle_favourite_entity.dart';

class ToggleFavouriteModel extends ToggleFavouriteEntity {
  ToggleFavouriteModel({required super.status, required super.message});

  factory ToggleFavouriteModel.fromJson(Map<String, dynamic> json) {
    return ToggleFavouriteModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
