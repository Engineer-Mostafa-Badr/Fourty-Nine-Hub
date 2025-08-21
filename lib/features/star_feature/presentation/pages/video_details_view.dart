import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:visibility_detector/visibility_detector.dart';

// New Video Details View
class VideoDetailsView extends StatefulWidget {
  final StarEntity talent;
  final String mediaUrl;
  final VoidCallback? onBack; // Add callback for back action

  const VideoDetailsView({
    super.key,
    required this.talent,
    required this.mediaUrl,
    this.onBack, // Optional callback
  });

  @override
  State<VideoDetailsView> createState() => _VideoDetailsViewState();
}

class _VideoDetailsViewState extends State<VideoDetailsView> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  final List<Map<String, dynamic>> _viewers = [];
  final List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _generateMockData();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.mediaUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.setVolume(_isMuted ? 0 : 1);
        });
        _controller.play();
        setState(() => _isPlaying = true);
      });
  }

  void _generateMockData() {
    // Generate mock viewers data
    for (int i = 0; i < 10; i++) {
      _viewers.add({
        'name': 'Ahmed Mohamed',
        'profileImage': '',
        'viewTime': DateTime.now().subtract(Duration(minutes: i * 5)),
      });
    }

    // Generate mock comments data
    _comments.addAll([
      {
        'username': '@Ahmed',
        'profileImage': '',
        'comment': 'Heart Touching Nasheed',
        'timeAgo': '1 Month Ago',
        'likes': 4,
        'isLiked': false,
      },
      {
        'username': '@Mohamed',
        'profileImage': '',
        'comment': 'Beautiful voice and melody',
        'timeAgo': '2 Weeks Ago',
        'likes': 2,
        'isLiked': false,
      },
      {
        'username': '@Ali',
        'profileImage': '',
        'comment': 'This brings peace to my heart',
        'timeAgo': '1 Week Ago',
        'likes': 6,
        'isLiked': false,
      },
    ]);
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _handleBack() {
    if (widget.onBack != null) {
      // Use callback if provided
      widget.onBack!();
    } else {
      // Fallback to navigation pop
      Navigator.pop(context);
    }
  }

  void _showViewersModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Views',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(),
            // Viewers list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _viewers.length,
                itemBuilder: (context, index) {
                  final viewer = _viewers[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        SizedBox(width: 12),
                        Text(
                          viewer['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(),
            // Comments list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(Icons.person, size: 20, color: Colors.grey),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment['username'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '· ${comment['timeAgo']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                comment['comment'],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        comment['isLiked'] =
                                            !comment['isLiked'];
                                        if (comment['isLiked']) {
                                          comment['likes']++;
                                        } else {
                                          comment['likes']--;
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          comment['isLiked']
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_outlined,
                                          size: 16,
                                          color: comment['isLiked']
                                              ? Colors.blue
                                              : Colors.grey[600],
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${comment['likes']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Icon(
                                    Icons.thumb_down_outlined,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text('Are you sure about deleting the Talent'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _handleBack(); // Use the back handler instead of Navigator.pop
                // Add your delete logic here
                context.read<StarCubit>().deleteMyTalent(id: widget.talent.id);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if this is used as embedded widget (has onBack callback)
    final bool isEmbedded = widget.onBack != null;

    if (isEmbedded) {
      // Return just the content without Scaffold when embedded
      return Column(
        children: [
          // Custom back header
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: _handleBack,
                ),
                Text(
                  'My Talent',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Video content
          Expanded(child: _buildVideoContent()),
        ],
      );
    } else {
      // Return full Scaffold when used as standalone page
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildVideoContent(),
      );
    }
  }

  Widget _buildVideoContent() {
    return Column(
      children: [
        // Video section
        Expanded(
          child: Column(
            children: [
              // Video player
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Show/hide controls or toggle play/pause
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      if (_isInitialized)
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/testforvideo.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      // Controls overlay
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: !_isPlaying ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Mute button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: _toggleMute,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      // Duration
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '7:54',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Video info section
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.talent.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${widget.talent.user.firstName} ${widget.talent.user.lastName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${widget.talent.totalViews} views • ${timeago.format(widget.talent.createdAt ?? DateTime.now())}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Star rating
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < widget.talent.averageRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < widget.talent.averageRating
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.visibility,
                          label: '${widget.talent.totalViews} views',
                          onTap: _showViewersModal,
                        ),
                        _buildActionButton(
                          icon: Icons.comment,
                          label: 'Comments',
                          onTap: _showCommentsModal,
                        ),
                        _buildActionButton(
                          icon: Icons.delete,
                          label: 'Delete',
                          onTap: _handleDelete,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red : Color(0xFF1B365C),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
