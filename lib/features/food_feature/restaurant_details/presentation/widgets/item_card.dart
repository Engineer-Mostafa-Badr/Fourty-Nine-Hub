import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/style/styles.dart';
import '../../../restaurants_list/domain/entities/restaurant_mneu.dart';

class ItemCard extends StatefulWidget {
  final String restaurantId;
  final RestaurantMenu meal;
  final bool? fromUpdate;

  const ItemCard({
    super.key,
    required this.meal,
    required this.restaurantId,
    this.fromUpdate,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int qty = 0;

  @override
  void initState() {
    super.initState();
    // Initialize quantity if needed
  }

  void _increaseQuantity() async {
    // await context.read<RestaurantDetailsCubit>().addToCart(
    //   context,
    //   restaurantId: widget.restaurantId,
    //   foodId: widget.meal.id ?? "",
    //   quantity: (1).toString(),
    // );
    setState(() {
      qty++;
    });
  }

  void _decreaseQuantity() async {
    if (qty > 0) {
      // await context.read<RestaurantDetailsCubit>().addToCart(
      //   context,
      //   restaurantId: widget.restaurantId,
      //   foodId: widget.meal.id ?? "",
      //   quantity: qty.toString(),
      // );
      setState(() {
        qty--;
      });
    }
  }

  void _addToCart() async {
    await context.read<RestaurantDetailsCubit>().addToCart(
          context,
          restaurantId: widget.restaurantId,
          foodId: widget.meal.id ?? "",
          quantity: qty,
        );
    setState(() {
      qty = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<RestaurantDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  color: cardDarkColor(context, isRestruantItem: true),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    190.horizontalSpace,
                    // Item Details
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.meal.foodName ?? 'Unknown',
                            style: Styles.headerText(
                                fontSize: 32, color: AppColors.LIGHT_COLOR),
                          ),
                          16.verticalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                ((widget.meal.price ?? 0.0)).toStringAsFixed(2),
                                style: Styles.headerText(
                                    fontSize: 32, color: AppColors.LIGHT_COLOR),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Item Price
                    Column(
                      children: [
                        10.verticalSpace,
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.LIGHT_COLOR)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (widget.fromUpdate ?? false)
                                    ? null
                                    : _decreaseQuantity,
                                child: Icon(
                                  Icons.remove,
                                  size: 50.sp,
                                  color: AppColors.LIGHT_COLOR,
                                ),
                              ),
                              24.horizontalSpace,
                              // Quantity Text
                              Text(
                                '$qty',
                                style: Styles.mediumText(
                                    fontSize: 32, color: AppColors.LIGHT_COLOR),
                              ),
                              24.horizontalSpace,
                              // Increase Quantity Button
                              InkWell(
                                onTap: (widget.fromUpdate ?? false)
                                    ? null
                                    : _increaseQuantity,
                                child: Icon(
                                  Icons.add,
                                  size: 50.sp,
                                  color: AppColors.LIGHT_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: qty > 0 ? 16.h : 0),
                        if (qty > 0)
                          BadgedLabel(
                            label: 'Add to cart',
                            onTap: _addToCart,
                            color: AppColors.SECONDARY_COLOR_DARK,
                            borderColor: AppColors.LIGHT_COLOR,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SquareImage(
                url: widget.meal.picture ?? "",
                width: 80.0,
                height: 160.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
