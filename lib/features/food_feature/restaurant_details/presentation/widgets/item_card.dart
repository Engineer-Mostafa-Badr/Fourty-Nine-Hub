import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
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
      child: Container(
        decoration: BoxDecoration(
          color:context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cD9D9D9,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to top
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: widget.meal.picture != null && widget.meal.picture!.isNotEmpty
                  ? Image.network(
                widget.meal.picture!,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              )
                  : Container(
                width: 100,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // MAIN CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8), // Align with quantity controls
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.foodName ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (widget.meal.price ?? 0.0).toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // QUANTITY AND ADD TO CART - STATIC POSITION
            Container(
              padding:  EdgeInsetsDirectional.only(top: 8, end: 8), // Match main content alignment
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quantity Container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color:context.isDarkMode ? AppColors.whiteColor : AppColors.black),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (widget.fromUpdate ?? false) ? null : _decreaseQuantity,
                          child: Icon(Icons.remove, size: 20.sp, color: context.isDarkMode ? AppColors.whiteColor :AppColors.black),
                        ),
                        const SizedBox(width: 12),
                        Label(
                          text: '$qty',
                          style:  TextStyle(fontSize: 12, color: context.isDarkMode ? AppColors.whiteColor :AppColors.black),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: (widget.fromUpdate ?? false) ? null : _increaseQuantity,
                          child: Icon(Icons.add, size: 20.sp, color: context.isDarkMode ? AppColors.whiteColor :AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6,),
                  // Space reserved for Add to Cart button (even when hidden)
                  SizedBox(
                    // height: qty > 0 ? 36 : 0, // Reserve space when button is hidden
                    child: Visibility(
                      visible: qty > 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: GestureDetector(
                          onTap: _addToCart,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.SECONDARY_COLOR_DARK,
                              borderRadius: BorderRadius.circular(15),
                              // border: Border.all(color: AppColors.LIGHT_COLOR),
                            ),
                            child:  Text(
                              LocaleKeys.addToCart.localize,
                              style: TextStyle(color: Colors.black, fontSize: 10,
                              fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if( qty > 0)
                    SizedBox(height: 6,)
                ],
              ),
            ),
          ],
        ),
      ),
    );




  }
}
