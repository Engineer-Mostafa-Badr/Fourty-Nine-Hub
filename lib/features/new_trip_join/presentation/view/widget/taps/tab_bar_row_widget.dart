import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';

import '../../../../../../res/assets/assets.dart';
import 'tab_item_widget.dart';

class TabBarRowWidget extends StatelessWidget {
  final TabController tabController;
  final void Function(int index) onTap;
  const TabBarRowWidget({super.key, required this.tabController, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
      builder: (context,state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TabItemWidget(
                  onTap: ()=>onTap(0),
                  text: context.isArabic ? "رحلات \n متاحه" : "Available\nTrips",
                  icon: Assets.ideaIcon,
                  index: 0,
                  tabController: tabController, isSelected: state.tapIndex==0,),
            ),
            SizedBox(width: 28.w),
            Expanded(
              child: TabItemWidget(
                  onTap: ()=>onTap(1),
                  text: context.isArabic ? "حجوزاتي" : "My\nBookings",
                  icon: Assets.ideaIcon,
                  index: 1,
                  tabController: tabController, isSelected: state.tapIndex==1),
            ),
            SizedBox(width: 28.w),
            Expanded(
              child: TabItemWidget(
                  onTap: ()=>onTap(2),
                  text: context.isArabic ? "رحلات \nجارية " : "Running\nTrips",
                  icon: Assets.ideaIcon,
                  index: 2,
                  tabController: tabController, isSelected: state.tapIndex==2),
            ),
            SizedBox(width: 28.w),
            Expanded(
              child: TabItemWidget(
                  onTap: ()=>onTap(3),
                text: context.isArabic ? "رحلات \n منتهية " : "Expired\nTrips",
                icon: Assets.ideaIcon,
                index: 3,
                tabController: tabController,
                  isSelected: state.tapIndex==3
              ),
            ),
          ],
        );
      }
    );
  }
}
