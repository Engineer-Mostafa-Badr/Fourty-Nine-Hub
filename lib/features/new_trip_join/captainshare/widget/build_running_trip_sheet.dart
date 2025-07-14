
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class BuildRunningTripSheet extends StatefulWidget {
  const BuildRunningTripSheet({super.key,required this.model});
  final RunningRouteEntity model;

  @override
  State<BuildRunningTripSheet> createState() => _BuildRunningTripSheetState();
}

class _BuildRunningTripSheetState extends State<BuildRunningTripSheet> {

  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    otpController.text = widget.model.otp.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        width: 160.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.black
                        ),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    context.isArabic ? "السائق في طريقه إليك." : "Driver on his way to you.",
                    style: const TextStyle(
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    context.isArabic ? "الدفع" : "Payment",
                    style: const TextStyle(
                      fontSize: FontSize.s25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.model.youPay}',
                        style: const TextStyle(
                          fontSize: FontSize.s25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10.h,
                      ),
                      Text(
                        context.isArabic ? "ج.م" : "EGP",
                        style: const TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  PinCodeTextField(
                    // onTap: () => _showOtpBottomSheet(context),
                    // readOnly: true,
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    enabled: false,
                    autoDismissKeyboard: true,
                    autoDisposeControllers: true,
                    autoUnfocus: true,

                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                      inactiveColor: Colors.grey,
                      selectedColor: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    animationDuration:
                    const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: false,
                    enablePinAutofill: false,
                    onCompleted: (value) {
                      // widget.onPressed(otpController.text);
                    },
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return context.isArabic?'يرجى إدخال رمز التحقيق المكون من 6 أرقام':'Please enter a 6-digit code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.PRIMARY_COLOR)
                    ),
                    child: Text(
                      context.isArabic ? "افتح خرائط جوجل" : "Open Google Map",
                      style: const TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.PRIMARY_COLOR)
                    ),
                    child: Text(
                      context.isArabic ? "الغاء" : "Cancel",
                      style: const TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
