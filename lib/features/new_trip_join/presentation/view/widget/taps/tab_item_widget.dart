import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';

import '../../../../../../helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TabItemWidget extends StatelessWidget {
  final String text;
  final String icon;
  final int index;
  final bool isSelected;
  final TabController tabController;
  final void Function() onTap;
  final void Function() onShowHint;

  const TabItemWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.index,
    required this.isSelected,
    required this.tabController,
    required this.onTap,
    required this.onShowHint,
  });

  @override
  Widget build(BuildContext context) {
    print("Tap selected $isSelected");
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
        builder: (context, state) {
      print("state.tapIndex ${state.tapIndex}");
      return GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          onTap();
          print("objectIndex $index");
          if (index == 1)
            context.read<CaptainShareCubit>().loadInitialData(context);
          if (index == 0)
            context.read<CaptainShareCubit>().loadInitialAvailableData(context);
          if (index == 2)
            context.read<CaptainShareCubit>().loadInitialRunningData(context);
          if (index == 3)
            context.read<CaptainShareCubit>().loadInitialExpiredData(context);
          tabController.animateTo(index);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              //   padding: EdgeInsets.symmetric(horizontal: 30.w),
              width: 140.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: isSelected ? Color(0XFFF88B92) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3))
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.black
                      : const Color(
                          0xff727272,
                        ),
                ),
              ),
            ),
            Positioned(
              top: -14,
              right: -6,
              child: GestureDetector(
                onTap: onShowHint,
                child: SvgPicture.asset(icon),
              ),
            ),
          ],
        ),
      );
    });
  }
}