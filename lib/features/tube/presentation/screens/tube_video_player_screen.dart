import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../cubit/tube_cubit.dart';


import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';
import '../widgets/video_card_widget.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';
import '../widgets/video_card_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../cubit/tube_cubit.dart';
import '../widgets/video_card_widget.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../cubit/tube_cubit.dart';
import '../widgets/video_card_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList; // Added to pass the video list

  const VideoPlayerPage({super.key, required this.video, this.videoList});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TubeCubit>();
    if (cubit.state.currentVideo?.id != widget.video.id) {
      cubit.playVideo(widget.video, videoList: widget.videoList); // Pass videoList
    } else {
      cubit.maximizePlayer();
    }
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
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
          return ListView(
            children: [
              // 🎥 Video Player Section
              SizedBox(
                height: 400,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 300 && !state.isLoading) {
                      context.read<TubeCubit>().minimizePlayer();
                      Navigator.pop(context);
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: state.chewieController?.videoPlayerController.value.aspectRatio ?? 16 / 9,
                    child: (state.isLoading || state.chewieController == null || !state.chewieController!.videoPlayerController.value.isInitialized)
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('جارٍ تحميل الفيديو...', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    )
                        : Chewie(controller: state.chewieController!),
                  ),
                ),
              ),

              // 📝 Video Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.title ?? "غير متوفر",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.video.views} • ${widget.video.updatedAt}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // 🔘 Action Buttons
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildActionButton(Icons.thumb_up_outlined, '12K'),
                    _buildActionButton(Icons.thumb_down_outlined, 'غير معجب'),
                    _buildActionButton(Icons.share, 'مشاركة'),
                    _buildActionButton(Icons.download, 'تنزيل'),
                    _buildActionButton(Icons.library_add, 'حفظ'),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFF272727)),

              // 📜 Description
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.video.description ?? "غير متوفر",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              const Divider(height: 1, color: Color(0xFF272727)),

              TubeCommentsSection(videoId: widget.video.id!),

              RelatedVideosScreen(videoId: widget.video.id!),

              const Divider(height: 1, color: Color(0xFF272727)),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class TubeCommentsSection extends StatefulWidget {
  final String videoId;

  const TubeCommentsSection({super.key, required this.videoId});

  @override
  State<TubeCommentsSection> createState() => _TubeCommentsSectionState();
}

