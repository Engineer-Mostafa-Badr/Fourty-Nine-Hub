import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class FacebookTweetCard extends StatelessWidget {
  const FacebookTweetCard({super.key, required this.post});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    bool isShared = post.isShared;
    return Container(
      decoration: BoxDecoration(
          border: isShared == true
              ? Border.all(color: AppColors.LIGHT_GRAY_COLOR)
              : null),
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: "@Tweet",
            style: Styles.headerText(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            onTap: () {
              bottomSheet(
                  context: context,
                  isScrollControlled: true,
                  widget: TwitterPostDetails(
                    postId: post.id,
                  ));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  if (isShared == true) ...[
                    _buildAccountHeader(
                      context: context,
                      user: post.user,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (post.content!.isNotEmpty || post.images!.isNotEmpty)
                      _buildContent(context: context, post: post),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                  Container(
                    decoration: BoxDecoration(
                        border: isShared == true ? Border.all() : null,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        _buildAccountHeader(
                            context: context,
                            user: isShared == true && post.mainPost != null
                                ? post.mainPost?.user
                                : post.user),
                        isShared == true
                            ? _buildMainContent(
                                context: context, post: post.mainPost!)
                            : _buildContent(context: context, post: post),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountHeader({
    required BuildContext context,
    required TwitterUserEntity user,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage((user.image != null)
                ? user.image ?? ''
                : UIConst.profilePlaceHolder),
          ),
        ),
        Sizer(),
        Expanded(
            child: InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextAppButton(
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  label: user.firstName,
                  onPressed: () => () => context.push(Routes.OTHERSACCOUNT)),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: user.sinceTime,
                    style: Styles.mediumText(color: Colors.grey)),
                const WidgetSpan(
                    child: Icon(
                  Icons.group,
                  size: 14,
                  color: Colors.grey,
                ))
              ]))
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required PostEntity post,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreLabel(text: post.content ?? ''),
          SizedBox(
            height: 10.h,
          ),
          if ((post.images?.isNotEmpty ?? false))
            GridView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: post.images!.length == 1 ? 1 : 2),
                itemCount: post.images!.length < 4 ? post.images!.length : 4,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        if (index != 3 ||
                            (index == 3 && post.images!.length == 4)) {
                          showDialog(
                              context: context,
                              builder: (context) => ImageDetailsScreen(
                                    image: post.images![index],
                                    fromPost: true,
                                    onRemoveImage: () {
                                      // controller
                                      //     .removePhoto(post.images![index]);
                                      context.pop();
                                    },
                                  ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ShowPostsImages(
                                  images: post.images ?? [],
                                  onRemoveImage: (UploadFileEntity image) {
                                    // controller.removePhoto(image);
                                  },
                                );
                              });
                        }
                      },
                      child: Stack(
                        children: [
                          Stack(
                            children: [
                              ImageFromInternet(
                                image: post.images?[index] ?? '',
                                defaultLogo: true,
                              ),
                              if (index == 3 && post.images!.length > 4)
                                Container(
                                  margin: EdgeInsetsDirectional.only(
                                      end: 10, bottom: 10),
                                  // padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(15),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Label(
                                      text: "+${post.images!.length - 4}",
                                      style: Styles.headerText(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )),
        ],
      ),
    );
  }

  Widget _buildMainContent({
    required BuildContext context,
    required MainPostEntity post,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreLabel(text: post.content ?? ''),
          SizedBox(
            height: 10.h,
          ),
          if ((post.images?.isNotEmpty ?? false))
            SizedBox(
              child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: post.images!.length == 1 ? 1 : 2),
                  itemCount: post.images!.length < 4 ? post.images!.length : 4,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          if (index != 3 ||
                              (index == 3 && post.images!.length == 4)) {
                            showDialog(
                                context: context,
                                builder: (context) => ImageDetailsScreen(
                                      image: post.images![index],
                                      fromPost: true,
                                      onRemoveImage: () {
                                        // controller
                                        //     .removePhoto(post.images![index]);
                                        context.pop();
                                      },
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ShowPostsImages(
                                    images: post.images ?? [],
                                    onRemoveImage: (UploadFileEntity image) {
                                      // controller.removePhoto(image);
                                    },
                                  );
                                });
                          }
                        },
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsetsDirectional.only(
                                      end: 10, bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        post.images?[index] ?? '',
                                      ),
                                    ),
                                  ),
                                ),
                                if (index == 3 && post.images!.length > 4)
                                  Container(
                                    margin: EdgeInsetsDirectional.only(
                                        end: 10, bottom: 10),
                                    // padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Label(
                                        text: "+${post.images!.length - 4}",
                                        style: Styles.headerText(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )),
            ),
        ],
      ),
    );
  }
}
