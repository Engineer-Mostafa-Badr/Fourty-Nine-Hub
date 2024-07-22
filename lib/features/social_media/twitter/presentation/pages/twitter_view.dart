import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TwitterView extends StatefulWidget {
  const TwitterView({super.key});
  @override
  State<TwitterView> createState() => _TwitterViewState();
}

class _TwitterViewState extends State<TwitterView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SharedScaffold(
          mainCategoryId: 2,
          body: _buildGlobalPosts(),
        ),
        PositionedDirectional(
          bottom: 70,
          end: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () => context.push(Routes.CREATEPOST),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalPosts() {
    return BlocBuilder<TwitterCubit, TwitterState>(builder: (context, state) {
      final controller = context.read<TwitterCubit>();
      return PagedListView<int, TwitterPostEntity>(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        pagingController: controller.postsPagingController,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
            noItemsFoundIndicatorBuilder: (context) {
              print(controller.postsPagingController.itemList?.length);
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
              print(controller.postsPagingController.itemList?.length);
              return TwitterPostCard(
                post: controller.postsPagingController.itemList![index],
                onReact: () {
                  controller.onReact(
                      params: TwitterPostReactParams(
                          postId: controller.postsPagingController
                                      .itemList![index].isShared ==
                                  false
                              ? controller
                                  .postsPagingController.itemList![index].id
                              : controller.postsPagingController
                                  .itemList![index].mainPost!.id,
                          react: 'love'));
                },
                onShare: () {
                  controller.onShare(
                    postId:controller.postsPagingController
                        .itemList![index].isShared ==
                        false
                        ? controller
                        .postsPagingController.itemList![index].id
                        : controller.postsPagingController
                        .itemList![index].mainPost!.id,
                  );
                },
                showPostComments: (String v) => controller.showPostComments(
                    context: context,
                    postId:controller.postsPagingController
                        .itemList![index].isShared ==
                        false
                        ? controller
                        .postsPagingController.itemList![index].id
                        : controller.postsPagingController
                        .itemList![index].mainPost!.id,),
              );
            },
            noMoreItemsIndicatorBuilder: (context) => Container(),
            firstPageProgressIndicatorBuilder: (context) => Container(
                margin: const EdgeInsets.only(top: 150),
                child: const CupertinoActivityIndicator()),
            newPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator()),
      );
    });
  }
}
