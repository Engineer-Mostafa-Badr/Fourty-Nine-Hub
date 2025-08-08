import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../instagram/presentation/cubit/instagram_cubit.dart';
import '../../../../instagram/presentation/widgets/insta_reel_card.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              state.failure ?? UnknownFailure(''),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return PagedSliverList<int, PostEntity>(
          // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
          pagingController: controller.userReelsPagingController,
          // shrinkWrap: true,
          // physics: const BouncingScrollPhysics(
          //     parent: AlwaysScrollableScrollPhysics()),
          builderDelegate: PagedChildBuilderDelegate<PostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.userReelsPagingController.itemList?.length);
                return Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: Center(
                    child: Text(
                      LocaleKeys.noReels.localize,
                      style: Styles.headerText(),
                    ),
                  ),
                );
              },
              itemBuilder: (context, item, index) {
                final post =
                    controller.userReelsPagingController.itemList![index];
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
                  margin: const EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const CupertinoActivityIndicator()),
        );
      }),
    );
  }
}
