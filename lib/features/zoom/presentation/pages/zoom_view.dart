import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/signal_service.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ZoomView extends StatelessWidget {
  ZoomView({super.key});

  // signalling server url
  final String websocketUrl = "http://localhost:5050";

  // generate callerID of local user
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');

  @override
  Widget build(BuildContext context) {
    // init signalling service
    SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );
    return Scaffold(
      backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 2,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(
        changeView: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1, crossAxisCount: 3),
        children: [
          _buildMeetingItem(
              color: AppColors.ACCENT_COLOR,
              label: 'New Meeting',
              icon: Icons.video_call,
              onTap: () =>
                  context.push(Routes.JOINSCREEN, extra: selfCallerID)),
          _buildMeetingItem(
              color: AppColors.PRIMARY_COLOR,
              label: 'Join',
              icon: Icons.add_box_rounded,
              onTap: () {}),
          _buildMeetingItem(
              color: AppColors.PRIMARY_COLOR,
              label: 'Schedule',
              icon: Icons.date_range_outlined,
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(
      {required Color color,
      required String label,
      required IconData icon,
      required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: kToolbarHeight,
            width: kToolbarHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
          const Sizer(),
          Label(text: label, style: Styles.mediumText())
        ],
      ),
    );
  }
}
