import '../../domain/entities/media_privacy_entity.dart';

class MediaPrivacyModel extends MediaPrivacyEntity {
  @override
  String? userId;
  @override
  String? showPosts;
  @override
  String? showStories;
  @override
  String? showReels;
  @override
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