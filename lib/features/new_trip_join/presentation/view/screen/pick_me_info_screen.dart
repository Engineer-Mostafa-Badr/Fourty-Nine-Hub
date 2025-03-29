import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../core/utils/handle_cashback.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';

class PickMeInfoScreen extends StatefulWidget {
  const PickMeInfoScreen({super.key});

  @override
  State<PickMeInfoScreen> createState() => _PickMeInfoScreenState();
}

class _PickMeInfoScreenState extends State<PickMeInfoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          context.push(Routes.pickMeInfoScreen);
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
              "Start Journey!",
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
          icon: const Icon(Icons.menu), // The menu icon
          onPressed: () {
            HandleCashback.setCount('drawerCount', context);
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
      ),
      body: const PickMeInfoInfoBody(),
    );
  }
}

class PickMeInfoInfoBody extends StatelessWidget {
  const PickMeInfoInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          const Text(
            'Pick me!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: 20.h),
          SvgPicture.asset(Assets.pickMeInfoIcon),
          SizedBox(height: 30.h),
          const RowTextWidget(text: "Don't have a car?!"),
          SizedBox(height: 15.h),
          const RowTextWidget(text: 'Tired from the expensive price.'),
          SizedBox(height: 15.h),
          const RowTextWidget(text: 'Advertise your daily repeat trip.'),
          SizedBox(height: 15.h),
          const RowTextWidget(text: 'Wait for car owners to contact you.'),
          SizedBox(height: 15.h),
          const RowTextWidget(text: 'Share your trip & save money.'),
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
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // توسيط كل العناصر
      children: [
        Flexible(
          child: Icon(
            Icons.circle,
            color: Colors.black,
            size: fontSize * 0.3, // حجم الأيقونة مناسب للنص
          ),
        ),
        SizedBox(width: 10.w),
        Center(
          // يضمن بقاء النص في المنتصف تمامًا
          child: Text(
            text,
            textAlign:
                TextAlign.center, // يجعل النص في المنتصف داخل الـ Expanded
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
