import 'package:equatable/equatable.dart';
import '../../../../authentication/data/models/base_user_model.dart';

class ReelEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final int saveCount;
  final String type;
  final String videoUrl;
  final String audioUrl;
  // final List<String> imageUrls;
  final String thumbnailUrl;
  final String createdAt;
  final BaseUserModel? user;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String userProfilePictureUrl;

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
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userProfilePictureUrl,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.saveCount,
    required this.type,
    // required this.imageUrls,
    required this.audioUrl,
    required this.createdAt,
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
