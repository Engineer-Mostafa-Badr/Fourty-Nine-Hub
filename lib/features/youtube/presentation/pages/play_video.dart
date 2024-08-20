import 'package:flutter/material.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';

import '../../../../common/widgets/stateful/videos/video_player.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../widgets/youtube_video_card.dart';

class PlayVideo extends StatelessWidget {
  const PlayVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildVideoWidget(),
          _buildVideoInfo(),
          _buildCommentsWidget(context: context),
          _buildRelatedVideos(),
        ],
      ),
    );
  }

  Widget _buildVideoWidget() {
    return const SizedBox(
      height: kToolbarHeight * 3,
      child: VideoPlayerWidget(
        url:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Label(
            text: UIConst.placeholderText,
            style: Styles.mediumText(fontWeight: FontWeight.w500),
            maxLines: 2,
          ),
          const Sizer(),
          Row(
            children: [
              const ProfileImage(accountId: 0),
              const Sizer(),
              Label(text: 'Mr Beast', style: Styles.mediumText()),
              const Spacer(),
              AppButton(
                  height: kToolbarHeight * .5,
                  label: 'Subscribe',
                  padding: 10,
                  onPressed: () {}),
            ],
          ),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * .5,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildActionItem(
                    label: 'Like', icon: Icons.thumb_up_outlined, onTap: () {}),
                _buildActionItem(
                    label: 'Dislike',
                    icon: Icons.thumb_down_outlined,
                    onTap: () {}),
                _buildActionItem(
                    label: 'Share', icon: Icons.share, onTap: () {}),
                _buildActionItem(
                    label: 'Save', icon: Icons.bookmark_outline, onTap: () {}),
                _buildActionItem(
                    label: 'Report', icon: Icons.flag_outlined, onTap: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionItem(
      {required String label,
      required IconData icon,
      required Function onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.LIGHT_GRAY_COLOR,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const Sizer(
            width: 5,
          ),
          Label(text: label, style: Styles.mediumText()),
        ],
      ),
    );
  }

  Widget _buildCommentsWidget({required BuildContext context}) {
    return InkWell(
      onTap: () {
        bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: ListView.separated(
                // itemBuilder: (context, index) => CommentCard(),
                itemBuilder: (context, index) => Container(),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: 10));
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.GREY_LIGHT_COLOR,
          borderRadius: BorderRadius.circular(10),
        ),
        // child: CommentCard(),
        child: Container(),
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const YoutubeVideoCard(),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 10);
  }
}
