import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/authentication/data/models/base_user_model.dart';

class ReelEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final BaseUserModel? user;

  int get numberOfLikes => 0;
  int get numberOfComments => 0;
  int get numberOfSaves => 0;
  int get numberOfExplores => 0;
  bool get isFollowed => false;
  const ReelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.user,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        videoUrl,
        thumbnailUrl,
        user,
      ];
}
