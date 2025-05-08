import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class BuildDriverOtpSheet extends StatefulWidget {
  const BuildDriverOtpSheet({super.key, required this.onPressed});
  final Function(String) onPressed;

  @override
  State<BuildDriverOtpSheet> createState() => _BuildDriverOtpSheetState();
}

class _BuildDriverOtpSheetState extends State<BuildDriverOtpSheet> {
  final TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      minChildSize: 0.2,
      maxChildSize: 0.80,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ActionButtonsWidget(
                      driverImageUrl: '',
                      driverRating: 12.2,
                      driverName: 'Driver Name',
                      onContactDriver: () {
                        context.push(Routes.ratingDriverScreen);
                      },
                      onSafety: () {
                        context.push(Routes.ratingClientScreen);
                      },
                      is_show_message: true,
                      onMessage: () {
                        context.push(Routes.completeRideScreen);
                      },
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
                        context.isArabic ? "تقرير العميل" : "Report Client",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        context.isArabic ? "رحلتك الحالية" : "Your Current Ride",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const LocationInfoWidget(
                      from: 'أول العاشر من رمضان',
                      to: 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      context.isArabic ? "أدخل رمز التحقيق" : "Enter OTP Code",
                      style: const TextStyle(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    PinCodeTextField(
                      // onTap: () => _showOtpBottomSheet(context),
                      // readOnly: true,
                      appContext: context,
                      length: 6,
                      controller: otpController,
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
                      animationDuration:
                      const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: false,
                      onCompleted: (value) {
                        widget.onPressed(otpController.text);
                      },
                      onChanged: (value) {},
                      validator: (v){
                        if(v?.isEmpty??false){
                          return context.isArabic?'من فضلك ادخل رمز التحقيق':'Please enter OTP';
                        }
                        return '';
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClickableWidget(
                            onTap: (){
                              if(formKey.currentState!.validate()){
                                widget.onPressed(otpController.text);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.SECONDARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.SECONDARY_COLOR)
                              ),
                              child: Text(
                                context.isArabic ? "بدء" : "Start",
                                style: const TextStyle(
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.black54),
                            SizedBox(width: 5),
                            Text(
                              "Travel time: ~14 min. Distance: 6.58 Km.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        LocaleKeys.cancelTheRide.localize,
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
