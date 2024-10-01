import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SavedReelsView extends StatelessWidget {
  const SavedReelsView({super.key, required this.userData});
  final UserProfileEntity userData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator()..loadSaverReels(userData.id),
      child: BlocConsumer<InstagramCubit, InstagramState>(
          listener: (context, state) {
            if (state.status == StateStatus.error) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.failure ?? UnknownFailure(''),
                  context,
                ),
              );
            }
          }, builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return PagedSliverList<int, PostEntity>(
          pagingController: controller.savedReelsPagingController,
          builderDelegate: PagedChildBuilderDelegate<PostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.savedReelsPagingController.itemList?.length);
                return Center(
                  child: Text(
                    LocaleKeys.noReels.localize,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                );
              },
              itemBuilder: (context, item, index) {
                final post =
                controller.savedReelsPagingController.itemList![index];
                print(post.videoMedia);
                return state.status == StateStatus.success
                    ? Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 400.h,
                    child: InstagramReelCard(
                      item: post,
                      playVideo: false,
                    ))
                    : Center(
                  child: Label(
                      text: getFailureMessage(
                        state.failure ?? UnknownFailure(''),
                        context,
                      )),
                );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  margin: EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
        );
      }),
    );
  }
}