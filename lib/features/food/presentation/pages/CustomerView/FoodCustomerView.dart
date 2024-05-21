import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../widgets/customer/offer_card.dart';
import '../../widgets/customer/restaurant_card.dart';

class FoodCustomerView extends StatelessWidget {
  const FoodCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildOffersWidget(),
            Label(text: 'Restaurants you know', style: Styles.headerText()),
            const Sizer(),
            _buildHorizontalRestaurants(),
            const Sizer(),
            Label(text: 'All Restaurants', style: Styles.headerText()),
            const Sizer(),
            _buildVerticalRestaurants()
          ],
        ),
      ),
    );
  }

  Widget _buildOffersWidget() {
    return SizedBox(
        height: kToolbarHeight * 2,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const FoodOfferCard(),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 10));
  }

  Widget _buildHorizontalRestaurants() {
    return SizedBox(
        height: kToolbarHeight * 3,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const RestaurantCard(),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 10));
  }

  Widget _buildVerticalRestaurants() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const RestaurantCard(
              isVert: false,
            ),
        separatorBuilder: (context, index) => const Sizer(),
        itemCount: 10);
  }
}
