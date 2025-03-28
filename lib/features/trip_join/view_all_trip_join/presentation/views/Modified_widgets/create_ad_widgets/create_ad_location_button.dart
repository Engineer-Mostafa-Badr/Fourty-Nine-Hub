import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/find_location_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
      child: Container(
        height: 76.h,
        child: Stack(
          children: [
            Expanded(
              child: FormTextField(
                  height: 76.h,
                prefix: Icon(Icons.trip_origin, color: widget.iconColor, size: 20),
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
            ),
            Align(
              alignment: Alignment.topRight,
              child: FindLocationButton(
                title: LocaleKeys.searchFind.localize,
                onTap: () {},
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
