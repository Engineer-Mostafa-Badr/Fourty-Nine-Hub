import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_global_posts.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/post_comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../routes/routes.dart';
import '../../../chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../../social_posts/presentation/pages/my_account_view.dart';

class InstagramView extends StatelessWidget {
  const InstagramView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SharedScaffold(
          mainCategoryId: 3,
          body: Column(
            children: [
              const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.grid_4x4_outlined),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  _buildInstagramWidget(),
                  const MyAccountView(),
                ]),
              )
            ],
          )),
    );
  }

  Widget _buildInstagramWidget() {
    return ListView(
      children: [
        const ChatStories(),
        Container(),
        const InstagramGlobalPosts(),
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

  Widget _buildContentInstagram({
    String? label,
    String? image,
  }) {
    return BlocBuilder<InstagramCubit,InstagramState>(
      builder: (context,state) {
        return Column(
          children: [
            const Sizer(),
            SizedBox(
              height: kToolbarHeight * 4,
              child: PageView.builder(
                  // controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return SocialImageViewer(
                      image: '',
                      index: index + 1,
                      length: 1,
                      onDoubleTap: () {
                        // widget.isLiked = !widget.isLiked;
                        // setState(() {});
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
                          icon:
                          // widget.isLiked
                          //     ? Icons.favorite
                          //     :
                          Icons.favorite_border,
                          onPressed: () {
                            // widget.isLiked = !widget.isLiked;
                            // setState(() {});
                          },
                          color:
                          // widget.isLiked ? Colors.red :
                          Colors.grey,
                          size: 25,
                        ),
                        const Sizer(),
                        IconAppButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          onPressed: () {
                            // bottomSheet(
                            //   context: context,
                            //   isScrollControlled: true,
                            //   widget: const PostComments(postId: '', comments: [], onAddComment: (PostCommentParams ) {  },),
                            // );
                          },
                          color: Colors.grey,
                          size: 25,
                        ),
                        const Sizer(),
                        IconAppButton(
                          icon: Icons.send_rounded,
                          color: Colors.grey,
                          onPressed: () {
                            // return context.push(Routes.CHAT);
                          },
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 8,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            separatorBuilder: (context, index) => const Sizer(
                              width: 3,
                            ),
                            itemBuilder: (context, index) {
                              return const CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                // pageController.page?.toInt() == index
                                //     ? AppColors.SECONDARY_COLOR
                                //     :
                                AppColors.PRIMARY_COLOR,
                              );
                            }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconAppButton(
                          icon: Icons.bookmark_outline,
                          color: Colors.grey,
                          onPressed: () {},
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }

}
