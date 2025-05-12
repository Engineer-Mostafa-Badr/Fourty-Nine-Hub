import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:lottie/lottie.dart';

class BuildReactionsButtons extends StatefulWidget {
  const BuildReactionsButtons(
      {super.key, required this.post, required this.from});
  final dynamic post;
  final String from;

  @override
  State<BuildReactionsButtons> createState() => _BuildReactionsButtonsState();
}

class _BuildReactionsButtonsState extends State<BuildReactionsButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
      builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
        return ReactionButton<String>(
          boxColor: Colors.white,
          boxRadius: 10,
          onReactionChanged: (Reaction<String>? reaction) async {
            print(reaction?.value);
            if (reaction != null) {
              await _handleReactionChange(reaction, controller);
            }
          },
          toggle: false,
          // direction: ReactionsBoxAlignment.ltr,
          animateBox: false,
          placeholder: Reaction<String>(
            value: null,
            icon: _buildReactionPlaceholder(),
          ),
          itemsSpacing: 0,

          itemSize: const Size(40, 40),
          reactions: context.isArabic
              ? _buildReactionsEnList()
              : _buildReactionsList(),
          selectedReaction: Reaction<String>(
            value: null,
            icon: _buildReactionPlaceholder(),
          ),
          child: _buildCurrentReaction(),
        );
      },
    );
  }

  Future<void> _handleReactionChange(
      Reaction<String> reaction, SocialPostsCubit controller) async {
    print("reaction.${reaction.value}");
    if ((reaction.value == 'like' || reaction.value == 'likes') &&
        widget.post.isLikes == false) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isLikes: true);
        setState(() {});
      }
    } else if ((reaction.value == 'like' || reaction.value == 'likes') &&
        widget.post.isLikes == true) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isLikes: false);
        setState(() {});
      }
    } else if (reaction.value == 'love' && widget.post.isLove == false) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isLove: true);
        setState(() {});
      }
    } else if (reaction.value == 'love' && widget.post.isLove == true) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isLove: false);
        setState(() {});
      }
    } else if (reaction.value == 'wow' && widget.post.isWow == false) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isWow: true);
        setState(() {});
      }
    } else if (reaction.value == 'wow' && widget.post.isWow == true) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isWow: false);
        setState(() {});
      }
    } else if (reaction.value == 'sad' && widget.post.isSad == false) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isSad: true);
        setState(() {});
      }
    } else if (reaction.value == 'sad' && widget.post.isSad == true) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isSad: false);
        setState(() {});
      }
    } else if (reaction.value == 'angry' && widget.post.isAngry == false) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isAngry: true);
        setState(() {});
      }
    } else if (reaction.value == 'angry' && widget.post.isAngry == true) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isAngry: false);
        setState(() {});
      }
    } else if (reaction.value == 'haha' && widget.post.isHaha == false) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isHaha: true);
        setState(() {});
      }
    } else if (reaction.value == 'haha' && widget.post.isHaha == true) {
      var response = widget.from == 'posts' || widget.from == 'userPosts'
          ? await controller.onReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''),
              from: widget.from)
          : await controller.onCommentReact(
              params: PostReactParams(
                  postId: widget.post.id, react: reaction.value ?? ''));
      if (response == true) {
        _updatePostReaction(isHaha: false);
        setState(() {});
      }
    }
  }

  void _updatePostReaction({
    bool? isLikes,
    bool? isHaha,
    bool? isLove,
    bool? isWow,
    bool? isSad,
    bool? isAngry,
  }) {
    setState(() {
      if (isLikes != null) {
        widget.post.isLikes = isLikes;
      }
      if (isLove != null) {
        widget.post.isLove = isLove;
      }
      if (isWow != null) {
        widget.post.isWow = isWow;
      }
      if (isHaha != null) {
        widget.post.isHaha = isHaha;
      }
      if (isSad != null) {
        widget.post.isSad = isSad;
      }
      if (isAngry != null) {
        widget.post.isAngry = isAngry;
      }
      widget.post.totalCount += (isLikes == true ||
              isLove == true ||
              isWow == true ||
              isSad == true ||
              isAngry == true ||
              isHaha == true)
          ? 1
          : -1;
    });
  }

  List<Reaction<String>> _buildReactionsList() {
    return <Reaction<String>>[
      Reaction<String>(
        value: widget.from == 'posts' || widget.from == 'userPosts'
            ? 'likes'
            : 'like',
        icon: _buildReactionItem(
            name: LocaleKeys.like.localize,
            item: Reactions.like,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'haha',
        icon: _buildReactionItem(
            name: LocaleKeys.haha.localize,
            item: Reactions.haha,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'love',
        icon: _buildReactionItem(
            name: LocaleKeys.love.localize,
            item: Reactions.love,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'wow',
        icon: _buildReactionItem(
            name: LocaleKeys.wow.localize,
            item: Reactions.wow,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'sad',
        icon: _buildReactionItem(
            name: LocaleKeys.sad.localize,
            item: Reactions.sad,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'angry',
        icon: _buildReactionItem(
            name: LocaleKeys.angry.localize,
            item: Reactions.angry,
            count: widget.post.totalCount),
      ),
    ];
  }

  List<Reaction<String>> _buildReactionsEnList() {
    return <Reaction<String>>[
      Reaction<String>(
        value: 'angry',
        icon: _buildReactionItem(
            name: LocaleKeys.like.localize,
            item: Reactions.like,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'sad',
        icon: _buildReactionItem(
            name: LocaleKeys.haha.localize,
            item: Reactions.haha,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'wow',
        icon: _buildReactionItem(
            name: LocaleKeys.love.localize,
            item: Reactions.love,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'love',
        icon: _buildReactionItem(
            name: LocaleKeys.wow.localize,
            item: Reactions.wow,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: 'haha',
        icon: _buildReactionItem(
            name: LocaleKeys.sad.localize,
            item: Reactions.sad,
            count: widget.post.totalCount),
      ),
      Reaction<String>(
        value: widget.from == 'posts' || widget.from == 'userPosts'
            ? 'likes'
            : 'like',
        icon: _buildReactionItem(
            name: LocaleKeys.angry.localize,
            item: Reactions.angry,
            count: widget.post.totalCount),
      ),
    ];
  }

  Widget _buildReactionItem({
    required Reactions item,
    required num count,
    required String name,
    String? from,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: from == 'view' ? 28 : 28,
          width: from == 'view' ? 28 : 28,
          child: from == 'view'
              ? Image.asset(
                  item.imageAsset(),
                  fit: BoxFit.fill,
              color: context.isDarkMode?Colors.white:null
                )
              : Lottie.asset(
                  item.lottieAsset(),
                  fit: BoxFit.fill,
                  onLoaded: (loaded) {},
                ),
        ),
        if (widget.from == 'posts' && from == 'view') ...[
          Label(text: name, style: Styles.mediumText(color: Colors.grey)),
        ],
      ],
    );
  }

  Widget _buildReactionPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.likeIcon,color:AppColors.getTextColor(context)),
        SizedBox(width: 8.w), // Space between icon and text
        Label(
          text: LocaleKeys.like.localize,
          style: TextStyle(
              color:AppColors.getTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildCurrentReaction() {
    if (widget.post.isLikes) {
      return _buildReactionItem(
          name: LocaleKeys.like.localize,
          item: Reactions.like,
          count: widget.post.totalCount,
          from: "view");
    } else if (widget.post.isLove) {
      return _buildReactionItem(
          name: LocaleKeys.love.localize,
          item: Reactions.love,
          count: widget.post.totalCount,
          from: "view");
    } else if (widget.post.isWow) {
      return _buildReactionItem(
          name: LocaleKeys.wow.localize,
          item: Reactions.wow,
          count: widget.post.totalCount,
          from: "view");
    } else if (widget.post.isSad) {
      return _buildReactionItem(
          name: LocaleKeys.sad.localize,
          item: Reactions.sad,
          count: widget.post.totalCount,
          from: "view");
    } else if (widget.post.isAngry) {
      return _buildReactionItem(
          name: LocaleKeys.angry.localize,
          item: Reactions.angry,
          count: widget.post.totalCount,
          from: "view");
    } else if (widget.post.isHaha) {
      return _buildReactionItem(
          name: LocaleKeys.haha.localize,
          item: Reactions.haha,
          count: widget.post.totalCount,
          from: "view");
    } else {
      return _buildReactionPlaceholder();
    }
  }
}

enum Reactions {
  like,
  love,
  wow,
  sad,
  angry,
  haha;

  String lottieAsset() {
    switch (this) {
      case Reactions.like:
        return Assets.likeReaction;
      case Reactions.love:
        return Assets.loveReaction;
      case Reactions.wow:
        return Assets.wowReaction;
      case Reactions.sad:
        return Assets.sadReaction;
      case Reactions.angry:
        return Assets.angryReaction;
      case Reactions.haha:
        return Assets.hahaReaction; // Make sure this asset exists
    }
  }

  String imageAsset() {
    switch (this) {
      case Reactions.like:
        return Assets.like;
      case Reactions.love:
        return Assets.heart;
      case Reactions.wow:
        return Assets.wow;
      case Reactions.sad:
        return Assets.sad;
      case Reactions.angry:
        return Assets.angry;
      case Reactions.haha:
        return Assets.haha; // Make sure this asset exists
    }
  }
}
