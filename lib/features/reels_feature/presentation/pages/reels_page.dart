import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../controllers/reels_cubit.dart';
import '../widgets/reel_widget.dart';
import '../../domain/entities/reel_entity.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, ChewieController> _chewieControllers = {};
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    try {
      final cubit = context.read<TiktokCubit>();
      cubit.loadReels();
    } catch (e) {
      print('Error initializing reels page: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    _disposeAllControllers();
    super.dispose();
  }

  void _disposeAllControllers() {
    try {
      for (final controller in _chewieControllers.values) {
        controller.dispose();
      }
      for (final controller in _videoControllers.values) {
        controller.dispose();
      }
      _chewieControllers.clear();
      _videoControllers.clear();
    } catch (e) {
      print('Error disposing controllers: $e');
    }
  }

  void _preloadVideos(int currentIndex, List<ReelEntity> reels) {
    if (_isDisposed) return;
    
    try {
      // More conservative preloading - only 2 videos before and after
      final startIndex = (currentIndex - 2).clamp(0, reels.length - 1);
      final endIndex = (currentIndex + 2).clamp(0, reels.length - 1);

      for (int i = startIndex; i <= endIndex; i++) {
        if (!_videoControllers.containsKey(i) && !_isDisposed) {
          _initializeVideoController(i, reels[i]);
        }
      }

      // Dispose controllers that are too far away
      final keysToRemove = <int>[];
      for (final key in _videoControllers.keys) {
        if (key < startIndex - 1 || key > endIndex + 1) {
          keysToRemove.add(key);
        }
      }

      for (final key in keysToRemove) {
        _disposeController(key);
      }
    } catch (e) {
      print('Error preloading videos: $e');
    }
  }

  void _initializeVideoController(int index, ReelEntity reel) async {
    if (_isDisposed) return;
    
    try {
      final videoController = VideoPlayerController.networkUrl(
        Uri.parse(reel.videoUrl),
      );

      await videoController.initialize();

      if (_isDisposed) {
        videoController.dispose();
        return;
      }

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: index == _currentIndex,
        looping: true,
        showControls: false,
        aspectRatio: videoController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Error loading video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (mounted && !_isDisposed) {
        setState(() {
          _videoControllers[index] = videoController;
          _chewieControllers[index] = chewieController;
        });
      } else {
        chewieController.dispose();
        videoController.dispose();
      }
    } catch (e) {
      print('Error initializing video controller for index $index: $e');
    }
  }

  void _disposeController(int index) {
    try {
      _chewieControllers[index]?.dispose();
      _videoControllers[index]?.dispose();
      _chewieControllers.remove(index);
      _videoControllers.remove(index);
    } catch (e) {
      print('Error disposing controller at index $index: $e');
    }
  }

  void _onPageChanged(int index) {
    if (_isDisposed) return;
    
    try {
      setState(() {
        _currentIndex = index;
      });

      // Pause all videos
      for (final controller in _videoControllers.values) {
        try {
          controller.pause();
        } catch (e) {
          print('Error pausing video controller: $e');
        }
      }

      // Play current video
      final currentController = _videoControllers[index];
      if (currentController != null) {
        try {
          currentController.play();
        } catch (e) {
          print('Error playing current video: $e');
        }
      }

      // Update cubit
      try {
        final cubit = context.read<TiktokCubit>();
        cubit.setCurrentIndex(index);
      } catch (e) {
        print('Error updating cubit: $e');
      }

      // Preload videos
      try {
        if (context.read<TiktokCubit>().state is TiktokLoaded) {
          final state = context.read<TiktokCubit>().state as TiktokLoaded;
          _preloadVideos(index, state.reels);
        }
      } catch (e) {
        print('Error preloading videos: $e');
      }
    } catch (e) {
      print('Error in page changed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<TiktokCubit, TiktokState>(
        builder: (context, state) {
          if (state is TiktokLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (state is TiktokError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        context.read<TiktokCubit>().loadReels();
                      } catch (e) {
                        print('Error reloading reels: $e');
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TiktokLoaded) {
            return Column(
              children: [
                // Header
                _buildHeader(),
                
                // Video content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: state.reels.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      try {
                        final reel = state.reels[index];
                        final isPlaying = index == _currentIndex;
                        
                        return ReelWidget(
                          reel: reel,
                          isPlaying: isPlaying,
                          videoController: _videoControllers[index],
                          chewieController: _chewieControllers[index],
                          onLike: () {
                            try {
                              context.read<TiktokCubit>().likeReel(reel.id);
                            } catch (e) {
                              print('Error liking reel: $e');
                            }
                          },
                          onShare: () {
                            try {
                              context.read<TiktokCubit>().shareReel(reel.id);
                            } catch (e) {
                              print('Error sharing reel: $e');
                            }
                          },
                          onComment: () {
                            // TODO: Implement comment functionality
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Comment on ${reel.title}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              print('Error showing comment snackbar: $e');
                            }
                          },
                          onFollow: () {
                            // TODO: Implement follow functionality
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Follow ${reel.authorName}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              print('Error showing follow snackbar: $e');
                            }
                          },
                        );
                      } catch (e) {
                        print('Error building reel widget: $e');
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              'Error loading video',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Title
          Text(
            'TikTok Reels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),
          
          // Search button
          GestureDetector(
            onTap: () {
              // TODO: Implement search functionality
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search functionality coming soon!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } catch (e) {
                print('Error showing search snackbar: $e');
              }
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // More options button
          GestureDetector(
            onTap: () {
              // TODO: Implement more options
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('More options coming soon!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } catch (e) {
                print('Error showing options snackbar: $e');
              }
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
