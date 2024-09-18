// //
// //
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:chewie/chewie.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
// // import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
// // import '../../data/repositories/reels_repository_impl.dart';
// //
// // class ReelView extends StatelessWidget {
// //   const ReelView({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true,
// //       appBar: _buildAppBar(context),
// //       backgroundColor: Colors.transparent,
// //       body: BlocProvider(
// //         create: (context) => ReelsCubit(repository: ReelsRepository()),
// //         child: const ReelsScreen(),
// //       ),
// //     );
// //   }
// //
// //   AppBar _buildAppBar(BuildContext context) {
// //     return AppBar(
// //       backgroundColor: Colors.transparent,
// //       elevation: 0,
// //       leading: IconAppButton(
// //         icon: Icons.arrow_back,
// //         color: Colors.white,
// //         size: 24,
// //         onPressed: () => context.pop(),
// //       ),
// //     );
// //   }
// // }
// //
// // class ReelsScreen extends StatefulWidget {
// //   const ReelsScreen({super.key});
// //
// //   @override
// //   ReelsScreenState createState() => ReelsScreenState();
// // }
// //
// // class ReelsScreenState extends State<ReelsScreen> {
// //   final PageController _pageController = PageController();
// //   int _currentPage = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     context.read<ReelsCubit>().fetchReels();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<ReelsCubit, ReelsState>(
// //       builder: (context, state) {
// //         if (state.reels.isEmpty) {
// //           return const Center(
// //               child: CupertinoActivityIndicator(
// //             radius: 25,
// //           ));
// //         }
// //
// //         return PageView.builder(
// //           physics: const BouncingScrollPhysics(),
// //           controller: _pageController,
// //           scrollDirection: Axis.vertical,
// //           itemCount: state.reels.length + (state.hasReachedMax ? 0 : 1),
// //           onPageChanged: (index) {
// //             setState(() => _currentPage = index);
// //             if (index == state.reels.length - 1) {
// //               context.read<ReelsCubit>().fetchReels();
// //             }
// //           },
// //           itemBuilder: (context, index) {
// //             if (index >= state.reels.length) {
// //               return const Center(
// //                   child: CupertinoActivityIndicator(radius: 25));
// //             }
// //             return ReelItem(
// //               key: ValueKey(state.reels[index].id),
// //               reel: state.reels[index],
// //               isVisible: _currentPage == index,
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// // }
// //
// // class ReelItem extends StatefulWidget {
// //   final Reel reel;
// //   final bool isVisible;
// //
// //   const ReelItem({super.key, required this.reel, required this.isVisible});
// //
// //   @override
// //   ReelItemState createState() => ReelItemState();
// // }
// //
// // class ReelItemState extends State<ReelItem> with AutomaticKeepAliveClientMixin {
// //   late final VideoPlayerController _videoPlayerController;
// //   ChewieController? _chewieController;
// //   bool _isInitialized = false;
// //   bool _isPlaying = false;
// //   bool _showPlayPauseIcon = false;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   @override
// //   void didUpdateWidget(ReelItem oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.isVisible != oldWidget.isVisible) {
// //       widget.isVisible ? _playVideo() : _pauseVideo();
// //     }
// //   }
// //
// //   Future<void> _initializePlayer() async {
// //     if (!await _checkConnectivity()) return;
// //
// //     _videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
// //
// //     try {
// //       await _videoPlayerController.initialize();
// //       _chewieController = ChewieController(
// //         videoPlayerController: _videoPlayerController,
// //         autoPlay: widget.isVisible,
// //         looping: true,
// //         showControls: false,
// //         aspectRatio: _videoPlayerController.value.aspectRatio,
// //       );
// //       setState(() {
// //         _isInitialized = true;
// //         _isPlaying = widget.isVisible;
// //       });
// //     } catch (error) {
// //       _handleVideoError('Failed to load video');
// //     }
// //   }
// //
// //   Future<bool> _checkConnectivity() async {
// //     final connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.none) {
// //       _handleVideoError('No internet connection');
// //       return false;
// //     }
// //     return true;
// //   }
// //
// //   void _handleVideoError(String message) {
// //     setState(() {
// //       _isInitialized = false;
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message)),
// //     );
// //   }
// //
// //   void _playVideo() {
// //     if (_isInitialized && !_isPlaying) {
// //       _chewieController?.play();
// //       setState(() {
// //         _isPlaying = true;
// //         _showPlayPauseIcon = true;
// //       });
// //       _hidePlayPauseIconAfterDelay();
// //     }
// //   }
// //
// //   void _pauseVideo() {
// //     if (_isInitialized && _isPlaying) {
// //       _chewieController?.pause();
// //       setState(() {
// //         _isPlaying = false;
// //         _showPlayPauseIcon = true;
// //       });
// //     }
// //   }
// //
// //   void _togglePlayPause() {
// //     if (_isPlaying) {
// //       _pauseVideo();
// //     } else {
// //       _playVideo();
// //     }
// //   }
// //
// //   void _hidePlayPauseIconAfterDelay() {
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         setState(() {
// //           _showPlayPauseIcon = false;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           if (_isInitialized && _chewieController != null)
// //             FittedBox(
// //               fit: BoxFit.fill,
// //               child: SizedBox(
// //                 width: _videoPlayerController.value.size.width,
// //                 height: _videoPlayerController.value.size.height,
// //                 child: Chewie(controller: _chewieController!),
// //               ),
// //             )
// //           else
// //             CachedNetworkImage(
// //               imageUrl: widget.reel.thumbnailSignedUrl,
// //               fit: BoxFit.cover,
// //               placeholder: (context, url) => const Center(
// //                 child: CupertinoActivityIndicator(radius: 25),
// //               ),
// //               errorWidget: (context, url, error) =>
// //                   const Center(child: Icon(Icons.error)),
// //             ),
// //           GestureDetector(
// //             onTap: _togglePlayPause,
// //             child: Center(
// //               child: AnimatedOpacity(
// //                 opacity: _showPlayPauseIcon ? 1.0 : 0.0,
// //                 duration: const Duration(milliseconds: 300),
// //                 child: Icon(
// //                   _isPlaying ? Icons.pause : Icons.play_arrow,
// //                   color: Colors.white,
// //                   size: 100,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           _buildOverlay(),
// //           if (!_isInitialized)
// //             const Center(
// //               child: CupertinoActivityIndicator(radius: 25),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildOverlay() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         SizedBox(height: kToolbarHeight + 20),
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: _togglePlayPause,
// //           ),
// //         ),
// //         _buildReelInfo(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelInfo() {
// //     final height = MediaQuery.of(context).size.height;
// //     final width = MediaQuery.of(context).size.width;
// //     return Padding(
// //       padding: EdgeInsets.all(0.0),
// //       child: SizedBox(
// //         height: height / 2,
// //         width: double.infinity,
// //         child: Stack(
// //           children: [
// //             Positioned(
// //               bottom: 16,
// //               left: 4,
// //               right: 20,
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Container(
// //                         // padding: EdgeInsets.all(2),
// //                         // Adjust padding as needed
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.circle,
// //                           border: Border.all(
// //                             color: widget.reel.user.story
// //                                 ? AppColors.PRIMARY_COLOR_DARK
// //                                 : Colors.transparent,
// //                             // Or any color you prefer for the story indicator
// //                             width: 3, // Adjust the border width as needed
// //                           ),
// //                         ),
// //                         child: CircleAvatar(
// //                           radius: 30,
// //                           backgroundImage: CachedNetworkImageProvider(
// //                             widget.reel.user.profilePictureSignedUrl,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: 12),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               children: [
// //                                 Text(
// //                                   '${widget.reel.user.firstName} ${widget.reel.user.lastName}',
// //                                   textScaler: const TextScaler.linear(1.5),
// //                                   style: const TextStyle(
// //                                       color: Colors.white,
// //                                       fontWeight: FontWeight.bold),
// //                                 ),
// //                                 SizedBox(width: 4),
// //                                 widget.reel.user.verified
// //                                     ? const Icon(
// //                                         Icons.verified,
// //                                         color: Colors.blue,
// //                                         size: 25,
// //                                       )
// //                                     : Sizer(),
// //                               ],
// //                             ),
// //                             Row(
// //                               children: [
// //                                 Text(widget.reel.name,
// //                                     style: const TextStyle(
// //                                         color: AppColors.DARK_GRAY_COLOR)),
// //                                 SizedBox(
// //                                   width: 16,
// //                                 ),
// //                                 FaIcon(
// //                                   FontAwesomeIcons.eye,
// //                                   size: 20,
// //                                   color: AppColors.PRIMARY_COLOR_DARK
// //                                       .withOpacity(0.6),
// //                                 ),
// //                                 SizedBox(
// //                                   width: 8,
// //                                 ),
// //                                 Text(widget.reel.viewCount.toString(),
// //                                     style: const TextStyle(
// //                                         color: AppColors.DARK_GRAY_COLOR)),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   Row(
// //                     children: [
// //                       SizedBox(
// //                         width: 4,
// //                       ),
// //                       FaIcon(
// //                         FontAwesomeIcons.music,
// //                         color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
// //                       ),
// //                       SizedBox(
// //                         width: 4,
// //                       ),
// //                       Container(
// //                         color: Colors.blueGrey.withOpacity(0.1),
// //                         width: width / 2,
// //                         child: ScrollingText(
// //                           text: widget.reel.audio.audioName,
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       RoundedButtonWithImage(
// //                         imagePath: widget.reel.audio.audioPicture,
// //                         // Replace with your image path
// //                         onPressed: () {
// //                           _pauseVideo();
// //                           // _videoPlayerControl/ler.dispose();
// //                           // _chewieController?.dispose();
// //                           Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) =>
// //                                     const InstagramAudioScreen(),
// //                               ));
// //                           // Define what happens when the button is pressed
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Positioned(
// //               right: 8,
// //               bottom: kToolbarHeight,
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                 children: [
// //                   _buildActionButton(
// //                       FontAwesomeIcons.heart, widget.reel.likeCount),
// //                   _buildActionButton(
// //                       FontAwesomeIcons.comment, widget.reel.commentCount),
// //                   _buildActionButton(
// //                       FontAwesomeIcons.share, widget.reel.shareCount),
// //                   _buildActionButton(
// //                       FontAwesomeIcons.bookmark, widget.reel.saveCount),
// //                   // _buildActionButton(Icons.more_vert, 0),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildActionButton(IconData icon, int count) {
// //     return IconButton(
// //       onPressed: () {},
// //       icon: Column(
// //         children: [
// //           FaIcon(
// //             icon,
// //             color: Colors.white,
// //             size: 35,
// //           ),
// //           SizedBox(height: 4.h),
// //           count != 0
// //               ? Text(
// //                   '$count',
// //                   style: const TextStyle(color: Colors.white),
// //                 )
// //               : Sizer(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _videoPlayerController.dispose();
// //     _chewieController?.dispose();
// //     super.dispose();
// //   }
// // }
// //
// // class ScrollingText extends StatefulWidget {
// //   final String text;
// //
// //   ScrollingText({super.key, required this.text});
// //
// //   @override
// //   _ScrollingTextState createState() => _ScrollingTextState();
// // }
// //
// // class _ScrollingTextState extends State<ScrollingText>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _animation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     _controller = AnimationController(
// //       duration: const Duration(seconds: 10),
// //       vsync: this,
// //     )..repeat(reverse: false);
// //
// //     _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     double screenWidth = MediaQuery.of(context).size.width;
// //     double textSize = screenWidth * 0.03; // 4% of screen width
// //
// //     return ClipRect(
// //       child: Container(
// //         alignment: Alignment.centerLeft,
// //         child: AnimatedBuilder(
// //           animation: _animation,
// //           builder: (context, child) {
// //             return FractionalTranslation(
// //               translation: Offset(_animation.value, 0),
// //               child: child,
// //             );
// //           },
// //           child: Text(
// //             widget.text,
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis,
// //             style: TextStyle(
// //                 fontSize: textSize,
// //                 color: AppColors
// //                     .DARK_GRAY_COLOR), // Smaller and responsive text size
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class RoundedButtonWithImage extends StatelessWidget {
// //   final String imagePath;
// //   final VoidCallback onPressed;
// //
// //   const RoundedButtonWithImage({
// //     super.key,
// //     required this.imagePath,
// //     required this.onPressed,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: 30,
// //       height: 40.h,
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.transparent,
// //           shadowColor: Colors.transparent,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12), // Rounded corners
// //             side: const BorderSide(
// //                 color: AppColors.PRIMARY_COLOR_DARK, width: 2), // White border
// //           ),
// //           padding: EdgeInsets.zero, // Remove padding to keep the button small
// //         ),
// //         onPressed: onPressed,
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(12),
// //           // Match the button's border radius
// //           child: Image.network(
// //             imagePath,
// //             fit: BoxFit.fill, // Ensure the image covers the entire button
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // -----------------------
// //
// // class AudioScreen extends StatelessWidget {
// //   const AudioScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Audio'),
// //         leading: const Icon(Icons.arrow_back),
// //         actions: const [
// //           Icon(Icons.share),
// //           SizedBox(width: 16),
// //           Icon(Icons.bookmark),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundImage: NetworkImage(
// //                       'https://example.com/image.jpg'), // Replace with actual image URL
// //                 ),
// //                 SizedBox(width: 16),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Original audio',
// //                         style: TextStyle(
// //                             fontSize: 18.sp, fontWeight: FontWeight.bold)),
// //                     Text('rami_ezazi'),
// //                     Text('1,341 reels'),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.0),
// //                 child: ElevatedButton(
// //                   style: const ButtonStyle(
// //                       backgroundColor:
// //                           MaterialStatePropertyAll(AppColors.PRIMARY_COLOR)),
// //                   onPressed: () {},
// //                   child: const Text(
// //                     'Use audio',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Expanded(
// //             child: GridView.builder(
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 childAspectRatio: 0.7,
// //                 mainAxisSpacing: 4,
// //                 crossAxisSpacing: 4,
// //               ),
// //               itemCount: 20, // Adjust the number of items
// //               itemBuilder: (context, index) {
// //                 return Stack(
// //                   children: [
// //                     Image.network(
// //                         'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                         fit: BoxFit.cover),
// //                     // Replace with actual image URL
// //                     const Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.play_arrow, color: Colors.white, size: 16),
// //                           SizedBox(width: 4),
// //                           Text('1,234', style: TextStyle(color: Colors.white)),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class InstagramAudioScreen extends StatefulWidget {
// //   const InstagramAudioScreen({super.key});
// //
// //   @override
// //   State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
// // }
// //
// // class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
// //   bool isPlaying = true;
// //
// //   void _togglePlayPause() {
// //     setState(() {
// //       isPlaying = !isPlaying;
// //     });
// //     // Add your play/pause logic here
// //     if (isPlaying) {
// //       log("Playing");
// //       // Play the video/audio
// //     } else {
// //       log("Paused");
// //       // Pause the video/audio
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         leading: const Icon(
// //           Icons.arrow_back,
// //           color: Colors.white,
// //         ),
// //         title: const Text('Audio',
// //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
// //         actions: const [
// //           Icon(
// //             Icons.share,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //           Icon(
// //             Icons.bookmark,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundImage: NetworkImage(
// //                     'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                   ), // Replace with actual image URL
// //                 ),
// //                 SizedBox(width: 16),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Original audio',
// //                         style: TextStyle(
// //                             fontSize: 18.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white)),
// //                     Text('rami_ezazi', style: TextStyle(color: Colors.white)),
// //                     Text('1,341 reels', style: TextStyle(color: Colors.white)),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.0),
// //                 child: ElevatedButton(
// //                   style: const ButtonStyle(
// //                       backgroundColor: MaterialStatePropertyAll(
// //                           AppColors.PRIMARY_COLOR_DARK)),
// //                   onPressed: () {},
// //                   child: const Text(
// //                     'Use audio',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // const Text('Original', style: TextStyle(color: Colors.white)),
// //                 IconButton(
// //                   icon: Icon(
// //                     isPlaying ? Icons.pause : Icons.play_arrow,
// //                     color: Colors.white,
// //                   ),
// //                   onPressed: _togglePlayPause,
// //                 ),
// //                 Expanded(
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: Slider(
// //                       value: 0.2, // Current position
// //                       onChanged: (value) {},
// //                       activeColor: Colors.white,
// //                       inactiveColor: Colors.grey,
// //                     ),
// //                   ),
// //                 ),
// //                 const Text('0:04', style: TextStyle(color: Colors.white)),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: GridView.builder(
// //               padding: EdgeInsets.all(8.0),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 childAspectRatio: 0.7,
// //                 mainAxisSpacing: 4,
// //                 crossAxisSpacing: 4,
// //               ),
// //               itemCount: 20, // Adjust the number of items
// //               itemBuilder: (context, index) {
// //                 return Stack(
// //                   children: [
// //                     Image.network(
// //                         'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                         fit: BoxFit.cover), // Replace with actual image URL
// //                     const Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.play_arrow, color: Colors.white, size: 16),
// //                           SizedBox(width: 4),
// //                           Text('1,234', style: TextStyle(color: Colors.white)),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chewie/chewie.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
// import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
// import '../../../twitter/presentation/widgets/report_view.dart';
// import 'audio_screen.dart';
//
// /// ReelView is the main screen that displays a list of reels.
// /// It initializes the ReelsCubit and handles navigation.
// class ReelView extends StatelessWidget {
//   const ReelView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: _buildAppBar(context),
//       backgroundColor: Colors.transparent,
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => serviceLocator<ReelsCubit>(),
//           ),
//           BlocProvider(
//             create: (context) => serviceLocator<UserCubit>(),
//           )
//         ],
//         child: const ReelsScreen(),
//       ),
//     );
//   }
//
//   /// Builds the app bar with a back button.
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: IconAppButton(
//         icon: Icons.arrow_back,
//         color: Colors.white,
//         size: 24,
//         onPressed: () => context.pop(),
//       ),
//     );
//   }
// }
//
// // void showRSnackBar(BuildContext context, {
// //   required String message,
// //   String? actionLabel,
// //   VoidCallback? onActionPressed,
// //   IconData? icon,
// //   Color backgroundColor = Colors.black,
// //   Color textColor = Colors.white,
// //   Color actionTextColor = Colors.blue,
// //   Duration duration = const Duration(seconds: 4),
// // }) {
// //
// //
// //   ScaffoldMessenger.of(context)
// //     ..hideCurrentSnackBar()
// //     ..showSnackBar(snackBar);
// // }
//
// void showSnackBarAfterBuild(
//   BuildContext context, {
//   required String message,
//   String? actionLabel,
//   VoidCallback? onActionPressed,
//   IconData? icon,
//   Color backgroundColor = Colors.black,
//   Color textColor = Colors.red,
//   Color actionTextColor = Colors.blue,
//   Duration duration = const Duration(seconds: 1),
// }) {
//   final snackBar = SnackBar(
//     content: Row(
//       children: [
//         if (icon != null) ...[
//           Icon(icon, color: textColor),
//           SizedBox(width: 12),
//         ],
//         Expanded(
//           child: Text(
//             message,
//             style: TextStyle(color: textColor),
//           ),
//         ),
//       ],
//     ),
//     backgroundColor: backgroundColor,
//     duration: duration,
//     action: actionLabel != null
//         ? SnackBarAction(
//             label: actionLabel,
//             onPressed: onActionPressed ?? () {},
//             textColor: actionTextColor,
//           )
//         : null,
//     behavior: SnackBarBehavior.floating,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     margin: EdgeInsets.all(16),
//     elevation: 10,
//   );
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   });
// }
//
// class ReelsScreen extends StatefulWidget {
//   const ReelsScreen({super.key});
//
//   @override
//   ReelsScreenState createState() => ReelsScreenState();
// }
//
// class ReelsScreenState extends State<ReelsScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialReels();
//   }
//
//   /// Fetches the initial set of reels.
//   void _fetchInitialReels() {
//     if (mounted) {
//       context.read<ReelsCubit>().fetchReels();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReelsCubit, ReelsState>(
//       builder: (context, state) {
//         if (state.reels.isEmpty) {
//           return const Center(
//             child: CupertinoActivityIndicator(radius: 25),
//           );
//         }
//         return PageView.builder(
//           physics: const BouncingScrollPhysics(),
//           controller: _pageController,
//           scrollDirection: Axis.vertical,
//           itemCount: state.reels.length + (state.hasReachedMax ? 0 : 1),
//           onPageChanged: _handlePageChange,
//           itemBuilder: (context, index) {
//             if (index >= state.reels.length) {
//               return const Center(
//                 child: CupertinoActivityIndicator(radius: 25),
//               );
//             }
//             return ReelItem(
//               key: ValueKey(state.reels[index].id),
//               reel: state.reels[index],
//               isVisible: _currentPage == index,
//             );
//           },
//         );
//       },
//     );
//   }
//
//   /// Handles the page change event to load more reels if needed.
//   void _handlePageChange(int index) {
//     setState(() => _currentPage = index);
//     final reelsCubit = context.read<ReelsCubit>();
//     if (index == reelsCubit.state.reels.length - 1 && mounted) {
//       reelsCubit.fetchReels();
//     }
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
//
// /// ReelsScreen displays a list of reels in a vertical PageView.
// /// The screen fetches more reels as the user scrolls.
// ///
// // class ReelsScreen extends StatefulWidget {
// //   const ReelsScreen({super.key});
// //
// //   @override
// //   ReelsScreenState createState() => ReelsScreenState();
// // }
// //
// // class ReelsScreenState extends State<ReelsScreen> {
// //   final PageController _pageController = PageController();
// //   int _currentPage = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchInitialReels();
// //   }
// //
// //   /// Fetches the initial set of reels.
// //   void _fetchInitialReels() {
// //     context.read<ReelsCubit>().fetchReels();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<ReelsCubit, ReelsState>(
// //       builder: (context, state) {
// //         if (state.reels.isEmpty) {
// //           return const Center(
// //             child: CupertinoActivityIndicator(radius: 25),
// //           );
// //         }
// //         return PageView.builder(
// //           physics: const BouncingScrollPhysics(),
// //           controller: _pageController,
// //           scrollDirection: Axis.vertical,
// //           itemCount: state.reels.length + (state.hasReachedMax ? 0 : 1),
// //           onPageChanged: _handlePageChange,
// //           itemBuilder: (context, index) {
// //             if (index >= state.reels.length) {
// //               return const Center(
// //                 child: CupertinoActivityIndicator(radius: 25),
// //               );
// //             }
// //             return ReelItem(
// //               key: ValueKey(state.reels[index].id),
// //               reel: state.reels[index],
// //               isVisible: _currentPage == index,
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   /// Handles the page change event to load more reels if needed.
// //   void _handlePageChange(int index) {
// //     setState(() => _currentPage = index);
// //     final reelsCubit = context.read<ReelsCubit>();
// //     if (index == reelsCubit.state.reels.length - 1) {
// //       reelsCubit.fetchReels();
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// // }
//
// class ReelItem extends StatefulWidget {
//   final Reel reel;
//   final bool isVisible;
//
//   const ReelItem({super.key, required this.reel, required this.isVisible});
//
//   @override
//   ReelItemState createState() => ReelItemState();
// }
//
// class ReelItemState extends State<ReelItem> with AutomaticKeepAliveClientMixin {
//   late final VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   bool _showPlayPauseIcon = false;
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   @override
//   void didUpdateWidget(ReelItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isVisible != oldWidget.isVisible) {
//       widget.isVisible ? _playVideo() : _pauseVideo();
//     }
//   }
//
//   /// Initializes the video player and handles connectivity checks.
//   Future<void> _initializePlayer() async {
//     if (!await _checkConnectivity()) return;
//
//     await _initializeVideoController();
//     _setupChewieController();
//     _setInitialVideoState();
//   }
//
//   /// Initializes the video controller with the reel's video media.
//   Future<void> _initializeVideoController() async {
//     _videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
//     try {
//       await _videoPlayerController.initialize();
//     } catch (error) {
//       if (mounted) {
//         _handleVideoError('Failed to load video');
//       }
//     }
//   }
//
//   /// Sets up the Chewie controller with video player settings.
//   void _setupChewieController() {
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: widget.isVisible,
//       looping: true,
//       showControls: false,
//       aspectRatio: _videoPlayerController.value.aspectRatio,
//     );
//   }
//
//   /// Sets the initial state of the video player.
//   void _setInitialVideoState() {
//     if (mounted) {
//       setState(() {
//         _isInitialized = true;
//         _isPlaying = widget.isVisible;
//       });
//     }
//   }
//
//   /// Checks the internet connectivity before initializing the player.
//   Future<bool> _checkConnectivity() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       if (mounted) {
//         _handleVideoError('No internet connection');
//       }
//       return false;
//     }
//     return true;
//   }
//
//   /// Handles video playback error by showing a message.
//   void _handleVideoError(String message) {
//     if (mounted) {
//       setState(() {
//         _isInitialized = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
//
//   /// Plays the video if it is initialized and not currently playing.
//   void _playVideo() {
//     if (_isInitialized && !_isPlaying) {
//       _chewieController?.play();
//       if (mounted) {
//         setState(() {
//           _isPlaying = true;
//           _showPlayPauseIcon = true;
//         });
//       }
//       _hidePlayPauseIconAfterDelay();
//     }
//   }
//
//   /// Pauses the video if it is initialized and currently playing.
//   void _pauseVideo() {
//     if (_isInitialized && _isPlaying) {
//       _chewieController?.pause();
//       if (mounted) {
//         setState(() {
//           _isPlaying = false;
//           _showPlayPauseIcon = true;
//         });
//       }
//     }
//   }
//
//   /// Toggles play/pause state of the video.
//   void _togglePlayPause() {
//     if (_isPlaying) {
//       _pauseVideo();
//     } else {
//       _playVideo();
//     }
//   }
//
//   /// Hides the play/pause icon after a delay.
//   void _hidePlayPauseIconAfterDelay() {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) {
//         setState(() {
//           _showPlayPauseIcon = false;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           _buildVideoOrPlaceholder(),
//           _buildPlayPauseIcon(),
//           _buildOverlay(),
//           if (!_isInitialized)
//             const Center(
//               child: CupertinoActivityIndicator(radius: 25),
//             ),
//         ],
//       ),
//     );
//   }
//
//   /// Builds the video player or a placeholder image.
//   Widget _buildVideoOrPlaceholder() {
//     if (_isInitialized && _chewieController != null) {
//       return FittedBox(
//         fit: BoxFit.fitHeight,
//         child: SizedBox(
//           width: _videoPlayerController.value.size.width,
//           height: _videoPlayerController.value.size.height,
//           child: Chewie(controller: _chewieController!),
//         ),
//       );
//     } else {
//       return CachedNetworkImage(
//         imageUrl: widget.reel.thumbnailSignedUrl,
//         fit: BoxFit.cover,
//         placeholder: (context, url) => const Center(
//           child: CupertinoActivityIndicator(radius: 25),
//         ),
//         errorWidget: (context, url, error) =>
//             const Center(child: Icon(Icons.error)),
//       );
//     }
//   }
//
//   /// Builds the play/pause icon overlay.
//   Widget _buildPlayPauseIcon() {
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Center(
//         child: AnimatedOpacity(
//           opacity: _showPlayPauseIcon ? 1.0 : 0.0,
//           duration: const Duration(milliseconds: 300),
//           child: Icon(
//             _isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.white,
//             size: 100,
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Builds the overlay containing user and reel info.
//   Widget _buildOverlay() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: kToolbarHeight + 20),
//         Expanded(
//           child: GestureDetector(
//             onTap: _togglePlayPause,
//           ),
//         ),
//         _buildReelInfo(),
//       ],
//     );
//   }
//
//   /// Builds the information section of the reel including user info and actions.
//   Widget _buildReelInfo() {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.all(0.0),
//       child: SizedBox(
//         height: height * 0.8,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Positioned(
//               bottom: 16,
//               left: 4,
//               right: 20,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       _buildUserAvatar(),
//                       SizedBox(width: 12),
//                       Expanded(child: _buildUserInfo()),
//                     ],
//                   ),
//                   _buildAudioAndButtons(width),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: 8,
//               bottom: kToolbarHeight,
//               child: _buildActionButtons(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds the user avatar with an optional story indicator.
//   Widget _buildUserAvatar() {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: widget.reel.user.story
//               ? AppColors.PRIMARY_COLOR_DARK
//               : Colors.transparent,
//           width: 3,
//         ),
//       ),
//       child: CircleAvatar(
//         radius: 30,
//         backgroundImage: CachedNetworkImageProvider(
//           widget.reel.user.profilePictureSignedUrl,
//         ),
//       ),
//     );
//   }
//
//   /// Builds the user information including name and reel name.
//   Widget _buildUserInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildUserName(),
//         _buildReelNameAndViews(),
//       ],
//     );
//   }
//
//   /// Builds the user's name with a verification badge if applicable.
//   Widget _buildUserName() {
//     return Row(
//       children: [
//         Text(
//           capitalizeAndSplit(
//               '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
//           textScaler: const TextScaler.linear(1.5),
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(width: 4),
//         if (widget.reel.user.verified)
//           const Icon(
//             Icons.verified,
//             color: Colors.blue,
//             size: 25,
//           ),
//       ],
//     );
//   }
//
//   /// Builds the reel name and view count.
//   Widget _buildReelNameAndViews() {
//     return Row(
//       children: [
//         Text(
//           widget.reel.name,
//           style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
//         ),
//         SizedBox(width: 16),
//         FaIcon(
//           FontAwesomeIcons.eye,
//           size: 20,
//           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
//         ),
//         SizedBox(width: 8),
//         Text(
//           widget.reel.viewCount.toString(),
//           style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
//         ),
//       ],
//     );
//   }
//
//   /// Builds the audio name with a scrolling text effect and a button to use the audio.
//   Widget _buildAudioAndButtons(double width) {
//     return Row(
//       children: [
//         SizedBox(width: 4),
//         FaIcon(
//           FontAwesomeIcons.music,
//           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
//         ),
//         SizedBox(width: 4),
//         Container(
//           color: Colors.blueGrey.withOpacity(0.1),
//           width: width / 2,
//           child: ScrollingText(text: widget.reel.audio.audioName),
//         ),
//         const Spacer(),
//         RoundedButtonWithImage(
//           imagePath: widget.reel.audio.audioPicture,
//           onPressed: () {
//             _pauseVideo();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     InstagramAudioScreen(audio: widget.reel.audio),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   /// Builds a column of action buttons (like, comment, share, save).
//   Widget _buildActionButtons() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildActionButton(
//             widget.reel.likeCount == 0
//                 ? FontAwesomeIcons.heart
//                 : FontAwesomeIcons.solidHeart,
//             widget.reel.likeCount, () {
//           context.read<ReelsCubit>().likeReel(widget.reel.id).then((value) {
//             if (context.read<ReelsCubit>().state.likeReelResponse!.message ==
//                 "Reel liked successfully") {
//               ++widget.reel.likeCount;
//             } else if (context
//                     .read<ReelsCubit>()
//                     .state
//                     .likeReelResponse!
//                     .message ==
//                 "Reel unlike successfully") {
//               --widget.reel.likeCount;
//             }
//           });
//         }, iconColor: Colors.red),
//         _buildActionButton(FontAwesomeIcons.comment, widget.reel.commentCount,
//             () {
//           context.read<ReelsCubit>().getComments(widget.reel.id).then(
//               (value) => showCommentsBottomSheet(context, reel: widget.reel));
//         }),
//         _buildActionButton(FontAwesomeIcons.share, widget.reel.shareCount, () {
//           context
//               .read<ReelsCubit>()
//               .shareReel(widget.reel.id)
//               .then((value) => widget.reel.shareCount++);
//         }),
//         _buildActionButton(
//             widget.reel.saveCount == 0
//                 ? FontAwesomeIcons.bookmark
//                 : FontAwesomeIcons.solidBookmark,
//             widget.reel.saveCount, () {
//           context.read<ReelsCubit>().saveReel(widget.reel.id).then((value) {
//             if (context.read<ReelsCubit>().state.reelSaveResponse.message ==
//                 "saved successfully") {
//               ++widget.reel.likeCount;
//             } else if (context
//                     .read<ReelsCubit>()
//                     .state
//                     .likeReelResponse!
//                     .message ==
//                 "unsaved successfully") {
//               --widget.reel.likeCount;
//             }
//           });
//         }, iconColor: Colors.yellowAccent),
//         _buildActionButton(FontAwesomeIcons.gift, 0, () {
//           showGiftBottomSheet(context, receiverId: widget.reel.user.id);
//         }),
//         _buildActionButton(FontAwesomeIcons.circleExclamation, 0, () {
//           bottomSheet(
//             context: context,
//             widget: ReportView(
//               id: widget.reel.user.id,
//               categoryId: '66684135dbb427ee42aa0141',
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   /// Builds an individual action button with an icon and a count.
//   Widget _buildActionButton(IconData icon, int count, VoidCallback function,
//       {Color? iconColor}) {
//     return IconButton(
//       onPressed: function,
//       icon: Column(
//         children: [
//           FaIcon(
//             icon,
//             color: iconColor ?? Colors.white,
//             size: 35,
//           ),
//           SizedBox(height: 4.h),
//           if (count != 0)
//             Text(
//               '$count',
//               style: const TextStyle(color: Colors.white),
//             )
//           else
//             Sizer(),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pauseVideo();
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
// }
//
// /// ReelItem displays an individual reel, handling video playback and visibility.
// ///
// // class ReelItem extends StatefulWidget {
// //   final Reel reel;
// //   final bool isVisible;
// //
// //   const ReelItem({super.key, required this.reel, required this.isVisible});
// //
// //   @override
// //   ReelItemState createState() => ReelItemState();
// // }
// //
// // class ReelItemState extends State<ReelItem> with AutomaticKeepAliveClientMixin {
// //   late final VideoPlayerController _videoPlayerController;
// //   ChewieController? _chewieController;
// //   bool _isInitialized = false;
// //   bool _isPlaying = false;
// //   bool _showPlayPauseIcon = false;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   @override
// //   void didUpdateWidget(ReelItem oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.isVisible != oldWidget.isVisible) {
// //       widget.isVisible ? _playVideo() : _pauseVideo();
// //     }
// //   }
// //
// //   /// Initializes the video player and handles connectivity checks.
// //   Future<void> _initializePlayer() async {
// //     if (!await _checkConnectivity()) return;
// //
// //     await _initializeVideoController();
// //     _setupChewieController();
// //     _setInitialVideoState();
// //   }
// //
// //   /// Initializes the video controller with the reel's video media.
// //   Future<void> _initializeVideoController() async {
// //     _videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
// //     try {
// //       await _videoPlayerController.initialize();
// //     } catch (error) {
// //       _handleVideoError('Failed to load video');
// //     }
// //   }
// //
// //   /// Sets up the Chewie controller with video player settings.
// //   void _setupChewieController() {
// //     _chewieController = ChewieController(
// //       videoPlayerController: _videoPlayerController,
// //       autoPlay: widget.isVisible,
// //       looping: true,
// //       showControls: false,
// //       aspectRatio: _videoPlayerController.value.aspectRatio,
// //     );
// //   }
// //
// //   /// Sets the initial state of the video player.
// //   void _setInitialVideoState() {
// //     setState(() {
// //       _isInitialized = true;
// //       _isPlaying = widget.isVisible;
// //     });
// //   }
// //
// //   /// Checks the internet connectivity before initializing the player.
// //   Future<bool> _checkConnectivity() async {
// //     final connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.none) {
// //       _handleVideoError('No internet connection');
// //       return false;
// //     }
// //     return true;
// //   }
// //
// //   /// Handles video playback error by showing a message.
// //   void _handleVideoError(String message) {
// //     setState(() {
// //       _isInitialized = false;
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message)),
// //     );
// //   }
// //
// //   /// Plays the video if it is initialized and not currently playing.
// //   void _playVideo() {
// //     if (_isInitialized && !_isPlaying) {
// //       _chewieController?.play();
// //       setState(() {
// //         _isPlaying = true;
// //         _showPlayPauseIcon = true;
// //       });
// //       _hidePlayPauseIconAfterDelay();
// //     }
// //   }
// //
// //   /// Pauses the video if it is initialized and currently playing.
// //   void _pauseVideo() {
// //     if (_isInitialized && _isPlaying) {
// //       _chewieController?.pause();
// //       setState(() {
// //         _isPlaying = false;
// //         _showPlayPauseIcon = true;
// //       });
// //     }
// //   }
// //
// //   /// Toggles play/pause state of the video.
// //   void _togglePlayPause() {
// //     if (_isPlaying) {
// //       _pauseVideo();
// //     } else {
// //       _playVideo();
// //     }
// //   }
// //
// //   /// Hides the play/pause icon after a delay.
// //   void _hidePlayPauseIconAfterDelay() {
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         setState(() {
// //           _showPlayPauseIcon = false;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           _buildVideoOrPlaceholder(),
// //           _buildPlayPauseIcon(),
// //           _buildOverlay(),
// //           if (!_isInitialized)
// //             const Center(
// //               child: CupertinoActivityIndicator(radius: 25),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Builds the video player or a placeholder image.
// //   Widget _buildVideoOrPlaceholder() {
// //     if (_isInitialized && _chewieController != null) {
// //       return FittedBox(
// //         fit: BoxFit.fitHeight,
// //         child: SizedBox(
// //           width: _videoPlayerController.value.size.width,
// //           height: _videoPlayerController.value.size.height,
// //           child: Chewie(controller: _chewieController!),
// //         ),
// //       );
// //     } else {
// //       return CachedNetworkImage(
// //         imageUrl: widget.reel.thumbnailSignedUrl,
// //         fit: BoxFit.cover,
// //         placeholder: (context, url) => const Center(
// //           child: CupertinoActivityIndicator(radius: 25),
// //         ),
// //         errorWidget: (context, url, error) =>
// //             const Center(child: Icon(Icons.error)),
// //       );
// //     }
// //   }
// //
// //   /// Builds the play/pause icon overlay.
// //   Widget _buildPlayPauseIcon() {
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Center(
// //         child: AnimatedOpacity(
// //           opacity: _showPlayPauseIcon ? 1.0 : 0.0,
// //           duration: const Duration(milliseconds: 300),
// //           child: Icon(
// //             _isPlaying ? Icons.pause : Icons.play_arrow,
// //             color: Colors.white,
// //             size: 100,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds the overlay containing user and reel info.
// //   Widget _buildOverlay() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         SizedBox(height: kToolbarHeight + 20),
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: _togglePlayPause,
// //           ),
// //         ),
// //         _buildReelInfo(),
// //       ],
// //     );
// //   }
// //
// //   /// Builds the information section of the reel including user info and actions.
// //   Widget _buildReelInfo() {
// //     final height = MediaQuery.of(context).size.height;
// //     final width = MediaQuery.of(context).size.width;
// //     return Padding(
// //       padding: EdgeInsets.all(0.0),
// //       child: SizedBox(
// //         height: height * 0.8,
// //         width: double.infinity,
// //         child: Stack(
// //           children: [
// //             Positioned(
// //               bottom: 16,
// //               left: 4,
// //               right: 20,
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     children: [
// //                       _buildUserAvatar(),
// //                       SizedBox(width: 12),
// //                       Expanded(child: _buildUserInfo()),
// //                     ],
// //                   ),
// //                   _buildAudioAndButtons(width),
// //                 ],
// //               ),
// //             ),
// //             Positioned(
// //               right: 8,
// //               bottom: kToolbarHeight,
// //               child: _buildActionButtons(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds the user avatar with an optional story indicator.
// //   Widget _buildUserAvatar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         border: Border.all(
// //           color: widget.reel.user.story
// //               ? AppColors.PRIMARY_COLOR_DARK
// //               : Colors.transparent,
// //           width: 3,
// //         ),
// //       ),
// //       child: CircleAvatar(
// //         radius: 30,
// //         backgroundImage: CachedNetworkImageProvider(
// //           widget.reel.user.profilePictureSignedUrl,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds the user information including name and reel name.
// //   Widget _buildUserInfo() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _buildUserName(),
// //         _buildReelNameAndViews(),
// //       ],
// //     );
// //   }
// //
// //   /// Builds the user's name with a verification badge if applicable.
// //   Widget _buildUserName() {
// //     return Row(
// //       children: [
// //         Text(
// //           capitalizeAndSplit(
// //               '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
// //           textScaler: const TextScaler.linear(1.5),
// //           style: const TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         SizedBox(width: 4),
// //         if (widget.reel.user.verified)
// //           const Icon(
// //             Icons.verified,
// //             color: Colors.blue,
// //             size: 25,
// //           ),
// //       ],
// //     );
// //   }
// //
// //   /// Builds the reel name and view count.
// //   Widget _buildReelNameAndViews() {
// //     return Row(
// //       children: [
// //         Text(
// //           widget.reel.name,
// //           style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
// //         ),
// //         SizedBox(width: 16),
// //         FaIcon(
// //           FontAwesomeIcons.eye,
// //           size: 20,
// //           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
// //         ),
// //         SizedBox(width: 8),
// //         Text(
// //           widget.reel.viewCount.toString(),
// //           style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Builds the audio name with a scrolling text effect and a button to use the audio.
// //   Widget _buildAudioAndButtons(double width) {
// //     return Row(
// //       children: [
// //         SizedBox(width: 4),
// //         FaIcon(
// //           FontAwesomeIcons.music,
// //           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
// //         ),
// //         SizedBox(width: 4),
// //         Container(
// //           color: Colors.blueGrey.withOpacity(0.1),
// //           width: width / 2,
// //           child: ScrollingText(text: widget.reel.audio.audioName),
// //         ),
// //         const Spacer(),
// //         RoundedButtonWithImage(
// //           imagePath: widget.reel.audio.audioPicture,
// //           onPressed: () {
// //             _pauseVideo();
// //             // _videoPlayerController.dispose();
// //             // _chewieController?.dispose();
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) =>
// //                     InstagramAudioScreen(audio: widget.reel.audio),
// //               ),
// //             ).then((value) {
// //               // initState();
// //             });
// //           },
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Builds a column of action buttons (like, comment, share, save).
// //   Widget _buildActionButtons() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// //       children: [
// //         _buildActionButton(
// //             widget.reel.likeCount == 0
// //                 ? FontAwesomeIcons.heart
// //                 : FontAwesomeIcons.solidHeart,
// //             widget.reel.likeCount, () {
// //           context.read<ReelsCubit>().likeReel(widget.reel.id).then((value) {
// //             if (context.read<ReelsCubit>().state.likeReelResponse!.message ==
// //                 "Reel liked successfully") {
// //               ++widget.reel.likeCount;
// //             } else if (context
// //                     .read<ReelsCubit>()
// //                     .state
// //                     .likeReelResponse!
// //                     .message ==
// //                 "Reel unlike successfully") {
// //               --widget.reel.likeCount;
// //             }
// //           });
// //         }, iconColor: Colors.red),
// //         _buildActionButton(FontAwesomeIcons.comment, widget.reel.commentCount,
// //             () {
// //           // showModalBottomSheet(
// //           //     context: context,
// //           //     isScrollControlled: true,
// //           //     backgroundColor: Colors.transparent,
// //           //     builder: (context) => BlocProvider.value(
// //           //           value: serviceLocator<ReelsCubit>()
// //           //           // value: serviceLocator<ReelsCubit>()
// //           //             ..getComments(widget.reel.id),
// //           //           child: CommentsBottomSheet(reel: widget.reel),
// //           //         ));
// //           context.read<ReelsCubit>().getComments(widget.reel.id).then(
// //               (value) => showCommentsBottomSheet(context, reel: widget.reel));
// //         }),
// //         _buildActionButton(FontAwesomeIcons.share, widget.reel.shareCount, () {
// //           context
// //               .read<ReelsCubit>()
// //               .shareReel(widget.reel.id)
// //               .then((value) => widget.reel.shareCount++);
// //         }),
// //         _buildActionButton(
// //             widget.reel.saveCount == 0
// //                 ? FontAwesomeIcons.bookmark
// //                 : FontAwesomeIcons.solidBookmark,
// //             widget.reel.saveCount, () {
// //           context
// //               .read<ReelsCubit>()
// //               .saveReel(widget.reel.id)
// //               .then((value) => widget.reel.saveCount++);
// //
// //           // _showGiftBottomSheet22(context, receiverId: widget.reel.user.id);
// //         }, iconColor: Colors.yellowAccent),
// //         _buildActionButton(FontAwesomeIcons.gift, 0, () {
// //           showGiftBottomSheet(context, receiverId: widget.reel.user.id);
// //         }),
// //         _buildActionButton(FontAwesomeIcons.circleExclamation, 0, () {
// //           bottomSheet(
// //             context: context,
// //             widget: ReportView(
// //               id: widget.reel.user.id,
// //               categoryId: '66684135dbb427ee42aa0141',
// //             ),
// //           );
// //         }),
// //       ],
// //     );
// //   }
// //
// //   /// Builds an individual action button with an icon and a count.
// //   Widget _buildActionButton(IconData icon, int count, VoidCallback function,
// //       {Color? iconColor}) {
// //     return IconButton(
// //       onPressed: function,
// //       icon: Column(
// //         children: [
// //           FaIcon(
// //             icon,
// //             color: iconColor ?? Colors.white,
// //             size: 35,
// //           ),
// //           SizedBox(height: 4.h),
// //           if (count != 0)
// //             Text(
// //               '$count',
// //               style: const TextStyle(color: Colors.white),
// //             )
// //           else
// //             Sizer(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pauseVideo();
// //     _videoPlayerController.dispose();
// //     _chewieController?.dispose();
// //     super.dispose();
// //   }
// // }
//
// /// ScrollingText creates a horizontally scrolling text widget.
// class ScrollingText extends StatefulWidget {
//   final String text;
//
//   const ScrollingText({super.key, required this.text});
//
//   @override
//   ScrollingTextState createState() => ScrollingTextState();
// }
//
// class ScrollingTextState extends State<ScrollingText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat(reverse: false);
//
//     _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double textSize = screenWidth * 0.03;
//
//     return ClipRect(
//       child: Container(
//         alignment: Alignment.centerLeft,
//         child: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return FractionalTranslation(
//               translation: Offset(_animation.value, 0),
//               child: child,
//             );
//           },
//           child: Text(
//             widget.text,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style:
//                 TextStyle(fontSize: textSize, color: AppColors.DARK_GRAY_COLOR),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// RoundedButtonWithImage creates a small, rounded button with an image.
// class RoundedButtonWithImage extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback onPressed;
//
//   const RoundedButtonWithImage({
//     super.key,
//     required this.imagePath,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 30,
//       height: 40.h,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: const BorderSide(color: Colors.white, width: 3),
//           ),
//           padding: EdgeInsets.zero,
//         ),
//         onPressed: onPressed,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               Image.network(
//                 width: double.infinity,
//                 height: double.infinity,
//                 imagePath,
//                 color: Colors.black,
//                 fit: BoxFit.fill,
//               ),
//               const Center(
//                 child: FaIcon(
//                   FontAwesomeIcons.music,
//                   size: 15,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------
//
// /// AudioScreen is a stateless widget displaying an audio screen.
// // class AudioScreen extends StatelessWidget {
// //   const AudioScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Audio'),
// //         leading: const Icon(Icons.arrow_back),
// //         actions: const [
// //           Icon(Icons.share),
// //           SizedBox(width: 16),
// //           Icon(Icons.bookmark),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundImage:
// //                       NetworkImage('https://example.com/image.jpg'),
// //                 ),
// //                 SizedBox(width: 16),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Original audio',
// //                         style: TextStyle(
// //                             fontSize: 18.sp, fontWeight: FontWeight.bold)),
// //                     Text('rami_ezazi'),
// //                     Text('1,341 reels'),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.0),
// //                 child: ElevatedButton(
// //                   style: const ButtonStyle(
// //                       backgroundColor:
// //                           MaterialStatePropertyAll(AppColors.PRIMARY_COLOR)),
// //                   onPressed: () {},
// //                   child: const Text(
// //                     'Use audio',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 16.h),
// //           Expanded(
// //             child: GridView.builder(
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 childAspectRatio: 0.7,
// //                 mainAxisSpacing: 4,
// //                 crossAxisSpacing: 4,
// //               ),
// //               itemCount: 20,
// //               itemBuilder: (context, index) {
// //                 return Stack(
// //                   children: [
// //                     Image.network(
// //                         'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                         fit: BoxFit.cover),
// //                     const Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.play_arrow, color: Colors.white, size: 16),
// //                           SizedBox(width: 4),
// //                           Text('1,234', style: TextStyle(color: Colors.white)),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // -----------------------
//
// // class InstagramAudioScreen extends StatefulWidget {
// //   const InstagramAudioScreen({super.key});
// //
// //   @override
// //   State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
// // }
// //
// // class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
// //   bool isPlaying = true;
// //
// //   void _togglePlayPause() {
// //     setState(() {
// //       isPlaying = !isPlaying;
// //     });
// //     if (isPlaying) {
// //       log("Playing");
// //     } else {
// //       log("Paused");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         leading: const Icon(
// //           Icons.arrow_back,
// //           color: Colors.white,
// //         ),
// //         title: const Text('Audio',
// //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
// //         actions: const [
// //           Icon(
// //             Icons.share,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //           Icon(
// //             Icons.bookmark,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundImage: NetworkImage(
// //                     'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Original audio',
// //                         style: TextStyle(
// //                             fontSize: 18.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white)),
// //                     Text('rami_ezazi', style: TextStyle(color: Colors.white)),
// //                     Text('1,341 reels', style: TextStyle(color: Colors.white)),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.0),
// //                 child: ElevatedButton(
// //                   style: const ButtonStyle(
// //                       backgroundColor: MaterialStatePropertyAll(
// //                           AppColors.PRIMARY_COLOR_DARK)),
// //                   onPressed: () {},
// //                   child: const Text(
// //                     'Use audio',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 IconButton(
// //                   icon: Icon(
// //                     isPlaying ? Icons.pause : Icons.play_arrow,
// //                     color: Colors.white,
// //                   ),
// //                   onPressed: _togglePlayPause,
// //                 ),
// //                 Expanded(
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: Slider(
// //                       value: 0.2,
// //                       onChanged: (value) {},
// //                       activeColor: Colors.white,
// //                       inactiveColor: Colors.grey,
// //                     ),
// //                   ),
// //                 ),
// //                 const Text('0:04', style: TextStyle(color: Colors.white)),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: GridView.builder(
// //               padding: EdgeInsets.all(8.0),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 childAspectRatio: 0.7,
// //                 mainAxisSpacing: 4,
// //                 crossAxisSpacing: 4,
// //               ),
// //               itemCount: 20,
// //               itemBuilder: (context, index) {
// //                 return Stack(
// //                   children: [
// //                     Image.network(
// //                         'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                         fit: BoxFit.cover),
// //                     const Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.play_arrow, color: Colors.white, size: 16),
// //                           SizedBox(width: 4),
// //                           Text('1,234', style: TextStyle(color: Colors.white)),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // class InstagramAudioScreen extends StatefulWidget {
// //   const InstagramAudioScreen({super.key});
// //
// //   @override
// //   State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
// // }
// //
// // class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
// //   late AudioPlayer _audioPlayer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _audioPlayer = AudioPlayer();
// //     _audioPlayer.setReleaseMode(ReleaseMode.stop);
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       await _audioPlayer.setSource(UrlSource(
// //           "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/lose.ogg"));
// //       await _audioPlayer.resume();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         leading: const Icon(
// //           Icons.arrow_back,
// //           color: Colors.white,
// //         ),
// //         title: const Text('Audio',
// //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
// //         actions: const [
// //           Icon(
// //             Icons.share,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //           Icon(
// //             Icons.bookmark,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundImage: NetworkImage(
// //                     'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Original audio',
// //                         style: TextStyle(
// //                             fontSize: 18.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white)),
// //                     Text('rami_ezazi', style: TextStyle(color: Colors.white)),
// //                     Text('1,341 reels', style: TextStyle(color: Colors.white)),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.0),
// //                 child: ElevatedButton(
// //                   style: const ButtonStyle(
// //                       backgroundColor: MaterialStatePropertyAll(
// //                           AppColors.PRIMARY_COLOR_DARK)),
// //                   onPressed: () {},
// //                   child: const Text(
// //                     'Use audio',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: PlayerWidget(player: _audioPlayer),
// //           ),
// //           Expanded(
// //             child: GridView.builder(
// //               padding: EdgeInsets.all(8.0),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 childAspectRatio: 0.7,
// //                 mainAxisSpacing: 4,
// //                 crossAxisSpacing: 4,
// //               ),
// //               itemCount: 20,
// //               itemBuilder: (context, index) {
// //                 return Stack(
// //                   children: [
// //                     Image.network(
// //                         'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                         fit: BoxFit.cover),
// //                     const Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.play_arrow, color: Colors.white, size: 16),
// //                           SizedBox(width: 4),
// //                           Text('1,234', style: TextStyle(color: Colors.white)),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class PlayerWidget extends StatefulWidget {
// //   final AudioPlayer player;
// //
// //   const PlayerWidget({required this.player, super.key});
// //
// //   @override
// //   State<StatefulWidget> createState() => _PlayerWidgetState();
// // }
// //
// // class _PlayerWidgetState extends State<PlayerWidget> {
// //   PlayerState? _playerState;
// //   Duration? _duration;
// //   Duration? _position;
// //
// //   StreamSubscription? _durationSubscription;
// //   StreamSubscription? _positionSubscription;
// //   StreamSubscription? _playerCompleteSubscription;
// //   StreamSubscription? _playerStateChangeSubscription;
// //
// //   bool get _isPlaying => _playerState == PlayerState.playing;
// //
// //   bool get _isPaused => _playerState == PlayerState.paused;
// //
// //   String get _durationText => _duration?.toString().split('.').first ?? '';
// //
// //   String get _positionText => _position?.toString().split('.').first ?? '';
// //
// //   AudioPlayer get player => widget.player;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _playerState = player.state;
// //     player.getDuration().then(
// //           (value) => setState(() {
// //             _duration = value;
// //           }),
// //         );
// //     player.getCurrentPosition().then(
// //           (value) => setState(() {
// //             _position = value;
// //           }),
// //         );
// //     _initStreams();
// //   }
// //
// //   @override
// //   void setState(VoidCallback fn) {
// //     if (mounted) {
// //       super.setState(fn);
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _durationSubscription?.cancel();
// //     _positionSubscription?.cancel();
// //     _playerCompleteSubscription?.cancel();
// //     _playerStateChangeSubscription?.cancel();
// //     super.dispose();
// //   }
// //
// //   void _initStreams() {
// //     _durationSubscription = player.onDurationChanged.listen((duration) {
// //       setState(() => _duration = duration);
// //     });
// //
// //     _positionSubscription = player.onPositionChanged.listen(
// //       (p) => setState(() => _position = p),
// //     );
// //
// //     _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
// //       setState(() {
// //         _playerState = PlayerState.stopped;
// //         _position = Duration.zero;
// //       });
// //     });
// //
// //     _playerStateChangeSubscription =
// //         player.onPlayerStateChanged.listen((state) {
// //       setState(() {
// //         _playerState = state;
// //       });
// //     });
// //   }
// //
// //   Future<void> _play() async {
// //     await player.resume();
// //     setState(() => _playerState = PlayerState.playing);
// //   }
// //
// //   Future<void> _pause() async {
// //     await player.pause();
// //     setState(() => _playerState = PlayerState.paused);
// //   }
// //
// //   Future<void> _stop() async {
// //     await player.stop();
// //     setState(() {
// //       _playerState = PlayerState.stopped;
// //       _position = Duration.zero;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final color = Theme.of(context).primaryColor;
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: <Widget>[
// //         Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             IconButton(
// //               key: const Key('play_button'),
// //               onPressed: _isPlaying ? null : _play,
// //               iconSize: 48.0,
// //               icon: const Icon(Icons.play_arrow),
// //               color: color,
// //             ),
// //             IconButton(
// //               key: const Key('pause_button'),
// //               onPressed: _isPlaying ? _pause : null,
// //               iconSize: 48.0,
// //               icon: const Icon(Icons.pause),
// //               color: color,
// //             ),
// //             IconButton(
// //               key: const Key('stop_button'),
// //               onPressed: _isPlaying || _isPaused ? _stop : null,
// //               iconSize: 48.0,
// //               icon: const Icon(Icons.stop),
// //               color: color,
// //             ),
// //           ],
// //         ),
// //         Slider(
// //           onChanged: (value) {
// //             final duration = _duration;
// //             if (duration == null) {
// //               return;
// //             }
// //             final position = value * duration.inMilliseconds;
// //
// //             player.seek(Duration(milliseconds: position.round()));
// //           },
// //           value: (_position != null &&
// //                   _duration != null &&
// //                   _position!.inMilliseconds > 0 &&
// //                   _position!.inMilliseconds < _duration!.inMilliseconds)
// //               ? _position!.inMilliseconds / _duration!.inMilliseconds
// //               : 0.0,
// //         ),
// //         Text(
// //           _position != null
// //               ? '$_positionText / $_durationText'
// //               : _duration != null
// //                   ? _durationText
// //                   : '',
// //           style: const TextStyle(fontSize: 16.sp),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// // class InstagramAudioScreen extends StatefulWidget {
// //   const InstagramAudioScreen({super.key});
// //
// //   @override
// //   State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
// // }
// //
// // class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
// //   late AudioPlayer _audioPlayer;
// //   final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
// //   final ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);
// //   final ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
// //   Timer? _positionUpdateTimer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _audioPlayer = AudioPlayer();
// //     _audioPlayer.setReleaseMode(ReleaseMode.stop);
// //
// //     _audioPlayer.onDurationChanged.listen((duration) {
// //       _duration.value = duration;
// //     });
// //
// //     _audioPlayer.onPositionChanged.listen((position) {
// //       _position.value = position;
// //     });
// //
// //     _audioPlayer.onPlayerComplete.listen((event) {
// //       _isPlaying.value = false;
// //       _position.value = Duration.zero;
// //     });
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       await _audioPlayer.setSource(UrlSource(
// //           "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/lose.ogg"));
// //       await _audioPlayer.resume();
// //       _isPlaying.value = true;
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose();
// //     _positionUpdateTimer?.cancel();
// //     _isPlaying.dispose();
// //     _duration.dispose();
// //     _position.dispose();
// //     super.dispose();
// //   }
// //
// //   String _formatDuration(Duration d) {
// //     String twoDigits(int n) => n.toString().padLeft(2, '0');
// //     final minutes = twoDigits(d.inMinutes.remainder(60));
// //     final seconds = twoDigits(d.inSeconds.remainder(60));
// //     return '$minutes:$seconds';
// //   }
// //
// //   Future<void> _togglePlayPause() async {
// //     if (_isPlaying.value) {
// //       await _audioPlayer.pause();
// //     } else {
// //       await _audioPlayer.resume();
// //     }
// //     _isPlaying.value = !_isPlaying.value;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.black,
// //         leading: const Icon(
// //           Icons.arrow_back,
// //           color: Colors.white,
// //         ),
// //         title: const Text('Audio',
// //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
// //         actions: const [
// //           Icon(
// //             Icons.share,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //           Icon(
// //             Icons.bookmark,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundImage: NetworkImage(
// //                     'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Original audio',
// //                         style: TextStyle(
// //                             fontSize: 18.sp,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white)),
// //                     Text('rami_ezazi', style: TextStyle(color: Colors.white)),
// //                     Text('1,341 reels', style: TextStyle(color: Colors.white)),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Center(
// //             child: SizedBox(
// //               width: double.infinity,
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 32.0),
// //                 child: ElevatedButton(
// //                   style: const ButtonStyle(
// //                       backgroundColor: MaterialStatePropertyAll(
// //                           AppColors.PRIMARY_COLOR_DARK)),
// //                   onPressed: () {},
// //                   child: const Text(
// //                     'Use audio',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 ValueListenableBuilder<bool>(
// //                   valueListenable: _isPlaying,
// //                   builder: (context, isPlaying, child) {
// //                     return IconButton(
// //                       icon: Icon(
// //                         isPlaying ? Icons.pause : Icons.play_arrow,
// //                         color: Colors.white,
// //                       ),
// //                       onPressed: _togglePlayPause,
// //                     );
// //                   },
// //                 ),
// //                 Expanded(
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: ValueListenableBuilder<Duration>(
// //                       valueListenable: _position,
// //                       builder: (context, position, child) {
// //                         return ValueListenableBuilder<Duration>(
// //                           valueListenable: _duration,
// //                           builder: (context, duration, child) {
// //                             final maxSliderValue = duration.inMilliseconds > 0
// //                                 ? position.inMilliseconds / duration.inMilliseconds
// //                                 : 0.0;
// //
// //                             return Slider(
// //                               value: maxSliderValue,
// //                               onChanged: (value) {
// //                                 final newPosition = value * duration.inMilliseconds;
// //                                 _audioPlayer.seek(Duration(milliseconds: newPosition.round()));
// //                               },
// //                               activeColor: Colors.white,
// //                               inactiveColor: Colors.grey,
// //                             );
// //                           },
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 // ValueListenableBuilder<Duration>(
// //                 //   valueListenable: _position,
// //                 //   builder: (context, position, child) {
// //                 //     return Text(
// //                 //       _formatDuration(position),
// //                 //       style: const TextStyle(color: Colors.white),
// //                 //     );
// //                 //   },
// //                 // ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: GridView.builder(
// //               padding: EdgeInsets.all(8.0),
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 3,
// //                 childAspectRatio: 0.7,
// //                 mainAxisSpacing: 4,
// //                 crossAxisSpacing: 4,
// //               ),
// //               itemCount: 20,
// //               itemBuilder: (context, index) {
// //                 return Stack(
// //                   children: [
// //                     Image.network(
// //                         'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
// //                         fit: BoxFit.cover),
// //                     const Positioned(
// //                       bottom: 8,
// //                       left: 8,
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.play_arrow, color: Colors.white, size: 16),
// //                           SizedBox(width: 4),
// //                           Text('1,234', style: TextStyle(color: Colors.white)),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //20/8
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../tinder/presentation/pages/user_profile.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import 'audio_screen.dart';

class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      backgroundColor: Colors.transparent,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => serviceLocator<ReelsCubit>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<UserCubit>(),
          )
        ],
        child: const ReelsScreen(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconAppButton(
        icon: Icons.arrow_back,
        color: Colors.white,
        size: 24,
        onPressed: () => context.pop(),
      ),
      actions: [
        const Spacer(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () async {
              // context.pop();
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReelsRecordingScreen(
                        // advertisementType: 'reel',
                        // comeFromCompany: 'company',
                        // totalPrice: '500',
                        ),
                  ));
            },
            icon: const FaIcon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        )
      ],
    );
  }
}

void showSnackBarAfterBuild(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
  IconData? icon,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.red,
  Color actionTextColor = Colors.blue,
  Duration duration = const Duration(seconds: 1),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: textColor),
          ),
        ),
        if (icon != null) ...[
          Icon(icon, color: Colors.green),
          SizedBox(width: 12),
        ],
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
            textColor: actionTextColor,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.all(16),
    elevation: 10,
  );
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
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
      context.read<ReelsCubit>().fetchReels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
        if (state.globalReels.isEmpty) {
          return const Center(
            child: CupertinoActivityIndicator(radius: 25),
          );
        }
        return PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: state.globalReels.length +
              (state.globalReelsHasReachedMax ? 0 : 1),
          onPageChanged: _handlePageChange,
          itemBuilder: (context, index) {
            if (index >= state.globalReels.length) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 25),
              );
            }
            return ReelItem(
              key: ValueKey(state.globalReels[index].id),
              reel: state.globalReels[index],
              isVisible: _currentPage == index,
            );
          },
        );
      },
    );
  }

  void _handlePageChange(int index) {
    setState(() => _currentPage = index);
    final reelsCubit = context.read<ReelsCubit>();
    if (index == reelsCubit.state.globalReels.length - 1 && mounted) {
      reelsCubit.fetchReels();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isVisible;

  const ReelItem({super.key, required this.reel, required this.isVisible});

  @override
  ReelItemState createState() => ReelItemState();
}

class ReelItemState extends State<ReelItem> with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
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
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
    try {
      await _videoPlayerController.initialize();
    } catch (error) {
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
          _buildOverlay(),
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
        imageUrl: widget.reel.thumbnailSignedUrl,
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

  Widget _buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: kToolbarHeight + 20),
        Expanded(
          child: GestureDetector(
            onTap: _togglePlayPause,
          ),
        ),
        _buildReelInfo(),
      ],
    );
  }

  Widget _buildReelInfo() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: SizedBox(
        height: height * 0.5,
        width: double.infinity,
        child: Stack(
          children: [
            // Positioned(
            //
            //   top: 100,
            //   right: 100,
            //   child: Padding(
            //     padding: EdgeInsets.all(8.0),
            //     child: IconButton(
            //
            //       onPressed: () {
            //         _pauseVideo();
            //
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const ReelsRecordingScreen(),
            //             ));
            //       },
            //       icon: const FaIcon(
            //         Icons.camera_alt_outlined,
            //         color: Colors.white,
            //         size: 35,
            //       ),
            //     ),
            //   ),
            // ),

            Positioned(
              bottom: 16,
              left: 4,
              right: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildUserAvatar(),
                      SizedBox(width: 12),
                      FittedBox(child: _buildUserInfo()),
                    ],
                  ),
                  _buildAudioAndButtons(width),
                ],
              ),
            ),

            context.isArabic
                ? Positioned(
                    left: 8,
                    bottom: 0,
                    child: _buildActionButtons(),
                  )
                : Positioned(
                    right: 8,
                    bottom: 0,
                    child: _buildActionButtons(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.reel.user.story
              ? AppColors.PRIMARY_COLOR_DARK
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: CachedNetworkImageProvider(
          widget.reel.user.profilePictureSignedUrl!,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserName(),
        _buildReelNameAndViews(),
      ],
    );
  }

  Widget _buildUserName() {
    return Row(
      children: [
        Text(
          capitalizeAndSplit(
              '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
          textScaler: const TextScaler.linear(1.5),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4),
        if (widget.reel.user.verified)
          const Icon(
            Icons.verified,
            color: AppColors.PRIMARY_COLOR_DARK,
            size: 25,
          ),
      ],
    );
  }

  Widget _buildReelNameAndViews() {
    return Row(
      children: [
        Text(
          widget.reel.name,
          style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
        ),
        SizedBox(width: 16),
        FaIcon(
          FontAwesomeIcons.eye,
          size: 20,
          color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
        ),
        SizedBox(width: 8),
        Text(
          widget.reel.viewCount.toString(),
          style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
        ),
      ],
    );
  }

  Widget _buildAudioAndButtons(double width) {
    return Row(
      children: [
        SizedBox(width: 4),
        // FaIcon(
        //   FontAwesomeIcons.music,
        //   color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
        // ),
        Container(
          color: Colors.blueGrey.withOpacity(0.2),
          width: width / 2,
          child: ScrollingText(text: widget.reel.audio.audioName),
        ),
        SizedBox(width: 4),
        RoundedButtonWithImage(
          imagePath: widget.reel.audio.audioPicture,
          onPressed: () {
            _pauseVideo();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: serviceLocator<ReelsCubit>()
                    ..fetchReelsWithSameAudio(widget.reel.audio.id),
                  child: InstagramAudioScreen(
                    audio: widget.reel.audio,
                    reel: widget.reel,
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildActionButtons() {
    final reelsCubit = context.read<ReelsCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          widget.reel.likeCount == 0
              ? FontAwesomeIcons.heart
              : FontAwesomeIcons.solidHeart,
          widget.reel.likeCount,
          () async {
            await _handleLikeAction(reelsCubit);
          },
          iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
        ),
        _buildActionButton(
          FontAwesomeIcons.comment,
          widget.reel.commentCount,
          () async {
            await _handleCommentAction(reelsCubit);
          },
        ),
        _buildActionButton(
          FontAwesomeIcons.paperPlane,
          widget.reel.shareCount,
          () async {
            _handleShareAction(widget.reel.videoMedia);
          },
        ),
        _buildActionButton(
          widget.reel.saveCount == 0
              ? FontAwesomeIcons.bookmark
              : FontAwesomeIcons.solidBookmark,
          widget.reel.saveCount,
          () async {
            await _handleSaveAction(reelsCubit);
          },
          iconColor:
              widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
        ),
        _buildActionButton(
          Icons.card_giftcard,
          0,
          () {
            showGiftBottomSheet(context, receiverId: widget.reel.user.id);
          },
        ),
        _buildActionButton(
          Icons.report_outlined,
          0,
          () {
            bottomSheet(
              context: context,
              widget: ReportView(
                id: widget.reel.user.id,
                categoryId: '66684135dbb427ee42aa0141',
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
    try {
      await reelsCubit.likeReel(widget.reel.id);
      final response = reelsCubit.state.likeReelResponse;
      if (response?.message == "Reel liked successfully") {
        setState(() => widget.reel.likeCount++);
      } else if (response?.message == "Reel unlike successfully") {
        setState(() => widget.reel.likeCount--);
      }
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
    try {
      await reelsCubit.getComments(widget.reel.id);
      showCommentsBottomSheet(context, reel: widget.reel);
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  void _handleShareAction(String videoUrl) {
    Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
    try {
      await reelsCubit.saveReel(widget.reel.id);
      final response = reelsCubit.state.reelSaveResponse;
      if (response!.message == "saved successfully") {
        setState(() => widget.reel.saveCount++);
      } else if (response.message == "unsaved successfully") {
        setState(() => widget.reel.saveCount--);
      }
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  Widget _buildActionButton(IconData icon, int count, VoidCallback function,
      {Color? iconColor}) {
    return IconButton(
      onPressed: function,
      icon: Column(
        children: [
          FaIcon(
            icon,
            color: iconColor ?? Colors.white,
            size: 30,
          ),
          SizedBox(height: 2),
          if (count != 0)
            Text(
              '$count',
              style: const TextStyle(color: Colors.white),
            )
          else
            Sizer(),
        ],
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
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.03;

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
              fontSize: textSize,
              color: AppColors.UNSELECTED_GRAY_COLOR,
              decoration: TextDecoration.none,
              shadows: [
                const Shadow(
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

class RoundedButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const RoundedButtonWithImage({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 50,
        child: FittedBox(
          child: ElevatedButton.icon(
              onPressed: onPressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Colors.blueGrey.withOpacity(0.2),
              )),
              icon: const Icon(
                FontAwesomeIcons.music,
                color: Colors.white,
              ),
              label: const Text(
                'Audio',
                style: TextStyle(color: Colors.white),
              )),
        )
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.transparent,
        //     shadowColor: Colors.transparent,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       side: const BorderSide(color: Colors.white, width: 1),
        //     ),
        //     padding: EdgeInsets.zero,
        //   ),
        //   onPressed: ,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(12),
        //     child: Stack(
        //       children: [
        //         Image.network(
        //           width: double.infinity,
        //           height: double.infinity,
        //           imagePath,
        //           fit: BoxFit.fill,
        //         ),
        //         const Positioned(
        //           bottom: 4,
        //           right: 4,
        //           child: Center(
        //             child: FaIcon(
        //               FontAwesomeIcons.music,
        //               size: 15,
        //               color: Colors.white,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
