import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../core/utils/handle_cashback.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';
import '../../../trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import '../../presentation/view/screen/pick_me_info_screen.dart';

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
              "Join Now!",
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
            'Captain Share !',
            style: TextStyle(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          const SizedBox(height: 20),
          SvgPicture.asset(Assets.captainInfoIcon),
          const SizedBox(height: 40),
          const RowTextWidget(
            text: 'Save money & Book 1 seat.',
          ),
          SizedBox(height: 15.h),
          const RowTextWidget(
            text: 'Heading final destination.',
          ),
          SizedBox(height: 15.h),
          const RowTextWidget(
            text: 'Wait for others to share route seats with ',
          ),
        ],
      ),
    );
  }
}
