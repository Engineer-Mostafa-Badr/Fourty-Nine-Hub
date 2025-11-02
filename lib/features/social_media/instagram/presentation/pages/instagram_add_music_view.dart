import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/enums/songs_enum.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/song_entity.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'dart:math' as math;

class MiniAudioEqualizer extends StatefulWidget {
  final bool isPlaying;
  final double width;
  final double height;
  final Color color;
  final double barWidth;
  final double radius;

  const MiniAudioEqualizer({
    super.key,
    required this.isPlaying,
    this.width = 44,
    this.height = 44,
    this.color = Colors.white,
    this.barWidth = 4,
    this.radius = 3,
  });

  @override
  State<MiniAudioEqualizer> createState() => _MiniAudioEqualizerState();
}

class _MiniAudioEqualizerState extends State<MiniAudioEqualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // لكل شرطه فاز مختلف عشان الحركة تبان موجية
  final List<double> _phases = [0.0, 0.33, 0.66];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MiniAudioEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // دالة بتحوّل قيمة وقتية (0..1) لارتفاع (0..1) بشكل موجي
  double _wave(double t, double phase) {
    // sin(2π*(t + phase)) ->  [-1..1]  نحولها لـ [0..1]
    return 0.5 + 0.5 * math.sin(2 * math.pi * (t + phase));
  }

  @override
  Widget build(BuildContext context) {
    final minH = 0.25; // أقل ارتفاع كنسبة من الارتفاع الكلي
    final maxH = 0.9;  // أقصى ارتفاع كنسبة

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // لو واقف: نخلي الأطراف صغيرة والوسط كبير (شكل ثابت)
          final t = _controller.isAnimating ? _controller.value : 0.0;

          List<double> bars = List.generate(3, (i) {
            final wave = _controller.isAnimating
                ? _wave(t, _phases[i])              // متحركة
                : (i == 1 ? 0.9 : 0.35);           // ثابتة: الوسط كبير والأطراف صغيرة
            final h = (minH + (maxH - minH) * wave) * widget.height;
            return h;
          });

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (i) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (widget.width - 3 * widget.barWidth) / 8,
                ),
                child: Container(
                  width: widget.barWidth,
                  height: bars[i],
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.radius),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class InstagramAddMusicView extends StatefulWidget {
  const InstagramAddMusicView({super.key, this.refreshUI});
  final Function? refreshUI;

  @override
  State<InstagramAddMusicView> createState() => _InstagramAddMusicViewState();
}

class _InstagramAddMusicViewState extends State<InstagramAddMusicView> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.addMusic.localize,
          style: Styles.headerText(
            fontSize: 40,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            serviceLocator<CreatePostInstagramCubit>().makeSongNull();
            Navigator.pop(context);
            if(widget.refreshUI != null) widget.refreshUI!();
          },
          icon: const Icon(Icons.close_rounded),
          color: context.isDarkMode ? Colors.white : const Color(0xB3000000),
        ),
      ),
      body: InstagramAddMusicViewBody(
        refreshUI: widget.refreshUI,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    serviceLocator<CreatePostInstagramCubit>().disposeAudioPlayer();
  }
}

class InstagramAddMusicViewBody extends StatelessWidget {
  const InstagramAddMusicViewBody({
    super.key,
    this.refreshUI,
  });

