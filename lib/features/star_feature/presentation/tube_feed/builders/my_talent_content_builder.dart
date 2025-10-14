import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';

import '../../../domain/entity/star_entity.dart';
import '../../presentation_exports.dart';
import '../helpers/navigation_helper.dart';
import '../widgets/common/empty_state_widget.dart';

class MyTalentContentBuilder {
  static Widget buildSliver({
    required BuildContext context,
    required StarCubit cubit,
    Function(StarEntity, String)? onVideoTap,
    ScrollController? scrollController,
  }) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        print(
            "🎬 Building MyTalent UI - count: ${state.myTalents.length}, loading: ${state.isLoading(TalentCategory.myTalents)}");

        if (state.isLoading(TalentCategory.myTalents) &&
            state.myTalents.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
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

        final controller = scrollController ?? ScrollController();

        return SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: OlxPaginationWidget(
              items: List.generate(
                myTalents.length,
                (index) => Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: TalentMyItem(
                    talent: myTalents[index],
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
                ),
              ),
              banners: bannersList,
              loadPage: (page) => cubit.loadTalents(TalentCategory.myTalents),
              scrollController: controller,
              itemsPerPage: 3,
            ),
          ),
        );
      },
    );
  }
}
