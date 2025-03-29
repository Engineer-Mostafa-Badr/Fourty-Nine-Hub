import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_order_card.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../domain/entity/order_food_entity.dart';
class AvailableRequestFood extends StatefulWidget {
  const AvailableRequestFood({super.key});

  @override
  State<AvailableRequestFood> createState() => _AvailableRequestFoodState();
}

class _AvailableRequestFoodState extends State<AvailableRequestFood> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  // @override
  @override
  void initState() {
    print("Worked");
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().getOrders(false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantDashboardCubit>().getOrders(false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
          builder: (context, state) {
            var controller = context.read<RestaurantDashboardCubit>();
            print("Number of orders: ${controller.orders.length}");

            return

               controller.orders.isNotEmpty
                ? ListView.builder(
              controller: _scrollController,
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                var data = controller.orders[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : Colors.black,
                        width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left Column: Image with Name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              // Prevent extra spacing
                              children: [
                                // Image.network(
                                //   data.orders[index].foodId.foodName, // Replace with actual image
                                //   width: 50,
                                //   height: 50,
                                //   fit: BoxFit.cover,
                                // ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  // width: 60, // Ensures the text fits in a reasonable space
                                  child: Label(
                                    text: data.restaurantId ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: context.isDarkMode
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Right Section: Image + Column (Title & Price)
                            Expanded(
                              // Ensures this section takes available space without overflow
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Column for Title & Price
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if (data.orders != null &&
                                            index < data.orders!.length &&
                                            data.orders![index].foodId != null &&
                                            data.orders![index].foodId!.foodName != null &&
                                            data.orders![index].foodId!.foodName!.trim().isNotEmpty)

                                        // print("✅ Showing: ${data.orders![index].foodId!.foodName!}"), // Debugging line
                                          Label(
                                            text: data.orders![index].foodId!.foodName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                            ),
                                          ),

                                        const SizedBox(height: 4.0),
                                        Label(
                                          text: "\$100",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8.0),
                                  // Image on the right
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    // Radius 10
                                    child: Image.asset(
                                      Assets.carImage,
                                      // Replace with actual image
                                      width: 80, // Reduce width slightly
                                      height: 60, // Reduce height slightly
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                              text: "30 Mins",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Label(
                              text: "Today",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (context) => CustomBottomSheet(),
                                );
                              },
                              child: SvgPicture.asset(
                                Assets.phoneRed,
                                color: AppColors.PRIMARY_COLOR_DARK,
                              ),
                            ),

                            SvgPicture.asset(
                              Assets.mailRed,
                              color: AppColors.PRIMARY_COLOR_DARK,
                            ),
                            SvgPicture.asset(
                              Assets.reportRed,
                              color: AppColors.PRIMARY_COLOR_DARK,
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.location_on_rounded),
                          Label(text: "Giza , Egypt")
                        ],
                      ),
                      AppButton(
                          height: 50,
                          color: AppColors.whiteColor,
                          backColor: AppColors.PRIMARY_COLOR,
                          label: "Complete",
                          onPressed: () {
                            controller.completeOrder(data.id!);
                            print("data ${data.id!}");
                          }),
                    ],
                  ),
                );
              },
            )
                : Center(
              child: Label(text: LocaleKeys.thereNoItems.localize),
            );
          }),
    );
  }
}


class PastRequestFood extends StatefulWidget {
  const PastRequestFood({super.key});

  @override
  State<PastRequestFood> createState() => _PastRequestFoodState();
}

class _PastRequestFoodState extends State<PastRequestFood> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  // @override
  @override
  void initState() {
    print("Worked");
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().getOrdersPast(true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantDashboardCubit>().getOrdersPast(true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
          builder: (context, state) {
            var controller = context.read<RestaurantDashboardCubit>();
            print("Number of orders: ${controller.ordersPast.length}");

            return state.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : controller.ordersPast.isNotEmpty
                ? ListView.builder(
              controller: _scrollController,
              itemCount: controller.ordersPast.length,
              itemBuilder: (context, index) {
                var data = controller.ordersPast[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : Colors.black,
                        width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left Column: Image with Name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              // Prevent extra spacing
                              children: [
                                // Image.network(
                                //   data.orders[index].foodId.foodName, // Replace with actual image
                                //   width: 50,
                                //   height: 50,
                                //   fit: BoxFit.cover,
                                // ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  // width: 60, // Ensures the text fits in a reasonable space
                                  child: Label(
                                    text: data.restaurantId ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: context.isDarkMode
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Right Section: Image + Column (Title & Price)
                            Expanded(
                              // Ensures this section takes available space without overflow
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Column for Title & Price
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if (data.orders != null &&
                                            index < data.orders!.length &&
                                            data.orders![index].foodId != null &&
                                            data.orders![index].foodId!.foodName != null &&
                                            data.orders![index].foodId!.foodName!.trim().isNotEmpty)

                                        // print("✅ Showing: ${data.orders![index].foodId!.foodName!}"), // Debugging line
                                          Label(
                                            text: data.orders![index].foodId!.foodName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                            ),
                                          ),

                                        const SizedBox(height: 4.0),
                                        Label(
                                          text: "\$100",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8.0),
                                  // Image on the right
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    // Radius 10
                                    child: Image.asset(
                                      Assets.carImage,
                                      // Replace with actual image
                                      width: 80, // Reduce width slightly
                                      height: 60, // Reduce height slightly
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                              text: "30 Mins",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Label(
                              text: "Today",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (context) => CustomBottomSheet(),
                                );
                              },
                              child: SvgPicture.asset(
                                Assets.phoneRed,
                                color: AppColors.PRIMARY_COLOR_DARK,
                              ),
                            ),

                            SvgPicture.asset(
                              Assets.mailRed,
                              color: AppColors.PRIMARY_COLOR_DARK,
                            ),
                            SvgPicture.asset(
                              Assets.reportRed,
                              color: AppColors.PRIMARY_COLOR_DARK,
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.location_on_rounded),
                          Label(text: "Giza , Egypt")
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
                : Center(
              child: Label(text: LocaleKeys.thereNoItems.localize),
            );
          }),
    );
  }
}




