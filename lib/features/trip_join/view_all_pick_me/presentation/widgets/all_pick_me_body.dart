import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_builder.dart';

class AllPickMeBody extends StatelessWidget {
  const AllPickMeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5.h),
      child: const AllPickMeBuilder(),
    );
  }
}
