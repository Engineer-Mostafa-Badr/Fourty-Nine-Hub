import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../res/style/styles.dart';
import '../../domain/entities/gift_competitions_entity.dart';
import 'competition_header_item.dart';
import 'competition_section.dart';

class CompetitionsPopUpItems extends StatelessWidget {
  const CompetitionsPopUpItems({
    super.key,
    required this.competitions,
    required this.luckyWheel,
  });

  final List<GiftCompetitionEntity> competitions;
  final WheelWalletEntity luckyWheel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.sizeOf(context).height * 0.85,
      padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.symmetric(vertical: 55, horizontal: 22),
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: competitions.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CompetitionHeaderItem(
                    title: LocaleKeys.luckyWheel.localize,
                    value: FormatNumbers()
                        .formatNumber(
                          luckyWheel.amount,
                          useArabicNumerals: context.isArabic,
                        )
                        .toString(),
                    svgPath: context.isDarkMode
                        ? Assets.luckyWheelIconDark
                        : Assets.luckyWheelIcon,
                  );
                }
                final competitionIndex = index - 1;
                return CompetitionHeaderItem(
                  title: context.isArabic
                      ? competitions[competitionIndex].nameAr!
                      : competitions[competitionIndex].nameEn!,
                  value: FormatNumbers()
                      .formatNumber(
                        competitions[competitionIndex].countOfRequest! *
                            competitions[competitionIndex].pricePerRequest!,
                        useArabicNumerals: context.isArabic,
                      )
                      .toString(),
                  svgPath: context.isDarkMode
                      ? competitionIconsDark[
                              competitions[competitionIndex].id] ??
                          ''
                      : competitionIcons[competitions[competitionIndex].id] ??
                          '',
                );
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomButtonWalletAndGiftAndCashback(
            title: LocaleKeys.close.localize,
            onPressed: () {
      ManageVibration.vibrate();
              Navigator.pop(context);
            },
            status: true,
            textStyle: Styles.headerText(fontWeight: FontWeight.w500),
            activeColor: context.isDarkMode
                ? const Color(0xff333333)
                : const Color(0xffD9D9D9),
          ),
        ],
      ),
    );
  }
}
