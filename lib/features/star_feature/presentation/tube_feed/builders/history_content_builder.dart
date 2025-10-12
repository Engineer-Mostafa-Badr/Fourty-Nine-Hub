import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../presentation_exports.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/load_more_widget.dart';

class HistoryContentBuilder {
  static Widget buildSliver({
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
            child: EmptyStateWidget(
              type: EmptyStateType.noHistory,
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == historyTalents.length) {
                return LoadMoreWidget(
                  state: state,
                  category: TalentCategory.history,
                  cubit: cubit,
                );
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
}
