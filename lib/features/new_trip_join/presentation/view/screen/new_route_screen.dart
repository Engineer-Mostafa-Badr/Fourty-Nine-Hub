import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/handle_cashback.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../widget/alert_text_widget.dart';
import '../widget/new_route_text_widget.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          key: _scaffoldKey,
          isWithBackArrow: false,
          language: true,
          leading: IconButton(
            icon: const Icon(Icons.menu), // The menu icon
            onPressed: () {
              HandleCashback.setCount('drawerCount', context);
              _scaffoldKey.currentState?.openDrawer(); // Open the drawer
            },
          ),
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
          const NewRouteTextWidget(),
          SizedBox(height: 20.h),
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
                    title: "Comfort",
                    value: isComfort,
                    onChanged: (val) {
                      setState(() => isComfort = val);
                    }),
                SwitchWidget(
                    title: "Lady",
                    value: isLady,
                    onChanged: (val) {
                      setState(() => isLady = val);
                    }),
                SwitchWidget(
                    title: "Lady Driver",
                    value: isLadyDriver,
                    onChanged: (val) {
                      setState(() => isLadyDriver = val);
                    }),
              ],
            ),
          ),
          if (isLadyDriver)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "You will find fewer drivers if you select this option!",
                style: TextStyle(
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
                      child: const Text(
                        "Payment Option",
                        style: TextStyle(
                          fontSize: 16,
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
                  const Center(
                    child: Text(
                      'Alert!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const AlertTextWidget(
                      text: "Payment in advance, charge your wallet."),
                  const AlertTextWidget(
                      text: "Payment in advance, charge your wallet."),
                  const AlertTextWidget(
                      text: "Payment in advance, charge your wallet."),
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
                      child: const Text(
                        "Close",
                        style: TextStyle(
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
