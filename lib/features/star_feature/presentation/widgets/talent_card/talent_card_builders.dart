import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';

import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../utils/enums.dart';
import 'talent_card.dart';
import 'talent_history_item.dart';
import 'talent_my_item.dart';

class TalentCardBuilders {
  // Available content (main feed)
  static Widget buildAvailableContentSliver({
    required BuildContext context,
    required StarCubit cubit,
    required bool isSearching,
    ScrollController? scrollController,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.status == StarStates.loading &&
            state.availableTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        final talentsToShow =
            isSearching ? state.searchResults : state.availableTalents;

        if (talentsToShow.isEmpty &&
            !state.isLoading(TalentCategory.available)) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    isSearching
                        ? (!context.isArabic
                            ? 'لا يوجد نتائج بحث'
                            : 'No search results found')
                        : LocaleKeys.noResultsFound.localize,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isSearching) ...[
                    SizedBox(height: 8),
                    Text(
                      !context.isArabic
                          ? 'اسحب للأسفل للتحديث'
                          : 'Pull down to refresh',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        final controller = scrollController ?? ScrollController();

        return SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: OlxPaginationWidget(
              items: List.generate(
                talentsToShow.length,
                (index) => TalentCard(
                  talent: talentsToShow[index],
                  cubit: cubit,
                ),
              ),
              banners: bannersList,
              loadPage: (page) => isSearching
                  ? Future.value()
                  : cubit.loadTalents(TalentCategory.available),
              scrollController: controller,
              itemsPerPage: 1,
            ),
          ),
        );
      },
    );
  }

  // Favorite content with refresh support
  static Widget buildFavoriteContentSliver({
    required BuildContext context,
    required StarCubit cubit,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.favorites) &&
            state.favoriteTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        final favoriteTalents = state.favoriteTalents;

        if (favoriteTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    !context.isArabic
                        ? 'لا يوجد فيديوات مفضلة بعد'
                        : 'No favorite videos yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    !context.isArabic
                        ? 'اضغط على القلب لإضافة فيديوات للمفضلة'
                        : 'Tap the heart icon to add videos to favorites',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == favoriteTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.favorites, cubit);
              }

              final talent = favoriteTalents[index];
              return TalentCard(
                talent: talent,
                cubit: cubit,
                onVideoTap: (talent, mediaUrl) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TalentVideoPlayer(
                        videoUrl: mediaUrl,
                        talent: talent,
                      ),
                    ),
                  );
                },
              );
            },
            childCount: favoriteTalents.length +
                (state.hasMore(TalentCategory.favorites) ? 1 : 0),
          ),
        );
      },
    );
  }

  // History content with refresh support
  static Widget buildHistoryContentSliver({
    required BuildContext context,
    required StarCubit cubit,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.history) &&
            state.historyTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        final historyTalents = state.historyTalents;

        if (historyTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    !context.isArabic
                        ? 'لا يوجد فيديوات في التاريخ'
                        : 'No videos in history',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    !context.isArabic
                        ? 'الفيديوات التي شاهدتها ستظهر هنا'
                        : 'Videos you watch will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == historyTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.history, cubit);
              }

              final talent = historyTalents[index];
              return TalentHistoryItem(
                talent: talent,
                cubit: cubit,
                index: index,
              );
            },
            childCount: historyTalents.length +
                (state.hasMore(TalentCategory.history) ? 1 : 0),
          ),
        );
      },
    );
  }

  // My talents content with refresh support
  static Widget buildMyTalentContentSliver({
    required BuildContext context,
    required StarCubit cubit,
    Function(StarEntity, String)? onVideoTap,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        print(
            "🎬 Building MyTalent UI - count: ${state.myTalents.length}, loading: ${state.isLoading(TalentCategory.myTalents)}");

        if (state.isLoading(TalentCategory.myTalents) &&
            state.myTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        final myTalents = state.myTalents;
        print("🎬 MyTalents to display: ${myTalents.length}");

        if (myTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    !context.isArabic
                        ? 'لا توجد مقاطع فيديو بعد'
                        : 'No videos yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    !context.isArabic
                        ? 'اضغط على "إضافة موهبة" لرفع أول فيديو'
                        : 'Tap "Add Talent" to upload your first video',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // استخدم SliverList بدل المشاكل اللي فوق
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= myTalents.length) {
                // Load more widget
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.myTalents, cubit);
              }

              final talent = myTalents[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                child: TalentMyItem(
                  talent: talent,
                  cubit: cubit,
                  index: index,
                  onVideoTap: onVideoTap ??
                      (talent, mediaUrl) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TalentVideoPlayer(
                              videoUrl: mediaUrl,
                              talent: talent,
                            ),
                          ),
                        );
                      },
                ),
              );
            },
            childCount: myTalents.length +
                (state.hasMore(TalentCategory.myTalents) ? 1 : 0),
          ),
        );
      },
    );
  }

  // Load more widget for pagination
  static Widget _buildLoadMoreWidget(
    BuildContext context,
    StarState state,
    TalentCategory category,
    StarCubit cubit,
  ) {
    if (state.isLoading(category)) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              CustomCircularProgressIndicator(),
              SizedBox(height: 8),
              Text(
                !context.isArabic ? 'جاري التحميل...' : 'Loading...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.hasMore(category)) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 24,
              ),
              SizedBox(height: 8),
              Text(
                !context.isArabic
                    ? 'لا يوجد المزيد من المحتوى'
                    : 'No more content',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                !context.isArabic
                    ? 'اسحب للأسفل للتحديث'
                    : 'Pull down to refresh',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => cubit.loadTalents(category),
          icon: Icon(Icons.refresh, size: 18),
          label: Text(
            !context.isArabic ? 'تحميل المزيد' : 'Load More',
            style: TextStyle(fontSize: 14),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
    );
  }
}

// Import for TalentVideoPlayer - Add this to your existing imports
class TalentVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final StarEntity talent;
  final StarCubit? cubit;

  const TalentVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.talent,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    // Try to get cubit from context if not provided
    StarCubit? effectiveCubit = cubit;
    if (effectiveCubit == null) {
      try {
        effectiveCubit = context.read<StarCubit>();
      } catch (e) {
        // StarCubit not available in this context
        print('StarCubit not available: $e');
      }
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          talent.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Video player placeholder - integrate your video player here
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[800],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Video Player',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      videoUrl,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Video info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    talent.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${talent.user.firstName} ${talent.user.lastName}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${talent.totalViews} views',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
