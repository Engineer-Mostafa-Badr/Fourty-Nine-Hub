import 'package:flutter/material.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../posts/PostCard.dart';

class PostsSection extends StatelessWidget {
  const PostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
    // return ListView.separated(
    //     itemBuilder: (context, index) =>  PostCard(),
    //     separatorBuilder: (context, index) => const Sizer(),
    //     itemCount: 6);
  }
}
