import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class TwitterPostCard extends StatefulWidget {
  bool isLiked;
  bool? fromProfile;
  final TwitterPostEntity post;
  final Function onReact;
  final Function getPost;
  final Function onShare;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final Function(String) showPostComments;
  final Function(String) onDeleteComment;
  final Function(TwitterPostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;
  bool? shareSuccess;
  TwitterPostCard({
    super.key,
    this.isLiked = false,
    this.shareSuccess = false,
    this.fromProfile = false,
    required this.post,
    required this.onReact,
    required this.showPostComments,
    required this.onShare,
    required this.getPost,
    required this.onReport,
    required this.deletePost,
    required this.hidePost,
    required this.onDeleteComment,
    required this.onEditComment,
  });

  @override
  State<TwitterPostCard> createState() => _TwitterPostCardState();
}

class _TwitterPostCardState extends State<TwitterPostCard> {
  final List<String> images = [
    UIConst.socialImagePlaceHolder,
    UIConst.socialImagePlaceHolder,
    UIConst.socialImagePlaceHolder,
    UIConst.socialImagePlaceHolder,
    UIConst.socialImagePlaceHolder,
  ];
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isShared = widget.post.isShared!;
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Container(
        padding: EdgeInsets.all(isShared == true ? 10 : 0),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isShared == true)
              _buildAccountRow(
                  context: context,
                  post: widget.post,
                  date: widget.post.sinceTime),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5.h),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.h),
              decoration: BoxDecoration(
                  border: isShared == true
                      ? Border.all(color: AppColors.LIGHT_GRAY_COLOR)
                      : null),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: widget.post.isShared == true
                        ? () {
                            print("objectH");
                            // context.push(Routes.TWITTERPOSTDETAILS,extra: widget.post.mainPost.id);

                            bottomSheet(
                                context: context,
                                isScrollControlled: true,
                                widget: TwitterPostDetails(
                                  postId: isShared == true
                                      ? widget.post.mainPost.id
                                      : widget.post.id,
                                  showPostComments: (id) {},
                                  onReport: (TwitterReportParams params) {},
                                ));
                          }
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainAccountRow(
                            context: context,
                            showOptions: false,
                            post: widget.post,
                            date: widget.post.isShared == true
                                ? widget.post.mainPost?.sinceTime ?? ''
                                : widget.post.sinceTime),
                        SizedBox(
                          height: 10.h,
                        ),
                        _buildContent(
                            label: widget.post.isShared == true
                                ? widget.post.mainPost?.content
                                : widget.post.content,
                            image: widget.post.photo),
                      ],
                    ),
                  ),
                  if (isShared == false)
                    _buildStatisticsWidget(widget.post, true),
                ],
              ),
            ),
            if (isShared == true)
              _buildTwitterStaticsWidget(widget.post, false),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsWidget(TwitterPostEntity post, bool isMain) {
    return _buildTwitterStaticsWidget(post, isMain);
  }

  Widget _buildTwitterStaticsWidget(TwitterPostEntity post, bool isMain) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTwitterItem(
              icon: Icons.comment,
              label: '${post.commentsCount}',
              onTap: () {
                if (context.read<UserCubit>().isLoggedIn) {
                  return widget.showPostComments(widget.post.id);
                } else {
                  context.push(Routes.LOGIN);
                }
              },
            ),
          ),
          Expanded(
            child: _buildTwitterItem(
              icon: FontAwesomeIcons.retweet,
              label: "${widget.post.sharesCount}",
              onTap: () {
                if (context.read<UserCubit>().isLoggedIn) {
                  widget.onShare();
                  if (widget.shareSuccess == true &&
                      widget.post.shares?.length == widget.post.sharesCount) {
                    widget.post.sharesCount = widget.post.sharesCount! + 1;
                  }
                  setState(() {});
                } else {
                  context.push(Routes.LOGIN);
                }
              },
            ),
          ),
          Expanded(
            child: _buildTwitterItem(
                icon: post.isReact == false
                    ? Icons.favorite_outline
                    : Icons.favorite,
                label: "${post.loveCount}",
                onTap: () {
                  if (context.read<UserCubit>().isLoggedIn) {
                    widget.onReact();
                  } else {
                    context.push(Routes.LOGIN);
                  }
                },
                iconColor: post.isReact == false ? Colors.grey : Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTwitterItem({
    required IconData icon,
    Color? iconColor,
    required String label,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor ?? Colors.grey,
          ),
          Sizer(),
          Label(text: label, style: Styles.mediumText(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildContent({
    String? label,
    String? image,
  }) {
    return _buildTwitterContent(image: image, label: label);
  }

  Widget _buildTwitterContent({
    String? label,
    String? image,
  }) {
    var myImages = widget.post.isShared == true
        ? widget.post.mainPost.images
        : widget.post.images;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || label != '') ...[
          ReadMoreLabel(
            text: label ?? '',
            style: Styles.headerText(fontSize: 30),
          ),
          Sizer(),
        ],
        if (myImages!.isNotEmpty)
          GridView.builder(
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: myImages.length == 1 ? 1 : 2),
            itemCount: myImages.length < 4 ? myImages.length : 4,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (index != 3 || (index == 3 && myImages!.length == 4)) {
                  showDialog(
                      context: context,
                      builder: (context) => ImageDetailsScreen(
                            image: myImages![index],
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
                          images: myImages ?? [],
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
                        image: myImages?[index] ?? '',
                        defaultLogo: true,
                      ),
                      if (index == 3 && myImages!.length > 4)
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Label(
                              text: "+${myImages!.length - 4}",
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
            ),
          ),
      ],
    );
  }

  //done for twitter
  Widget _buildAccountRow({
    required BuildContext context,
    required String date,
    required TwitterPostEntity post,
  }) {
    final user = context.read<UserCubit>().state.data;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        post.user.image != ''
            ? UserProfileImage(
                accountId: 0,
                imageURL: post.user.image,
                fromProfile: widget.fromProfile,
                userId: post.user.id,
              )
            : UserProfileImage(
                accountId: 0,
                fromProfile: widget.fromProfile,
                userId: post.user.id,
              ),
        Sizer(),
        Label(
            text: "${post.user.firstName} ${post.user.lastName}",
            style: Styles.mediumText(fontWeight: FontWeight.w500)),
        Sizer(
          width: 4,
        ),
        if (post.user.isDocumented == true)
          const Icon(
            Icons.verified,
            color: AppColors.PRIMARY_COLOR,
          ),
        Sizer(),
        Expanded(
          child: Label(
              text: '@${post.user.email.split('@')[0]}',
              style: Styles.mediumText(color: Colors.grey)),
        ),
        Label(text: ' . $date', style: Styles.mediumText(color: Colors.grey)),
        if (post.user.id != user?.id && context.read<UserCubit>().isLoggedIn)
          IconButton(
            onPressed: () {
              bottomSheet(
                  context: context,
                  widget: ReportView(
                    id: widget.post.id,
                    categoryId: '66a3583454e6e337915514db',
                  ));
            },
            icon: const Icon(
              Icons.report,
              color: AppColors.SECONDARY_COLOR,
            ),
          ),
        if (context.read<UserCubit>().isLoggedIn)
          IconAppButton(
            icon: Icons.clear,
            onPressed: () {
              bottomSheet(
                context: context,
                widget: _buildPostOptions(
                  isMyPost: (post.user.id == user!.id),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPostOptions({
    required bool isMyPost,
  }) {
    return SizedBox(
      height: isMyPost ? 150 : 80,
      child: Column(
        children: [
          if (isMyPost)
            listTile(
                icon: Icons.delete,
                title: LocaleKeys.deletePost.localize,
                subTitle: LocaleKeys.youWillDeletePost.localize,
                onTap: () {
                  widget.deletePost(widget.post.id);
                  // context.pop();
                  // if(fromDetails==true){
                  //   context.pop();
                  // }
                }),
          listTile(
              icon: Icons.visibility_off,
              title: LocaleKeys.hidePost.localize,
              subTitle: LocaleKeys.youWillHidePost.localize,
              onTap: () {
                widget.hidePost(widget.post.id);
                // context.pop();
                // if(fromDetails==true){
                //   context.pop();
                // }
              }),
        ],
      ),
    );
  }

  Widget listTile(
      {required IconData icon,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }

  Widget _buildMainAccountRow({
    required BuildContext context,
    bool showOptions = true,
    required String date,
    required TwitterPostEntity post,
  }) {
    final user = context.read<UserCubit>().state.data;
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              post.user.image != ''
                  ? UserProfileImage(
                      accountId: 0,
                      imageURL: post.user.image,
                      fromProfile: widget.fromProfile,
                      userId: post.user.id,
                    )
                  : UserProfileImage(
                      accountId: 0,
                      fromProfile: widget.fromProfile,
                      userId: post.user.id,
                    ),
              Sizer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: post.isShared == true
                            ? "${post.mainPost?.user.firstName} ${post.mainPost?.user.lastName}"
                            : "${post.user.firstName} ${post.user.lastName}",
                        style: Styles.mediumText(fontWeight: FontWeight.w500)),
                    Label(
                        text:
                            '@${(post.isShared == true && post.mainPost != null ? post.mainPost.user.email ?? '' : post.user.email).split('@')[0]}',
                        maxLines: 1,
                        style: Styles.mediumText(color: Colors.grey)),
                  ],
                ),
              ),
              Label(
                  text: date,
                  maxLines: 1,
                  style: Styles.mediumText(color: Colors.black)),
              if (post.user.isDocumented == true && post.isShared == false ||
                  (post.mainPost?.user.isDocumented == true &&
                      post.isShared == true))
                Icon(
                  Icons.verified,
                  color: Theme.of(context).primaryColor,
                ),
              // Sizer(),
            ],
          ),
        ),
        if (post.isShared == false &&
            (post.user.id != user?.id) &&
            context.read<UserCubit>().isLoggedIn) ...[
          IconButton(
            onPressed: () {
              bottomSheet(
                context: context,
                widget: ReportView(
                  id: widget.post.id,
                  categoryId: '66a3583454e6e337915514db',
                ),
              );
            },
            icon: Icon(
              Icons.report,
              color: AppColors.SECONDARY_COLOR,
              size: 35.w,
            ),
          ),
          if (context.read<UserCubit>().isLoggedIn)
            IconAppButton(
              icon: Icons.clear,
              size: 40.w,
              onPressed: () {
                bottomSheet(
                    context: context,
                    widget: _buildPostOptions(
                        isMyPost: (post.user.id == user!.id)));
              },
            ),
        ]
      ],
    );
  }
}
