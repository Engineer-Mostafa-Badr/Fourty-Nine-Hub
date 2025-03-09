import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../res/assets/assets.dart';
import '../../widgets/font_manager.dart';
class EditPriceWidget extends StatefulWidget {
  const EditPriceWidget({super.key});

  @override
  State<EditPriceWidget> createState() => _EditPriceWidgetState();
}

int price = 79;

class _EditPriceWidgetState extends State<EditPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.acceptAnothePrice.localize,
            style: const TextStyle(
                fontSize: FontSize.s18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _fareButton("-3", () {
                if (price > 3) {
                  price = price - 3;
                  setState(() {});
                }
              }),
              Column(
                children: [
                   Text(
                    LocaleKeys.offerPrice.tr(),
                    style: const TextStyle(
                        fontSize: FontSize.s14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${LocaleKeys.egp.tr()} $price",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              _fareButton("+3", () {
                price = price + 3;
                setState(() {});
              }),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.buttonDialog,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              LocaleKeys.raiseFare.localize,
              style: const TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Align(alignment: AlignmentDirectional.bottomStart,
            child: Text(LocaleKeys.Payment.localize,
                style: const TextStyle(
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff494949))),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(Assets.cash, width: 10, height: 10),
              const SizedBox(width: 8),
              Text(
                '${LocaleKeys.egp.tr()} $price ${LocaleKeys.cash.tr()}',
                style: const TextStyle(
                    fontSize: FontSize.s12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                LocaleKeys.yourCurrentRide.localize,
                style: const TextStyle(
                    color: Color(0xff494949),
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _locationRow("Tariaq Bedon Esm", Colors.blue, true),
          const SizedBox(height: 15),
          _locationRow("Open Air Mall - Madinaty", Colors.green, false),
          const SizedBox(height: 25),
          AppButton(
            backColor: AppColors.PRIMARY_COLOR,
            label: LocaleKeys.sendOffer.localize,
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _fareButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY_COLOR,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontSize: FontSize.s16)),
    );
  }

  Widget _locationRow(String location, Color color, bool isFrom) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
              border: Border.all(color: color, width: 4)),
        ),
        const SizedBox(width: 8),
        Text(location,
            style: isFrom
                ? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                : const TextStyle(fontWeight: FontWeight.w300)),
      ],
    );
  }
}
