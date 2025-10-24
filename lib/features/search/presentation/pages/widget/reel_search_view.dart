import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../../domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ReelSearchView extends StatefulWidget {
  const ReelSearchView({super.key});

  @override
  _ReelSearchViewState createState() => _ReelSearchViewState();
}

class _ReelSearchViewState extends State<ReelSearchView> {
  late final ScrollController _scrollController;
  late final SearchCubit _cubit;
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() async {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    final searchText = _cubit.searchController.text.trim();

    // if (searchText.isEmpty) return;

    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingReelsSearchMore &&
        _cubit.hasMoreReelsSearchData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: _cubit.searchController.text.trim(),
        filter: filter,
        params: PaginationParams(page: _cubit.reelsSearchPage),
      );
      _cubit.getPaginatedReelsSearch(params: params);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final reels = _cubit.reelsSearch;
          if (_cubit.searchController.text.trim().isEmpty) {
            return CustomEmptyWidget.searchInitial(context: context);
          }
          if (state.status == SearchStates.loading) {
            return const Center(
              child: CustomLoadingSearchWidget(),
              //  CupertinoActivityIndicator(),
            );
          }

          if (reels.isEmpty) {
            return CustomEmptyWidget(
              label: LocaleKeys.noResultsFound.localize,
            );
            // return Center(
            //   child: Text(
            //     LocaleKeys.noResultsFound.localize,
            //     style: Styles.mediumText(),
            //   ),
            // );
          }

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: reels.length + (_cubit.isLoadingReelsSearchMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= reels.length) {
                return const CupertinoActivityIndicator();
              }
              return InkWell(
                onTap: () {
                  ManageVibration.vibrate();
                  context.push(Routes.REELS);
                },
                child: VideoGridItem(videoUrl: reels[index]),
              );
            },
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
    _controller =
        VideoPlayerController.network(widget.videoUrl.videoMedia.mediaKey)
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
        ? GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                context.push(Routes.REELS);
                // controller.play();
              }
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: VideoProgressIndicator(_controller,
                        allowScrubbing: true),
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
                        ManageVibration.vibrate();
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
