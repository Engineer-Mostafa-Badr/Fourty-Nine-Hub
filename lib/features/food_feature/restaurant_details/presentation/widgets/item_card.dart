import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
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
          color: AppColors.cD9D9D9,
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
              padding: const EdgeInsets.only(top: 8, right: 8), // Match main content alignment
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quantity Container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.black),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (widget.fromUpdate ?? false) ? null : _decreaseQuantity,
                          child: Icon(Icons.remove, size: 20.sp, color: AppColors.black),
                        ),
                        const SizedBox(width: 12),
                        Label(
                          text: '$qty',
                          style: const TextStyle(fontSize: 12, color: AppColors.black),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: (widget.fromUpdate ?? false) ? null : _increaseQuantity,
                          child: Icon(Icons.add, size: 20.sp, color: AppColors.black),
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
                            child: const Text(
                              'Add to cart',
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
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Stack(
    //     children: [
    //       Positioned.fill(
    //         child: Container(
    //           decoration: BoxDecoration(
    //               color: AppColors.cD9D9D9,
    //               borderRadius: BorderRadius.circular(20)
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(4.0),
    //             child: Row(
    //               mainAxisSize: MainAxisSize.max,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 190.horizontalSpace,
    //                 // Item Details
    //                 Expanded(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         widget.meal.foodName ?? 'Unknown',
    //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    //                       ),
    //                       16.verticalSpace,
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Text(
    //                             ((widget.meal.price ?? 0.0)).toStringAsFixed(2),
    //                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //
    //                 // Item Price
    //                 Column(
    //                   children: [
    //                     10.verticalSpace,
    //                     Container(
    //                       padding: EdgeInsets.all(2.w),
    //                       decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(20),
    //                           border: Border.all(color: AppColors.black)),
    //                       child: Row(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           InkWell(
    //                             onTap: (widget.fromUpdate ?? false)
    //                                 ? null
    //                                 : _decreaseQuantity,
    //                             child: Icon(
    //                               Icons.remove,
    //                               size: 50.sp,
    //                               color: AppColors.black,
    //                             ),
    //                           ),
    //                           24.horizontalSpace,
    //                           // Quantity Text
    //                           Label(
    //
    //                             text:'$qty',
    //                             style: TextStyle(
    //                                 fontSize: 12, color: AppColors.black),
    //                           ),
    //                           24.horizontalSpace,
    //                           // Increase Quantity Button
    //                           InkWell(
    //                             onTap: (widget.fromUpdate ?? false)
    //                                 ? null
    //                                 : _increaseQuantity,
    //                             child: Icon(
    //                               Icons.add,
    //                               size: 50.sp,
    //                               color: AppColors.black,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(height: qty > 0 ? 16.h : 0),
    //                     if (qty > 0)
    //                       BadgedLabel(
    //                         label: 'Add to cart',
    //                         onTap: _addToCart,
    //                         color: AppColors.SECONDARY_COLOR_DARK,
    //                         borderColor: AppColors.LIGHT_COLOR,
    //                       ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       Align(
    //         alignment: AlignmentDirectional.centerStart,
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(15),
    //           child: SquareImage(
    //             url: widget.meal.picture ?? "",
    //             width: 100,
    //             height: 70,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    /*
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cD9D9D9,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: widget.meal.picture?.isNotEmpty == true
                  ? Image.network(
                widget.meal.picture!,
                width: 100,
                height: 70,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.meal.foodName ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (widget.meal.price ?? 0.0).toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // QUANTITY CONTROLS
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.black),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: (widget.fromUpdate ?? false) ? null : _decreaseQuantity,
                        child: Icon(Icons.remove, size: 20.sp, color: AppColors.black),
                      ),
                      const SizedBox(width: 12),
                      Label(
                        text: '$qty',
                        style: const TextStyle(fontSize: 12, color: AppColors.black),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: (widget.fromUpdate ?? false) ? null : _increaseQuantity,
                        child: Icon(Icons.add, size: 20.sp, color: AppColors.black),
                      ),
                    ],
                  ),
                ),

                if (qty > 0) const SizedBox(height: 8),
                if (qty > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.SECONDARY_COLOR_DARK,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.LIGHT_COLOR),
                    ),
                    child: GestureDetector(
                      onTap: _addToCart,
                      child: Text(
                        'Add to cart',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );

     */



  }
}
