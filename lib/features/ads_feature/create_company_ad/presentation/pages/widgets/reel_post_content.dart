import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../domain/entities/company_ad_entity.dart';
import '../../../domain/entities/media_entity.dart';

class ReelsPostContent extends StatelessWidget {
  const ReelsPostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: _buildAppBar(context),
      backgroundColor: Colors.transparent,
      body: const ReelsScreen(),
    );
  }
}

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialReels();
  }

  void _fetchInitialReels() {
    if (mounted) {
      context
          .read<CreateCompanyAdCubit>()
          .getCompanyAdPosts('reel', params: PaginationParams.basic());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
      listener: (BuildContext context, CreateCompanyAdState state) {
        if (state.status == StateStatus.success) {
          showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
        }
      },
      builder: (context, state) {
        return PaginationView<CompanyAdEntity>(
          loadingWidget: const SizedBox.shrink(),
          build:
              (ScrollController scrollController, List<CompanyAdEntity> data) {
            if (data.isEmpty) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 25),
              );
            }
            return data.isNotEmpty
                ? PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    onPageChanged: (index) {
                      _handlePageChange(index, data);
                    },
                    itemBuilder: (context, index) {
                      if (index >= data.length) {
                        return const Center(
                          child: CupertinoActivityIndicator(radius: 25),
                        );
                      }

                      var mediaList = data[index].media;
                      if (mediaList == null || index >= mediaList.length) {
                        return const Center(
                          child: CupertinoActivityIndicator(radius: 25),
                        );
                      }

                      var mediaItem = mediaList[index];
                      return ReelItemForCompany(
                        key: ValueKey(mediaItem.sId),
                        post: mediaItem,
                        isVisible: _currentPage == index,
                        advertises: data[index],
                        onDeleteItem: (id) async {
                          var result = await context
                              .read<CreateCompanyAdCubit>()
                              .deleteCompanyAd(id: id);
                          if (result == true) {
                            data.removeWhere((e) => e.sId == id);
                            setState(() {});
                          }
                        },
                      );
                    })
                : Center(child: Label(text: LocaleKeys.noPosts.localize));
          },
          fetchData: (PaginationParams paginationParams) {
            return context.read<CreateCompanyAdCubit>().getCompanyAdPosts(
                  'reel',
                  params: paginationParams,
                );
          },
        );
      },
    );
  }

  void _handlePageChange(index, data) {
    setState(() => _currentPage = index);
    final postsCubit = context.read<CreateCompanyAdCubit>();
    if (index == data.length - 1 && mounted) {
      postsCubit.getCompanyAdPosts('reel', params: PaginationParams.basic());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class ReelItemForCompany extends StatefulWidget {
  final MediaEntity? post;
  final bool isVisible;
  final CompanyAdEntity advertises;
  final Function(String) onDeleteItem;

  const ReelItemForCompany(
      {super.key,
      required this.post,
      required this.isVisible,
      required this.advertises,
      required this.onDeleteItem});

  @override
  ReelItemForCompanyState createState() => ReelItemForCompanyState(advertises, onDeleteItem);
}

class ReelItemForCompanyState extends State<ReelItemForCompany> with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;
  final CompanyAdEntity advertises;
  final Function(String) onDeleteItem;

  ReelItemForCompanyState(this.advertises, this.onDeleteItem);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ReelItemForCompany oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _playVideo() : _pauseVideo();
    }
  }

  Future<void> _initializePlayer() async {
    if (!await _checkConnectivity()) return;

    await _initializeVideoController();
    _setupChewieController();
    _setInitialVideoState();
  }

  Future<void> _initializeVideoController() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.post?.photo ?? ''));
    try {
      print('Initializing video controller with URL: ${widget.post?.photo}');
      await _videoPlayerController.initialize();
      print('Video controller initialized successfully');
    } catch (error) {
      print('Error initializing video controller: $error');
      if (mounted) {
        _handleVideoError('Failed to load video');
      }
    }
  }

  void _setupChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.isVisible,
      looping: true,
      showControls: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
    );
  }

  void _setInitialVideoState() {
    if (mounted) {
      setState(() {
        _isInitialized = true;
        _isPlaying = widget.isVisible;
      });
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        _handleVideoError('No internet connection');
      }
      return false;
    }
    return true;
  }

  void _handleVideoError(String message) {
    if (mounted) {
      setState(() {
        _isInitialized = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _playVideo() {
    if (_isInitialized && !_isPlaying) {
      _chewieController?.play();
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _showPlayPauseIcon = true;
        });
      }
      _hidePlayPauseIconAfterDelay();
    }
  }

  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      _chewieController?.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _showPlayPauseIcon = true;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
  }

  void _hidePlayPauseIconAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoOrPlaceholder(),
          _buildPlayPauseIcon(),
          _buildOverlay(advertises, onDeleteItem),
          if (!_isInitialized)
            const Center(
              child: CupertinoActivityIndicator(radius: 25),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoOrPlaceholder() {
    if (_isInitialized && _chewieController != null) {
      return FittedBox(
        fit: BoxFit.fitHeight,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: Chewie(controller: _chewieController!),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.post?.photo ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CupertinoActivityIndicator(radius: 25),
        ),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      );
    }
  }

  Widget _buildPlayPauseIcon() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Center(
        child: AnimatedOpacity(
          opacity: _showPlayPauseIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(
      CompanyAdEntity advertises, Function(String) onDeleteItem) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReelInfo(advertises, onDeleteItem),
        SizedBox(height: kToolbarHeight + 20),
        Expanded(
          child: GestureDetector(
            onTap: _togglePlayPause,
          ),
        ),
      ],
    );
  }

  Widget _buildReelInfo(
      CompanyAdEntity advertises, final Function(String) onDeleteItem) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: height * 0.5,
        width: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  // _pauseVideo();

                  onDeleteItem(advertises.sId!);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const ReelsRecordingScreen(),
                  //     ));
                },
                icon: const FaIcon(
                  Icons.close,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pauseVideo();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

class ScrollingText extends StatefulWidget {
  final String text;

  const ScrollingText({super.key, required this.text});

  @override
  ScrollingTextState createState() => ScrollingTextState();
}

class ScrollingTextState extends State<ScrollingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(_animation.value, 0),
              child: child,
            );
          },
          child: Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 25.sp,
              color: AppColors.UNSELECTED_GRAY_COLOR,
              shadows: const [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
