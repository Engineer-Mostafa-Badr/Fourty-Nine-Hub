import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../presentation_exports.dart';
import '../helpers/navigation_helper.dart';
import '../widgets/cards/talent_card.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/load_more_widget.dart';

class FavoriteContentBuilder {
  static Widget buildSliver({
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
            child: EmptyStateWidget(
              type: EmptyStateType.noFavorites,
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == favoriteTalents.length) {
                return LoadMoreWidget(
                  state: state,
                  category: TalentCategory.favorites,
                  cubit: cubit,
                );
              }

              final talent = favoriteTalents[index];
              return TalentCard(
                talent: talent,
                cubit: cubit,
                onVideoTap: (talent, mediaUrl) {
                  TubeNavigationHelper.handleVideoTap(
                    context: context,
                    talent: talent,
                    mediaUrl: mediaUrl,
                    cubit: cubit,
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
}
