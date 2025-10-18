import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';

import '../../presentation_exports.dart';
import '../helpers/navigation_helper.dart';
import '../widgets/cards/talent_card.dart';
import '../widgets/common/empty_state_widget.dart';

class FavoriteContentBuilder {
  static Widget buildSliver({
    required BuildContext context,
    required StarCubit cubit,
    ScrollController? scrollController,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.favorites) &&
            state.favoriteTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
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

        final controller = scrollController ?? ScrollController();

        return SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: OlxPaginationWidget(
              items: List.generate(
                favoriteTalents.length,
                (index) => TalentCard(
                  talent: favoriteTalents[index],
                  cubit: cubit,
                  onVideoTap: (talent, mediaUrl) {
                    TubeNavigationHelper.handleVideoTap(
                      context: context,
                      talent: talent,
                      mediaUrl: mediaUrl,
                      cubit: cubit,
                    );
                  },
                ),
              ),
              banners: bannersList,
              loadPage: (page) => cubit.loadTalents(TalentCategory.favorites),
              scrollController: controller,
              itemsPerPage: 3,
            ),
          ),
        );
      },
    );
  }
}
