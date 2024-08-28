import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/strings/labels.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';

class Winners extends StatelessWidget {
  const Winners({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const BackAppBar(
        centerTitle: false,
        label: Labels.winners,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: .6),
            itemBuilder: (context, index) {
              return winnerCard(isWinner: true);
            }),
      ),
    );
  }

  Widget winnerCard({bool isWinner = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.star,
              size: 14,
              color: AppColors.ACCENT_COLOR,
            ),
            Column(
              children: [
                Icon(
                  FontAwesomeIcons.crown,
                  color: AppColors.ACCENT_COLOR,
                ),
                Sizer(),
              ],
            ),
            Icon(
              Icons.star,
              size: 14,
              color: AppColors.ACCENT_COLOR,
            ),
          ],
        ),
        CircleAvatar(
          radius: isWinner ? 42 : 35,
          backgroundColor:
              isWinner ? AppColors.ACCENT_COLOR : AppColors.PRIMARY_COLOR,
          child: CircleAvatar(
            radius: isWinner ? 40 : 33,
            backgroundColor: Colors.white,
            backgroundImage: const NetworkImage(UIConst.profilePlaceHolder),
          ),
        ),
        const Sizer(),
        Label(
            text: 'Moaz Mohamed',
            style: Styles.mediumText(fontWeight: FontWeight.w500)),
        Label(
            text: 'Friends request',
            style: Styles.smallText()),
        Label(text: '5000', style: Styles.mediumText()),
      ],
    );
  }
}
