import '../../entity/star_entity.dart';

/// UseCase for sharing a video
/// This is a simple use case that doesn't interact with repository
/// It's just a wrapper for sharing logic
class ShareVideoUseCase {
  Future<void> call(StarEntity video) async {
    // TODO: Implement actual share logic with share_plus package
    // For now, just a placeholder
    final shareText = 'Check out this video: ${video.title}';
    print('Sharing video: $shareText');
  }
}
