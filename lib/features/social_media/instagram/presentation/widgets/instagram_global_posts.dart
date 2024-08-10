import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstagramGlobalPosts extends StatefulWidget {
  const InstagramGlobalPosts({super.key, });
  @override
  State<InstagramGlobalPosts> createState() => _InstagramGlobalPostsState();
}

class _InstagramGlobalPostsState extends State<InstagramGlobalPosts> {
  @override
  Widget build(BuildContext context) {
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
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: ChatStories(),
            ),
            PagedSliverList<int, PostEntity>(
              pagingController: controller.feedPagingController,
              builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return const Center(
                    child: Text(
                      "لا يوجد بوستات",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  final pageController = PageController();
                  if(controller.feedPagingController.itemList?[index].type=='advertisement'){
                    return FacebookAdvertisementCard(post: controller.feedPagingController.itemList![index],);

                  }else{
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10.0,end:10,top: 0,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Sizer(),
                          SizedBox(
                            height: kToolbarHeight * 5,
                            child: PageView.builder(
                                controller: pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.feedPagingController.itemList![index].images!.length,
                                onPageChanged: (i){
                                  controller.changeIndex(i);
                                },
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
                          const SizedBox(
                            height: 10,
                          ),
                          Label(text:controller.feedPagingController.itemList?[index].content??''),
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
                                        onPressed: () async{
                                          var reacted = await controller.onReact(params: PostReactParams(postId: controller.feedPagingController.itemList![index].id, react: 'love',),);
                                          if(reacted==true){
                                            controller.feedPagingController.itemList?[index].isLove = !controller.feedPagingController.itemList![index].isLove!;
                                          }
                                          setState(() {});
                                        },
                                        color: controller.feedPagingController.itemList?[index].isLove==true ? Colors.red : Colors.grey,
                                        size: 25,
                                      ),
                                      const Sizer(),
                                      IconAppButton(
                                        icon: Icons.chat_bubble_outline_rounded,
                                        onPressed: () {
                                          controller.showPostComments(context: context, postId: controller.feedPagingController.itemList![index].id);
                                        },
                                        color: Colors.grey,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                if(controller.feedPagingController.itemList![index].images!.length>1)Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      height: 8,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.feedPagingController.itemList![index].images!.length,
                                          separatorBuilder: (context, index) => const Sizer(
                                            width: 3,
                                          ),
                                          itemBuilder: (context, index) {
                                            return CircleAvatar(
                                              radius: 4,
                                              backgroundColor: state.pageIndex == index
                                                  ? AppColors.SECONDARY_COLOR
                                                  : AppColors.PRIMARY_COLOR,
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox()
                        ],
                      ),
                    );
                  }                      },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
