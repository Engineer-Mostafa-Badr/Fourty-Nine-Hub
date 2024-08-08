import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstagramGlobalPosts extends StatefulWidget {
  const InstagramGlobalPosts({super.key, });
  @override
  State<InstagramGlobalPosts> createState() => _InstagramGlobalPostsState();
}

class _InstagramGlobalPostsState extends State<InstagramGlobalPosts> {
  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return BlocConsumer<InstagramCubit, InstagramState>(listener: (context, state) {
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
      return RefreshIndicator(
        onRefresh: () async => controller.onRefresh(),
        child: PagedListView<int, PostEntity>(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          pagingController: controller.feedPagingController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          builderDelegate: PagedChildBuilderDelegate<PostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.feedPagingController.itemList?.length);
                return const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        "لا يوجد بوستات",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ));
              },
              itemBuilder: (context, item, index) {
    if(controller.feedPagingController.itemList?[index].type=='advertisement'){
      return FacebookAdvertisementCard(post: controller.feedPagingController.itemList![index],);

    }else{
      return Column(
        children: [
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 4,
            child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: controller.feedPagingController.itemList![index].images!.length,
                itemBuilder: (context, i) {
                  return SocialImageViewer(
                    image: controller.feedPagingController.itemList![index].images![i],
                    index: i + 1,
                    length: controller.feedPagingController.itemList![index].images!.length,
                    onDoubleTap: () {
                      controller.feedPagingController.itemList?[index].isLove = !controller.feedPagingController.itemList![index].isLove!;
                      setState(() {});
                    },
                  );
                }),
          ),
          const Sizer(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconAppButton(
                        icon: controller.feedPagingController.itemList?[index].isLove==true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onPressed: () {
                          controller.feedPagingController.itemList?[index].isLove = !controller.feedPagingController.itemList![index].isLove!;
                          setState(() {});
                        },
                        color: controller.feedPagingController.itemList?[index].isLove==true ? Colors.red : Colors.grey,
                        size: 25,
                      ),
                      const Sizer(),
                      IconAppButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        onPressed: () {
                          // bottomSheet(
                          //   context: context,
                          //   isScrollControlled: true,
                          //   widget: const PostComments(),
                          // );
                        },
                        color: Colors.grey,
                        size: 25,
                      ),
                      // const Sizer(),
                      // IconAppButton(
                      //   icon: Icons.send_rounded,
                      //   color: Colors.grey,
                      //   onPressed: () => context.push(Routes.CHAT),
                      //   size: 25,
                      // ),
                    ],
                  ),
                ),
                if(controller.feedPagingController.itemList![index].images!.length>1)Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 8,
                      // child: ListView.separated(
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: controller.feedPagingController.itemList![index].images!.length,
                      //     separatorBuilder: (context, index) => const Sizer(
                      //       width: 3,
                      //     ),
                      //     itemBuilder: (context, index) {
                      //       return CircleAvatar(
                      //         radius: 4,
                      //         backgroundColor: pageController.page?.toInt() == index
                      //             ? AppColors.SECONDARY_COLOR
                      //             : AppColors.PRIMARY_COLOR,
                      //       );
                      //     }),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconAppButton(
                      //   icon: Icons.bookmark_outline,
                      //   color: Colors.grey,
                      //   onPressed: () {},
                      //   size: 25,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
        ),
      );
    });
  }
}
