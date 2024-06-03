import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/functions/helper/randome_color.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class CompetitionView extends StatelessWidget {
  const CompetitionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: ListView(children: [
        winnersBanner(context: context),
        competionBanner(),
      ]),
    );
  }

  Widget winnersBanner({required BuildContext context}) {
    return InkWell(
      onTap: () {
        context.push(Routes.WINNERS);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 5,
              spreadRadius: 5,
              color: AppColors.GRAY_LIGHT_COLOR3)
        ]),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.crown,
              color: AppColors.ACCENT_COLOR,
              size: 30,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: 'Winner Champions!',
                    style: Styles.mediumText(fontWeight: FontWeight.bold)),
                Label(
                    text:
                        'You can be one of the winners, continue using 49Hub App!',
                    style: Styles.mediumText(color: Colors.grey))
              ],
            )),
            const Sizer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget competionBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 5, spreadRadius: 5, color: AppColors.GRAY_LIGHT_COLOR3)
      ]),
      child: Column(
        children: [
          Label(text: '49Hub Competition', style: Styles.headerText()),
          timeFrame(),
          GridView.builder(
              itemCount: 12,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .7, crossAxisCount: 4),
              itemBuilder: (context, insdex) {
                return compeitionCounter(
                    title: 'Special Ads',
                    description: UIConst.placeholderText,
                    subTitle: 'Slef-Earn',
                    target: 10,
                    context: context,
                    value: 3);
              }),
        ],
      ),
    );
  }

  Widget timeFrame() {
    return Container(
      height: kToolbarHeight * .6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.PRIMARY_COLOR),
      ),
      child: Row(
        children: [
          timeFrameItem(title: 'Last Year'),
          timeFrameItem(
            title: 'Last Month',
          ),
          timeFrameItem(title: '7 days', isSelected: true),
        ],
      ),
    );
  }

  Widget timeFrameItem({bool isSelected = false, required String title}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? AppColors.PRIMARY_COLOR : Colors.white),
        child: Center(
          child: Label(
              text: title,
              style: Styles.mediumText(
                  color: isSelected ? Colors.white : AppColors.PRIMARY_COLOR)),
        ),
      ),
    );
  }

  Widget compeitionCounter({
    required String title,
    required String subTitle,
    required String description,
    required int target,
    required int value,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        bottomSheet(
            context: context,
            widget: Column(
              children: [
                Expanded(
                    child:
                        Label(text: description, style: Styles.mediumText())),
                ElevatedAppButton(
                    label: 'Join Competition',
                    onPressed: () => context.go(Routes.HOME))
              ],
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: kToolbarHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      value: value / target,
                      strokeWidth: 10,
                      backgroundColor: getRandomColor().withAlpha(50),
                      color: getRandomColor(),
                    ),
                  ),
                  Positioned.fill(
                      child: Center(
                          child: RichText(
                              text: TextSpan(children: [
                    TextSpan(text: '30 ', style: Styles.mediumText()),
                    const WidgetSpan(
                        child: Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.green,
                      size: 14,
                    ))
                  ])))),
                ],
              ),
            ),
            const Sizer(),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '$subTitle ',
                  style: Styles.mediumText(color: Colors.grey)),
              const WidgetSpan(
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 12,
                  color: AppColors.DARK_GRAY_COLOR,
                ),
              ),
            ])),
            Label(
                text: title,
                style: Styles.mediumText(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
