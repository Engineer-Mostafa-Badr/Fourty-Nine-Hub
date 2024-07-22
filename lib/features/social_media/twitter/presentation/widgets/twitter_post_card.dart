import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
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
  final Function onShare;
  final Function(String) showPostComments;
  TwitterPostCard(
      {super.key, this.isLiked = false, required this.post, required this.onReact, required this.showPostComments, required this.onShare});

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
    bool isShared = widget.post.isShared;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Container(
              padding: EdgeInsets.all(isShared==true?10:0),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(isShared==true)_buildAccountRow(context: context, post: widget.post, date: widget.post.sinceTime),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: isShared==true?Border.all(color: AppColors.LIGHT_GRAY_COLOR):null),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainAccountRow(context: context, showOptions: false, post: widget.post, date:widget.post.sinceTime),
                        _buildContent(
                            label: widget.post.content,
                            image: widget.post.images!.isEmpty?'':widget.post.images?.first),
                        _buildStatisticsWidget(widget.post,true),
                      ],
                    ),
                  ),
                  if(isShared==true)_buildTwitterStaticsWidget(widget.post,false),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticsWidget(TwitterPostEntity post,bool isMain) {
    return _buildTwitterStaticsWidget(post,isMain);
  }

  Widget _buildTwitterStaticsWidget(TwitterPostEntity post,bool isMain) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTwitterItem(
                icon: Icons.comment,
                label: '${isMain==false?post.mainPost!.commentsCount:post.comments.length}',
                onTap: () {
                  print(widget.post.id);
                  return widget.showPostComments(widget.post.id);

                },),
          ),
          Expanded(
            child: _buildTwitterItem(
                icon: FontAwesomeIcons.retweet, label: "${isMain==false?widget.post.mainPost!.shares?.length:widget.post.shares?.length}", onTap: widget.onShare),
          ),
          Expanded(
            child: _buildTwitterItem(
                icon: Icons.favorite_outline, label: "${isMain==false?widget.post.mainPost!.love?.length:widget.post.love?.length}", onTap: widget.onReact),
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
            color: Colors.grey,
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
        if (image !='')
          Image.network(
            image!,
            width: double.infinity,
            fit: BoxFit.cover,
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
              const ProfileImage(accountId: 0),
              const Sizer(),
              Label(
                  text: post.mainPost?.user.firstName??"",
                  style: Styles.mediumText(fontWeight: FontWeight.w500)),
              const Sizer(),
              const Icon(
                Icons.verified,
                color: AppColors.PRIMARY_COLOR,
              ),
              const Sizer(),
              Label(
                  text: '@lastvibes . $date',
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
        const ProfileImage(accountId: 0),
        const Sizer(),
        Label(
            text: post.user.firstName,
            style: Styles.mediumText(fontWeight: FontWeight.w500)),
        const Sizer(),
        const Icon(
          Icons.verified,
          color: AppColors.PRIMARY_COLOR,
        ),
        const Sizer(),
        Label(
            text: '@lastvibes . $date',
            style: Styles.mediumText(color: Colors.grey)),
      ],
    );
  }
}
