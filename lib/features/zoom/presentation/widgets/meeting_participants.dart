import 'package:flutter/material.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../res/style/app_colors.dart';

class MeetingParticipants extends StatelessWidget {
  const MeetingParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Meeting Participants',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (context, index) => _buildParticipantItem(),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 4),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton(padding: 10, label: 'Invite', onPressed: () {}),
          AppButton(padding: 10, label: 'Show All', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildParticipantItem() {
    return Row(
      children: [
        const SquareImage(
          source: NetworkImage(UIConst.profilePlaceHolder),
          height: kToolbarHeight * .5,
          width: kToolbarHeight * .5,
        ),
        const Sizer(),
        Label(text: 'Farouk Shahin', style: Styles.mediumText()),
        const Spacer(),
        const Icon(
          Icons.mic_off,
          color: AppColors.SECONDARY_COLOR,
        )
      ],
    );
  }
}
