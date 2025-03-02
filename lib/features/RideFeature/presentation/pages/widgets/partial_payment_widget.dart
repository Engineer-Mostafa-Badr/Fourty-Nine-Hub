import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';

class PartialPaymentWidget extends StatefulWidget {
  const PartialPaymentWidget({super.key});

  @override
  State<PartialPaymentWidget> createState() => _PartialPaymentWidgetState();
}

class _PartialPaymentWidgetState extends State<PartialPaymentWidget> {
  TextEditingController cashController = TextEditingController();
  TextEditingController visaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(spacing: 10,
        children: [
          _partialWidget(
              icon: 'assets/icons/cash.svg',
              text: 'cash'.tr(),
              controller: cashController),
          _partialWidget(
              icon: 'assets/icons/visa.svg',
              text: 'Visa'.tr(),
              controller: visaController),
          const SizedBox(height:20),
          AppButton(
              width: double.infinity,
              label: LocaleKeys.done.tr(),
              onPressed: () {},
              backColor: AppColors.PRIMARY_COLOR),
        ],
      ),
    );
  }

  Widget _partialWidget(
      {required String icon,
      required String text,
      required TextEditingController controller}) {
    return Row(
      spacing: 15,
      children: [
        Expanded(
          flex: 1,
          child: SvgPicture.asset(icon),
        ),
        Expanded(
          flex: 7,
          child: Text(text,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            width: 70,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.white,
                filled: true,
                enabledBorder: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(),
                disabledBorder: UnderlineInputBorder(),
                hintText: 'EGP',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
