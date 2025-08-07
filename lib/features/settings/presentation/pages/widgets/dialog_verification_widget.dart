import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import 'custombutton.dart';
import '../../../../../res/style/styles.dart';

class DialogVerificationWidget extends StatelessWidget {
  const DialogVerificationWidget(
      {super.key, required this.okOnPressed, required this.cancelOnPressed});

  final Function() okOnPressed;
  final Function() cancelOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 6),
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: 'Failed!',
            style: Styles.headerText(
              fontWeight: FontWeight.w700,
              color: const Color(0xffF33D49),
            ),
          ),
          Label(
            text: 'Your answers are not correct!',
            style: Styles.mediumText(
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
            // textAlign: TextAlign.center,
          ),
          Label(
            text: 'You cant change your password!',
            style: Styles.mediumText(
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
            // textAlign: TextAlign.center,
          ),
          Label(
            text: 'Do you want to try again?',
            style: Styles.mediumText(
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
            // textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: okOnPressed,
                  text: LocaleKeys.ok.localize,
                  color: const Color(0xffF33D49),
                  textStyle: Styles.headerText(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 11,
              ),
              Expanded(
                child: CustomButton(
                  onPressed: cancelOnPressed,
                  text: LocaleKeys.cancel.localize,
                  color: const Color(0xffD9D9D9),
                  textStyle: Styles.headerText(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
