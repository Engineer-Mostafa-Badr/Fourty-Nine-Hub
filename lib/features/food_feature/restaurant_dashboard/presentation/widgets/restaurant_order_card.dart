// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../restaurants_list/presentation/cubit/restaurants_list_cubit.dart';

class RestaurantOrderCard extends StatelessWidget {
  final RestaurantOrder item;

  const RestaurantOrderCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final order = item;
        final user = order.userInfo;
        final food = order.orders[0].foodId;

        return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.teal.withOpacity(0.3),
            child: Stack(
              children: [
                Positioned(
                  top: 4,
                  right: 4,
                  child: Row(
                    children: [
                      Text(
                        '${order.total.ceil()} ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        order.currency,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Information with Profile Picture
                        Row(
                          children: [
                            //gander image instead of this
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black,
                              // backgroundImage: AssetImage(Assets.maleImagePlaceholdere),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.firstName + "          ",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // const Spacer(),
                                  ],
                                ),
                                // SizedBox(height: 5),
                                // Text(
                                //   order.phone,
                                //   style: TextStyle(color: Colors.grey[600]),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Order Details
                        Row(
                          children: [
                            // Food Image
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(15),
                            //   child: Image.network(
                            //     food.picture.mediaKey,
                            //     height: 100,
                            //     width: 100,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            // const SizedBox(width: 15),
                            // Food and Order Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    // 'Food: ${food.id}',
                                    'Order: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        'kepda',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${order.orders[0].quantity}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'kepda',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${order.orders[0].quantity}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'kepda',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${order.orders[0].quantity}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'kepda',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${order.orders[0].quantity}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Sizer(),

                                  const SizedBox(height: 10),
                                  // Phone number
                                  // const Row(
                                  //   children: [
                                  //     Icon(Icons.phone, color: Colors.teal),
                                  //     SizedBox(width: 5),
                                  //     Icon(Icons.message, color: Colors.teal),
                                  //     SizedBox(width: 5),
                                  //     // Text(order.phone),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Order Timing Information

                        const SizedBox(height: 8),

                        CallMessageReportButtons(item: item),
                        Text(
                          '                                 ' +
                              DateFormat('MMM d, yyyy h:mm a')
                                  .format(order.createdAt),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const Text(
                          'Please Subscribe to contact the client!',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
    // return Card(
    //   color: AppColors.PRIMARY_COLOR,
    //   // padding: const EdgeInsets.all(5),
    //   // decoration: BoxDecoration(
    //   //     border: Border.all(color: Colors.grey, width: .5),
    //   //     borderRadius: BorderRadius.circular(10)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         // _buildRestaurantInfoWidget(),
    //         Sizer(),
    //         // _buildAddressWidget(),
    //         Label(
    //           text: 'Meals',
    //           style: Styles.mediumText(
    //               fontWeight: FontWeight.bold, color: Colors.white),
    //         ),
    //         // _buildMealsWidget(),
    //         Image(
    //           image: NetworkImage(
    //             item.orders.first.foodId.picture.mediaKey,
    //           ),
    //           height: 0.5.sw,
    //         ),
    //         Sizer(),
    //         Row(
    //           children: [
    //             Expanded(
    //                 child: AppButton(
    //                     icon: Icons.check,
    //                     label: 'Approve',
    //                     backColor: const Color.fromRGBO(76, 175, 80, 1),
    //                     onPressed: () => showAreYouSure(
    //                         title: 'Approve',
    //                         subTitle: 'Do you want to approve this request?',
    //                         action: () => (int v) {},
    //                         context: context))),
    //             Sizer(),
    //             Expanded(
    //                 child: AppButton(
    //                     icon: Icons.clear,
    //                     label: 'Cancel',
    //                     onPressed: () => showAreYouSure(
    //                         title: 'Cancel',
    //                         subTitle: 'Do you want to cancel this request?',
    //                         action: () => (int v) {},
    //                         context: context))),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
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

class CallMessageReportButtons extends StatelessWidget {
  final RestaurantOrder item;

  const CallMessageReportButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // final isChatEnabled = item.enableOrDisableChat != 'disable';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Row(
        children: [
          //if enabled color = blue
          _buildButtonWithIcon(
            label: 'Call',
            icon: Icons.call,
            color: AppColors.GREY_DARK_COLOR,
            onPressed:
                true ? () => launchUrlString("tel://${item.phone}") : () {},
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: 'Message',
            icon: Icons.message,
            color: AppColors.GREY_DARK_COLOR,
            onPressed: true
                ? () {
                    BlocProvider.of<RestaurantsCubit>(context)
                        .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {},
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: 'Report',
            icon: Icons.report,
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () {
              bottomSheet(
                context: context,
                widget: ReportView(
                  id: item.id,
                  categoryId: item.restaurantId,
                ),
              );
              // Implement report functionality here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWithIcon({
    required String label,
    required IconData icon,
    required Color color,
    required Function onPressed,
  }) {
    return Expanded(
      child: AppButton(
        padding: 0,
        margin: 0,
        height: 60.h,
        label: label,
        icon: icon,
        iconSize: 70.h,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
