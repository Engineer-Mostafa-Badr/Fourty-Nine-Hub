import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/functions/helper/randome_color.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/strings/labels.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../account_taps/wallet/domain/entities/competition_entity.dart';

class CompetitionView extends StatelessWidget {
  final List<CompetitionEntity> list;
  final Function(BuildContext context)? onCompetitionClicked;
  const CompetitionView(
      {super.key, required this.list, this.onCompetitionClicked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.appCompetitions,
      ),
      body: ListView(children: [
        // winnersBanner(context: context),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // timeFrame(),
          const Sizer(),
          GridView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .7, crossAxisCount: 4),
              itemBuilder: (context, index) {
                final item = list[index];
                return compeitionCounter(
                    title: item.name,
                    description: item.target.toString(),
                    subTitle: 'Slef-Earn',
                    target: item.target,
                    context: context,
                    value: item.value);
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
    required num target,
    required num value,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        if (onCompetitionClicked != null) {
          onCompetitionClicked!(context);
        }
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
                    TextSpan(text: '$value', style: Styles.mediumText()),
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
            Label(
                text: title,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Styles.mediumText(fontWeight: FontWeight.w600)),
            Label(
                text: 'Target: $target',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Styles.mediumText(
                    fontWeight: FontWeight.w600, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
