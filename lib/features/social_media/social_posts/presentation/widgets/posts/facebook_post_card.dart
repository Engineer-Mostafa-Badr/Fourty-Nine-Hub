import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/ReadMoreLabel.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/social_image_viewer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import '../../../domain/usecases/post_react_usecase.dart';
import 'PostOptions.dart';


class FacebookPostCard extends StatefulWidget {
  final PostEntity post;
  final Function(PostReactParams) onReact;
  final Function(String) showPostComments;
  const FacebookPostCard(
      {super.key, required this.post, required this.onReact, required this.showPostComments});

  @override
  State<FacebookPostCard> createState() => _FacebookPostCardState();
}

class _FacebookPostCardState extends State<FacebookPostCard> {
  final pageController = PageController();
  bool isLiked = false;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountHeader(context: context, post: widget.post),
        _buildContentWidget(post: widget.post),
        Row(
          children: [
            if (widget.post.likesCount != 0)
              _buildCounterWidget(
                  value: widget.post.likesCount, image: Assets.like),
            if (widget.post.loveCount != 0)
              _buildCounterWidget(
                  value: widget.post.loveCount, image: Assets.heart),
            if (widget.post.wowCount != 0)
              _buildCounterWidget(
                  value: widget.post.wowCount, image: Assets.wow),
            if (widget.post.sadCount != 0)
              _buildCounterWidget(
                  value: widget.post.sadCount, image: Assets.sad),
            if (widget.post.angryCount != 0)
              _buildCounterWidget(
                  value: widget.post.angryCount, image: Assets.angry),
            const Spacer(),
            Row(
              children: [
                Label(
                  text: widget.post.commentsCount.toString(),
                  style: Styles.mediumText(),
                ),
                const Sizer(
                  width: 5,
                ),
                Label(
                  text: 'Comments',
                  style: Styles.mediumText(),
                )
              ],
            ),
          ],
        ),
        const Divider(
          color: AppColors.LIGHT_GRAY_COLOR,
        ),
        SizedBox(
          height: kToolbarHeight * .6,
          child: Row(
            children: [
              Expanded(child: _buildReactionsButton()),
              Expanded(
                child: _buildReactionPlaceHolder(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Comment',
                    onTap: ()=> widget.showPostComments(widget.post.id)),
              ),
              Expanded(
                child: _buildReactionPlaceHolder(
                    icon: Icons.chat_rounded,
                    label: 'Message',
                    onTap: () => context.push(Routes.CHAT)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterWidget({
    required num value,
    required String image,
  }) {
    return Row(
      children: [
        Image.asset(
          image,
          height: 20,
        ),
        const Sizer(
          width: 5,
        ),
        Label(
          text: value.toString(),
          style: Styles.mediumText(),
        )
      ],
    );
  }

  Widget _buildAccountHeader({
    required BuildContext context,
    bool showOptions = true,
    required PostEntity post,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
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
                  label: post.user.firstName,
                  onPressed: () => () => context.push(Routes.OTHERSACCOUNT)),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '19 hr   ',
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
        if (showOptions)
          IconButton(
              onPressed: () {
                bottomSheet(context: context, widget: const PostOptions());
              },
              icon: const Icon(Icons.more_horiz)),
        if (showOptions) IconAppButton(icon: Icons.clear, onPressed: () {})
      ],
    );
  }

  Widget _buildContentWidget({required PostEntity post}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreLabel(text: post.content),
          if ((post.images?.isNotEmpty ?? false))
            SizedBox(
              height: kToolbarHeight * 4,
              child: PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: post.images?.length ?? 0,
                  itemBuilder: (context, index) {
                    return SocialImageViewer(
                      image: post.images![index],
                      index: index + 1,
                      length: post.images!.length,
                      onDoubleTap: () {
                        isLiked = !isLiked;
                        setState(() {});
                      },
                    );
                  }),
            ),
        ],
      ),
    );
  }

  Widget _buildReactionsButton() {
    return ReactionButton<String>(
      boxColor: Colors.white,
      boxRadius: 10,

      onReactionChanged: (Reaction<String>? reaction) {
        widget.onReact(PostReactParams(
            postId: widget.post.id, react: reaction?.value ?? 'like'));
      },
      toggle: false,
      direction: ReactionsBoxAlignment.rtl,
      placeholder: Reaction<String>(
        value: null,
        icon: _buildReactionPlaceHolder(
            icon: Icons.thumb_up_alt_outlined, label: 'Like'),
      ),
      // boxColor: Colors.black.withOpacity(0.5),
      itemsSpacing: 10,
      itemSize: const Size(20, 20),
      reactions: <Reaction<String>>[
        Reaction<String>(
          value: 'like',
          icon: _buildReactionItem(item: Reactions.like),
        ),
        Reaction<String>(
          value: 'heart',
          icon: _buildReactionItem(item: Reactions.love),
        ),
        Reaction<String>(
          value: 'wow',
          icon: _buildReactionItem(item: Reactions.wow),
        ),
        Reaction<String>(
          value: 'sad',
          icon: _buildReactionItem(item: Reactions.sad),
        ),
        Reaction<String>(
          value: 'angry',
          icon: _buildReactionItem(item: Reactions.angry),
        ),
      ],
      selectedReaction: Reaction<String>(
        value: 'like',
        icon: _buildReactionItem(item: Reactions.like),
      ),
    );
  }

  Widget _buildReactionPlaceHolder({
    required IconData icon,
    required String label,
    Function? onTap,
  }) {
    if (onTap == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const Sizer(),
          Label(text: label, style: Styles.mediumText(color: Colors.grey))
        ],
      );
    } else {
      return InkWell(
        onTap: () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.grey,
            ),
            const Sizer(),
            Label(text: label, style: Styles.mediumText(color: Colors.grey))
          ],
        ),
      );
    }
  }

  Widget _buildReactionItem({
    required Reactions item,
  }) {
    return Row(
      children: [
        Image.asset(
          item.image(),
          height: 20,
        ),
        const Sizer(width: 5),
        Label(text: item.label()),
      ],
    );
  }
}
