import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../cubit/social_posts_cubit.dart';
import 'build_facebook_suggest_people.dart';
import 'facebook_reels.dart';
import 'normal_post_screen.dart';
import '../posts/create_post_banner.dart';
import '../../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../../stories/presentation/pages/facebook_stories.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../core/widget/custom_circular_progress_indicator.dart';


class FaceBookView extends StatefulWidget {
  const FaceBookView({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FaceBookView> createState() => _FaceBookViewState();
}

class _FaceBookViewState extends State<FaceBookView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  // void _onScroll() {
  //   if (widget.scrollController.position.pixels >=
  //       widget.scrollController.position.maxScrollExtent - 200) {
  //     context.read<SocialPostsCubit>().getAllFeed();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
        listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return RefreshIndicator(
        backgroundColor: AppColors.getFillColor(context),
        color: AppColors.getTextColor(context),
        onRefresh: () async {
          controller.loadData();
          context.read<StoryCubit>()
            ..fetchStories(loadMore: true)
            ..getMutedStories();
          controller.onRefresh();
        },
        child: ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  const CreatePostBanner(),
                  Container(
                    width: double.infinity,
                    height: 5.h,
                    color: AppColors.LIGHT_GRAY_COLOR,
                  ),
                  const Stories(),
                ],
              ),
              // BuildPeopleYouMayKnow(),
              controller.loadFaceData
                  ? const Center(
                      child: CustomCircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        // Container(height: 10,color: Colors.black,),
                        if (controller.suggestedFriends.isNotEmpty)
                          const BuildFacebookSuggestPeople(),
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.allFeed.length,
                            itemBuilder: (context, index) {
                              final user = context.read<UserCubit>().state.data;
                              var post = controller.allFeed[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: post.posts?.length ?? 0,
                                    itemBuilder: (context, i) {
                                      return NormalPostScreen(
                                        postEntity: post.posts![i],
                                      );
                                    },
                                  ),
                                  if (post.reels?.isNotEmpty ?? false)
                                    FacebookReels(
                                      reels: post.reels ?? [],
                                    ),
                                ],
                              );
                            }),
                        if (controller.isLoadingFaceMore)
                          const Center(
                              child: CustomCircularProgressIndicator()),
                      ],
                    ),
            ]),
      );
    });
  }
}