  final Function? refreshUI;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        serviceLocator<CreatePostInstagramCubit>().makeSongNull();
        Navigator.pop(context);
        if(refreshUI != null) refreshUI!();
        return false;
      },
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  InstagramAddMusicViewAppBar(),
                  SizedBox(
                    height: 16,
                  ),
                  if(serviceLocator<CreatePostInstagramCubit>().searchController.text.isNotEmpty || serviceLocator<CreatePostInstagramCubit>().searchSongs.isNotEmpty)
                  Expanded(child: InstagramAddMusicListViewSearch()),
                  if(serviceLocator<CreatePostInstagramCubit>().searchController.text.isEmpty && serviceLocator<CreatePostInstagramCubit>().searchSongs.isEmpty)
                  MusicSectionsWidget(),
                  if(serviceLocator<CreatePostInstagramCubit>().searchController.text.isEmpty && serviceLocator<CreatePostInstagramCubit>().searchSongs.isEmpty)
                  SizedBox(
                    height: 4,
                  ),
                  if(serviceLocator<CreatePostInstagramCubit>().searchController.text.isEmpty && serviceLocator<CreatePostInstagramCubit>().searchSongs.isEmpty)
                  BlocBuilder <CreatePostInstagramCubit, CreatePostInstagramState>(
                    builder: (context, state) {
                      if(state.selectedSong == SongsEnum.forYou){
                        return Expanded(child: InstagramAddMusicListViewForYou());
                      }
                      else if (state.selectedSong == SongsEnum.trending){
                        return Expanded(child: InstagramAddMusicListViewTrending());
                      } else if (state.selectedSong == SongsEnum.saved){
                        return Expanded(child: InstagramAddMusicListViewSaved());
                      }
                      else {
                        return Expanded(child: InstagramAddMusicListViewForYou());
                      }
                    },
                  ),
                ],
              ),
              BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
                  buildWhen: (previous, current) => previous.isPlaying != current.isPlaying || previous.song != current.song,
                builder: (context, state) {
                  if (state.song == null) return const SizedBox.shrink();
                  return Positioned(
                    left: 16,
                    right: 16,
                    bottom: 34,
                    child: AudioPlayerWidget(
                      song: state.song!,
                      isPlaying: state.isPlaying,
                      onPlayPause: () {
                        context.read<CreatePostInstagramCubit>().togglePlayPause();
                      },
                      onNext: () {
                        context.pop();
                        if(refreshUI != null) refreshUI!();
                      },
                    )
                  );
                }
              ),
            ],
          );
        }
      ),
    );
  }
}

class AudioPlayerWidget extends StatelessWidget {
  final SongEntity song;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final bool isPlaying;

