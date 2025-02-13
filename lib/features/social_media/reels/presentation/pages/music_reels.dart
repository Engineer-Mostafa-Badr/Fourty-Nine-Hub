import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class MusicReels extends StatelessWidget {
  const MusicReels({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildMusicHeader(),
            _buildReelsImage(context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicHeader() {
    return Row(
      children: [
        const SquareImage(
            height: kToolbarHeight * 1.5,
            width: kToolbarHeight * 1.5,
            radius: 10,
            source: NetworkImage(UIConst.mrbeast)),
        const Sizer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: 'Original Sound',
              style: Styles.headerText(),
            ),
            Label(
              text: 'Songer Name',
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
            Label(
              text: '551 posts',
              style: Styles.mediumText(color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildReelsImage({
    required BuildContext context,
  }) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: .8, crossAxisCount: 3),
        itemBuilder: (context, index) => _buildReelItem(context: context));
  }

  Widget _buildReelItem({required BuildContext context}) {
    return InkWell(
      onTap: () => context.push(Routes.REELS),
      child: Image.network(UIConst.mrbeast),
    );
  }
}
