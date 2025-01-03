import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DriverLicenseCardRegisterRideWidget extends StatefulWidget {
  DriverLicenseCardRegisterRideWidget({super.key, required this.title, this.onChanged});
  final String title;
  final Function(String value)? onChanged;

  @override
  State<DriverLicenseCardRegisterRideWidget> createState() => _DriverLicenseCardRegisterRideWidgetState();
}

class _DriverLicenseCardRegisterRideWidgetState extends State<DriverLicenseCardRegisterRideWidget> {
  TextEditingController pricingPerKmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.isDarkMode?AppColors.UNSELECTED_DARK_GRAY_COLOR: Colors.white,
          boxShadow: context.isDarkMode?[]: [BoxShadow(color: Colors.grey.shade400, blurRadius: 30)]
          ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 40),
          ),
          const Sizer(),
          DefaultTextFormField(
            onChanged: widget.onChanged,
            isAuthentcation: true,
            hint: '',
            hintColor: AppColors.PRIMARY_COLOR,
            currentController: pricingPerKmController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return LocaleKeys.thisFieldIsRequired.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
