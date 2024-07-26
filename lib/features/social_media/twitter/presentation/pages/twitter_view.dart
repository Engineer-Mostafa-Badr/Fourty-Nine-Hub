import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
            builder: (context,state) {
              return context.read<UserCubit>().isLoggedIn
                  ?_buildGlobalPosts(): Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () => context.push(Routes.LOGIN),
                          child: Label(
                              text: 'Login',
                              style: Styles.headerText(color: Colors.blue))),
                      Label(
                          text: ', To continue in using chat services',
                          style: Styles.headerText()),
                    ],
                  ));
            }
          ),
        ),
        PositionedDirectional(
          bottom: 70,
          end: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () => context.push(Routes.CREATEPOST,extra: 'twitter'),
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
    return BlocConsumer<TwitterCubit, TwitterState>(
      listener: (context,state){
        if(state.status == StateStatus.error) {

          showErrorMessage(context, getFailureMessage(
            state.failure ?? const UnknownFailure(),
            context,
          ),);
        }
      },
        builder: (context, state) {
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
              return TwitterPostCard(
                post: controller.postsPagingController.itemList![index],
                onReact: () {
                  controller.onReact(
                      params: TwitterPostReactParams(
                          postId: controller.postsPagingController
                                  .itemList![index].id,
                          react: 'love'));
                  controller.postsPagingController.itemList?[index].isReact=!controller.postsPagingController.itemList![index].isReact!;
                },
                shareSuccess: state.shareSuccess,
                onShare: () {
                  controller.onShare(
                    postId: controller.postsPagingController
                        .itemList![index].id,
                  );
                  setState(() {
                  });
                },
                showPostComments: (String v) {
                  print("mainId ${controller.postsPagingController
                      .itemList![index].id}");
                  controller.showPostComments(
                    context: context,
                    postId: controller.postsPagingController
                        .itemList![index].id,);
                }, getPost: (){
                controller.getTwitterPost(context,controller.postsPagingController
                    .itemList![index].mainPost.id);
              },
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