class _TubeCommentsSectionState extends State<TubeCommentsSection> {
  late final ScrollController _scrollController;
  int _visibleCommentsCount = 3;
  bool _isCommentsExpanded = false;
  bool _allCommentsLoadedIncrementally = false; // NEW: Track incremental loading

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    final cubit = context.read<TubeCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadInitialTubeVideoComments(context, widget.videoId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.getTubeVideoComments(context);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleCommentsExpansion(List<TubeCommentEntity> comments, TubeCubit cubit) {
    setState(() {
      if (_areAllCommentsVisible(comments, cubit)) {
        // If all comments are visible, collapse them
        _isCommentsExpanded = false;
        _allCommentsLoadedIncrementally = false; // Reset incremental flag
        _visibleCommentsCount = 3;
      } else {
        // If not all comments are visible, expand them
        _isCommentsExpanded = true;
        _visibleCommentsCount = comments.length;
      }
    });
  }

  void _loadMoreComments(List<TubeCommentEntity> comments, TubeCubit cubit) {
    setState(() {
      _visibleCommentsCount += 3;

      // Check if we've loaded all comments incrementally
      if (_visibleCommentsCount >= comments.length && !cubit.hasMoreTubeVideoComments) {
        _allCommentsLoadedIncrementally = true;
      }
    });

    // If we've reached the end of loaded comments and there are more from API, load them
    if (_visibleCommentsCount >= comments.length &&
        cubit.hasMoreTubeVideoComments) {
      cubit.getTubeVideoComments(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        final cubit = context.read<TubeCubit>();
        final comments = cubit.tubeVideoComments;

        // Only show initial loading when there are no comments
        if (cubit.isTubeVideoCommentsInitialLoading && comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Comment Widget at the top
            AddCommentWidget(
              videoId: widget.videoId,
              currentUserAvatar: null,
              currentUserName: null,
            ),

            if (comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
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
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comments Header with Expand/Collapse
                  _buildCommentsHeader(comments, cubit),

                  const Divider(height: 1, color: Color(0xFF272727)),

                  // Comments List
                  _buildCommentsList(comments, cubit),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentsHeader(List<TubeCommentEntity> comments, TubeCubit cubit) {
    final areAllCommentsVisible = _areAllCommentsVisible(comments, cubit);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${_getTotalCommentsCount(comments)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Spacer(),

          // Expand/Collapse Button (YouTube style) - Only show when there are more than 3 comments
          if (comments.length > 3)
            TextButton(
              onPressed: () => _toggleCommentsExpansion(comments, cubit),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    areAllCommentsVisible ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    areAllCommentsVisible ? 'Show less' : 'Show more',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _areAllCommentsVisible(List<TubeCommentEntity> comments, TubeCubit cubit) {
    // All comments are visible if:
    // 1. User clicked "Show more" in header OR
    // 2. User loaded all comments incrementally
    return _isCommentsExpanded || _allCommentsLoadedIncrementally;
  }

  Widget _buildCommentsList(List<TubeCommentEntity> comments, TubeCubit cubit) {
    // Determine visible comments based on state
    final visibleComments = _areAllCommentsVisible(comments, cubit)
        ? comments
        : comments.take(_visibleCommentsCount).toList();

    // Check if there are more comments to show (only when not all comments are visible)
    final hasMoreToShow = !_areAllCommentsVisible(comments, cubit) &&
        (_visibleCommentsCount < comments.length || cubit.hasMoreTubeVideoComments);

    return Column(
      children: [
        // Comments List
        ListView.builder(
          controller: _areAllCommentsVisible(comments, cubit) ? _scrollController : null,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleComments.length + (hasMoreToShow ? 1 : 0) + _getAdditionalItemsCount(comments, cubit),
          itemBuilder: (context, index) {
            // Show comments
            if (index < visibleComments.length) {
              final comment = visibleComments[index];
              return CommentItem(
                comment: comment,
                videoId: widget.videoId,
                currentUserId: null,
              );
            }

            // Show "Load more" button when not all comments are visible and there are more comments
            else if (!_areAllCommentsVisible(comments, cubit) &&
                index == visibleComments.length &&
                hasMoreToShow) {
              return _buildLoadMoreButton(comments, cubit);
            }

            // Show loading indicator for pagination
            else if (cubit.isTubeVideoCommentsLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              );
            }

            // Show "No more comments"
            else if (!cubit.hasMoreTubeVideoComments &&
                comments.isNotEmpty &&
                index >= comments.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No more comments',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton(List<TubeCommentEntity> comments, TubeCubit cubit) {
    final remainingComments = comments.length - _visibleCommentsCount;
    final hasMoreFromApi = cubit.hasMoreTubeVideoComments;

    String buttonText;
    if (hasMoreFromApi && remainingComments > 0) {
      buttonText = 'View $remainingComments more comments';
    } else if (hasMoreFromApi) {
      buttonText = 'Load more comments';
    } else {
      buttonText = 'View $remainingComments more comments';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: TextButton(
          onPressed: () => _loadMoreComments(comments, cubit),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.expand_more,
                size: 18,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getAdditionalItemsCount(List<TubeCommentEntity> comments, TubeCubit cubit) {
    int count = 0;

    // Only add "Load more" button when not all comments are visible
    if (!_areAllCommentsVisible(comments, cubit) &&
        (_visibleCommentsCount < comments.length || cubit.hasMoreTubeVideoComments)) {
      count += 1;
    }

    // Add loading indicator
    if (cubit.isTubeVideoCommentsLoadingMore) {
      count += 1;
    }

    // Add "No more comments" when appropriate
    if (!cubit.hasMoreTubeVideoComments && comments.isNotEmpty) {
      count += 1;
    }

    return count;
  }

  int _getTotalCommentsCount(List<TubeCommentEntity> comments) {
    int total = comments.length;
    for (var comment in comments) {
      total += comment.replies.length;
    }
    return total;
  }
}

// ---------------------------------------------------------------
// 💬 CommentItem: Individual comment card with nested replies
// ---------------------------------------------------------------
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
  bool _showReplies = false;
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

    // TODO: Initialize from API if your backend tracks user-specific likes
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
              // Avatar
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

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username + timestamp
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

                    // Comment text
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

                    // Like / Dislike / Reply buttons
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
                          if (!widget.isReply) ...[
                            const SizedBox(width: 12),
                            _ActionButton(
                              icon: Icons.comment_outlined,
                              label: 'Reply',
                              onTap: () => _showReplyDialog(context),
                            ),
                          ],
                        ],
                      ),

                    // Show/Hide Replies Button (YouTube style)
                    if (repliesCount > 0 && !_isEditing && !widget.isReply)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showReplies = !_showReplies;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _showReplies ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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

              // Menu (edit/delete/report)
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

        // Nested Replies (YouTube style)
        if (_showReplies && repliesCount > 0 && !widget.isReply)
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
  }

  // 🩵 Handles like toggle
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

  // 💔 Handles dislike toggle
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

  void _showReplyDialog(BuildContext context) {
    final replyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reply to ${widget.comment.owner?.channelName ?? 'User'}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              maxLines: 3,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a reply...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final reply = replyController.text.trim();
                    if (reply.isNotEmpty) {
                      Navigator.pop(ctx);
                      context.read<TubeCubit>().createCommentOnTubeVideo(
                        context: context,
                        videoId: widget.videoId,
                        content: reply,
                        parentCommentId: widget.comment.id,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Reply'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.blue : Colors.grey,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// ➕ Add Comment Widget
// ---------------------------------------------------------------
class AddCommentWidget extends StatefulWidget {
  final String videoId;
  final String? currentUserAvatar;
  final String? currentUserName;

  const AddCommentWidget({
    Key? key,
    required this.videoId,
    this.currentUserAvatar,
    this.currentUserName,
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
        _isExpanded = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _postComment() {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final cubit = context.read<TubeCubit>();

    // Clear input and close immediately
    _commentController.clear();
    _focusNode.unfocus();
    setState(() => _isExpanded = false);

    // Make completely silent API call - no loading state
    cubit.createCommentOnTubeVideo(
      context: context,
      videoId: widget.videoId,
      content: content,
      parentCommentId: null,
    );
  }

  void _cancel() {
    _commentController.clear();
    _focusNode.unfocus();
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[800],
            backgroundImage: widget.currentUserAvatar != null &&
                widget.currentUserAvatar!.isNotEmpty
                ? NetworkImage(widget.currentUserAvatar!)
                : null,
            child: widget.currentUserAvatar == null ||
                widget.currentUserAvatar!.isEmpty
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _commentController,
                  focusNode: _focusNode,
                  maxLines: _isExpanded ? 3 : 1,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    filled: false,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 0,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _cancel,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _commentController.text.trim().isEmpty
                            ? null
                            : _postComment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _commentController.text.trim().isEmpty
                              ? Colors.grey[800]
                              : Colors.blue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[800],
                          disabledForegroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Comment'), // No loading indicator
                      ),
                    ],
                  ),
                ],
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
// 💬 Comments Section

class RelatedVideosScreen extends StatefulWidget {
  final String videoId;

  const RelatedVideosScreen({super.key, required this.videoId});

  @override
  State<RelatedVideosScreen> createState() => _RelatedVideosScreenState();
}

class _RelatedVideosScreenState extends State<RelatedVideosScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    final cubit = context.read<TubeCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadInitialRelatedTubeVideos(context, widget.videoId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.getRelatedTubeVideos(context);
      }
    });
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
