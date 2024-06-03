import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../domain/entities/reel_entity.dart';
import '../widgets/reel_card.dart';

class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconAppButton(
          icon: Icons.arrow_back,
          color: Colors.white,
          size: 24,
          onPressed: () => context.pop(),
        ),
      ),
      extendBody: true,
      backgroundColor: Colors.black,
      body: PagedPageView<int, ReelEntity>(
        scrollDirection: Axis.vertical,
        pagingController:
            context.read<ExploreReelsCubit>().exploreReelsPagingController,
        builderDelegate: PagedChildBuilderDelegate<ReelEntity>(
          itemBuilder: (context, item, index) {
            return ReelCard(
              item: item,
            );
          },
        ),
      ),
    );
  }
}
