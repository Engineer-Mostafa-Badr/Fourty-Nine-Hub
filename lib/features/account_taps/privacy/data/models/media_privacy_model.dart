import '../../domain/entities/media_privacy_entity.dart';

class MediaPrivacyModel extends MediaPrivacyEntity {
  String? userId;
  String? showPosts;
  String? showStories;
  String? showReels;
  String? writeComments;

  MediaPrivacyModel({
    this.userId,
    this.showPosts,
    this.showStories,
    this.showReels,
    this.writeComments,
  });

  factory MediaPrivacyModel.fromJson(Map<String, dynamic> json) {
    return MediaPrivacyModel(
      userId: json['userId'],
      showPosts: json['showPosts'],
      showStories: json['showStories'],
      showReels: json['showReels'],
      writeComments: json['writeComments'],
    );
  }


}