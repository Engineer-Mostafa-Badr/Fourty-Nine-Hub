import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

// ignore: must_be_immutable
class TwitterPostCard extends StatefulWidget {
  bool isLiked;
  final TwitterPostEntity post;
  final Function onReact;
  final Function getPost;
  final Function onShare;
  final Function(String) showPostComments;
  final Function(TwitterReportParams) onReport;
  bool? shareSuccess;
  TwitterPostCard({
    super.key,
    this.isLiked = false,
    this.shareSuccess = false,
    required this.post,
    required this.onReact,
    required this.showPostComments,
    required this.onShare,
    required this.getPost,
    required this.onReport,
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
      decoration: const BoxDecoration(color: Colors.white),
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
                    onTap: () {
                      if (isShared == true) {
                        widget.getPost();
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainAccountRow(
                            context: context,
                            showOptions: false,
                            post: widget.post,
                            date: widget.post.sinceTime),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildContent(
                            label: widget.post.content,
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
              label: '${post.comments.length}',
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
                  if (post.isReact == true) {
                    widget.onReact();

                    post.loveCount = (post.loveCount! - 1);
                    setState(() {});
                  } else {
                    widget.onReact();

                    post.loveCount = post.loveCount! + 1;
                    setState(() {});
                  }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ReadMoreLabel(text: label),
        const Sizer(),
        if (image != '')
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 12,
                    blurRadius: 8,
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                    image: NetworkImage(image!), fit: BoxFit.fill)),
          ),
      ],
    );
  }

  //done for twitter
  Widget _buildAccountRow({
    required BuildContext context,
    bool showOptions = true,
    required String date,
    required TwitterPostEntity post,
  }) {
    return Row(
      children: [
        post.user.image!=''? ProfileImage(accountId: 0,imageURL: post.user.image,):const ProfileImage(accountId: 0),
        const Sizer(),
        Label(
            text: post.mainPost?.user.firstName ?? "",
            style: Styles.mediumText(fontWeight: FontWeight.w500)),
        const Sizer(),
        if (post.user.isDocumented == true)
          const Icon(
            Icons.verified,
            color: AppColors.PRIMARY_COLOR,
          ),
        const Sizer(),
        Label(
            text: '@${post.user.email.split('@')[0]} . $date',
            style: Styles.mediumText(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMainAccountRow({
    required BuildContext context,
    bool showOptions = true,
    required String date,
    required TwitterPostEntity post,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              post.user.image!=''? ProfileImage(accountId: 0,imageURL:post.user.image):ProfileImage(accountId: 0),
              const Sizer(),
              Label(
                  text: post.user.firstName,
                  style: Styles.mediumText(fontWeight: FontWeight.w500)),
              const Sizer(),
              if (post.user.isDocumented == true)
                const Icon(
                  Icons.verified,
                  color: AppColors.PRIMARY_COLOR,
                ),
              const Sizer(),
              SizedBox(
                width: 100,
                child: Label(
                    text: '@${post.user.email.split('@')[0]} . $date',
                    maxLines: 1,
                    style: Styles.mediumText(color: Colors.grey)),
              ),
              const Sizer(),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            bottomSheet(
                context: context,
                widget: ReportView(
                  id: widget.post.id, categoryId: '66a3583454e6e337915514db',

                ));
          },
          icon: const Icon(
            Icons.report,
            color: AppColors.SECONDARY_COLOR,
          ),
        ),
      ],
    );
  }
}
