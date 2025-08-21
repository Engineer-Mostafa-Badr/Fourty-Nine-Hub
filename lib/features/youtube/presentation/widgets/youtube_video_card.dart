import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../helpers/manage_vibration.dart';

class YoutubeVideoCard extends StatelessWidget {
  final bool isVertical;

  const YoutubeVideoCard({super.key, this.isVertical = true});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.PLAYVIDEO),
      child: isVertical
          ? _buildVerticalWidget(context: context)
          : _buildHorizontalWidget(context: context),
    );
  }

  Widget _buildVerticalWidget({required BuildContext context}) {
    return Column(
      children: [
        SizedBox(
          height: kToolbarHeight * 3,
          width: double.infinity,
          child: Stack(
            children: [
              const Positioned.fill(
                child: SquareImage(source: NetworkImage(UIConst.mrbeast)),
              ),
              Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Label(
                        text: '03:20',
                        style: Styles.mediumText(color: Colors.white)),
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const ProfileImage(
                accountId: 0,
                userId: '',
              ),
              const Sizer(),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                      text: 'Protect The Yacht, Keep It',
                      style: Styles.mediumText(fontWeight: FontWeight.w500)),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Mr Beast',
                        style: Styles.mediumText(color: Colors.grey)),
                    TextSpan(
                        text: '  .  ',
                        style: Styles.mediumText(color: Colors.grey)),
                    TextSpan(
                        text: '14M views',
                        style: Styles.mediumText(color: Colors.grey)),
                    TextSpan(
                        text: '  .  ',
                        style: Styles.mediumText(color: Colors.grey)),
                    TextSpan(
                        text: '6 years ago',
                        style: Styles.mediumText(color: Colors.grey)),
                  ]))
                ],
              )),
              IconAppButton(
                  icon: Icons.more_vert,
                  onPressed: () {
                    ManageVibration.vibrate();
                    bottomSheet(
                      context: context,
                      widget: const Column(
                        children: [],
                      ),
                    );
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalWidget({required BuildContext context}) {
    return const Row(
      children: [],
    );
  }
}
