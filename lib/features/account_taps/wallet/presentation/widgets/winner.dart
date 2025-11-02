import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class WinnersGridViewModel {
  final String image;
  final String name;
  final String? title;
  final String date;
  final String price;
  final String currencyAr;
  final String currencyEn;

  WinnersGridViewModel({
    required this.image,
    required this.name,
    this.title,
    required this.date,
    required this.price,
    required this.currencyAr,
    required this.currencyEn,
  });
}

class WinnersGridViewItem extends StatelessWidget {
  const WinnersGridViewItem({
    super.key,
    required this.winner,
  });
  final WinnersGridViewModel winner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? const Color(0xB3FFFFFF)
            : const Color(0xB3000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 18,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              ImageFromInternet(
                width: 70.25,
                height: 70.25,
                image: winner.image,
                isCircle: true,
                firstChar: winner.name[0].toUpperCase(),
                charPadding: 3,
              ),
              Positioned(
                top: -25,
                right: -2,
                child: SvgPicture.asset(
                  context.isDarkMode ? Assets.crownIconDark : Assets.crownIcon,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Label(
              text: winner.name,
              style: Styles.headerText(
                fontSize: 24,
                color:
                    context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
              ),
            ),
          ),
          // const SizedBox(height: 3),
          if (winner.title != null)
            Label(
              text: winner.title!,
              style: Styles.mediumText(
                fontSize: 20,
                color:
                    context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
              ),
            ),
          Label(
            text: formatDateInWinners(winner.date, context),
            style: Styles.mediumText(
              fontSize: 20,
              color:
                  context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
            ),
          ),
          Flexible(
            child: Label(
              text:
                  '${FormatNumbers().formatNumberByComma(winner.price, isArabic: context.isArabic)} ${context.isArabic ? winner.currencyAr : winner.currencyEn}',
              style: Styles.mediumText(
                fontSize: 20,
                color:
                    context.isDarkMode ? const Color(0xff0D0D0D) : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDateInWinners(String date, BuildContext context) {
    DateTime parsedDate = DateTime.parse(date);

    return context.locale == Locales.english
        ? DateFormat('d/M/yyyy', 'en').format(parsedDate)
        : DateFormat('yyyy/M/d', 'ar').format(parsedDate);
  }
}