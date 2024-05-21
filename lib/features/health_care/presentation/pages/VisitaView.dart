import 'package:flutter/material.dart';
import 'customer_view/CustomerVisitaView.dart';
import 'doctor_view/Doctor_view.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';

class VisitaView extends StatelessWidget {
  const VisitaView({super.key});

  final bool isDoctor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 1,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      body: isDoctor ? const DoctorView() : const VisitaCustomerView(),
    );
  }
}
