import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class RestaurantMedia extends Equatable {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "mediaKey")
  final String? mediaKey;
  const RestaurantMedia({
    this.id,
    this.mediaKey,
  });
  @override
  List<Object?> get props => [
        id,
        mediaKey,
      ];
}
