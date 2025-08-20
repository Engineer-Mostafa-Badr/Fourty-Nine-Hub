import 'package:flutter/material.dart';
import '../../../../../../common/functions/global/upload_file.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../create_post/presentation/widgets/image_details.dart';
import '../../../domain/entities/main_post_entity.dart';
import '../../../domain/entities/post_entity.dart';
import '../../pages/show_post_images.dart';
import '../facebook_widgets/image_from_internet.dart';
import '../../../../twitter/domain/entities/twitter_user_entity.dart';
import '../../../../twitter/presentation/pages/twitter_post_details.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/manage_vibration.dart';

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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: "@${LocaleKeys.tweet.localize}",
            style: Styles.headerText(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            onTap: () {
      ManageVibration.vibrate();
              bottomSheet(
                  context: context,
                  isScrollControlled: true,
                  widget: TwitterPostDetails(
                    postId: post.id,
                  ));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.DIVIDER_GRAY_COLOR),
                borderRadius: BorderRadius.circular(5),
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
                    if (post.content!.isNotEmpty || post.images.isNotEmpty)
                      _buildContent(context: context, post: post),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                  Container(
                    decoration: BoxDecoration(
                        border: isShared == true
                            ? Border.all(color: AppColors.DIVIDER_GRAY_COLOR)
                            : null,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        _buildAccountHeader(
                            context: context,
                            user: post.user),
                         _buildContent(context: context, post: post),
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
          onTap: () => context.push(Routes.OTHERSACCOUNT, extra: user.id),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage((user.image != null)
                ? user.image ?? ''
                : UIConst.profilePlaceHolder),
          ),
        ),
        const Sizer(),
        Expanded(
            child: InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextAppButton(
                  style: Styles.headerText(
                      fontSize: 32, color: Theme.of(context).primaryColor),
                  label: "${user.firstName} ${user.lastName}",
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
          ReadMoreLabel(
            text: post.content ?? '',
            style: Styles.headerText(color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10.h,
          ),
          if ((post.images.isNotEmpty ?? false))
            GridView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: post.images.length == 1 ? 1 : 2),
                itemCount: post.images.length < 4 ? post.images.length : 4,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
      ManageVibration.vibrate();
                        if (index != 3 ||
                            (index == 3 && post.images.length == 4)) {
                          showDialog(
                              context: context,
                              builder: (context) => ImageDetailsScreen(
                                    image: post.images[index],
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
                                image: post.images[index] ?? '',
                                defaultLogo: true,
                              ),
                              if (index == 3 && post.images.length > 4)
                                Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      end: 10, bottom: 10),
                                  // padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(5),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Label(
                                      text: "+${post.images.length - 4}",
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
          ReadMoreLabel(
            text: post.content ?? '',
            style: Styles.headerText(color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 10.h,
          ),
          if ((post.images?.isNotEmpty ?? false))
            SizedBox(
              child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: post.images!.length == 1 ? 1 : 2),
                  itemCount: post.images!.length < 4 ? post.images!.length : 4,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
      ManageVibration.vibrate();
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
                                  margin: const EdgeInsetsDirectional.only(
                                      end: 10, bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
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
                                    margin: const EdgeInsetsDirectional.only(
                                        end: 10, bottom: 10),
                                    // padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
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