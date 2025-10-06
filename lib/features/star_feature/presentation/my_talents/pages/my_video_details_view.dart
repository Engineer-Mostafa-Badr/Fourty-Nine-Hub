import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:get_it/get_it.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../domain/entity/comment_entity.dart';
import '../../../domain/entity/viewer_entity.dart';
import '../../../domain/use_case/comment_use_cases.dart';
import '../../presentation_exports.dart';
import '../widgets/my_video_details/modals/comments_modal.dart'
    as my_comments_modal;
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
    return SizedBox(
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
    return SizedBox(
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
    my_comments_modal.CommentsModal.show(
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

  Future<bool> _showDeleteDialog() async {
    return await showAnimatedDialog(
          context,
          AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titlePadding: const EdgeInsets.only(top: 16),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              context.isArabic ? "تنبيه" : "Alert",
              style: Styles.headerText(
                  color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Label(
                  text: context.isArabic
                      ? "هل تريد حذف الفيديو؟"
                      : "Do you want to delete the video?",
                  style: Styles.mediumText(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: buildButton(
                        context,
                        label: LocaleKeys.yes.localize,
                        color: AppColors.SECONDARY_COLOR,
                        onTap: () {
                          ManageVibration.vibrate();
                          Navigator.of(context).pop(true);
                          _handleBack();
                          // Use the provided cubit or get from service locator
                          final starCubit =
                              widget.cubit ?? GetIt.instance<StarCubit>();
                          starCubit.deleteMyTubeVideo(widget.talent.id);
                        },
                      ),
                    ),
                    Expanded(
                      child: buildButton(
                        context,
                        label: LocaleKeys.no.localize,
                        onTap: () {
                          ManageVibration.vibrate();
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ) ??
        false;
  }
}

Widget buildButton(BuildContext context,
    {required String label, required Function() onTap, Color? color}) {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: color ??
          (context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      // foregroundColor: color == AppColors.SECONDARY_COLOR
      //     ? Colors.white
      //     : (context.isDarkMode ? AppColors.PRIMARY_COLOR : Colors.white),
      padding: const EdgeInsets.all(0),
      minimumSize: const Size(70, 30),
      maximumSize: const Size(200, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: () => onTap(),
    child: Label(
      text: label,
      style: Styles.mediumText(
        color: color != null
            ? Colors.white
            : (context.isDarkMode ? AppColors.PRIMARY_COLOR : Colors.white),
      ),
    ),
  );
}
