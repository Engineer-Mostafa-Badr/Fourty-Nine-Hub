import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../domain/entity/star_entity.dart';
import '../../presentation_exports.dart';
import '../helpers/navigation_helper.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/load_more_widget.dart';

class MyTalentContentBuilder {
  static Widget buildSliver({
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
            child: EmptyStateWidget(
              type: EmptyStateType.noMyVideos,
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= myTalents.length) {
                return LoadMoreWidget(
                  state: state,
                  category: TalentCategory.myTalents,
                  cubit: cubit,
                );
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
                        TubeNavigationHelper.handleVideoTap(
                          context: context,
                          talent: talent,
                          mediaUrl: mediaUrl,
                          cubit: cubit,
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
}
