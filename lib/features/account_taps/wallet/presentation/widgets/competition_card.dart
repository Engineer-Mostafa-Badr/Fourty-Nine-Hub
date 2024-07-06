import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competition_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class CompetitionCard extends StatelessWidget {
  final CompetitionEntity item;
  final Function(BuildContext context) onTap;
  const CompetitionCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: .5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: item.name,
                      style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                    Label(
                      text: item.value.toString(),
                    ),
                  ],
                )),
                SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: item.value / item.target,
                          strokeWidth: 10,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                      Positioned.fill(
                          child: Center(
                        child: Label(text: item.value.toString()),
                      ))
                    ],
                  ),
                )
              ],
            ),
            const Sizer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                const Sizer(),
                Expanded(
                    child: Label(
                  text: 'Minimum 1500 EGP for personal transaction',
                  style: Styles.mediumText(color: Colors.grey),
                )),
              ],
            ),
            const Sizer(),
            AppButton(
                label: 'Request Withdrawel',
                backColor: Colors.red.withOpacity(.5),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
