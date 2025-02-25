import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';

class OptionsBottomsheetWidget extends StatefulWidget {
  const OptionsBottomsheetWidget({super.key});

  @override
  State<OptionsBottomsheetWidget> createState() =>
      _OptionsBottomsheetWidgetState();
}

class _OptionsBottomsheetWidgetState extends State<OptionsBottomsheetWidget> {
  bool isComfort = false;
  bool isNonSmoker = false;
  bool isAutoAccept = false;
  bool isRecord = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        switchWidget(
          text: LocaleKeys.comfort.tr(),
          valuee: isComfort,
          onChanged: (value) {
            setState(() {
              isComfort = value;
            });
          },
        ),
        switchWidget(
          text: LocaleKeys.noSmoker.tr(),
          valuee: isNonSmoker,
          onChanged: (value) {
            setState(() {
              isNonSmoker = value;
            });
          },
        ),
        switchWidget(
          text: LocaleKeys.autoAccept.tr(),
          valuee: isAutoAccept,
          onChanged: (value) {
            setState(() {
              isAutoAccept = value;
            });
          },
        ),
        switchWidget(
          text: LocaleKeys.record.tr(),
          valuee: isRecord,
          onChanged: (value) {
            setState(() {
              isRecord = value;
            });
          },
        ),
         const SizedBox(height: 15),
          AppButton(
              width: double.infinity,
              label: LocaleKeys.done.tr(),
              onPressed: () {},
              backColor: AppColors.PRIMARY_COLOR),
      ],
    );
  }

  Widget switchWidget(
      {required String? text,
      required bool? valuee,
      Function(bool)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text ?? '',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: valuee ?? false,
              activeColor: AppColors.PRIMARY_COLOR,
              inactiveThumbColor: AppColors.PRIMARY_COLOR,
              trackOutlineColor: WidgetStateProperty.all<Color>(
                AppColors.PRIMARY_COLOR,
              ),
              activeTrackColor: const Color(0xff19D176),
              inactiveTrackColor: AppColors.whiteColor,
              onChanged: onChanged ??
                  (value) {
                    setState(() {
                      valuee = value;
                    });
                  },
            ),
          ),
        ],
      ),
    );
  }
}
