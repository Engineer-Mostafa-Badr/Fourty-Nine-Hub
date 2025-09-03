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

        if (talentsToShow.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: isSearching
                    ? (context.isArabic
                        ? 'لا يوجد نتائج بحث'
                        : 'No search results found')
                    : LocaleKeys.noResultsFound.localize,
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

  // Favorite content - Fixed to show only favorite videos
  static Widget buildFavoriteContentSliver({
    required BuildContext context,
    required StarCubit cubit,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.favorites)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        // Use favoriteTalents instead of availableTalents
        final favoriteTalents = state.favoriteTalents;

        if (favoriteTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: context.isArabic
                    ? 'لا يوجد فيديوات مفضلة بعد'
                    : 'No favorite videos yet',
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
                // Add onVideoTap to navigate to TalentVideoPlayer
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

  // History content - Fixed to show only history videos
  static Widget buildHistoryContentSliver({
    required BuildContext context,
    required StarCubit cubit,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.history)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        // Use historyTalents instead of availableTalents
        final historyTalents = state.historyTalents;

        if (historyTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  context.isArabic
                      ? 'لا يوجد فيديوات في التاريخ'
                      : 'No videos in history',
                  style: TextStyle(color: Colors.grey[600]),
                ),
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

  // My talents content - Fixed to show only my videos
  static Widget buildMyTalentContentSliver({
    required BuildContext context,
    required StarCubit cubit,
    Function(StarEntity, String)? onVideoTap,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.myTalents)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        // Use myTalents instead of availableTalents
        final myTalents = state.myTalents;

        if (myTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: LocaleKeys.noResultsFound.localize,
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == myTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.myTalents, cubit);
              }

              final talent = myTalents[index];
              return TalentMyItem(
                talent: talent,
                cubit: cubit,
                index: index,
                onVideoTap: onVideoTap ??
                    (talent, mediaUrl) {
                      // Default navigation to TalentVideoPlayer
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
        child: Center(child: CustomCircularProgressIndicator()),
      );
    }

    if (!state.hasMore(category)) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            context.isArabic ? 'لا يوجد المزيد' : 'No more content',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: () => cubit.loadTalents(category),
          child: Text(context.isArabic ? 'تحميل المزيد' : 'Load More'),
        ),
      ),
    );
  }
}

// Import for TalentVideoPlayer - Add this to your existing imports
class TalentVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final StarEntity talent;

  const TalentVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.talent,
  });

  @override
  Widget build(BuildContext context) {
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
