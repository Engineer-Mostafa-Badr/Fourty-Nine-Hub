import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entity/comment_entity.dart';
import '../../domain/entity/viewer_entity.dart';
import '../../domain/use_case/comment_use_cases.dart';
import '../controller/star_cubit/star_cubit.dart';
import '../controller/video_details_cubit/video_details_cubit.dart';
import '../widgets/my_video_details/modals/comments_modal.dart';
import '../widgets/my_video_details/modals/viewers_modal.dart';
import '../widgets/my_video_details/video_actions_section.dart';
import '../widgets/my_video_details/video_details_app_bar.dart';
import '../widgets/my_video_details/video_info_section.dart';
import '../widgets/my_video_details/video_player_widget.dart';

class VideoDetailsView extends StatefulWidget {
  final StarEntity talent;
  final String mediaUrl;
  final StarCubit? cubit;
  final VoidCallback? onBack;
  final Function(String)? onAddComment;

  const VideoDetailsView({
    super.key,
    required this.talent,
    required this.mediaUrl,
    this.cubit,
    this.onBack,
    this.onAddComment,
  });

  @override
  State<VideoDetailsView> createState() => _VideoDetailsViewState();
}

class _VideoDetailsViewState extends State<VideoDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createVideoDetailsCubit(),
      child: BlocBuilder<VideoDetailsCubit, VideoDetailsState>(
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContent(state),
          );
        },
      ),
    );
  }

  // Factory method to create VideoDetailsCubit with all required dependencies
  VideoDetailsCubit _createVideoDetailsCubit() {
    final serviceLocator = GetIt.instance;

    return VideoDetailsCubit(
      mediaUrl: widget.mediaUrl,
      talent: widget.talent,
      starCubit: widget.cubit ?? serviceLocator<StarCubit>(),
      createCommentUseCase: serviceLocator<CreateCommentUseCase>(),
      getCommentsUseCase: serviceLocator<GetCommentsUseCase>(),
      updateCommentUseCase: serviceLocator<UpdateCommentUseCase>(),
      deleteCommentUseCase: serviceLocator<DeleteCommentUseCase>(),
      likeCommentUseCase: serviceLocator<LikeCommentUseCase>(),
      dislikeCommentUseCase: serviceLocator<DislikeCommentUseCase>(),
      onBack: widget.onBack,
    )..initialize();
  }

  Widget _buildContent(VideoDetailsState state) {
    final bool isEmbedded = widget.onBack != null;

    if (isEmbedded) {
      return Column(
        children: [
          VideoDetailsAppBar(
            title: 'My Talent',
            onBack: _handleBack,
          ),
          Expanded(child: _buildVideoContent(state)),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildVideoContent(state),
    );
  }

  Widget _buildVideoContent(VideoDetailsState state) {
    // Handle loading state
    if (state is VideoDetailsLoading) {
      return _buildLoadingState();
    }

    // Handle error state
    if (state is VideoDetailsError) {
      return _buildErrorState(state.message);
    }

    // Handle loaded state
    if (state is VideoDetailsLoaded) {
      return Column(
        children: [
          // Video Player Section
          VideoPlayerWidget(
            controller: state.videoController,
            isInitialized: state.isInitialized,
            isPlaying: state.isPlaying,
            isMuted: state.isMuted,
            onPlayPause: () =>
                context.read<VideoDetailsCubit>().togglePlayPause(),
            onMute: () => context.read<VideoDetailsCubit>().toggleMute(),
          ),
          // Video Info Section
          VideoInfoSection(
            talent: state.talent,
            onRatingChanged: _handleRatingChange,
          ),
          // Action Buttons Section
          VideoActionsSection(
            talent: state.talent,
            cubit:
                widget.cubit ?? GetIt.instance<StarCubit>(), // Provide fallback
            onViewersPressed: () => _showViewersModal(state.viewers),
            onCommentsPressed: () => _showCommentsModal(state.comments),
            onDeletePressed: _handleDelete,
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildLoadingState() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // Video Loading Section
          Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading video...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content Loading
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // Error Video Section
          Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VideoDetailsCubit>().initialize();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          // Error Details
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBack() {
    ManageVibration.vibrate();
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.pop(context);
    }
  }

  void _handleRatingChange(int rating) {
    ManageVibration.vibrate();
    // Use the provided cubit or get from service locator
    final starCubit = widget.cubit ?? GetIt.instance<StarCubit>();
    starCubit.updateRating(widget.talent.id, rating);
  }

  void _showViewersModal(List<ViewerEntity> viewers) {
    ManageVibration.vibrate();
    ViewersModal.show(
      context: context,
      viewers: viewers,
    );
  }

  void _showCommentsModal(List<CommentEntity> comments) {
    ManageVibration.vibrate();

    // Enhanced comments modal with all comment actions
    CommentsModal.show(
      context: context,
      comments: comments,
      onAddComment: (comment) {
        context.read<VideoDetailsCubit>().addComment(comment);
        if (widget.onAddComment != null) {
          widget.onAddComment!(comment);
        }
      },
      onLikeComment: (commentId) {
        context.read<VideoDetailsCubit>().likeComment(commentId);
      },
      onDislikeComment: (commentId) {
        context.read<VideoDetailsCubit>().dislikeComment(commentId);
      },
      onReplyToComment: (parentCommentId, replyContent) {
        context
            .read<VideoDetailsCubit>()
            .replyToComment(parentCommentId, replyContent);
      },
      onUpdateComment: (commentId, newContent) {
        context.read<VideoDetailsCubit>().updateComment(commentId, newContent);
      },
      onDeleteComment: (commentId) {
        context.read<VideoDetailsCubit>().deleteComment(commentId);
      },
    );
  }

  void _handleDelete() {
    ManageVibration.vibrate();
    _showDeleteDialog();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert!'),
          content: const Text('Are you sure about deleting the Talent'),
          actions: [
            TextButton(
              onPressed: () {
                ManageVibration.vibrate();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                ManageVibration.vibrate();
                Navigator.pop(context);
                _handleBack();
                // Use the provided cubit or get from service locator
                final starCubit = widget.cubit ?? GetIt.instance<StarCubit>();
                starCubit.deleteMyTubeVideo(widget.talent.id);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
