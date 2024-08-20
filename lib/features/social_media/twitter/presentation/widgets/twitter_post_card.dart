import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';

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
      decoration:  BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
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
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        const SizedBox(
                          height: 10,
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTwitterItem(
              icon: Icons.comment,
              label: '${post.commentsCount}',
              onTap: () {
                return widget.showPostComments(widget.post.id);
              },
            ),
          ),
          Expanded(
            child: _buildTwitterItem(
              icon: FontAwesomeIcons.retweet,
              label: "${widget.post.sharesCount}",
              onTap: () {
                widget.onShare();
                if (widget.shareSuccess == true &&
                    widget.post.shares?.length == widget.post.sharesCount) {
                  widget.post.sharesCount = widget.post.sharesCount! + 1;
                }
                setState(() {});
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
                  widget.onReact();
                  // print(result);
                  // if(result == true){
                  //   if(post.isReact == true){
                  //     post.isReact = false;
                  //     post.loveCount = (post.loveCount! - 1);
                  //     setState(() {});
                  //   }else{
                  //     post.isReact = true;
                  //     post.loveCount = (post.loveCount! + 1);
                  //     setState(() {});
                  //   }
                  // }
                  // if (post.isReact == true) {
                  //   var result = widget.onReact();
                  //   print(result);
                  //   post.loveCount = (post.loveCount! - 1);
                  //   setState(() {});
                  // } else {
                  //   widget.onReact();
                  //
                  //   post.loveCount = post.loveCount! + 1;
                  //   setState(() {});
                  // }
                },
                iconColor: post.isReact == false ? Colors.grey : Colors.red),
          ),
          // Expanded(
          //   child: _buildTwitterItem(
          //       icon: Icons.analytics, label: '14,350', onTap: () {}),
          // ),
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
          const Sizer(),
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
    var myImages=widget.post.isShared==true?widget.post.mainPost.images:widget.post.images;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ReadMoreLabel(text: label),
        const Sizer(),
        if (myImages!.isNotEmpty)
          GridView.builder(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: myImages.length == 1 ? 1 : 2),
            itemCount: myImages.length < 4
                ? myImages.length
                : 4,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (index != 3 ||
                    (index == 3 && myImages!.length == 4)) {
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
        const Sizer(),
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
        const Sizer(),
        Expanded(
          child: Label(
              text: '@${post.user.email.split('@')[0]}',
              style: Styles.mediumText(color: Colors.grey)),
        ),
        Label(text: ' . $date', style: Styles.mediumText(color: Colors.grey)),
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
                title: 'Delete Post',
                subTitle:
                    'Your post will be deleted, and you cannot get it again',
                onTap: () {
                  widget.deletePost(widget.post.id);
                  // context.pop();
                  // if(fromDetails==true){
                  //   context.pop();
                  // }
                }),
          listTile(
              icon: Icons.visibility_off,
              title: 'Hide Post',
              subTitle: 'Your post will be hidden, you can get it again',
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
              const Sizer(),
              Label(
                  text: post.isShared == true
                      ? post.mainPost?.user.firstName ?? ''
                      : post.user.firstName,
                  style: Styles.mediumText(fontWeight: FontWeight.w500)),
              const Sizer(),
              if (post.user.isDocumented == true && post.isShared == false ||
                  (post.mainPost?.user.isDocumented == true &&
                      post.isShared == true))
                 Icon(
                  Icons.verified,
                  color: Theme.of(context).primaryColor,
                ),
              const Sizer(),
              SizedBox(
                width: 100,
                child: Label(
                    text:
                        '@${(post.isShared == true && post.mainPost != null ? post.mainPost.user.email ?? '' : post.user.email).split('@')[0]} . $date',
                    maxLines: 1,
                    style: Styles.mediumText(color: Colors.grey)),
              ),
              const Sizer(),
            ],
          ),
        ),
        if(post.isShared==false)...[IconButton(
          onPressed: () {
            bottomSheet(
              context: context,
              widget: ReportView(
                id: widget.post.id,
                categoryId: '66a3583454e6e337915514db',
              ),
            );
          },
          icon: const Icon(
            Icons.report,
            color: AppColors.SECONDARY_COLOR,
          ),
        ),
        IconAppButton(
          icon: Icons.clear,
          onPressed: () {
            bottomSheet(
                context: context,
                widget:
                    _buildPostOptions(isMyPost: (post.user.id == user!.id)));
          },
        ),]
      ],
    );
  }
}
