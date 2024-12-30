import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DriverLicenseCardRegisterRideWidget extends StatelessWidget {
  DriverLicenseCardRegisterRideWidget({super.key});
  TextEditingController pricingPerKmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 30)
                  ]
                ),
      child: Column(
        children: [
          Text(
            "رقم رخصة السائق",
            style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 40),
          ),
          Sizer(),
          DefaultTextFormField(
            isAuthentcation: true,
            hint: '',
            hintColor: AppColors.PRIMARY_COLOR,
            currentController: pricingPerKmController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return LocaleKeys.pricingPerKmIsRequired.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
