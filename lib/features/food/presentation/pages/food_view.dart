import 'package:flutter/material.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../core/localization/localization.dart';



class FoodView extends StatelessWidget {
  const FoodView({super.key});

  final bool isRestaurant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 1,
        index: 1,
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Text(tr(context).hello),
      //  body: isRestaurant ? const RestaurantView() : const FoodCustomerView(),
    );
  }
}