  const AudioPlayerWidget({
    super.key,
    required this.song,
    this.onPlayPause,
    this.onNext,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFF4C2F2B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          ImageFromInternet(
            image: song.songThumbnailUrl,
            height: 44,
            width: 44,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: song.name,
                style: Styles.mediumText(
                  color:Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.29,
                ),
              ),
              const SizedBox(height: 4),
              Label(
                text: song.artistName?? (context.isArabic? 'فنان غير معروف' : 'Unknown artist'),
                style: Styles.smallText(
                  fontSize: 24,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                  height: 0.83,
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: onPlayPause,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onNext,
            child: Icon(
              Icons.arrow_circle_right,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// for you
class InstagramAddMusicListViewForYou extends StatefulWidget {
  const InstagramAddMusicListViewForYou({super.key});

  @override
  State<InstagramAddMusicListViewForYou> createState() => _InstagramAddMusicListViewForYouState();
}

class _InstagramAddMusicListViewForYouState extends State<InstagramAddMusicListViewForYou> {
  late ScrollController _scrollController; 
  @override
  void initState() {
    super.initState();
    context.read<CreatePostInstagramCubit>().loadInitialForYouSongs();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<CreatePostInstagramCubit>().getForYouSongs();
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
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CreatePostInstagramCubit>().loadInitialForYouSongs();
      },
      backgroundColor: Colors.white,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
        builder: (context, state) {
          if (state.status == CreatePostInstagramStates.loading &&
              context.read<CreatePostInstagramCubit>().forYouSongs.isEmpty) {
            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColors.SECONDARY_COLOR,
              child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h, left: 24.w, right: 24.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Shimmer.fromColors(
                              baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                              highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                              child: Container(
                                height: 200.h,
                                color: Colors.white,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
          if (state.status != CreatePostInstagramStates.loading &&
              context.read<CreatePostInstagramCubit>().forYouSongs.isEmpty) {
            return Center(child: Label(text: context.isArabic ? 'لا يوجد أغاني متاحة': 'No Songs Available', style: Styles.headerText(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 34),));
          }
          return GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColors.SECONDARY_COLOR,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: context.read<CreatePostInstagramCubit>().forYouSongs.length +
                  ((context.read<CreatePostInstagramCubit>().isLoadingMoreForYou &&
                      context.read<CreatePostInstagramCubit>().forYouSongs.isNotEmpty)
                      ? 10
                      : 0),
              itemBuilder: (context, index) {
                if (index >=
                    context.read<CreatePostInstagramCubit>().forYouSongs.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                            highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                            child: Container(
                              height: 200.h,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
                  child: ListTile(
                    onTap: () {
                      context.read<CreatePostInstagramCubit>().setSong(
                          song:  context.read<CreatePostInstagramCubit>().forYouSongs[index]);
                    },
                    leading: Stack(
                      children: [
                        ImageFromInternet(
                          image: context.read<CreatePostInstagramCubit>().forYouSongs[index].songThumbnailUrl,
                          height: 44,
                          width: 44,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        if(context.read<CreatePostInstagramCubit>().state.song?.id == context.read<CreatePostInstagramCubit>().forYouSongs[index].id)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha:  0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 44,
                          width: 44,
                          child: Center(
                            child: MiniAudioEqualizer(
                              isPlaying: context.read<CreatePostInstagramCubit>().state.isPlaying
                                  // لو عايز تظهر الحركة بس عند الأغنية الحالية:
                                  && context.read<CreatePostInstagramCubit>().state.song?.id ==
                                      context.read<CreatePostInstagramCubit>().forYouSongs[index].id,
                              color: Colors.white,
                              width: 44,
                              height: 30,
                              barWidth: 4,
                              radius: 3,
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Label(
                      text: context.read<CreatePostInstagramCubit>().forYouSongs[index].name,
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                        height: 1.29,
                      ),
                    ),
                    subtitle: Label(
                      text: context.read<CreatePostInstagramCubit>().forYouSongs[index].artistName ?? (context.isArabic? "فنان غير معروف": "Unknown Artist"),
                      style: Styles.smallText(
                        fontSize: 24,
                        color: context.isDarkMode
                            ? const Color(0x66FFFFFF)
                            : const Color(0x66000000),
                        fontWeight: FontWeight.w500,
                        height: 0.83,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async{
                        await context.read<CreatePostInstagramCubit>().addRemoveSongFromFavs(
                          song: context.read<CreatePostInstagramCubit>().forYouSongs[index],
                        );
                      },
                      icon:  Icon(context.read<CreatePostInstagramCubit>().forYouSongs[index].isSaved ?  Icons.turned_in: Icons.turned_in_not,  color: context.read<CreatePostInstagramCubit>().forYouSongs[index].isSaved ? AppColors.PRIMARY_COLOR_DARK : null,),
                    ),
                  ),
                );
              },
            ),
          );
        }
      ),
    );
  }
}


// trending

class InstagramAddMusicListViewTrending extends StatefulWidget {
  const InstagramAddMusicListViewTrending({super.key});

  @override
  State<InstagramAddMusicListViewTrending> createState() => _InstagramAddMusicListViewTrendingState();
}

class _InstagramAddMusicListViewTrendingState extends State<InstagramAddMusicListViewTrending> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<CreatePostInstagramCubit>().loadInitialTrending();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<CreatePostInstagramCubit>().getTrendingSongs();
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
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CreatePostInstagramCubit>().loadInitialTrending();
      },
      backgroundColor: Colors.white,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
          builder: (context, state) {
            if (state.status == CreatePostInstagramStates.loading &&
                context.read<CreatePostInstagramCubit>().trendingSongs.isEmpty) {
              return GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: AppColors.SECONDARY_COLOR,
                child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h, left: 24.w, right: 24.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                                child: Container(
                                  height: 200.h,
                                  color: Colors.white,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
            if (state.status != CreatePostInstagramStates.loading &&
                context.read<CreatePostInstagramCubit>().trendingSongs.isEmpty) {
              return Center(child: Label(text: context.isArabic ? 'لا يوجد أغاني متاحة': 'No Songs Available', style: Styles.headerText(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 34),));
            }
            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColors.SECONDARY_COLOR,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: context.read<CreatePostInstagramCubit>().trendingSongs.length +
                    ((context.read<CreatePostInstagramCubit>().isLoadingMoreTrending &&
                        context.read<CreatePostInstagramCubit>().trendingSongs.isNotEmpty)
                        ? 10
                        : 0),
                itemBuilder: (context, index) {
                  if (index >=
                      context.read<CreatePostInstagramCubit>().trendingSongs.length) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Shimmer.fromColors(
                              baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                              highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                              child: Container(
                                height: 200.h,
                                color: Colors.white,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
                    child: ListTile(
                      onTap: () {
                        context.read<CreatePostInstagramCubit>().setSong(
                         song:    context.read<CreatePostInstagramCubit>().trendingSongs[index]);
                      },
                      leading: Stack(
                        children: [
                          ImageFromInternet(
                            image: context.read<CreatePostInstagramCubit>().trendingSongs[index].songThumbnailUrl,
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          if(context.read<CreatePostInstagramCubit>().state.song?.id == context.read<CreatePostInstagramCubit>().trendingSongs[index].id)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha:  0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              height: 44,
                              width: 44,
                              child: Center(
                                child: MiniAudioEqualizer(
                                  isPlaying: context.read<CreatePostInstagramCubit>().state.isPlaying
                                      // لو عايز تظهر الحركة بس عند الأغنية الحالية:
                                      && context.read<CreatePostInstagramCubit>().state.song?.id ==
                                          context.read<CreatePostInstagramCubit>().trendingSongs[index].id,
                                  color: Colors.white,
                                  width: 44,
                                  height: 30,
                                  barWidth: 4,
                                  radius: 3,
                                ),
                              ),
                            )
                        ],
                      ),
                      title: Label(
                        text: context.read<CreatePostInstagramCubit>().trendingSongs[index].name,
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          height: 1.29,
                        ),
                      ),
                      subtitle: Label(
                        text: context.read<CreatePostInstagramCubit>().trendingSongs[index].artistName ?? (context.isArabic ? 'فنان غير معروف' : 'Unknown Artist'),
                        style: Styles.smallText(
                          fontSize: 24,
                          color: context.isDarkMode
                              ? const Color(0x66FFFFFF)
                              : const Color(0x66000000),
                          fontWeight: FontWeight.w500,
                          height: 0.83,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          await context.read<CreatePostInstagramCubit>().addRemoveSongFromFavs(
                            song: context.read<CreatePostInstagramCubit>().trendingSongs[index],
                          );
                        },
                        icon: Icon(context.read<CreatePostInstagramCubit>().trendingSongs[index].isSaved ?  Icons.turned_in: Icons.turned_in_not,  color: context.read<CreatePostInstagramCubit>().trendingSongs[index].isSaved ? AppColors.PRIMARY_COLOR_DARK : null,),
                      ),
                    ),
                  );
                },
              ),
            );
          }
      ),
    );
  }
}


// saved

class InstagramAddMusicListViewSaved extends StatefulWidget {
  const InstagramAddMusicListViewSaved({super.key});

  @override
  State<InstagramAddMusicListViewSaved> createState() => _InstagramAddMusicListViewSavedState();
}

class _InstagramAddMusicListViewSavedState extends State<InstagramAddMusicListViewSaved> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    context.read<CreatePostInstagramCubit>().loadInitialSaved();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          context.read<CreatePostInstagramCubit>().getFavoriteSongs();
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
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CreatePostInstagramCubit>().loadInitialSaved();
      },
      backgroundColor: Colors.white,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
          builder: (context, state) {
            if (state.status == CreatePostInstagramStates.loading &&
                context.read<CreatePostInstagramCubit>().favoriteSongs.isEmpty) {
              return GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: AppColors.SECONDARY_COLOR,
                child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h, left: 24.w, right: 24.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                                child: Container(
                                  height: 200.h,
                                  color: Colors.white,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
            if (state.status != CreatePostInstagramStates.loading &&
                context.read<CreatePostInstagramCubit>().favoriteSongs.isEmpty) {
              return Center(child: Label(text: context.isArabic ? 'لا يوجد أغاني متاحة': 'No Songs Available', style: Styles.headerText(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 34),));
            }
            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColors.SECONDARY_COLOR,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: context.read<CreatePostInstagramCubit>().favoriteSongs.length +
                    ((context.read<CreatePostInstagramCubit>().isLoadingMoreFavorite &&
                        context.read<CreatePostInstagramCubit>().favoriteSongs.isNotEmpty)
                        ? 10
                        : 0),
                itemBuilder: (context, index) {
                  if (index >=
                      context.read<CreatePostInstagramCubit>().favoriteSongs.length) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Shimmer.fromColors(
                              baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                              highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                              child: Container(
                                height: 200.h,
                                color: Colors.white,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
                    child: ListTile(
                      onTap: () {
                        context.read<CreatePostInstagramCubit>().setSong(
                         song:  context.read<CreatePostInstagramCubit>().favoriteSongs[index],
                        );
                      },
                      leading: Stack(
                        children: [
                          ImageFromInternet(
                            image: context.read<CreatePostInstagramCubit>().favoriteSongs[index].songThumbnailUrl,
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          if(context.read<CreatePostInstagramCubit>().state.song?.id == context.read<CreatePostInstagramCubit>().favoriteSongs[index].id)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha:  0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              height: 44,
                              width: 44,
                              child: Center(
                                child: MiniAudioEqualizer(
                                  isPlaying: context.read<CreatePostInstagramCubit>().state.isPlaying
                                      // لو عايز تظهر الحركة بس عند الأغنية الحالية:
                                      && context.read<CreatePostInstagramCubit>().state.song?.id ==
                                          context.read<CreatePostInstagramCubit>().favoriteSongs[index].id,
                                  color: Colors.white,
                                  width: 44,
                                  height: 30,
                                  barWidth: 4,
                                  radius: 3,
                                ),
                              ),
                            )
                        ],
                      ),
                      title: Label(
                        text: context.read<CreatePostInstagramCubit>().favoriteSongs[index].name,
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          height: 1.29,
                        ),
                      ),
                      subtitle: Label(
                        text: context.read<CreatePostInstagramCubit>().favoriteSongs[index].artistName ?? (context.isArabic ? "فنان غير معروف" : "Unknown Artist"),
                        style: Styles.smallText(
                          fontSize: 24,
                          color: context.isDarkMode
                              ? const Color(0x66FFFFFF)
                              : const Color(0x66000000),
                          fontWeight: FontWeight.w500,
                          height: 0.83,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          await context.read<CreatePostInstagramCubit>().addRemoveSongFromFavs(
                            song: context.read<CreatePostInstagramCubit>().favoriteSongs[index],
                          );
                        },
                        icon:  Icon(context.read<CreatePostInstagramCubit>().favoriteSongs[index].isSaved ?  Icons.turned_in: Icons.turned_in_not, color: context.read<CreatePostInstagramCubit>().favoriteSongs[index].isSaved ? AppColors.PRIMARY_COLOR_DARK : null,),
                      ),
                    ),
                  );
                },
              ),
            );
          }
      ),
    );
  }
}

