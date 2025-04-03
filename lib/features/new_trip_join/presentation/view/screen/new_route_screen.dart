import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../widget/alert_text_widget.dart';
import '../widget/premium_and_request_widget.dart';
import '../widget/price_and_seat_widget.dart';
import '../widget/switch_widget.dart';
import '../widget/welcome_text_widget.dart';

class NewRouteScreen extends StatefulWidget {
  const NewRouteScreen({super.key});

  @override
  State<NewRouteScreen> createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends State<NewRouteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: HomeAppbar(
        key: _scaffoldKey,
        isWithBackArrow: false,
        language: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // The menu icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const NewRouteBody(),
    );
  }
}

class NewRouteBody extends StatefulWidget {
  const NewRouteBody({super.key});

  @override
  _NewRouteBodyState createState() => _NewRouteBodyState();
}

class _NewRouteBodyState extends State<NewRouteBody> {
  bool isComfort = false;
  bool isLady = false;
  bool isLadyDriver = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //     const NewRouteTextWidget(),
          SizedBox(height: 10.h),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: WelcomeTextWidget(),
          ),
          const SizedBox(height: 350),
          const PriceAndSeatWidget(),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SwitchWidget(
                    title: LocaleKeys.comfort.localize,
                    value: isComfort,
                    onChanged: (val) {
                      setState(() => isComfort = val);
                    }),
                SwitchWidget(
                    title: LocaleKeys.lady.localize,
                    value: isLady,
                    onChanged: (val) {
                      setState(() => isLady = val);
                    }),
                SwitchWidget(
                    title: LocaleKeys.ladyDriver.localize,
                    value: isLadyDriver,
                    onChanged: (val) {
                      setState(() => isLadyDriver = val);
                    }),
              ],
            ),
          ),
          if (isLadyDriver)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                context.isArabic
                    ? "ستجد عددًا أقل من السائقين إذا قمت بتحديد هذا الخيار"
                    : 'You will find fewer drivers if you select this option!',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => showPaymentAlert(context),
                      child: Text(
                        LocaleKeys.paymentOption.localize,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () => showPaymentAlert(context),
                      child: SvgPicture.asset(Assets.ideaIcon),
                    ),
                  ],
                ),
                SvgPicture.asset(Assets.visaIcon, width: 40),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          const PremiumAndRequestWidget(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  void showPaymentAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // زوايا مدورة
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      context.isArabic ? 'تحذير' : 'Alert!',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AlertTextWidget(
                    text: context.isArabic
                        ? "الدفع مقدمًا وشحن محفظتك."
                        : "Payment in advance, charge your wallet.",
                  ),
                  AlertTextWidget(
                      text: context.isArabic
                          ? "سيتم الاحتفاظ بالمال حتى انتهاء الرحلة."
                          : "Money will be holding till the ride ends."),
                  AlertTextWidget(
                    text: context.isArabic
                        ? "لا يوجد أموال للكابتن."
                        : "No cash for the captain.",
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        LocaleKeys.cancel.localize,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
