class StoryModel {
  final String id;
  final String name;
  final String profileImage;
  final bool isMyStory;
  final bool isViewed;
  final bool hasNewStory;

  StoryModel({
    required this.id,
    required this.name,
    required this.profileImage,
    this.isMyStory = false,
    this.isViewed = false,
    this.hasNewStory = false,
  });
}
