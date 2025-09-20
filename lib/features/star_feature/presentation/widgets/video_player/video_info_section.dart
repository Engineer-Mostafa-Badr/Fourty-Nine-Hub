import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../data/model/tube_video_models.dart';
import '../../controller/star_cubit/star_cubit.dart';

class VideoInfoSection extends StatelessWidget {
  final StarEntity talent;
  final StarCubit starCubit;
  final bool showFullDescription;
  final VoidCallback? onToggleDescription;
  final VoidCallback? onOpenComments;

  const VideoInfoSection({
    super.key,
    required this.talent,
    required this.starCubit,
    required this.showFullDescription,
    this.onToggleDescription,
    this.onOpenComments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.isDarkMode ? Colors.black : Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video title
          Text(
            talent.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Views and date
          Text(
            '${talent.totalViews} views • ${talent.sinceTime}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons (Like, Dislike, Share, etc.)
          _buildActionButtons(context),

          const SizedBox(height: 16),

          // Channel info
          _buildChannelInfo(context),

          const SizedBox(height: 16),

          // Description
          _buildDescription(context),

          const SizedBox(height: 16),

          // Comments section header
          _buildCommentsHeader(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Like/Dislike buttons container
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Like button
              BlocBuilder<StarCubit, StarState>(
                builder: (context, starState) {
                  final updatedVideo = starCubit.getVideoById(talent.id);
                  final isLiked = updatedVideo != null && updatedVideo is TubeVideoModel
                      ? updatedVideo.isLike
                      : false;

                  return IconButton(
                    icon: Icon(
                      isLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      size: 20,
                      color: isLiked
                          ? Colors.blue
                          : Colors.grey[700],
                    ),
                    onPressed: () {
                      starCubit.likeTubeVideo(talent.id);
                    },
                  );
                },
              ),

              // Like count
              BlocBuilder<StarCubit, StarState>(
                builder: (context, starState) {
                  final updatedVideo = starCubit.getVideoById(talent.id);
                  int currentLikes = updatedVideo?.likes ?? talent.likes;

                  return Text(
                    '$currentLikes',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  );
                },
              ),

              // Divider
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[400],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),

              // Dislike button
              BlocBuilder<StarCubit, StarState>(
                builder: (context, starState) {
                  final updatedVideo = starCubit.getVideoById(talent.id);
                  final isDisliked = updatedVideo != null && updatedVideo is TubeVideoModel
                      ? updatedVideo.isDislike
                      : false;

                  return IconButton(
                    icon: Icon(
                      isDisliked
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined,
                      size: 20,
                      color: isDisliked
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                    onPressed: () {
                      starCubit.dislikeTubeVideo(talent.id);
                    },
                  );
                },
              ),

              // Dislike count
              BlocBuilder<StarCubit, StarState>(
                builder: (context, starState) {
                  final updatedVideo = starCubit.getVideoById(talent.id);
                  int currentDislikes = updatedVideo?.dislikes ?? talent.dislikes;

                  return Text(
                    '$currentDislikes',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Share button
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(
              Icons.share,
              size: 20,
              color: Colors.grey[700],
            ),
            onPressed: () {
              // Handle share
            },
          ),
        ),

        const SizedBox(width: 12),

        // Download button
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(
              Icons.download,
              size: 20,
              color: Colors.grey[700],
            ),
            onPressed: () {
              // Handle download
            },
          ),
        ),

        const Spacer(),

        // More options
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey[700],
          ),
          onPressed: () {
            // Handle more options
          },
        ),
      ],
    );
  }

  Widget _buildChannelInfo(BuildContext context) {
    return Row(
      children: [
        // Channel avatar
        CircleAvatar(
          radius: 20,
          backgroundImage: talent.user.image.isNotEmpty
              ? NetworkImage(talent.user.image)
              : null,
          child: talent.user.image.isEmpty
              ? Icon(
                  Icons.person,
                  color: Colors.grey[600],
                )
              : null,
        ),
        const SizedBox(width: 12),

        // Channel info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${talent.user.firstName} ${talent.user.lastName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${talent.totalViews} views',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Subscribe button
        ElevatedButton(
          onPressed: () {
            // Handle subscribe
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            context.isArabic ? 'اشتراك' : 'Subscribe',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (talent.description.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                talent.description,
                style: TextStyle(
                  fontSize: 14,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                maxLines: showFullDescription ? null : 3,
                overflow: showFullDescription ? null : TextOverflow.ellipsis,
              ),
              if (talent.description.length > 100)
                GestureDetector(
                  onTap: onToggleDescription,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      showFullDescription
                          ? (context.isArabic ? 'عرض أقل' : 'Show less')
                          : (context.isArabic ? 'عرض المزيد' : 'Show more'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsHeader(BuildContext context) {
    return GestureDetector(
      onTap: onOpenComments,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(
              context.isArabic ? 'التعليقات' : 'Comments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
            const Spacer(),
            Icon(
              Icons.comment,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}