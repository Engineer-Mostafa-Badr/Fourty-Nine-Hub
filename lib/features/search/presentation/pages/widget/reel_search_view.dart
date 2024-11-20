import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class ReelSearchView extends StatefulWidget {
  const ReelSearchView({super.key});

  @override
  _ReelSearchViewState createState() => _ReelSearchViewState();
}

class _ReelSearchViewState extends State<ReelSearchView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: BlocBuilder<SearchCubit,SearchState>(
        builder: (BuildContext context, state) {
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return PagedGridView<int, ReelsSearchEntity>(
              pagingController: controller.searchPagingReelsController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10, // Horizontal space between items
                mainAxisSpacing: 10, // Vertical space between items
              ),
              builderDelegate: PagedChildBuilderDelegate<ReelsSearchEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      LocaleKeys.noData.localize,
                      style: Styles.mediumText(),
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  return InkWell(
                      onTap: (){
                      //  context.push(Routes.OTHERSACCOUNT,extra: item.id);
                      },
                      child: VideoGridItem(videoUrl: state.reels![index],));
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
              ),
            );
          }

          return const Center(
            child: Text('No results found.'),
          );
        },
      ),
    );
  }
}

class VideoGridItem extends StatefulWidget {
  final ReelsSearchEntity videoUrl;

  const VideoGridItem({super.key, required this.videoUrl});

  @override
  _VideoGridItemState createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl.videoMedia.mediaKey)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        : Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
  }
}
