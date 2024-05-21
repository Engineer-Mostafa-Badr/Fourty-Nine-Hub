import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../widgets/meeting_participants.dart';

class MeetingRoom extends StatelessWidget {
  const MeetingRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          AppButton(
              padding: 10,
              label: 'End',
              onPressed: () {
                bottomSheet(
                    context: context,
                    isScrollControlled: true,
                    widget: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            AppButton(
                                padding: 10,
                                label: 'Cancel',
                                backColor: AppColors.LIGHT_GRAY_COLOR,
                                onPressed: () => context.pop())
                          ],
                        ),
                        const Sizer(),
                        AppButton(
                            label: 'Leave Meeting',
                            backColor: AppColors.DARK_GRAY_COLOR,
                            onPressed: () {}),
                        const Sizer(),
                        AppButton(
                            label: 'End Meeting for all', onPressed: () {})
                      ],
                    ));
              }),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildActions(context: context),
    );
  }

  Widget _buildBody() {
    return const Center(
      child: SquareImage(
        height: kToolbarHeight,
        width: kToolbarHeight,
        source: NetworkImage(UIConst.profilePlaceHolder),
      ),
    );
  }

  Widget _buildActions({required BuildContext context}) {
    return SizedBox(
      height: kToolbarHeight * 1.5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildActionItem(icon: Icons.mic, label: 'Audio', onTap: () {}),
          _buildActionItem(
              icon: Icons.video_camera_front, label: 'Video', onTap: () {}),
          _buildActionItem(
              icon: Icons.group,
              label: 'Participants',
              onTap: () {
                bottomSheet(
                    isScrollControlled: true,
                    context: context,
                    widget: const MeetingParticipants());
              }),
          _buildActionItem(
              icon: Icons.chat,
              label: 'Chat',
              onTap: () => context.push(Routes.CHATROOM)),
          _buildActionItem(
              icon: Icons.screen_search_desktop_outlined,
              label: 'Share screen',
              onTap: () {}),
          _buildActionItem(
              icon: Icons.security, label: 'Security', onTap: () {}),
          _buildActionItem(
              icon: Icons.settings, label: 'Settings', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      {required IconData icon,
      required String label,
      required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            Label(text: label, style: Styles.mediumText(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
