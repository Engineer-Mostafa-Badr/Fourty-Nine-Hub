import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class FoodOrderCard extends StatelessWidget {
  final FoodOrderEntity item;
  const FoodOrderCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.RESTAURANTDETAILS),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: .5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRestaurantInfoWidget(),
            const Sizer(),
            _buildAddressWidget(),
            Label(
              text: 'Meals',
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
            _buildMealsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsWidget() {
    return ListView.builder(
        itemCount: item.meals.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final meal = item.meals[index];
          return RichText(
              text: TextSpan(children: [
            TextSpan(
                text: meal.meal.name,
                style: Styles.mediumText(fontWeight: FontWeight.w600)),
            TextSpan(
                text: ' x ${meal.qty} \n',
                style: Styles.mediumText(fontWeight: FontWeight.w600)),
            ...meal.selectedVariations.map((e) {
              return WidgetSpan(
                  child: BadgedLabel(
                      margin: 5,
                      style: Styles.smallText(color: Colors.white),
                      label: '${e.variation.name} : ${e.selectedOption.name}'));
            }),
            ...meal.selectedAddOn.map((e) {
              return WidgetSpan(
                  child: BadgedLabel(
                      margin: 5,
                      style: Styles.smallText(color: Colors.white),
                      color: Colors.green,
                      label: '${e.name} : ${e.name}'));
            })
          ]));
        });
  }

  Widget _buildAddressWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: 'Address: ${item.address.address}'),
          Label(
              text: 'Name: ${item.address.firstName} ${item.address.lastName}'),
          Label(text: 'Phone: ${item.address.phone}'),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfoWidget() {
    return Row(
      children: [
        SquareImage(
            height: kToolbarHeight,
            width: kToolbarHeight,
            radius: 10,
            source: NetworkImage(item.restaurant.image.first)),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: item.restaurant.name,
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
            Label(
              text: item.restaurant.description,
              style: Styles.mediumText(color: Colors.grey),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.ACCENT_COLOR,
                ),
                const Sizer(),
                Label(
                    text: '${item.restaurant.rate} ',
                    style: Styles.mediumText(fontWeight: FontWeight.w500)),
                Label(
                    text: '(${item.restaurant.numberOfReviews}+)',
                    style: Styles.mediumText()),
              ],
            )
          ],
        ))
      ],
    );
  }
}
