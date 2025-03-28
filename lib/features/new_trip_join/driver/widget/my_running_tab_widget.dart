import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../res/style/app_colors.dart';
import '../screen/running_and_past_trips_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyRunningTabWidget extends StatefulWidget {
  final String? clientNumberEn;
  final String? clientNumberAr;
  final void Function()? onPressed;

  final List<String> content;
  const MyRunningTabWidget(
      {super.key,
      required this.content,
      this.clientNumberEn,
      this.clientNumberAr,
      this.onPressed});

  @override
  State<MyRunningTabWidget> createState() => _MyRunningTabWidgetState();
}

class _MyRunningTabWidgetState extends State<MyRunningTabWidget> {
  final TextEditingController otpController =
      TextEditingController(); // كنترولر مشترك بين الحقول
  @override
  void dispose() {
    otpController.dispose(); // تأكد من التخلص من الكنترولر
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
                      // العنوان والمعلومات
                      Row(
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 65.h,
                              width: 170.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.PRIMARY_COLOR,
                              ),
                              child: Center(
                                child: Text(
                                  context.isArabic
                                      ? widget.clientNumberAr ?? ""
                                      : widget.clientNumberEn ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 65.h,
                              width: 170.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.PRIMARY_COLOR,
                              ),
                              child: Center(
                                child: Text(
                                  context.isArabic
                                      ? " افتح خرائط جوجل"
                                      : "Open Google Map",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: const BorderSide(
                                color: Colors.black, width: 1.5),
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  void _showOtpBottomSheet(BuildContext context) {
    final FocusNode otpFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // يجعل البوتن شيت يظهر بحجم مناسب للكيبورد
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(otpFocusNode);
        });

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                16, // يجعل المساحة ديناميكية مع الكيبورد
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
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
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                focusNode: otpFocusNode,
                keyboardType: TextInputType.number,
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                controller: otpController, // نفس الكنترولر المستخدم فوق
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: AppColors.PRIMARY_COLOR,
                  inactiveColor: AppColors.GREYBG,
                  selectedColor: AppColors.PRIMARY_COLOR,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: false,
                onCompleted: (value) {
                  Navigator.pop(context);
                },
                onChanged: (value) {
                  if (!mounted) return;
                  Future.microtask(() {
                    if (mounted) {
                      setState(() {}); // تأكيد التحديث
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  child: Center(
                    child: Text(
                      context.isArabic ? " تم" : "Done",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 36.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
