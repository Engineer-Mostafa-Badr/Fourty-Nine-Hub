// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';

class RestaurantOrderCard extends StatelessWidget {
  final RestaurantOrder item;
  final String subCategoryId;

  const RestaurantOrderCard(
      {super.key, required this.item, required this.subCategoryId});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final order = item;
        final user = order.userInfo;

        return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.teal.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Information with Profile Picture
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            //gander image instead of this
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black,
                              backgroundImage: AssetImage(
                                  order.userInfo.gender == 'male'
                                      ? Assets.maleImagePlaceholder
                                      : Assets.femaleImagePlacehlder),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.firstName,
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
                      ),
                      Row(
                        children: [
                          Text('${order.total.ceil()} ',
                              style: Styles.headerText(
                                  color: AppColors.WHATS_APP_COLOR)),
                          Text(
                              context.isArabic
                                  ? order.currencyAr
                                  : order.currencyEn,
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR_DARK,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Order Details
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'Food: ${food.id}',
                              LocaleKeys.orders.localize,
                              // 'Orders:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Column(
                              children: List.generate(
                                order.orders.length,
                                (index) => Row(
                                  children: [
                                    Text(
                                      order.orders[index].foodId.foodName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      order.orders[index].quantity.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),
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

                  // Order Timing Information

                  const SizedBox(height: 8),

                  CallMessageReportButtons(
                    item: item,
                    subcategoryId: subCategoryId,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        getTimeAgo(context, order.createdAt.toString()),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class CallMessageReportButtons extends StatelessWidget {
  final RestaurantOrder item;
  final String subcategoryId;

  const CallMessageReportButtons(
      {super.key, required this.item, required this.subcategoryId});

  @override
  Widget build(BuildContext context) {
    // final isChatEnabled = item.enableOrDisableChat != 'disable';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Row(
        children: [
          //if enabled color = blue
          _buildButtonWithIcon(
            label: LocaleKeys.call.localize,
            icon: Icons.call,
            color: item.openCallAndChat != 'disable'
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: item.openCallAndChat != 'disable'
                ? () => launchUrlString("tel://${item.phone}")
                : () {
                    SubscriptionMethod().subscribe(
                        subscribeId: subcategoryId,
                        title: LocaleKeys.restaurantDashboard.localize);
                  },
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: LocaleKeys.message.localize,
            icon: Icons.message,
            color: item.openCallAndChat != 'disable'
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: item.openCallAndChat != 'disable'
                ? () {
                    // BlocProvider.of<RestaurantsCubit>(context)
                    //     .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {
                    SubscriptionMethod().subscribe(
                        subscribeId: subcategoryId,
                        title: LocaleKeys.restaurantDashboard.localize);
                  },
          ),
          const SizedBox(width: 4),
          _buildButtonWithIcon(
            label: LocaleKeys.report.localize,
            icon: Icons.report,
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: cardDarkColor(context),
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id,
                      categoryId: item.restaurantId,
                    ),
                  );
                },
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
        style:
            Styles.mediumText(color: Colors.white, fontWeight: FontWeight.bold),
        onPressed: onPressed,
      ),
    );
  }
}
