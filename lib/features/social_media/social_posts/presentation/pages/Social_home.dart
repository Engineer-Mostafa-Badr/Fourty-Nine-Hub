import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/other_account_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../domain/entities/post_entity.dart';
import '../widgets/posts/Stories.dart';
import '../widgets/posts/create_post_banner.dart';
import '../widgets/posts/facebook_post_card.dart';

class SocialHomeView extends StatefulWidget {
  final String userId;
  const SocialHomeView({super.key, required this.userId});

  @override
  State<SocialHomeView> createState() => _SocialHomeViewState();
}

class _SocialHomeViewState extends State<SocialHomeView> {
  late SocialPostsCubit controller;

  @override
  void initState() {
    controller = context.read<SocialPostsCubit>();
    controller.getMyPosts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SharedScaffold(
        mainCategoryId: 2,
        body: NestedAppbar(appBars: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            floating: true,
            // pinned: true,
            flexibleSpace: CreatePostBanner(),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            // floating: true,
            pinned: true,
            flexibleSpace: _buildTabBar(),
          )
        ], body: _buildBody()),
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBar(tabs: [
      Tab(
        icon: Icon(Icons.home),
      ),
      Tab(
        icon: Icon(Icons.add_home_outlined),
      ),
      Tab(
        icon: Icon(Icons.person),
      ),
    ]);
  }

  Widget _buildBody() {
    return TabBarView(children: [
      _buildFacebookWidget(),
      _buildMyPostsWidget(),
      const OtherAccountView(),
    ]);
  }

  Widget _buildFacebookWidget() {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return RefreshIndicator(
        onRefresh: () async => controller.loadData(),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Stories(),
            _buildPeopleYouMayKnow(),
            // render posts
            ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => FacebookPostCard(
                      deletePost: (String postId) => controller.deletePost(
                          context: context, postId: postId),
                      hidePost: (String postId) => controller.deletePost(
                          context: context, postId: postId),
                      post: state.posts![index],
                      onReact: (PostReactParams item) =>
                          controller.onReact(params: item),
                      showPostComments: (String v) => controller
                          .showPostComments(context: context, postId: v),
                      showPostDetails: (PostEntity post) => controller
                          .showPostDetails(context: context, post: post),
                    ),
                separatorBuilder: (context, index) {
                  if (index == 4) {}
                  return Container(
                    color: AppColors.LIGHT_GRAY_COLOR,
                    height: 4,
                  );
                },
                itemCount: state.posts?.length ?? 0),

            // on loading
            if (state.status == StateStatus.loading)
              const SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(child: CircularProgressIndicator.adaptive()))
          ],
        ),
      );
    });
  }

  Widget _buildPeopleYouMayKnow() {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
      listener: (context,state){
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? const UnknownFailure(),
              context,
            ),
          );
        }
      },
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return state.suggestedFriends == null||controller.suggestUserPagingController.itemList!.isEmpty
          ? const SizedBox.shrink()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 5,
                  color: AppColors.LIGHT_GRAY_COLOR,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                            text: "Peaple you may know",
                            style: Styles.headerText(),
                          ),
                          Row(
                            children: [
                              IconAppButton(
                                  icon: Icons.more_horiz, onPressed: () {}),
                              const SizedBox(
                                width: 10,
                              ),
                              IconAppButton(
                                  icon: Icons.clear, onPressed: () {}),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        height: 250,
                        child: RefreshIndicator(
                          onRefresh: () async => controller.loadData(),
                          child: PagedListView<int, SuggestUserEntity>(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            pagingController:
                                controller.suggestUserPagingController,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            builderDelegate: PagedChildBuilderDelegate<
                                    SuggestUserEntity>(
                                noItemsFoundIndicatorBuilder: (context) {
                                  print(controller.suggestUserPagingController
                                      .itemList?.length);
                                  return const Padding(
                                      padding: EdgeInsets.only(top: 200),
                                      child: Center(
                                        child: Label(
                                          text: "No friends suggested",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ));
                                },
                                itemBuilder: (context, item, index) {
                                  SuggestUserEntity item = controller
                                      .suggestUserPagingController
                                      .itemList![
                                  index];
                                  return Container(
                                    width: 200,
                                    margin: const EdgeInsetsDirectional.only(
                                        end: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppColors.DARK_GRAY_COLOR),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 250,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(item.profilePicture),
                                                fit: BoxFit.fill),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Label(
                                                text:
                                                    "${item.firstName} ${item.lastName}",
                                                maxLines: 1,
                                                style: Styles.mediumText(),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              item.sendWelcomeSuccessfully==true?Label(text: "Message sent successfully",style: Styles.mediumText(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14
                                              ),):Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async{
                                                        if(item.addedSuccessfully==false){
                                                          var response = await controller.friendRequest(
                                                              context: context,
                                                              userId: item.id);
                                                          print(item.addedSuccessfully);

                                                          if(response==true){
                                                            item.addedSuccessfully=true;
                                                            setState(() {});
                                                            print(item.addedSuccessfully);
                                                          }
                                                        }else if(item.addedSuccessfully==true&&item.followSuccessfully==false){
                                                          var response = await controller.followRequest(
                                                              context: context,
                                                              userId: item.id);
                                                          if(response==true){
                                                            item.followSuccessfully=true;
                                                            setState(() {

                                                            });
                                                          }
                                                        }else if(item.addedSuccessfully==true&&item.followSuccessfully==true){
                                                          var response = await controller.sendGreetMessage(
                                                              context: context,
                                                              userId: item.id);
                                                          if(response==true){
                                                            item.sendWelcomeSuccessfully=true;
                                                            setState(() {

                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                              border: item.followSuccessfully==true?Border.all():null,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: item.addedSuccessfully ==false? AppColors
                                                              .PRIMARY_COLOR
                                                              :item.addedSuccessfully ==true&&item.followSuccessfully ==false? AppColors
                                                                  .PRIMARY_COLOR_DARK:Colors.white,
                                                        ),
                                                        child: Label(
                                                          text: item.addedSuccessfully==false?'Add Friend':item.addedSuccessfully==true&&item.followSuccessfully==false?'Follow':"Greet",
                                                          style:
                                                              Styles.mediumText(
                                                                  color: item.followSuccessfully==true?AppColors.PRIMARY_COLOR_DARK:Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async{
                                                        bool data = await controller.removeSuggestUser(context: context, userId: item.id);
                                                      if(data==true){
                                                        controller.suggestUserPagingController.itemList?.removeWhere((e)=>e.id==controller.suggestUserPagingController.itemList?[index].id);
                                                        setState(() {

                                                        });
                                                      }
                                                        },
                                                      child: Container(
                                                        height: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.grey,
                                                        ),
                                                        child: Label(
                                                          text: 'Remove',
                                                          style:
                                                              Styles.mediumText(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //     child: DefaultButton(
                                                  //         onPressed: () {}))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                noMoreItemsIndicatorBuilder: (context) =>
                                    Container(),
                                firstPageProgressIndicatorBuilder: (context) =>
                                    Container(
                                        margin: const EdgeInsets.only(top: 150),
                                        child:
                                            const CupertinoActivityIndicator()),
                                newPageProgressIndicatorBuilder: (context) =>
                                    const CupertinoActivityIndicator()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Label(
                        text: "See all",
                        style: Styles.mediumText(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 5,
                  color: AppColors.LIGHT_GRAY_COLOR,
                ),
              ],
            );
    });
  }

  Widget _buildMyPostsWidget() {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return RefreshIndicator(
        onRefresh: () async => controller.getMyPosts(context: context),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => FacebookPostCard(
                  deletePost: (String postId) =>
                      controller.deletePost(context: context, postId: postId),
                  hidePost: (String postId) =>
                      controller.deletePost(context: context, postId: postId),
                  isMyPost: true,
                  post: state.myPosts![index],
                  onReact: (PostReactParams item) =>
                      controller.onReact(params: item),
                  showPostComments: (String v) =>
                      controller.showPostComments(context: context, postId: v),
                  showPostDetails: (PostEntity post) =>
                      controller.showPostDetails(context: context, post: post),
                ),
            separatorBuilder: (context, index) {
              if (index == 4) {}
              return Container(
                color: AppColors.LIGHT_GRAY_COLOR,
                height: 4,
              );
            },
            itemCount: state.myPosts?.length ?? 0),
      );
    });
  }

  Widget _buildInstagramWidget() {
    return ListView(
      children: [
        const ChatStories(),
        Container(),
        // ListView.separated(
        //     shrinkWrap: true,
        //     physics: const BouncingScrollPhysics(),
        //     itemBuilder: (context, index) => PostCard(
        //           postType: PostType.Instagram,
        //         ),
        //     separatorBuilder: (context, index) => const Sizer(),
        //     itemCount: 30),
      ],
    );
  }
}
