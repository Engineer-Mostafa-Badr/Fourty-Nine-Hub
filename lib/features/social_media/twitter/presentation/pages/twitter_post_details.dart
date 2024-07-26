import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class TwitterPostDetails extends StatelessWidget {
  const TwitterPostDetails(
      {super.key,
      required this.post,
      required this.onReact,
      required this.onShare,
      required this.showPostComments});
  final TwitterPostEntity post;
  final Function onReact;
  final Function onShare;
  final Function(String) showPostComments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: BlocProvider<TwitterCubit>(
        create: (_) => serviceLocator(),
        child: BlocBuilder<TwitterCubit, TwitterState>(
          builder: (context, state) {
            // return Container();
            return TwitterPostCard(
              post: post,
              onReact: onReact,
              showPostComments: showPostComments,
              onShare: onShare,
              getPost: () {},
            );
          },
        ),
      ),
    );
  }
}