// search
class InstagramAddMusicListViewSearch extends StatefulWidget {
  const InstagramAddMusicListViewSearch({super.key});

  @override
  State<InstagramAddMusicListViewSearch> createState() => _InstagramAddMusicListViewSearchState();
}

class _InstagramAddMusicListViewSearchState extends State<InstagramAddMusicListViewSearch> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    // context.read<CreatePostInstagramCubit>().loadInitialForYouSongs();

    _scrollController = ScrollController();
      // ..addListener(() {
      //   if (_scrollController.position.pixels >=
      //       _scrollController.position.maxScrollExtent - 200) {
      //     context.read<CreatePostInstagramCubit>().getForYouSongs();
      //   }
      // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CreatePostInstagramCubit>().searchForSongs();
      },
      backgroundColor: Colors.white,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
          builder: (context, state) {
            if (state.status == CreatePostInstagramStates.loading &&
                context.read<CreatePostInstagramCubit>().searchSongs.isEmpty) {
              return GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: AppColors.SECONDARY_COLOR,
                child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h, left: 24.w, right: 24.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                                child: Container(
                                  height: 200.h,
                                  color: Colors.white,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
            if (state.status != CreatePostInstagramStates.loading &&
                context.read<CreatePostInstagramCubit>().searchSongs.isEmpty) {
              return Center(child: Label(text: context.isArabic ? 'لا يوجد أغاني متاحة': 'No Songs Available', style: Styles.headerText(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 34),));
            }
            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: AppColors.SECONDARY_COLOR,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: context.read<CreatePostInstagramCubit>().searchSongs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
                    child: ListTile(
                      onTap: () {
                        context.read<CreatePostInstagramCubit>().setSong(
                            song:  context.read<CreatePostInstagramCubit>().searchSongs[index]);
                      },
                      leading: Stack(
                        children: [
                          ImageFromInternet(
                            image: context.read<CreatePostInstagramCubit>().searchSongs[index].songThumbnailUrl,
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          if(context.read<CreatePostInstagramCubit>().state.song?.id == context.read<CreatePostInstagramCubit>().searchSongs[index].id)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha:  0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              height: 44,
                              width: 44,
                              child: Center(
                                child: MiniAudioEqualizer(
                                  isPlaying: context.read<CreatePostInstagramCubit>().state.isPlaying
                                      // لو عايز تظهر الحركة بس عند الأغنية الحالية:
                                      && context.read<CreatePostInstagramCubit>().state.song?.id ==
                                          context.read<CreatePostInstagramCubit>().searchSongs[index].id,
                                  color: Colors.white,
                                  width: 44,
                                  height: 30,
                                  barWidth: 4,
                                  radius: 3,
                                ),
                              ),
                            )
                        ],
                      ),
                      title: Label(
                        text: context.read<CreatePostInstagramCubit>().searchSongs[index].name,
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          height: 1.29,
                        ),
                      ),
                      subtitle: Label(
                        text: context.read<CreatePostInstagramCubit>().searchSongs[index].artistName ?? (context.isArabic? "فنان غير معروف": "Unknown Artist"),
                        style: Styles.smallText(
                          fontSize: 24,
                          color: context.isDarkMode
                              ? const Color(0x66FFFFFF)
                              : const Color(0x66000000),
                          fontWeight: FontWeight.w500,
                          height: 0.83,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async{
                          await context.read<CreatePostInstagramCubit>().addRemoveSongFromFavs(
                            song: context.read<CreatePostInstagramCubit>().searchSongs[index],
                          );
                        },
                        icon:  Icon(context.read<CreatePostInstagramCubit>().searchSongs[index].isSaved ?  Icons.turned_in: Icons.turned_in_not,  color: context.read<CreatePostInstagramCubit>().searchSongs[index].isSaved ? AppColors.PRIMARY_COLOR_DARK : null,),
                      ),
                    ),
                  );
                },
              ),
            );
          }
      ),
    );
  }
}


