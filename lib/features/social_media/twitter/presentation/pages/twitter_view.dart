import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/post_type_enum.dart';

import '../../../social_posts/presentation/widgets/posts/PostCard.dart';

class TwitterView extends StatelessWidget {
  const TwitterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 2,
      body: _buildGlobalPosts(),
    );
  }

  Widget _buildGlobalPosts() {
    return Container();
    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: 10,
    //     itemBuilder: (context, index) => PostCard(
    //           postType: PostType.Twitter,
    //         ));
  }
}
