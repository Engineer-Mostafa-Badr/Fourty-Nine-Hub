import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';

import '../../presentation_exports.dart';
import '../widgets/common/empty_state_widget.dart';

class HistoryContentBuilder {
  static Widget buildSliver({
    required BuildContext context,
    required StarCubit cubit,
    ScrollController? scrollController,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.history) &&
            state.historyTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
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
            child: EmptyStateWidget(
              type: EmptyStateType.noHistory,
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
                historyTalents.length,
                (index) => TalentHistoryItem(
                  talent: historyTalents[index],
                  cubit: cubit,
                  index: index,
                ),
              ),
              banners: bannersList,
              loadPage: (page) => cubit.loadTalents(TalentCategory.history),
              scrollController: controller,
              itemsPerPage: 3,
            ),
          ),
        );
      },
    );
  }
}
