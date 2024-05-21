import 'package:flutter/material.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';

import 'Biddings.dart';

class DetailsCounterWidget extends StatelessWidget {
  const DetailsCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(100),
            bottomRight: Radius.circular(100),
          )),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Label(
                      text: 'Highest bid',
                      style: Styles.mediumText(color: Colors.grey)),
                  Label(
                      text: '580 \$',
                      style: Styles.headerText(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(UIConst.profilePlaceHolder),
                      ),
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(UIConst.profilePlaceHolder),
                      ),
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(UIConst.profilePlaceHolder),
                      ),
                      TextAppButton(
                          label: '21 bid',
                          onPressed: () {
                            bottomSheet(
                                context: context, widget: const Biddings());
                          })
                    ],
                  )
                ],
              )),
          SizedBox(
            height: kTextTabBarHeight * 2,
            width: kTextTabBarHeight * 2,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: .8,
                  ),
                ),
                Positioned.fill(
                    child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                          text: 'Ends At',
                          style: Styles.mediumText(color: Colors.grey)),
                      Label(text: '01h 23m', style: Styles.headerText())
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
