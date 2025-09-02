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

  // Favorite content
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

        if (state.favoriteTalents.isEmpty) {
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
              if (index == state.favoriteTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.favorites, cubit);
              }

              final talent = state.favoriteTalents[index];
              return TalentCard(
                talent: talent,
                cubit: cubit,
              );
            },
            childCount: state.favoriteTalents.length +
                (state.hasMore(TalentCategory.favorites) ? 1 : 0),
          ),
        );
      },
    );
  }

  // History content
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

        if (state.historyTalents.isEmpty) {
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
              if (index == state.historyTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.history, cubit);
              }

              final talent = state.historyTalents[index];
              return TalentHistoryItem(
                talent: talent,
                cubit: cubit,
                index: index,
              );
            },
            childCount: state.historyTalents.length +
                (state.hasMore(TalentCategory.history) ? 1 : 0),
          ),
        );
      },
    );
  }

  // My talents content
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

        if (state.myTalents.isEmpty) {
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
              if (index == state.myTalents.length) {
                return _buildLoadMoreWidget(
                    context, state, TalentCategory.myTalents, cubit);
              }

              final talent = state.myTalents[index];
              return TalentMyItem(
                talent: talent,
                cubit: cubit,
                index: index,
                onVideoTap: onVideoTap,
              );
            },
            childCount: state.myTalents.length +
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
