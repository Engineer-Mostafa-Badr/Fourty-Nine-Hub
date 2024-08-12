import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BuildReactionsButtons extends StatefulWidget {
  const BuildReactionsButtons({super.key, required this.post, required this.from});
  final dynamic post;
  final String from;

  @override
  State<BuildReactionsButtons> createState() => _BuildReactionsButtonsState();
}

class _BuildReactionsButtonsState extends State<BuildReactionsButtons> {

  Reaction<String>? _selectedReaction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
          final controller = context.read<SocialPostsCubit>();
          return ReactionButton<String>(
            boxColor: Colors.white,
            boxRadius: 10,

            onReactionChanged: (Reaction<String>? reaction) async {
              if (reaction?.value == 'likes'||reaction?.value == 'like' && widget.post.isLikes == false) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'), from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  if(widget.post.isLikes== false&&
                      widget.post.isAngry== false&&
                      widget.post.isSad== false&&
                      widget.post.isWow== false&&
                      widget.post.isLove== false ){
                    widget.post.totalCount=widget.post.totalCount+1;
                  }
                      widget.post.isLikes = true;
                  widget.post.isAngry = false;
                  widget.post.isSad = false;
                  widget.post.isWow = false;
                  widget.post.isLove = false;
                  setState(() {});
                }
              } else if (reaction?.value == 'likes' ||reaction?.value == 'like'&&
                  widget.post.isLikes == true) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  widget.post.isLikes = false;
                  widget.post.totalCount=widget.post.totalCount-1;
                  setState(() {});
                }
              } else if (reaction?.value == 'love' &&
                  widget.post.isLove == false) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  if(widget.post.isLikes== false&&
                      widget.post.isAngry== false&&
                      widget.post.isSad== false&&
                      widget.post.isWow== false&&
                      widget.post.isLove== false ){
                    widget.post.totalCount=widget.post.totalCount+1;
                  }
                  widget.post.isLove = true;
                  widget.post.isAngry = false;
                  widget.post.isSad = false;
                  widget.post.isWow = false;
                  widget.post.isLikes = false;
                  setState(() {});
                }
              } else if (reaction?.value == 'love' &&
                  widget.post.isLove == true) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));
                if (response == true) {
                  widget.post.isLove = false;
                  widget.post.totalCount=widget.post.totalCount-1;
                  setState(() {});
                }
              } else if (reaction?.value == 'wow' && widget.post.isWow == false) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  widget.post.isWow = true;
                  widget.post.isAngry = false;
                  widget.post.isSad = false;
                  widget.post.isLove = false;
                  widget.post.isLikes = false;
                  setState(() {});
                }
                if(widget.post.isLikes== false&&
                    widget.post.isAngry== false&&
                    widget.post.isSad== false&&
                    widget.post.isWow== false&&
                    widget.post.isLove== false ){
                  widget.post.totalCount=widget.post.totalCount+1;
                }
                widget.post.isWow = true;
                widget.post.isAngry = false;
                widget.post.isSad = false;
                widget.post.isLove = false;
                widget.post.isLikes = false;
                setState(() {});
              } else if (reaction?.value == 'wow' && widget.post.isWow == true) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  widget.post.isWow = false;
                  widget.post.totalCount=widget.post.totalCount-1;
                  setState(() {});
                }
              }else if (reaction?.value == 'sad' && widget.post.isSad == false) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  if(widget.post.isLikes== false&&
                      widget.post.isAngry== false&&
                      widget.post.isSad== false&&
                      widget.post.isWow== false&&
                      widget.post.isLove== false ){
                    widget.post.totalCount=widget.post.totalCount+1;
                  }
                  widget.post.isSad = true;
                  widget.post.isAngry = false;
                  widget.post.isWow = false;
                  widget.post.isLove = false;
                  widget.post.isLikes = false;
                  setState(() {});
                }
              } else if (reaction?.value == 'sad' && widget.post.isSad == true) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  widget.post.isSad = false;
                  widget.post.totalCount=widget.post.totalCount-1;
                  setState(() {});
                }
              }else if (reaction?.value == 'angry' && widget.post.isAngry == false) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  if(widget.post.isLikes== false&&
                      widget.post.isAngry== false&&
                      widget.post.isSad== false&&
                      widget.post.isWow== false&&
                      widget.post.isLove== false ){
                    widget.post.totalCount=widget.post.totalCount+1;
                  }
                      widget.post.isAngry = true;
                  widget.post.isSad = false;
                  widget.post.isWow = false;
                  widget.post.isLove = false;
                  widget.post.isLikes = false;
                  setState(() {});
                }
              } else if (reaction?.value == 'angry' && widget.post.isAngry == true) {
                var response = widget.from=='posts'?await controller.onReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'),from: widget.from):
                await controller.onCommentReact(
                    params: PostReactParams(postId: widget.post.id, react: reaction?.value??'like'));                  if (response == true) {
                  widget.post.isAngry = false;
                  widget.post.angryCount=widget.post.angryCount-1;
                  setState(() {});
                }
              }
            },
            toggle: false,
            direction: ReactionsBoxAlignment.rtl,
            placeholder: (widget.post.isLikes == false &&
                widget.post.isLove == false &&
                widget.post.isAngry == false &&
                widget.post.isSad == false &&
                widget.post.isWow == false)
                ? Reaction<String>(
              value: null,
              icon: _buildReactionPlaceHolder(),)
                : null,
            // boxColor: Colors.black.withOpacity(0.5),
            itemsSpacing: 10,
            itemSize: const Size(20, 20),
            reactions: <Reaction<String>>[
              Reaction<String>(
                value: widget.from=='posts'?'likes':'like',
                icon: _buildReactionItem(item: Reactions.like, count: widget.post.totalCount),
              ),
              Reaction<String>(
                value: 'love',
                icon: _buildReactionItem(item: Reactions.love, count: widget.post.totalCount),
              ),
              Reaction<String>(
                value: 'wow',
                icon: _buildReactionItem(item: Reactions.wow, count: widget.post.totalCount),
              ),
              Reaction<String>(
                value: 'sad',
                icon: _buildReactionItem(item: Reactions.sad, count: widget.post.totalCount),
              ),
              Reaction<String>(
                value: 'angry',
                icon: _buildReactionItem(item: Reactions.angry, count: widget.post.totalCount),
              ),
            ],
            selectedReaction: _selectedReaction ??
                Reaction<String>(
                  value: null,
                  icon: _buildReactionPlaceHolder(),
                ),
            child: (widget.post.isLikes == false &&
                widget.post.isLove == false &&
                widget.post.isAngry == false &&
                widget.post.isSad == false &&
                widget.post.isWow == false)
                ? _buildReactionPlaceHolder()
                : widget.post.isLikes == true
                ? _buildReactionItem(item: Reactions.like, count: widget.post.totalCount,from:"view")
                : widget.post.isWow == true
                ? _buildReactionItem(item: Reactions.wow, count: widget.post.totalCount,from:"view")
                : widget.post.isSad == true
                ? _buildReactionItem(item: Reactions.sad, count: widget.post.totalCount,from:"view")
                : widget.post.isAngry == true
                ? _buildReactionItem(item: Reactions.angry, count: widget.post.totalCount,from:"view")
                : _buildReactionItem(item: Reactions.love, count: widget.post.totalCount,from:"view"),
          );
        });
  }

  Widget _buildReactionItem({
    required Reactions item,
    required num count,
    String? from
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          item.image(),
          height: 20,
        ),
        // if(from=="view")Label(text: count.toString()),
      ],
    );
  }
  Widget _buildReactionPlaceHolder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.thumb_up_alt_outlined,
          color: Colors.grey,
        ),
        const Sizer(),
        Label(text: 'Like', style: Styles.mediumText(color: Colors.grey))
      ],
    );
  }
}
