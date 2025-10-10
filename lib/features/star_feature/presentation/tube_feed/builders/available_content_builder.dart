import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';

import '../../presentation_exports.dart';
import '../helpers/navigation_helper.dart';
import '../widgets/cards/talent_card.dart';
import '../widgets/common/empty_state_widget.dart';

class AvailableContentBuilder {
  static Widget buildSliver({
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
            child: EmptyStateWidget(
              type: EmptyStateType.noResults,
              isSearching: isSearching,
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
              loadPage: (page) => isSearching
                  ? Future.value()
                  : cubit.loadTalents(TalentCategory.available),
              scrollController: controller,
              itemsPerPage: 3,
            ),
          ),
        );
      },
    );
  }
}
