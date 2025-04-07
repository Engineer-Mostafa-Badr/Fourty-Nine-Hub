import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../core/utils/handle_cashback.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';

class CaptainShareInfoScreen extends StatefulWidget {
  const CaptainShareInfoScreen({super.key});

  @override
  State<CaptainShareInfoScreen> createState() => _CaptainShareInfoScreenState();
}

class _CaptainShareInfoScreenState extends State<CaptainShareInfoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          context.push(Routes.captainShareScreen);
        },
        child: Container(
          width: 300.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: Center(
            child: Text(
              context.isArabic ? "انضم الآن !" : "Join Now!",
              style: TextStyle(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      appBar: HomeAppbar(
        isWithBackArrow: false,
        language: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            HandleCashback.setCount('drawerCount', context);
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: const CaptainShareInfoBody(),
    );
  }
}

class CaptainShareInfoBody extends StatelessWidget {
  const CaptainShareInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text(
            context.isArabic ? 'مشاركة كابتن !' : 'Captain Share !',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              color: context.isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.PRIMARY_COLOR,
            ),
          ),
          const SizedBox(height: 20),
          SvgPicture.asset(Assets.captainInfoIcon),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: RowTextWidget(
              text: context.isArabic
                  ? "وفر المال واحجز مقعدًا واحدًا."
                  : 'Save money & Book 1 seat.',
            ),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: RowTextWidget(
              text: context.isArabic
                  ? "متجه إلى الوجهة النهائية."
                  : 'Heading final destination.',
            ),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: RowTextWidget(
              text: context.isArabic
                  ? "انتظر حتى يشارك الآخرون مقاعد الطريق مع قائدك"
                  : "Wait for others to share route  seats with your captain",
            ),
          ),
        ],
      ),
    );
  }
}

class RowTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const RowTextWidget({
    super.key,
    required this.text,
    this.fontSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: fontSize * 0.19),
          child: Icon(
            Icons.circle,
            size: fontSize * 0.4,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w700,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