class MusicSectionsWidget extends StatelessWidget {
  const MusicSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) =>
          previous.selectedSong != current.selectedSong,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: SongsEnum.values
                .map((section) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 12,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          context
                              .read<CreatePostInstagramCubit>()
                              .changeMusicSection(section);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: ShapeDecoration(
                            color: state.selectedSong ==
                                    section
                                ? (context.isDarkMode
                                    ? const Color(0xff171717)
                                    : const Color(0xFFFFEEEA))
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Label(
                            text: context.isArabic? section.ar() : section.en(),
                            style: Styles.headerText(
                              color: state.selectedSong ==
                                  section
                                  ? (context.isDarkMode
                                      ? const Color(0xffFF4622)
                                      : const Color(0xFFFF3308))
                                  : (context.isDarkMode
                                      ? const Color(0x4DFFFFFF)
                                      : const Color(0x4D000000)),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class InstagramAddMusicViewAppBar extends StatefulWidget {
  const InstagramAddMusicViewAppBar({super.key});

  @override
  State<InstagramAddMusicViewAppBar> createState() => _InstagramAddMusicViewAppBarState();
}

class _InstagramAddMusicViewAppBarState extends State<InstagramAddMusicViewAppBar> {
  Timer? _debounce;
  bool isSearching = false;

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (isSearching) return;

      isSearching = true;
      await serviceLocator<CreatePostInstagramCubit>().searchForSongs();
      isSearching = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: serviceLocator<CreatePostInstagramCubit>().searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.isDarkMode
              ? const Color(0xFF1B1B1B)
              : const Color(0xffF0F0F0),
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon( Icons.close_rounded, color: context.isDarkMode ? Colors.white : const Color(0xB3000000),),
            onPressed: () async {
              serviceLocator<CreatePostInstagramCubit>().clearSearch();
            },
          ),
          prefixIcon: SizedBox(
            width: 16,
            height: 16,
            child: Center(
              child: SvgPicture.asset(context.isDarkMode
                  ? Assets.instagramSearchIconDark
                  : Assets.instagramSearchIcon),
            ),
          ),
          hintStyle: Styles.mediumText(
            color: context.isDarkMode
                ? const Color(0x80FFFFFF)
                : const Color(0x80000000),
          ),
          hintText: context.isArabic? "ابحث عن موسيقى ..." : "Search for music ...",
        ),
      ),
    );
  }
}
