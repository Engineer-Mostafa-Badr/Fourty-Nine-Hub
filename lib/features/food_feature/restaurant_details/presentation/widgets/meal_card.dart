import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/selected_meal_model.dart';
import 'meal_details.dart';

class MealCard extends StatelessWidget {
  final MealModel item;
    final Function(SelectedMealModel) addToCart;
  const MealCard({super.key, required this.item, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => bottomSheet(
          context: context,
          isScrollControlled: true,
          widget: MealDetailsWidget(
            addToCart: addToCart,
            item: SelectedMealModel(
                qty: 1,
                price: item.price,
                meal: item,
                selectedAddOn: [],
                selectedVariations: []),
          )),
      child: SizedBox(
        width: kToolbarHeight * 2.5,
        height: kToolbarHeight * 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SquareImage(radius: 5, source: NetworkImage(item.image)),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: item.name,
                  style: Styles.mediumText(fontWeight: FontWeight.w400),
                ),
                Label(
                  text: item.description,
                  style: Styles.mediumText(color: Colors.grey),
                ),
                Label(
                    text: '${item.price} EGP',
                    style: Styles.mediumText(
                      color: AppColors.SECONDARY_COLOR,
                    )),
                if (item.oldPrice != 0)
                  Label(
                      text: '${item.oldPrice} EGP OG',
                      style: Styles.mediumText(
                          decoration: TextDecoration.lineThrough))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
