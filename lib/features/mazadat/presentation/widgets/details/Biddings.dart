import 'package:flutter/material.dart';
import '../../../../../common/functions/helper/randome_color.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../res/style/app_colors.dart';

class Biddings extends StatelessWidget {
  const Biddings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: 'Biddings',
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildBiddingItem();
          }),
    );
  }

  Widget _buildBiddingItem() {
    return Dismissible(
      key: Key(getRandomColor().toString()),
      background: Container(
        decoration: const BoxDecoration(color: Colors.green),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label(
                text: 'Accept', style: Styles.headerText(color: Colors.white)),
          ],
        ),
      ),
      onDismissed: (v) {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextAppButton(label: 'Moses Bliake', onPressed: () {}),
                Label(
                    text: '10h ago',
                    style: Styles.mediumText(color: Colors.grey))
              ],
            )),
            const Sizer(),
            Label(
                text: '320.32 \$',
                style: Styles.headerText(color: AppColors.PRIMARY_COLOR))
          ],
        ),
      ),
    );
  }
}
