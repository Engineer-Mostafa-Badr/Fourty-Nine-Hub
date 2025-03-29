import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../res/style/app_colors.dart';
import '../screen/running_and_past_trips_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'available_ride_mode_widget.dart';

class MyRunningTabWidget extends StatefulWidget {
  final String? clientNumberEn;
  final String? clientNumberAr;
  final void Function()? onPressed;
  final List<String> content;

  const MyRunningTabWidget({
    super.key,
    required this.content,
    this.clientNumberEn,
    this.clientNumberAr,
    this.onPressed,
  });

  @override
  State<MyRunningTabWidget> createState() => _MyRunningTabWidgetState();
}

class _MyRunningTabWidgetState extends State<MyRunningTabWidget> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.content.isEmpty
        ? _emptyMessage()
        : SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  requestType: context.isArabic ? 'عادي' : 'Regular',
                  cancelButton: false,
                  statusDriver: "Running",
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTripInfo(context),
                      const SizedBox(height: 5),
                      _buildActionButtons(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showOtpBottomSheet(context),
                              child: Text(
                                "Enter OTP Code",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            PinCodeTextField(
                              onTap: () => _showOtpBottomSheet(context),
                              readOnly: true,
                              appContext: context,
                              length: 6,
                              controller: otpController,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeColor: AppColors.PRIMARY_COLOR,
                                inactiveColor: Colors.grey,
                                selectedColor: AppColors.PRIMARY_COLOR,
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: false,
                              onCompleted: (value) {},
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      _buildReportButton(context),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget _buildTripInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SvgPicture.asset(Assets.circleGreen),
              const SizedBox(width: 5),
              const Text(
                "Giza, Egypt",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "1st Client  3 mins",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _customButton(
            context.isArabic
                ? widget.clientNumberAr ?? ""
                : widget.clientNumberEn ?? "",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _customButton(
            context.isArabic ? "افتح خرائط جوجل" : "Open Google Map",
          ),
        ),
      ],
    );
  }

  Widget _customButton(String text) {
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.PRIMARY_COLOR,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(color: Colors.black, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          context.isArabic ? "تقرير العميل" : "Report Client",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showOtpBottomSheet(BuildContext context) {
    final TextEditingController tempController = TextEditingController();
    final FocusNode otpFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            FocusScope.of(context).requestFocus(otpFocusNode);
          }
        });
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildOtpHeader(context),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    keyboardType: TextInputType.number,
                    focusNode: otpFocusNode,
                    appContext: context,
                    length: 6,
                    controller: tempController,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: AppColors.PRIMARY_COLOR,
                      inactiveColor: Colors.grey,
                      selectedColor: AppColors.PRIMARY_COLOR,
                    ),
                    onChanged: (value) {},
                  ),
                  _buildDoneButton(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOtpHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              "Enter OTP Code",
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              backgroundColor: const Color(0xffD9D9D9),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.PRIMARY_COLOR,
        ),
        child: Center(
          child: Text("تم",
              style: TextStyle(fontSize: 36.sp, color: Colors.white)),
        ),
      ),
    );
  }
}

Widget _emptyMessage() {
  return const Center(
    child: Text(
      'Your running trip right now.',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
