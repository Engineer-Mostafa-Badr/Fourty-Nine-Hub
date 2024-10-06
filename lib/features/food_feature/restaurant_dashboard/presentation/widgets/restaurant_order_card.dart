// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';

class RestaurantOrderCard extends StatelessWidget {
  final RestaurantOrder item;

  const RestaurantOrderCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.PRIMARY_COLOR,
      // padding: const EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.grey, width: .5),
      //     borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildRestaurantInfoWidget(),
            Sizer(),
            // _buildAddressWidget(),
            Label(
              text: 'Meals',
              style: Styles.mediumText(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            // _buildMealsWidget(),
            Sizer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        icon: Icons.check,
                        label: 'Approve',
                        backColor: const Color.fromRGBO(76, 175, 80, 1),
                        onPressed: () => showAreYouSure(
                            title: 'Approve',
                            subTitle: 'Do you want to approve this request?',
                            action: () => (int v) {},
                            context: context))),
                Sizer(),
                Expanded(
                    child: AppButton(
                        icon: Icons.clear,
                        label: 'Cancel',
                        onPressed: () => showAreYouSure(
                            title: 'Cancel',
                            subTitle: 'Do you want to cancel this request?',
                            action: () => (int v) {},
                            context: context))),
              ],
            )
          ],
        ),
      ),
    );
  }

// Widget _buildMealsWidget() {
//   return ListView.builder(
//       itemCount: item.orders.length,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         final meal = item.orders[index];
//         return RichText(
//             text: TextSpan(children: [
//           TextSpan(
//               text: meal.foodIdmeal.foodName ?? "",
//               style: Styles.mediumText(fontWeight: FontWeight.w600)),
//           TextSpan(
//               text: ' x ${meal.qty} \n',
//               style: Styles.mediumText(fontWeight: FontWeight.w600)),
//           ...meal.selectedVariations.map((e) {
//             return WidgetSpan(
//                 child: BadgedLabel(
//                     margin: 5,
//                     style: Styles.smallText(color: Colors.white),
//                     label: '${e.variation.name} : ${e.selectedOption.name}'));
//           }),
//           ...meal.selectedAddOn.map((e) {
//             return WidgetSpan(
//                 child: BadgedLabel(
//                     margin: 5,
//                     style: Styles.smallText(color: Colors.white),
//                     color: Colors.green,
//                     label: '${e.name} : ${e.name}'));
//           })
//         ]));
//       });
// }
//
// Widget _buildAddressWidget() {
//   return Container(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Label(text: 'Address: ${item.address.address}'),
//         Label(
//             text: 'Name: ${item.address.firstName} ${item.address.lastName}'),
//         Label(text: 'Phone: ${item.address.phone}'),
//       ],
//     ),
//   );
// }
//
// Widget _buildRestaurantInfoWidget() {
//   return Row(
//     children: [
//       SquareImage(
//           height: kToolbarHeight,
//           width: kToolbarHeight,
//           radius: 10,
//           source:
//               NetworkImage(item.user?.image ?? UIConst.profilePlaceHolder)),
//       Sizer(),
//       Expanded(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Label(
//             text: item.user?.name ?? '',
//             style: Styles.mediumText(fontWeight: FontWeight.bold),
//           ),
//           Label(
//             text: item.user?.phone ?? '',
//             style: Styles.mediumText(color: Colors.grey),
//           ),
//         ],
//       ))
//     ],
//   );
// }
}
