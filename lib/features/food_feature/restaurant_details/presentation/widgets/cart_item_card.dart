import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/entities/selected_meal_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class CartItemCard extends StatelessWidget {
  final Function(SelectedMealEntity) onEdit;
  final Function onRemove;
  final SelectedMealEntity meal;
  const CartItemCard(
      {super.key,
      required this.onRemove,
      required this.onEdit,
      required this.meal});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SquareImage(
            height: kToolbarHeight,
            width: kToolbarHeight,
            radius: 10,
            source: NetworkImage(meal.meal.picture?.mediaKey ?? "")),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: meal.meal.foodName ?? "",
                style: Styles.mediumText(fontWeight: FontWeight.w400),
              ),
              Label(
                  text: '${meal.meal.price} EGP',
                  style: Styles.mediumText(
                    color: AppColors.SECONDARY_COLOR,
                  )),
              RichText(
                  text: TextSpan(children: [
                ...meal.selectedVariations.map((e) {
                  return WidgetSpan(
                      child: BadgedLabel(
                          margin: 5,
                          color: AppColors.ACCENT_COLOR,
                          label:
                              '${e.variation.name} : ${e.selectedOption.name}'));
                }),
                ...meal.selectedAddOn.map((e) {
                  return WidgetSpan(
                      child: BadgedLabel(
                          margin: 5, color: Colors.green, label: e.name));
                })
              ])),
            ],
          ),
        ),
        Label(text: 'x ${meal.qty}'),
        const Sizer(),
        IconAppButton(
            icon: Icons.delete,
            isCircle: true,
            color: Colors.red,
            onPressed: () => onRemove()),
      ],
    );
  }
}
