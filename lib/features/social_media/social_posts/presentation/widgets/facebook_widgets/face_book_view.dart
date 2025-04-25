import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_suggest_people.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_reels.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/normal_post_screen.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/create_post_banner.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class FaceBookView extends StatefulWidget {
  const FaceBookView({super.key});

  @override
  State<FaceBookView> createState() => _FaceBookViewState();
}

class _FaceBookViewState extends State<FaceBookView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SocialPostsCubit>().getAllFeed();
    }
  }

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
        onRefresh: () async {
          controller.loadData();
          context.read<StoryCubit>()
            ..fetchStories(loadMore: true)
            ..getMutedStories();
          controller.onRefresh();
        },
        child: ListView(
            controller: _scrollController,
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
                      child: CircularProgressIndicator(),
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
                          const Center(child: CircularProgressIndicator()),
                      ],
                    ),
            ]),
      );
    });
  }
}
