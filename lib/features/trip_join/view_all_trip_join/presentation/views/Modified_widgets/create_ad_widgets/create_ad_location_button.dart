import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import 'find_location_button.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../helpers/manage_vibration.dart';

class StartTextFieldAndFindButton extends StatefulWidget {
  const StartTextFieldAndFindButton(
      {super.key, this.isTripJoin = false, required this.iconColor, required this.hint});
  final bool isTripJoin;
  final Color iconColor;
  final String hint;

  @override
  State<StartTextFieldAndFindButton> createState() =>
      _StartTextFieldAndFindButtonState();
}

class _StartTextFieldAndFindButtonState
    extends State<StartTextFieldAndFindButton> {
  late TextEditingController startingController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    startingController = TextEditingController();
  }

  @override
  void dispose() {
    startingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 76.h,
        child: Stack(
          children: [
            FormTextField(
                height: 76.h,
              prefix: Icon(Icons.trip_origin, color: widget.iconColor, size: 24),
                type: TextInputType.phone,
                style: Styles.mediumText(),
                constraints: const BoxConstraints(
                    maxHeight: 52, minHeight: 52),
                fillColor: AppColors.colorGreyLight,
                borderRadius: BorderRadius.circular(30.h),
                controller: startingController,
                hint: widget.hint,
                validator: (value) {
                  return null;
                }),
            Align(
              alignment:context.isArabic?Alignment.topLeft: Alignment.topRight,
              child: FindLocationButton(
                title: LocaleKeys.searchFind.localize,
                onTap: () {

      ManageVibration.vibrate();
                },
                height: double.infinity,
                width: 200.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

}