import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../cubit/tube_cubit.dart';



import '../widgets/video_card_widget.dart';




class VideoPlayerPage extends StatefulWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList;

  const VideoPlayerPage({super.key, required this.video, this.videoList});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {


  @override
  void initState() {
    super.initState();
    _currentVideoId = widget.video.id!;
    final cubit = context.read<TubeCubit>();
    final state = cubit.state;

    if (state.currentVideo?.id == widget.video.id &&
        state.isMinimized &&
        state.areControllersInitialized) {
      cubit.maximizePlayer();
      if (state.videoPlayerController != null &&
          state.lastPlaybackPosition != null) {
        state.videoPlayerController!.seekTo(state.lastPlaybackPosition!);
        if (state.isPlaying) {
          state.videoPlayerController!.play();
        }
      }
    } else {
      cubit.playVideo(widget.video, videoList: widget.videoList);
    }
  }
  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, GetAllTubeVideosEntity video) {
    final cubit = context.read<TubeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) => TubeCommentsSection(
            videoId: video.id!,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }


    // bool _isImageContent() => widget.video.videoUrl == null || widget.video.videoUrl!.isEmpty;
  bool _isImageContent(GetAllTubeVideosEntity video) => video.videoUrl == null || video.videoUrl!.isEmpty;
  String _currentVideoId = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final cubit = context.read<TubeCubit>();
        cubit.minimizePlayer(); // 👈 Minimize when back
        return true; // Allow pop to continue
      },
      child: Scaffold(
        backgroundColor: Colors.black,
      
        body: BlocConsumer<TubeCubit, TubeState>(
          listener: (context, state) {
            // 🔥 Listen for video changes and update the related videos
            if (state.currentVideo != null && state.currentVideo!.id != _currentVideoId) {
              setState(() {
                _currentVideoId = state.currentVideo!.id!;
              });
            }
          },
          builder: (context, state) {
            final currentVideo = state.currentVideo ?? widget.video;
      
            return Column(
              children: [
                // 🔹 Video Player (same as before)
                SizedBox(
                  height: 400,
                  child: GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! > 300 &&
                          !state.isLoading &&
                          !_isImageContent(currentVideo)) {
                        context.read<TubeCubit>().minimizePlayer();
                        Navigator.pop(context);
                      }
                    },
                    child: _isImageContent(currentVideo)
                        ? Image.network(
                      currentVideo.thumbnail ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                    )
                        : Container(
                      color: Colors.black,
                      width: double.infinity,
                      child: (state.isLoading ||
                          state.chewieController == null ||
                          !state.chewieController!.videoPlayerController.value.isInitialized)
                          ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading video...',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.zero,
                        child: Chewie(controller: state.chewieController!),
                      ),
                    ),
                  ),
                ),
      
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // ▶ Title and metadata - use currentVideo instead of widget.video
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              currentVideo.title ?? "Not available",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Views and date
                            Text(
                              '${currentVideo.views} views • ${currentVideo.updatedAt != null ? DateFormat('MMM d, yyyy', context.isArabic ? 'ar' : 'en').format(DateTime.parse(currentVideo.updatedAt!)) : ''}',
                              style: const TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 🔹 Description - use currentVideo
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          currentVideo.description ?? "Not available",
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),

                      // 🔹 Action Buttons Row (Like, Dislike, Share, etc.)
                      Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildYouTubeActionButton(
                              icon: Icons.thumb_up_outlined,
                              activeIcon: Icons.thumb_up,
                              label: '12K',
                              isActive: false,
                            ),
                            const SizedBox(width: 2),
                            _buildYouTubeActionButton(
                              icon: Icons.thumb_down_outlined,
                              activeIcon: Icons.thumb_down,
                              label: 'Dislike',
                              isActive: false,
                            ),
                            const SizedBox(width: 2),
                            _buildYouTubeActionButton(
                              icon: Icons.share_outlined,
                              label: 'Share',
                            ),
                            const SizedBox(width: 2),
                            _buildYouTubeActionButton(
                              icon: Icons.download_outlined,
                              label: 'Download',
                            ),
                            if (!_isImageContent(currentVideo)) ...[
                              const SizedBox(width: 2),
                              _buildYouTubeActionButton(
                                icon: Icons.comment_outlined,
                                label: 'Comments',
                                onTap: () => _showCommentsBottomSheet(context, currentVideo),
                              ),
                            ],
                            const SizedBox(width: 2),
                            _buildYouTubeActionButton(
                              icon: Icons.playlist_add,
                              label: 'Save',
                            ),
                          ],
                        ),
                      ),
      
                      const Divider(height: 1, color: Color(0xFF272727)),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Channel avatar
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade800,
                              backgroundImage: currentVideo.owner?.channelPicture != null &&
                                  currentVideo.owner!.channelPicture!.isNotEmpty
                                  ? NetworkImage(currentVideo.owner!.channelPicture!)
                                  : null,
                              child: (currentVideo.owner?.channelPicture == null ||
                                  currentVideo.owner!.channelPicture!.isEmpty)
                                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            // Channel name and subscribers
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          currentVideo.owner?.channelName ?? "Unknown Channel",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (currentVideo.owner?.isAccountVerified == true)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(Icons.check_circle, color: Color(0xFFAAAAAA), size: 14),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '1.2M subscribers', // You can replace with actual subscriber count
                                    style: TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Subscribe Button
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Subscribe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: GestureDetector(
                          onTap: () => _showCommentsBottomSheet(context, currentVideo),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF272727),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentVideo.description ?? "No description available",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Show more',
                                  style: TextStyle(
                                    color: Color(0xFFAAAAAA),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
      
                      const Divider(height: 1, color: Color(0xFF272727)),
      
                      // 🔹 Related Videos - use current video ID
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: RelatedVideosScreen(videoId: currentVideo.id!),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  Widget _buildYouTubeActionButton({
    required IconData icon,
    IconData? activeIcon,
    required String label,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF272727),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive && activeIcon != null ? activeIcon : icon,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TubeCommentsSection extends StatefulWidget {
  final String videoId;
  final ScrollController scrollController;

  const TubeCommentsSection({super.key, required this.videoId, required this.scrollController});

  @override
  State<TubeCommentsSection> createState() => _TubeCommentsSectionState();
}

class _TubeCommentsSectionState extends State<TubeCommentsSection> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TubeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadInitialTubeVideoComments(context, widget.videoId);
    });

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent - 200) {
        context.read<TubeCubit>().getTubeVideoComments(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        final cubit = context.read<TubeCubit>();
        final comments = cubit.tubeVideoComments;

        return Container(
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF272727)),
              Expanded(
                child: comments.isEmpty && cubit.isTubeVideoCommentsInitialLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.red))
                    : comments.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.comment_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No comments yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Be the first to comment',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: widget.scrollController,
                  itemCount: comments.length + (cubit.hasMoreTubeVideoComments ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < comments.length) {
                      final comment = comments[index];
                      return CommentItem(
                        comment: comment,
                        videoId: widget.videoId,
                        currentUserId: null,
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 1, color: Color(0xFF272727)),
              AddCommentWidget(
                videoId: widget.videoId,
                currentUserAvatar: null,
                currentUserName: null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentItem extends StatefulWidget {
  final TubeCommentEntity comment;
  final String videoId;
  final String? currentUserId;
  final bool isReply;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.videoId,
    this.currentUserId,
    this.isReply = false,
  }) : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isEditing = false;
  late TextEditingController _editController;
  late bool _isLiked;
  late bool _isDisliked;
  late int _localLikes;
  late int _localDislikes;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.comment.content);
    _localLikes = widget.comment.likes;
    _localDislikes = widget.comment.dislikes;
    _isLiked = false;
    _isDisliked = false;
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  bool get _isMyComment =>
      widget.currentUserId != null && widget.comment.userId == widget.currentUserId;

  bool get _isEdited =>
      widget.comment.updatedAt.isAfter(widget.comment.createdAt.add(const Duration(seconds: 1)));

  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.comment.owner?.channelPicture?.mediaKey;
    final userName = widget.comment.owner?.channelName ?? 'Unknown User';
    final repliesCount = widget.comment.replies.length;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        final showReplies = state.expandedComments[widget.comment.id] ?? false;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: widget.isReply ? 56 : 16,
                right: 16,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: widget.isReply ? 16 : 18,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? Text(
                      _getInitials(userName),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.isReply ? 12 : 14,
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                userName,
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatTimeAgo(widget.comment.createdAt),
                              style: TextStyle(
                                fontSize: width * 0.032,
                                color: Colors.grey[400],
                              ),
                            ),
                            if (_isEdited)
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  '(edited)',
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (_isEditing)
                          _buildEditField()
                        else
                          Text(
                            widget.comment.content,
                            style: TextStyle(
                              fontSize: width * 0.038,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        const SizedBox(height: 6),
                        if (!_isEditing)
                          Row(
                            children: [
                              _ActionButton(
                                icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                label: _localLikes > 0 ? _localLikes.toString() : '',
                                onTap: _handleLike,
                                isActive: _isLiked,
                              ),
                              const SizedBox(width: 12),
                              _ActionButton(
                                icon: _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                                label: _localDislikes > 0 ? _localDislikes.toString() : '',
                                onTap: _handleDislike,
                                isActive: _isDisliked,
                              ),
                              if (!widget.isReply)
                                Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    _ActionButton(
                                      icon: Icons.comment_outlined,
                                      label: 'Reply',
                                      onTap: () => _showReplyDialog(context),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        if (repliesCount > 0 && !_isEditing && !widget.isReply)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: InkWell(
                              onTap: () {
                                context.read<TubeCubit>().toggleCommentReplies(widget.comment.id);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    showReplies ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  Text(
                                    '$repliesCount ${repliesCount == 1 ? 'reply' : 'replies'}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_isMyComment && !_isEditing)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                      color: Colors.grey[900],
                      onSelected: (value) {
                        if (value == 'edit') {
                          setState(() => _isEditing = true);
                        } else if (value == 'delete') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit', style: TextStyle(color: Colors.white)),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  else if (!_isMyComment && !_isEditing)
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.grey, size: 18),
                      onPressed: () => _showReportDialog(context),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            if (showReplies && repliesCount > 0 && !widget.isReply)
              ...widget.comment.replies.map((reply) {
                return CommentItem(
                  comment: TubeCommentEntity(
                    id: reply.id,
                    content: reply.content,
                    userId: reply.userId,
                    owner: reply.owner,
                    video: reply.video,
                    likes: reply.likes.length,
                    dislikes: reply.dislikes.length,
                    replies: [],
                    createdAt: reply.createdAt,
                    updatedAt: reply.updatedAt,
                  ),
                  videoId: widget.videoId,
                  currentUserId: widget.currentUserId,
                  isReply: true,
                );
              }).toList(),
          ],
        );
      },
    );
  }

  void _handleLike() {
    final cubit = context.read<TubeCubit>();

    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _localLikes--;
      } else {
        _isLiked = true;
        _localLikes++;
        if (_isDisliked) {
          _isDisliked = false;
          _localDislikes--;
        }
      }
    });

    cubit.likeComment(widget.comment.id);
  }

  void _handleDislike() {
    final cubit = context.read<TubeCubit>();

    setState(() {
      if (_isDisliked) {
        _isDisliked = false;
        _localDislikes--;
      } else {
        _isDisliked = true;
        _localDislikes++;
        if (_isLiked) {
          _isLiked = false;
          _localLikes--;
        }
      }
    });

    cubit.dislikeComment(widget.comment.id);
  }

  Widget _buildEditField() {
    return Column(
      children: [
        TextField(
          controller: _editController,
          maxLines: null,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _editController.text = widget.comment.content;
                });
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _saveEdit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  void _saveEdit() {
    final newContent = _editController.text.trim();
    if (newContent.isEmpty || newContent == widget.comment.content) {
      setState(() => _isEditing = false);
      return;
    }

    final cubit = context.read<TubeCubit>();
    cubit.updateCommentOnTubeVideo(
      context: context,
      commentId: widget.comment.id,
      videoId: widget.videoId,
      content: newContent,
    );

    setState(() => _isEditing = false);
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete comment?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will permanently delete your comment.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TubeCubit>().deleteTubeComment(
                context: context,
                commentId: widget.comment.id,
                videoId: widget.videoId,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }


  // Add this static flag at the top of the _CommentItemState class
  static bool _isReplyDialogOpen = false;
  void _showReplyDialog(BuildContext context) {
    if (_isReplyDialogOpen) return;
    _isReplyDialogOpen = true;

    final cubit = context.read<TubeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) => Container(
            color: Colors.black,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                          Text(
                            'Reply to ${widget.comment.owner?.channelName ?? 'User'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFF272727)),
                Expanded(
                  child: BlocBuilder<TubeCubit, TubeState>(
                    builder: (context, state) {
                      final latestComments = cubit.tubeVideoComments;
                      final latestComment = latestComments.firstWhere(
                            (c) => c.id == widget.comment.id,
                        orElse: () => widget.comment,
                      );

                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            // Original comment - PASS isReply: true to prevent nested rendering
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: CommentItem(
                                comment: latestComment,
                                videoId: widget.videoId,
                                currentUserId: widget.currentUserId,
                                isReply: true, // ✅ Changed from false to true
                              ),
                            ),
                            // Replies - now displayed separately without duplication
                            ...latestComment.replies.map((reply) {
                              return CommentItem(
                                comment: TubeCommentEntity(
                                  id: reply.id,
                                  content: reply.content,
                                  userId: reply.userId,
                                  owner: reply.owner,
                                  video: reply.video,
                                  likes: reply.likes.length,
                                  dislikes: reply.dislikes.length,
                                  replies: [],
                                  createdAt: reply.createdAt,
                                  updatedAt: reply.updatedAt,
                                ),
                                videoId: widget.videoId,
                                currentUserId: widget.currentUserId,
                                isReply: true,
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, color: Color(0xFF272727)),
                AddCommentWidget(
                  videoId: widget.videoId,
                  currentUserAvatar: null,
                  currentUserName: null,
                  parentCommentId: widget.comment.id,
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      _isReplyDialogOpen = false;
    });
  }




  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Report comment',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildReportOption(ctx, 'Spam'),
            _buildReportOption(ctx, 'Harassment'),
            _buildReportOption(ctx, 'Hate speech'),
            _buildReportOption(ctx, 'Misinformation'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(BuildContext ctx, String reason) {
    return ListTile(
      title: Text(reason, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comment reported for: $reason'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

class AddCommentWidget extends StatefulWidget {
  final String videoId;
  final String? currentUserAvatar;
  final String? currentUserName;
  final String? parentCommentId;
  final VoidCallback? onReplyPosted; // Add this callback

  const AddCommentWidget({
    Key? key,
    required this.videoId,
    this.currentUserAvatar,
    this.currentUserName,
    this.parentCommentId,
    this.onReplyPosted, // Add this
  }) : super(key: key);

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isExpanded = _focusNode.hasFocus || _commentController.text.isNotEmpty;
      });
    });
    _commentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _postComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final cubit = context.read<TubeCubit>();

    // Clear text and reset input
    _commentController.clear();
    _focusNode.unfocus();
    setState(() => _isExpanded = false);

    // Wait for backend + Cubit silent refresh
    await cubit.createCommentOnTubeVideo(
      context: context,
      videoId: widget.videoId,
      content: content,
      parentCommentId: widget.parentCommentId,
    );

    // ✅ Only scroll after Cubit finishes refresh
    if (widget.parentCommentId != null) {
      widget.onReplyPosted?.call();
    }
  }


  void _cancelComment() {
    _commentController.clear();
    _focusNode.unfocus();
    setState(() => _isExpanded = false);

    // Only close if it's a reply in bottom sheet
    if (widget.parentCommentId != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[800],
                backgroundImage: widget.currentUserAvatar != null &&
                    widget.currentUserAvatar!.isNotEmpty
                    ? NetworkImage(widget.currentUserAvatar!)
                    : null,
                child: widget.currentUserAvatar == null || widget.currentUserAvatar!.isEmpty
                    ? Text(
                  _getInitials(widget.currentUserName ?? 'User'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _focusNode,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: widget.parentCommentId != null
                        ? 'Add a reply...'
                        : 'Add a public comment...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _cancelComment,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _commentController.text.trim().isEmpty ? null : _postComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(widget.parentCommentId != null ? 'Reply' : 'Comment'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class RelatedVideosScreen extends StatefulWidget {
  final String videoId;

  const RelatedVideosScreen({super.key, required this.videoId});

  @override
  State<RelatedVideosScreen> createState() => _RelatedVideosScreenState();
}

class _RelatedVideosScreenState extends State<RelatedVideosScreen> {
  late final ScrollController _scrollController;
  late String _currentVideoId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _currentVideoId = widget.videoId;

    _loadInitialVideos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<TubeCubit>().getRelatedTubeVideos();
      }
    });
  }

  void _loadInitialVideos() {
    final cubit = context.read<TubeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadInitialRelatedTubeVideos( _currentVideoId);
    });
  }

  @override
  void didUpdateWidget(RelatedVideosScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _currentVideoId = widget.videoId;
      _loadInitialVideos();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        final cubit = context.read<TubeCubit>();
        final relatedVideos = state.relatedTubeVideosData ?? [];

        if (cubit.isRelatedTubeInitialLoading && relatedVideos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        if (relatedVideos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('No related videos available',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: relatedVideos.length + 1,
          itemBuilder: (context, index) {
            if (index < relatedVideos.length) {
              final video = relatedVideos[index];
              return VideoCardTube(video: video, videoList: relatedVideos);
            } else {
              if (cubit.isRelatedTubeLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                );
              } else if (!cubit.hasMoreRelatedTubeVideos &&
                  relatedVideos.isNotEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No more related videos',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}


// ---------------------------------------------------------------
// ✅ RelatedVideosScreen
// ---------------------------------------------------------------


// ---------------------------------------------------------------
// 💬 TubeCommentsSection

// ---------------------------------------------------------------
// 💬 TubeCommentsSection


// class TubeCommentsSection extends StatefulWidget {
//   final String videoId;
//
//   const TubeCommentsSection({super.key, required this.videoId});
//
//   @override
//   State<TubeCommentsSection> createState() => _TubeCommentsSectionState();
// }
//
// class _TubeCommentsSectionState extends State<TubeCommentsSection> {
//   late final ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//
//     final cubit = context.read<TubeCubit>();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cubit.loadInitialTubeVideoComments(context, widget.videoId);
//     });
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         cubit.getTubeVideoComments(context);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TubeCubit, TubeState>(
//       builder: (context, state) {
//         final cubit = context.read<TubeCubit>();
//         final comments = cubit.tubeVideoComments;
//
//         if (cubit.isTubeVideoCommentsInitialLoading && comments.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 32),
//             child: Center(child: CircularProgressIndicator(color: Colors.red)),
//           );
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Add Comment Widget at the top
//             AddCommentWidget(
//               videoId: widget.videoId,
//               currentUserAvatar: null, // TODO: Pass user avatar
//               currentUserName: null, // TODO: Pass user name
//             ),
//
//             if (comments.isEmpty)
//               const Padding(
//                 padding: EdgeInsets.all(24),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Icon(Icons.comment_outlined, size: 48, color: Colors.grey),
//                       SizedBox(height: 12),
//                       Text(
//                         'No comments yet',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Be the first to comment',
//                         style: TextStyle(color: Colors.grey, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//                     child: Row(
//                       children: [
//                         const Text(
//                           'Comments',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '${_getTotalCommentsCount(comments)}',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(height: 1, color: Color(0xFF272727)),
//                   ListView.builder(
//                     controller: _scrollController,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: comments.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index < comments.length) {
//                         final comment = comments[index];
//                         return CommentItem(
//                           comment: comment,
//                           videoId: widget.videoId,
//                           currentUserId: null, // TODO: Add your current user ID
//                         );
//                       } else {
//                         if (cubit.isTubeVideoCommentsLoadingMore) {
//                           return const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 24),
//                             child: Center(
//                               child: CircularProgressIndicator(color: Colors.red),
//                             ),
//                           );
//                         } else if (!cubit.hasMoreTubeVideoComments &&
//                             comments.isNotEmpty) {
//                           return const Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Center(
//                               child: Text(
//                                 'No more comments',
//                                 style: TextStyle(color: Colors.grey, fontSize: 12),
//                               ),
//                             ),
//                           );
//                         }
//                       }
//                       return const SizedBox.shrink();
//                     },
//                   ),
//                 ],
//               ),
//           ],
//         );
//       },
//     );
//   }
//
//   int _getTotalCommentsCount(List<TubeCommentEntity> comments) {
//     int total = comments.length;
//     for (var comment in comments) {
//       total += comment.replies.length;
//     }
//     return total;
//   }
// }
//
// // ---------------------------------------------------------------
// // 💬 CommentItem: Individual comment card with nested replies
// // ---------------------------------------------------------------
// class CommentItem extends StatefulWidget {
//   final TubeCommentEntity comment;
//   final String videoId;
//   final String? currentUserId;
//   final bool isReply;
//
//   const CommentItem({
//     Key? key,
//     required this.comment,
//     required this.videoId,
//     this.currentUserId,
//     this.isReply = false,
//   }) : super(key: key);
//
//   @override
//   State<CommentItem> createState() => _CommentItemState();
// }
//
// class _CommentItemState extends State<CommentItem> {
//   bool _isEditing = false;
//   bool _showReplies = false;
//   late TextEditingController _editController;
//
//   late bool _isLiked;
//   late bool _isDisliked;
//   late int _localLikes;
//   late int _localDislikes;
//
//   @override
//   void initState() {
//     super.initState();
//     _editController = TextEditingController(text: widget.comment.content);
//
//     _localLikes = widget.comment.likes;
//     _localDislikes = widget.comment.dislikes;
//
//     // TODO: Initialize from API if your backend tracks user-specific likes
//     _isLiked = false;
//     _isDisliked = false;
//   }
//
//   @override
//   void dispose() {
//     _editController.dispose();
//     super.dispose();
//   }
//
//   bool get _isMyComment =>
//       widget.currentUserId != null &&
//           widget.comment.userId == widget.currentUserId;
//
//   bool get _isEdited =>
//       widget.comment.updatedAt
//           .isAfter(widget.comment.createdAt.add(const Duration(seconds: 1)));
//
//   @override
//   Widget build(BuildContext context) {
//     final avatarUrl = widget.comment.owner?.channelPicture?.mediaKey;
//     final userName = widget.comment.owner?.channelName ?? 'Unknown User';
//     final repliesCount = widget.comment.replies.length;
//     final width = MediaQuery.of(context).size.width;
//
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(
//             left: widget.isReply ? 56 : 16,
//             right: 16,
//             top: 10,
//             bottom: 10,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Avatar
//               CircleAvatar(
//                 radius: widget.isReply ? 16 : 18,
//                 backgroundColor: Colors.grey[800],
//                 backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
//                     ? NetworkImage(avatarUrl)
//                     : null,
//                 child: (avatarUrl == null || avatarUrl.isEmpty)
//                     ? Text(
//                   _getInitials(userName),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: widget.isReply ? 12 : 14,
//                   ),
//                 )
//                     : null,
//               ),
//               const SizedBox(width: 12),
//
//               // Main content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Username + timestamp
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             userName,
//                             style: TextStyle(
//                               fontSize: width * 0.035,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           _formatTimeAgo(widget.comment.createdAt),
//                           style: TextStyle(
//                             fontSize: width * 0.032,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                         if (_isEdited)
//                           const Padding(
//                             padding: EdgeInsets.only(left: 6),
//                             child: Text(
//                               '(edited)',
//                               style: TextStyle(fontSize: 11, color: Colors.grey),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//
//                     // Comment text
//                     if (_isEditing)
//                       _buildEditField()
//                     else
//                       Text(
//                         widget.comment.content,
//                         style: TextStyle(
//                           fontSize: width * 0.038,
//                           color: Colors.white,
//                           height: 1.4,
//                         ),
//                       ),
//
//                     const SizedBox(height: 6),
//
//                     // Like / Dislike / Reply buttons
//                     if (!_isEditing)
//                       Row(
//                         children: [
//                           _ActionButton(
//                             icon: _isLiked
//                                 ? Icons.thumb_up
//                                 : Icons.thumb_up_outlined,
//                             label: _localLikes > 0 ? _localLikes.toString() : '',
//                             onTap: _handleLike,
//                             isActive: _isLiked,
//                           ),
//                           const SizedBox(width: 12),
//                           _ActionButton(
//                             icon: _isDisliked
//                                 ? Icons.thumb_down
//                                 : Icons.thumb_down_outlined,
//                             label: _localDislikes > 0
//                                 ? _localDislikes.toString()
//                                 : '',
//                             onTap: _handleDislike,
//                             isActive: _isDisliked,
//                           ),
//                           if (!widget.isReply) ...[
//                             const SizedBox(width: 12),
//                             _ActionButton(
//                               icon: Icons.comment_outlined,
//                               label: 'Reply',
//                               onTap: () => _showReplyDialog(context),
//                             ),
//                           ],
//                         ],
//                       ),
//
//                     // Show/Hide Replies Button (YouTube style)
//                     if (repliesCount > 0 && !_isEditing && !widget.isReply)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: InkWell(
//                           onTap: () {
//                             setState(() {
//                               _showReplies = !_showReplies;
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Icon(
//                                 _showReplies
//                                     ? Icons.arrow_drop_up
//                                     : Icons.arrow_drop_down,
//                                 color: Colors.blue,
//                                 size: 24,
//                               ),
//                               Text(
//                                 '$repliesCount ${repliesCount == 1 ? 'reply' : 'replies'}',
//                                 style: const TextStyle(
//                                   color: Colors.blue,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               // Menu (edit/delete/report)
//               if (_isMyComment && !_isEditing)
//                 PopupMenuButton<String>(
//                   icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
//                   color: Colors.grey[900],
//                   onSelected: (value) {
//                     if (value == 'edit') {
//                       setState(() => _isEditing = true);
//                     } else if (value == 'delete') {
//                       _showDeleteDialog(context);
//                     }
//                   },
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: 'edit',
//                       child: Text('Edit', style: TextStyle(color: Colors.white)),
//                     ),
//                     const PopupMenuItem(
//                       value: 'delete',
//                       child: Text('Delete', style: TextStyle(color: Colors.red)),
//                     ),
//                   ],
//                 )
//               else if (!_isMyComment && !_isEditing)
//                 IconButton(
//                   icon: const Icon(Icons.more_vert, color: Colors.grey, size: 18),
//                   onPressed: () => _showReportDialog(context),
//                   padding: EdgeInsets.zero,
//                 ),
//             ],
//           ),
//         ),
//
//         // Nested Replies (YouTube style)
//         if (_showReplies && repliesCount > 0 && !widget.isReply)
//           ...widget.comment.replies.map((reply) {
//             return CommentItem(
//               comment: TubeCommentEntity(
//                 id: reply.id,
//                 content: reply.content,
//                 userId: reply.userId,
//                 owner: reply.owner,
//                 video: reply.video,
//                 likes: reply.likes.length,
//                 dislikes: reply.dislikes.length,
//                 replies: [],
//                 createdAt: reply.createdAt,
//                 updatedAt: reply.updatedAt,
//               ),
//               videoId: widget.videoId,
//               currentUserId: widget.currentUserId,
//               isReply: true,
//             );
//           }).toList(),
//       ],
//     );
//   }
//
//   // 🩵 Handles like toggle
//   void _handleLike() {
//     final cubit = context.read<TubeCubit>();
//
//     setState(() {
//       if (_isLiked) {
//         _isLiked = false;
//         _localLikes--;
//       } else {
//         _isLiked = true;
//         _localLikes++;
//         if (_isDisliked) {
//           _isDisliked = false;
//           _localDislikes--;
//         }
//       }
//     });
//
//     cubit.likeComment(widget.comment.id);
//   }
//
//   // 💔 Handles dislike toggle
//   void _handleDislike() {
//     final cubit = context.read<TubeCubit>();
//
//     setState(() {
//       if (_isDisliked) {
//         _isDisliked = false;
//         _localDislikes--;
//       } else {
//         _isDisliked = true;
//         _localDislikes++;
//         if (_isLiked) {
//           _isLiked = false;
//           _localLikes--;
//         }
//       }
//     });
//
//     cubit.dislikeComment(widget.comment.id);
//   }
//
//   Widget _buildEditField() {
//     return Column(
//       children: [
//         TextField(
//           controller: _editController,
//           maxLines: null,
//           autofocus: true,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey[900],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.all(10),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _isEditing = false;
//                   _editController.text = widget.comment.content;
//                 });
//               },
//               child: const Text('Cancel'),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _saveEdit,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   void _saveEdit() {
//     final newContent = _editController.text.trim();
//     if (newContent.isEmpty || newContent == widget.comment.content) {
//       setState(() => _isEditing = false);
//       return;
//     }
//
//     final cubit = context.read<TubeCubit>();
//     cubit.updateCommentOnTubeVideo(
//       context: context,
//       commentId: widget.comment.id,
//       videoId: widget.videoId,
//       content: newContent,
//     );
//
//     setState(() => _isEditing = false);
//   }
//
//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: Colors.grey[900],
//         title: const Text(
//           'Delete comment?',
//           style: TextStyle(color: Colors.white),
//         ),
//         content: const Text(
//           'This will permanently delete your comment.',
//           style: TextStyle(color: Colors.grey),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               context.read<TubeCubit>().deleteTubeComment(
//                 context: context,
//                 commentId: widget.comment.id,
//                 videoId: widget.videoId,
//               );
//             },
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showReplyDialog(BuildContext context) {
//     final replyController = TextEditingController();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.grey[900],
//       builder: (ctx) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(ctx).viewInsets.bottom,
//           left: 16,
//           right: 16,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Reply to ${widget.comment.owner?.channelName ?? 'User'}',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: replyController,
//               maxLines: 3,
//               autofocus: true,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Add a reply...',
//                 hintStyle: TextStyle(color: Colors.grey[600]),
//                 filled: true,
//                 fillColor: Colors.grey[850],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(ctx),
//                   child: const Text('Cancel'),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     final reply = replyController.text.trim();
//                     if (reply.isNotEmpty) {
//                       Navigator.pop(ctx);
//                       context.read<TubeCubit>().createCommentOnTubeVideo(
//                         context: context,
//                         videoId: widget.videoId,
//                         content: reply,
//                         parentCommentId: widget.comment.id,
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                   ),
//                   child: const Text('Reply'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showReportDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: Colors.grey[900],
//         title: const Text(
//           'Report comment',
//           style: TextStyle(color: Colors.white),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildReportOption(ctx, 'Spam'),
//             _buildReportOption(ctx, 'Harassment'),
//             _buildReportOption(ctx, 'Hate speech'),
//             _buildReportOption(ctx, 'Misinformation'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildReportOption(BuildContext ctx, String reason) {
//     return ListTile(
//       title: Text(reason, style: const TextStyle(color: Colors.white)),
//       onTap: () {
//         Navigator.pop(ctx);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Comment reported for: $reason'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       },
//     );
//   }
//
//   String _getInitials(String name) {
//     final parts = name.trim().split(' ');
//     if (parts.isEmpty) return 'U';
//     if (parts.length == 1) return parts[0][0].toUpperCase();
//     return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//   }
//
//   String _formatTimeAgo(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//
//     if (difference.inDays > 365) {
//       final years = (difference.inDays / 365).floor();
//       return '$years ${years == 1 ? 'year' : 'years'} ago';
//     } else if (difference.inDays > 30) {
//       final months = (difference.inDays / 30).floor();
//       return '$months ${months == 1 ? 'month' : 'months'} ago';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }
//
//
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final bool isActive;
//
//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.isActive = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: isActive ? Colors.blue : Colors.grey,
//             ),
//             if (label.isNotEmpty) ...[
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isActive ? Colors.blue : Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ---------------------------------------------------------------
// // ➕ Add Comment Widget
// // ---------------------------------------------------------------
// class AddCommentWidget extends StatefulWidget {
//   final String videoId;
//   final String? currentUserAvatar;
//   final String? currentUserName;
//
//   const AddCommentWidget({
//     Key? key,
//     required this.videoId,
//     this.currentUserAvatar,
//     this.currentUserName,
//   }) : super(key: key);
//
//   @override
//   State<AddCommentWidget> createState() => _AddCommentWidgetState();
// }
//
// class _AddCommentWidgetState extends State<AddCommentWidget> {
//   final TextEditingController _commentController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   bool _isExpanded = false;
//   bool _isPosting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       setState(() {
//         _isExpanded = _focusNode.hasFocus;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _commentController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   void _postComment() async {
//     final content = _commentController.text.trim();
//     if (content.isEmpty || _isPosting) return;
//
//     setState(() => _isPosting = true);
//
//     // Optimistically add the comment to UI
//     final cubit = context.read<TubeCubit>();
//
//     // Create optimistic comment
//     final optimisticComment = TubeCommentEntity(
//       id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
//       content: content,
//       userId: widget.currentUserName ?? 'current_user',
//       owner: TubeCommentOwnerEntity(
//         id: widget.currentUserName ?? 'current_user',
//         channelName: widget.currentUserName ?? 'You',
//         channelPicture: widget.currentUserAvatar != null
//             ? TubeOwnerPictureEntity(
//           id: 'temp_picture',
//           mediaKey: widget.currentUserAvatar!,
//         )
//             : null,
//       ),
//       video: widget.videoId,
//       likes: 0,
//       dislikes: 0,
//       replies: [],
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//
//     // Add to list immediately
//     // cubit.addOptimisticComment(optimisticComment);
//
//     // Clear input and close
//     _commentController.clear();
//     _focusNode.unfocus();
//     setState(() {
//       _isExpanded = false;
//     });
//
//     // Make API call
//     await cubit.createCommentOnTubeVideo(
//       context: context,
//       videoId: widget.videoId,
//       content: content,
//       parentCommentId: null,
//       // optimisticCommentId: optimisticComment.id,
//     );
//
//     setState(() => _isPosting = false);
//   }
//
//   void _cancel() {
//     _commentController.clear();
//     _focusNode.unfocus();
//     setState(() => _isExpanded = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey[800]!,
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundColor: Colors.grey[800],
//             backgroundImage: widget.currentUserAvatar != null &&
//                 widget.currentUserAvatar!.isNotEmpty
//                 ? NetworkImage(widget.currentUserAvatar!)
//                 : null,
//             child: widget.currentUserAvatar == null ||
//                 widget.currentUserAvatar!.isEmpty
//                 ? Text(
//               _getInitials(widget.currentUserName ?? 'User'),
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             )
//                 : null,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 TextField(
//                   controller: _commentController,
//                   focusNode: _focusNode,
//                   maxLines: _isExpanded ? 3 : 1,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: 'Add a comment...',
//                     hintStyle: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                     filled: false,
//                     border: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey[700]!),
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey[700]!),
//                     ),
//                     focusedBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white, width: 2),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 0,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     setState(() {});
//                   },
//                 ),
//                 if (_isExpanded) ...[
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: _cancel,
//                         style: TextButton.styleFrom(
//                           foregroundColor: Colors.grey,
//                         ),
//                         child: const Text('Cancel'),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: _commentController.text.trim().isEmpty || _isPosting
//                             ? null
//                             : _postComment,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _commentController.text.trim().isEmpty || _isPosting
//                               ? Colors.grey[800]
//                               : Colors.blue,
//                           foregroundColor: Colors.white,
//                           disabledBackgroundColor: Colors.grey[800],
//                           disabledForegroundColor: Colors.grey[600],
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                         ),
//                         child: _isPosting
//                             ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Text('Comment'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getInitials(String name) {
//     final parts = name.trim().split(' ');
//     if (parts.isEmpty) return 'U';
//     if (parts.length == 1) return parts[0][0].toUpperCase();
//     return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//   }
// }
//
/*
class VideoPlayerPage extends StatefulWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList;

  const VideoPlayerPage({super.key, required this.video, this.videoList});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TubeCubit>();
    final state = cubit.state;

    if (state.currentVideo?.id == widget.video.id && state.isMinimized && state.areControllersInitialized) {
      // Same video in mini player: maximize and resume
      cubit.maximizePlayer();
      if (state.videoPlayerController != null && state.lastPlaybackPosition != null) {
        state.videoPlayerController!.seekTo(state.lastPlaybackPosition!);
        if (state.isPlaying) {
          state.videoPlayerController!.play();
        }
      }
    } else {
      // Different video or no mini player: initialize fresh
      cubit.playVideo(widget.video, videoList: widget.videoList);
    }
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final cubit = context.read<TubeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) => TubeCommentsSection(
            videoId: widget.video.id!,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }

  bool _isImageContent() {
    return widget.video.videoUrl == null || widget.video.videoUrl!.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<TubeCubit>().minimizePlayer();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<TubeCubit, TubeState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 400,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 300 && !state.isLoading && !_isImageContent()) {
                      context.read<TubeCubit>().minimizePlayer();
                      Navigator.pop(context);
                    }
                  },
                  child: _isImageContent()
                      ? Image.network(
                    widget.video.thumbnail ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, color: Colors.white),
                    ),
                  )
                      : Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.black, // helps hide any empty background
                    child: (state.isLoading ||
                        state.chewieController == null ||
                        !state.chewieController!.videoPlayerController.value.isInitialized)
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading video...', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Chewie(
                        controller: state.chewieController!,
                      ),
                    ),
                  ),


                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.title ?? "Not available",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.video.views} • ${widget.video.updatedAt}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildActionButton(Icons.thumb_up_outlined, '12K'),
                    _buildActionButton(Icons.thumb_down_outlined, 'Dislike'),
                    _buildActionButton(Icons.share, 'Share'),
                    _buildActionButton(Icons.download, 'Download'),
                    if (!_isImageContent())
                      _buildActionButton(
                        Icons.comment,
                        'Comments',
                        onTap: () => _showCommentsBottomSheet(context),
                      ),
                    _buildActionButton(Icons.library_add, 'Save'),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF272727)),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.video.description ?? "Not available",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const Divider(height: 1, color: Color(0xFF272727)),
              Expanded(
                child: _isImageContent()
                    ? BlocBuilder<TubeCubit, TubeState>(
                  builder: (context, state) {
                    final comments = context.read<TubeCubit>().tubeVideoComments;
                    if (comments.isEmpty && state.status == StateStatus.loading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    }
                    if (comments.isEmpty) {
                      return const Center(
                        child: Text('No comments yet', style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return GestureDetector(
                      onTap: () => _showCommentsBottomSheet(context),
                      child: CommentItem(
                        comment: comments.first,
                        videoId: widget.video.id!,
                        currentUserId: null,
                      ),
                    );
                  },
                )
                    : RelatedVideosScreen(videoId: widget.video.id!),
              ),
              const Divider(height: 1, color: Color(0xFF272727)),
            ],
          );
        },
      ),
    );
  }
}
*/