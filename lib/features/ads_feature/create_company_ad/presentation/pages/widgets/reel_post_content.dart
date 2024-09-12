import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';

import '../../../../../../core/enums/base_status_enum.dart';
import '../../cubit/create_company_ad_cubit.dart';

class ReelsPostContent extends StatefulWidget {
  const ReelsPostContent({Key? key}) : super(key: key);

  @override
  _ReelsPostContentState createState() => _ReelsPostContentState();
}

class _ReelsPostContentState extends State<ReelsPostContent> {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CreateCompanyAdCubit>().getCompanyAdPosts('reel', params: PaginationParams.basic()); // Trigger the fetch
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _initializeVideoController(String videoUrl) {
    _videoController?.dispose(); // Dispose the previous controller before initializing a new one
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoController?.play();
        });
      });
  }

  void _onPageChanged(int index, List<CompanyAdEntity> data) {
    setState(() {
      currentPageIndex = index;
    });

    _videoController?.pause(); // Pause the current video
    _initializeVideoController(data[index].media?.first.photo ?? ''); // Load the next video
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController?.pause();
      } else {
        _videoController?.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
      builder: (BuildContext context, state) {
        if (state.status == StateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == StateStatus.error) {
          return Center(child: Text('Error: ${state.failure}'));
        }

        final List<CompanyAdEntity> data = state.posts ?? [];

        if (data.isEmpty) {
          return const Center(child: Text('No videos available.'));
        }

        return PaginationView<CompanyAdEntity>(
          build:
              (ScrollController scrollController, List<CompanyAdEntity> data) {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => _onPageChanged(index, data),
              itemCount: data.length,
              itemBuilder: (context, index) {
                // Initialize the video for the first page if not initialized
                if (index == 0 && (_videoController == null || !_videoController!.value.isInitialized)) {
                  _initializeVideoController(data[index].media?.first.photo ?? '');
                }

                return GestureDetector(
                  onTap: _togglePlayPause,
                  child: Center(
                    child: _videoController != null && _videoController!.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                        : const CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
          fetchData: (PaginationParams paginationParams) {
            return context
                .read<CreateCompanyAdCubit>()
                .getCompanyAdPosts('reel', params: paginationParams);
          },
        );
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../cubit/create_company_ad_cubit.dart';
//
// class ReelsPostContent extends StatefulWidget {
//   @override
//   _VideoReelsScreenState createState() => _VideoReelsScreenState();
// }
//
// class _VideoReelsScreenState extends State<ReelsPostContent> {
//   final List<String> videoUrls = [
//     'https://49hub-reels.s3.eu-central-1.amazonaws.com/Social/reels/66ca3e98d62c72b67feec0f1/4f733d2a-ac26-4836-bebe-8e3c536c3b53.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240911%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240911T205213Z&X-Amz-Expires=3600&X-Amz-Signature=d985a13c8c2da77f125d2aee5dfe8ed2f6572905c9b46019aa6db04e2b1343ea&X-Amz-SignedHeaders=host&x-id=GetObject',
//     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
//   ];
//
//   PageController _pageController = PageController();
//   int currentPageIndex = 0;
//   late VideoPlayerController _videoController;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.network(videoUrls[currentPageIndex])
//       ..initialize().then((_) {
//         setState(() {
//           _videoController.play();
//         });
//       });
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
//
//   void _onPageChanged(int index) {
//     setState(() {
//       currentPageIndex = index;
//     });
//
//     _videoController.pause();
//     _videoController = VideoPlayerController.network(videoUrls[index])
//       ..initialize().then((_) {
//         setState(() {
//           _videoController.play();
//         });
//       });
//   }
//
//   // Function to toggle play/pause when screen is tapped
//   void _togglePlayPause() {
//     setState(() {
//       if (_videoController.value.isPlaying) {
//         _videoController.pause();
//       } else {
//         _videoController.play();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateCompanyAdCubit,CreateCompanyAdState>(
//       builder: (BuildContext context, state) {
//         return  PageView.builder(
//           controller: _pageController,
//           scrollDirection: Axis.vertical,
//           onPageChanged: _onPageChanged,
//           itemCount:state.posts?.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: _togglePlayPause, // Detect tap to play/pause
//               child: Stack(
//                 children: [
//                   Center(
//                     child: _videoController.value.isInitialized
//                         ? AspectRatio(
//                       aspectRatio: _videoController.value.aspectRatio,
//                       child: VideoPlayer(_videoController),
//                     )
//                         : CircularProgressIndicator(),
//                   ),
//                   // Positioned(
//                   //   bottom: 40,
//                   //   left: 10,
//                   //   right: 10,
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       Column(
//                   //         children: [
//                   //           Icon(Icons.favorite_border,
//                   //               color: Colors.white, size: 35),
//                   //           Text('Like', style: TextStyle(color: Colors.white)),
//                   //         ],
//                   //       ),
//                   //       Column(
//                   //         children: [
//                   //           Icon(Icons.comment, color: Colors.white, size: 35),
//                   //           Text('Comment', style: TextStyle(color: Colors.white)),
//                   //         ],
//                   //       ),
//                   //       Column(
//                   //         children: [
//                   //           Icon(Icons.share, color: Colors.white, size: 35),
//                   //           Text('Share', style: TextStyle(color: Colors.white)),
//                   //         ],
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
