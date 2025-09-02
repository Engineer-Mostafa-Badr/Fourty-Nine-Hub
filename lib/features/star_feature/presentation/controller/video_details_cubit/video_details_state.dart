part of 'video_details_cubit.dart';

abstract class VideoDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoDetailsInitial extends VideoDetailsState {}

class VideoDetailsLoading extends VideoDetailsState {}

class VideoDetailsError extends VideoDetailsState {
  final String message;

  VideoDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class VideoDetailsLoaded extends VideoDetailsState {
  final VideoPlayerController videoController;
  final bool isInitialized;
  final bool isPlaying;
  final bool isMuted;
  final List<ViewerEntity> viewers;
  final List<CommentEntity> comments;
  final StarEntity talent;

  VideoDetailsLoaded({
    required this.videoController,
    required this.isInitialized,
    required this.isPlaying,
    required this.isMuted,
    required this.viewers,
    required this.comments,
    required this.talent,
  });

  VideoDetailsLoaded copyWith({
    VideoPlayerController? videoController,
    bool? isInitialized,
    bool? isPlaying,
    bool? isMuted,
    List<ViewerEntity>? viewers,
    List<CommentEntity>? comments,
    StarEntity? talent,
  }) {
    return VideoDetailsLoaded(
      videoController: videoController ?? this.videoController,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      viewers: viewers ?? this.viewers,
      comments: comments ?? this.comments,
      talent: talent ?? this.talent,
    );
  }

  @override
  List<Object?> get props => [
        videoController,
        isInitialized,
        isPlaying,
        isMuted,
        viewers,
        comments,
        talent,
      ];
}
