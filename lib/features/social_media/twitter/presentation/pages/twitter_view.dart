import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';
import 'package:fourtyninehub/core/enums/post_type_enum.dart';
import 'package:fourtyninehub/features/social_media/social/presentation/widgets/posts/PostCard.dart';

class TwitterView extends StatelessWidget {
  const TwitterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedCommonNavigator(
      mainCategory: 3,
      body: _buildGlobalPosts(),
    );
  }

  Widget _buildGlobalPosts() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) => PostCard(
              postType: PostType.Twitter,
            ));
  }
}
