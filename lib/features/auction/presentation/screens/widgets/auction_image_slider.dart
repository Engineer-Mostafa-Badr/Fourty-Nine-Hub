import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:video_player/video_player.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../domain/entities/get_all_auction_entity.dart';
class AuctionImageCarousel extends StatefulWidget {
  final List<AuctionMediaEntity> images;

  const AuctionImageCarousel({super.key, required this.images});

  @override
  State<AuctionImageCarousel> createState() => _AuctionImageCarouselState();
}

class _AuctionImageCarouselState extends State<AuctionImageCarousel> {
  int activeIndex = 0;
  int maxReachedIndex = 0; // track how far user has scrolled
  final CarouselSliderController _controller = CarouselSliderController();

  bool _isVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv');
  }

  Widget _buildCustomDots() {
    final totalImages = widget.images.length;

    if (totalImages <= 1) return const SizedBox.shrink();

    const mainDots = 4; // initial normal dots

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalImages, (index) {
        final isActive = index == activeIndex;

        // if user has reached this dot once, promote it to normal
        final isPromoted = index < mainDots || index <= maxReachedIndex;

        double dotSize;
        Color dotColor;

        if (isPromoted) {
          if (isActive) {
            dotSize = 12.0;
            dotColor = context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR;
          } else {
            dotSize = 6.0;
            dotColor = Colors.grey.shade400;
          }
        } else {
          if (isActive) {
            dotSize = 12.0;
            dotColor = context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR;
          } else {
            dotSize = 3.0;
            dotColor = Colors.grey.shade400;
          }
        }

        return GestureDetector(
          onTap: () {
            _controller.animateToPage(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    return Column(
      children: [
        // ===== IMAGE / VIDEO CAROUSEL =====
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: total,
          itemBuilder: (context, index, realIndex) {
            final media = widget.images[index];
            final mediaUrl = media.mediaKey ?? "";

            if (mediaUrl.isEmpty) {
              return _buildErrorWidget();
            }

            final isVideo = _isVideo(mediaUrl);

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isVideo
                  ? VideoPlayerWidget.network(url: mediaUrl)
                  : ImageFromInternet(
              image: mediaUrl,
                height: 201,
                width: double.infinity,
                fit: BoxFit.cover,
                // errorBuilder: (_, __, ___) => _buildErrorWidget(),
              ),
            );
          },
          options: CarouselOptions(
            height: 201,
            viewportFraction: 1,
            autoPlay: false,
            // autoPlay: total > 1,
            enableInfiniteScroll: total > 1,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
                if (index > maxReachedIndex) {
                  maxReachedIndex = index; // promote dots progressively
                }
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // ===== CUSTOM DOTS INDICATOR =====
        _buildCustomDots(),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 160,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String? url;
  final File? file;
  final String? thumbnailUrl;
  final bool autoInitialize;

  const VideoPlayerWidget.network({
    super.key,
    required this.url,
    this.thumbnailUrl,
    this.autoInitialize = false,
  }) : file = null;

  const VideoPlayerWidget.file({
    super.key,
    required this.file,
    this.thumbnailUrl,
    this.autoInitialize = false,
  }) : url = null;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _showVideo = false;

  @override
  bool get wantKeepAlive => _isInitialized;

  @override
  void initState() {
    super.initState();
    if (widget.autoInitialize) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (_isLoading || _isInitialized) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      if (widget.url != null) {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.url!),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
      } else if (widget.file != null) {
        _videoController = VideoPlayerController.file(widget.file!);
      }

      if (_videoController != null) {
        await _videoController!.initialize();

        if (mounted) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: false,
            looping: false,
            // Remove aspectRatio to let video fill container width
            // aspectRatio: _videoController!.value.aspectRatio,
            autoInitialize: true,
            showControls: true,
            // Custom control theme to make icons smaller
            cupertinoProgressColors: ChewieProgressColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey.shade300,
            ),
            materialProgressColors: ChewieProgressColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey.shade300,
            ),
            // Make controls smaller
            optionsTranslation: OptionsTranslation(
              playbackSpeedButtonText: 'Speed',
              subtitlesButtonText: 'Subtitles',
              cancelButtonText: 'Cancel',
            ),
            placeholder: widget.thumbnailUrl != null
                ? Container(
              color: Colors.black,
              child: Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
              ),
            )
                : Container(color: Colors.black),
            errorBuilder: (context, errorMessage) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.white, size: 24),
                      SizedBox(height: 8),
                      Text(
                        'Video failed to load',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          setState(() {
            _isInitialized = true;
            _isLoading = false;
            _showVideo = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _onThumbnailTap() {
    if (!_isInitialized && !_isLoading) {
      _initializeVideo();
    } else if (_isInitialized) {
      setState(() {
        _showVideo = true;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_hasError) {
      return Container(
        height: 201, // Match carousel height
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 30, color: Colors.grey),
            SizedBox(height: 8),
            Text('Failed to load video', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Container(
        height: 201, // Match carousel height
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            if (widget.thumbnailUrl != null)
              Image.network(
                widget.thumbnailUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isInitialized && _showVideo && _chewieController != null) {
      // Fixed: Use Container with proper sizing
      return ClipRRect(
        borderRadius: BorderRadius.circular(12), // Match carousel border radius
        child: Theme(
          // Override theme to make video controls smaller
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(size: 20), // Smaller icons
            textTheme: Theme.of(context).textTheme.copyWith(
              bodyLarge: const TextStyle(fontSize: 12),
              bodyMedium: const TextStyle(fontSize: 10),
            ),
          ),
          child: Chewie(controller: _chewieController!),
        ),
      );
    }

    // Show thumbnail with play button
    return GestureDetector(
      onTap: _onThumbnailTap,
      child: Container(
        height: 201, // Match carousel height
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.thumbnailUrl != null)
              Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.videocam, size: 30, color: Colors.grey),
                  );
                },
              )
            else
              Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.videocam, size: 30, color: Colors.grey),
              ),
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class VideoPlayerWidget extends StatefulWidget {
  final String? url;
  final File? file;
  final String? thumbnailUrl;
  final bool autoInitialize;

  const VideoPlayerWidget.network({
    super.key,
    required this.url,
    this.thumbnailUrl,
    this.autoInitialize = false,
  }) : file = null;

  const VideoPlayerWidget.file({
    super.key,
    required this.file,
    this.thumbnailUrl,
    this.autoInitialize = false,
  }) : url = null;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _showVideo = false;

  @override
  bool get wantKeepAlive => _isInitialized;

  @override
  void initState() {
    super.initState();
    if (widget.autoInitialize) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (_isLoading || _isInitialized) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      if (widget.url != null) {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.url!),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
      } else if (widget.file != null) {
        _videoController = VideoPlayerController.file(widget.file!);
      }

      if (_videoController != null) {
        await _videoController!.initialize();

        if (mounted) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: false,
            looping: false,
            aspectRatio: _videoController!.value.aspectRatio,
            autoInitialize: true,
            showControls: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey.shade300,
            ),
            placeholder: widget.thumbnailUrl != null
                ? Container(
              color: Colors.black,
              child: Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
              ),
            )
                : Container(color: Colors.black),
            errorBuilder: (context, errorMessage) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.white, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Video failed to load',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          setState(() {
            _isInitialized = true;
            _isLoading = false;
            _showVideo = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _onThumbnailTap() {
    if (!_isInitialized && !_isLoading) {
      _initializeVideo();
    } else if (_isInitialized) {
      setState(() {
        _showVideo = true;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_hasError) {
      return Container(
        height: 180,
        color: Colors.grey.shade200,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('Failed to load video'),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Container(
        height: 180,
        color: Colors.black,
        child: Stack(
          children: [
            if (widget.thumbnailUrl != null)
              Image.network(
                widget.thumbnailUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (_isInitialized && _showVideo && _chewieController != null) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    }

    // Show thumbnail with play button
    return GestureDetector(
      onTap: _onThumbnailTap,
      child: Container(
        height: 180,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.thumbnailUrl != null)
              Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.videocam, size: 50),
                  );
                },
              )
            else
              Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.videocam, size: 50),
              ),
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
class AuctionImageCarousel extends StatefulWidget {
  final List<AuctionMediaEntity> images;

  const AuctionImageCarousel({super.key, required this.images});

  @override
  State<AuctionImageCarousel> createState() => _AuctionImageCarouselState();
}
class _AuctionImageCarouselState extends State<AuctionImageCarousel> {
  int activeIndex = 0;
  int maxReachedIndex = 0; // track how far user has scrolled
  final CarouselSliderController _controller = CarouselSliderController();

  Widget _buildCustomDots() {
    final totalImages = widget.images.length;

    if (totalImages <= 1) return const SizedBox.shrink();

    const mainDots = 4; // initial normal dots

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalImages, (index) {
        final isActive = index == activeIndex;

        // if user has reached this dot once, promote it to normal
        final isPromoted = index < mainDots || index <= maxReachedIndex;

        double dotSize;
        Color dotColor;

        if (isPromoted) {
          // behaves like a normal dot
          if (isActive) {
            dotSize = 12.0;
            dotColor = context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR;
          } else {
            dotSize = 6.0;
            dotColor = Colors.grey.shade400;
          }
        } else {
          // still tiny until visited
          if (isActive) {
            dotSize = 12.0;
            dotColor = context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR;
          } else {
            dotSize = 3.0;
            dotColor = Colors.grey.shade400;
          }
        }

        return GestureDetector(
          onTap: () {
            _controller.animateToPage(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ===== IMAGE CAROUSEL =====
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = widget.images[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl.mediaKey!,
                height: 201,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 201,
            viewportFraction: 1,
            autoPlay: true,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
                if (index > maxReachedIndex) {
                  maxReachedIndex = index; // promote dots progressively
                }
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // ===== CUSTOM DOTS INDICATOR =====
        _buildCustomDots(),
      ],
    );
  }

}
*/