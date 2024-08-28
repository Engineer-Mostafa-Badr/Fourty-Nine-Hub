import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserReels extends StatefulWidget {
  const UserReels({super.key, required this.userData});
  final UserProfileEntity userData;
  @override
  State<UserReels> createState() => _UserReelsState();
}

class _UserReelsState extends State<UserReels> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator()..loadUserReels(widget.userData.id),
      child: BlocConsumer<InstagramCubit, InstagramState>(
          listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? const UnknownFailure(),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return PagedSliverList<int, PostEntity>(
          // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          pagingController: controller.userReelsPagingController,
          // shrinkWrap: true,
          // physics: const BouncingScrollPhysics(
          //     parent: AlwaysScrollableScrollPhysics()),
          builderDelegate: PagedChildBuilderDelegate<PostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.userReelsPagingController.itemList?.length);
                return const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        "No Reels",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ));
              },
              itemBuilder: (context, item, index) {
                final post =
                    controller.userReelsPagingController.itemList![index];
                print(post.videoMedia);
                return state.status == StateStatus.success
                    ? Container(
                        color: Colors.black,
                        width: double.infinity,
                        height: 400,
                        child: InstagramReelCard(
                          item: post,
                          playVideo: false,
                        ))
                    : Center(
                        child: Label(
                            text: getFailureMessage(
                          state.failure ?? const UnknownFailure(),
                          context,
                        )),
                      );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const CupertinoActivityIndicator()),
        );
      }),
    );
  }
}
