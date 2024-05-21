import 'package:flutter/material.dart';

import '../../../../../../res/style/const.dart';

class MediaSection extends StatelessWidget {
  const MediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) => Image.network(
        UIConst.socialImagePlaceHolder,
        fit: BoxFit.cover,
      ),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: .8,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
    );
  }
}
