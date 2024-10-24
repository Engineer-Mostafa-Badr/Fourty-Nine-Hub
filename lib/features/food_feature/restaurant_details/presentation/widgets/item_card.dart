import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../restaurants_list/domain/entities/restaurant_mneu.dart';

class ItemCard extends StatefulWidget {
  final String restaurantId;
  final RestaurantMenu meal;
  final bool? fromUpdate;

  ItemCard({
    super.key,
    required this.meal,
    required this.restaurantId,
    this.fromUpdate,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int qty = 1;

  @override
  void initState() {
    super.initState();
    // Initialize quantity if needed
  }

  void _increaseQuantity() {
    setState(() {
      qty++;
    });
    context.read<RestaurantDetailsCubit>().addToCart(
      context,
      restaurantId: widget.restaurantId, // restaurantId is non-null
      foodId: widget.meal.id ?? "", // Handle possible null id
      quantity: qty.toString(),
    );
    // Update quantity in controller if needed
  }

  void _decreaseQuantity() {
    if (qty > 0) {
      setState(() {
        qty--;
      });
      context.read<RestaurantDetailsCubit>().addToCart(
        context,
        restaurantId: widget.restaurantId, // restaurantId is non-null
        foodId: widget.meal.id ?? "", // Handle possible null id
        quantity: qty.toString(),
      );
      // Update quantity in controller if needed
    }
  }

  void _removeItem() {
    final controller = context.read<RestaurantDetailsCubit>();
    controller.removeMeal(meal: widget.meal);
    // Optionally, show a confirmation dialog before removing
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RestaurantDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: cardDarkColor(context),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(12.0),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.4),
        //       spreadRadius: 2,
        //       blurRadius: 5,
        //       offset: const Offset(0, 3),
        //     ),
        //   ],
        // ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SquareImage(
                  url: widget.meal.picture?.mediaKey ?? "", // Handle null mediaKey
                  width: 80.0,
                  height: 80.0,
                ),
              ),
              const SizedBox(width: 12.0),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.foodName ?? 'Unknown', // Handle null foodName
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        // Decrease Quantity Button
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: InkWell(
                            onTap: (widget.fromUpdate ?? false)
                                ? null
                                : _decreaseQuantity, // Handle null fromUpdate
                            child: const Icon(
                              Icons.remove,
                              size: 16.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Quantity Text
                        Text(
                          '$qty',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Increase Quantity Button
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: InkWell(
                            onTap: (widget.fromUpdate ?? false)
                                ? null
                                : _increaseQuantity, // Handle null fromUpdate
                            child: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Item Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // Handle null price by providing a default value of 0.0
                    ((widget.meal.price ?? 0.0) * qty).toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
// // import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
// // import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:fourtyninehub/res/style/styles.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // class ItemCard extends StatefulWidget {
// //   final String restaurantId;
// //
// //   const ItemCard({
// //     super.key,
// //     required this.meal,
// //     required this.restaurantId,
// //   });
// //
// //   final RestaurantMenu? meal;
// //
// //   @override
// //   State<ItemCard> createState() => _ItemCardState();
// // }
// //
// // class _ItemCardState extends State<ItemCard> {
// //   int qty = 1;
// //   double total = 0.0;
// //   bool add = false;
// //
// //   @override
// //   void initState() {
// //     total = widget.meal?.price ?? 0.0;
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = context.read<RestaurantDetailsCubit>();
// //     return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
// //         builder: (context, state) {
// //       return ListTile(
// //         onTap: () {
// //           // // controller.selectMeal(meal: meal!, index: index);
// //         },
// //         dense: true,
// //         visualDensity: VisualDensity.comfortable,
// //         title: Text(
// //           widget.meal?.foodName ?? "",
// //           style: Styles.headerText(
// //               fontWeight: FontWeight.bold, color: AppColors.PRIMARY_COLOR),
// //         ),
// //         subtitle: Text(
// //           '${widget.meal?.price} EGP',
// //           style: Styles.headerText(
// //             fontWeight: FontWeight.bold,
// //             color: AppColors.ACCENT_COLOR,
// //           ),
// //         ),
// //         leading: SquareImage(
// //           url: widget.meal?.picture?.mediaKey ?? "",
// //           height: 50.h,
// //           width: 50,
// //         ),
// //         trailing: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             IconButton(
// //               icon: const Icon(Icons.remove),
// //               onPressed: () async {
// //                 // await controller.addToCart(
// //                 //     context: context,
// //                 //     restaurantId: widget.meal?.restaurantId ?? "",
// //                 //     foodId: widget.meal?.id ?? "",
// //                 //     quantity: qty.toString());
// //                 if (qty > 1) {
// //                   setState(() {
// //                     qty--;
// //                     total = qty * (widget.meal?.price ?? 0.0);
// //                   });
// //                 }
// //               },
// //             ),
// //             Text(
// //               qty.toString(),
// //               style: Styles.headerText(
// //                 fontWeight: FontWeight.bold,
// //                 color: AppColors.PRIMARY_COLOR,
// //               ),
// //             ),
// //             IconButton(
// //               icon: const Icon(Icons.add),
// //               onPressed: () async {
// //                 setState(() {
// //                   qty++;
// //                   total = qty * (widget.meal?.price ?? 0.0);
// //                 });
// //
// //                 if (qty > 1 && !add) {
// //                   // controller.selectMeal(meal: widget.meal!, qty: qty);
// //                   add = true;
// //                 }
// //                 await controller.addToCart(
// //                     restaurantId: widget.restaurantId ?? "",
// //                     foodId: widget.meal?.id ?? "",
// //                     quantity: qty.toString());
// //               },
// //             ),
// //             Checkbox(
// //               value: add,
// //               onChanged: (value) async {
// //                 if (value != null) {
// //                   setState(() {
// //                     add = value;
// //                   });
// //                   if (value) {
// //                     // await controller.addToCart(
// //                     //     context: context,
// //                     //     restaurantId: widget.meal?.restaurantId ?? "",
// //                     //     foodId: widget.meal?.id ?? "",
// //                     //     quantity: qty.toString());
// //                     print(value);
// //                     print(add);
// //                     // controller.selectMeal(meal: widget.meal!, qty: qty);
// //                   } else {
// //                     controller.removeMeal(meal: widget.meal!);
// //                   }
// //                 }
// //               },
// //               activeColor: AppColors.SECONDARY_COLOR,
// //               checkColor: Colors.white,
// //               visualDensity: VisualDensity.comfortable,
// //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //             ),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
//
// import '../../../restaurants_list/domain/entities/restaurant_mneu.dart';
//
// class ItemCard extends StatefulWidget {
//   final String restaurantId;
//   final RestaurantMenu meal;
//
//   bool? fromUpdate;
//
//   ItemCard({
//     Key? key,
//     required this.meal,
//     required this.restaurantId,
//     this.fromUpdate,
//   }) : super(key: key);
//
//   @override
//   State<ItemCard> createState() => _ItemCardState();
// }
//
// class _ItemCardState extends State<ItemCard> {
//   int qty = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize quantity if needed
//   }
//
//   void _increaseQuantity() {
//     setState(() {
//       qty++;
//     });
//     context.read<RestaurantDetailsCubit>().addToCart(
//         restaurantId: widget.restaurantId ?? "",
//         foodId: widget.meal.id ?? "",
//         quantity: qty.toString());
//     // Update quantity in controller if needed
//   }
//
//   void _decreaseQuantity() {
//     if (qty > 0) {
//       setState(() {
//         qty--;
//       });
//       context.read<RestaurantDetailsCubit>().addToCart(
//           restaurantId: widget.restaurantId ?? "",
//           foodId: widget.meal.id ?? "",
//           quantity: qty.toString());
//       // Update quantity in controller if needed
//     }
//   }
//
//   void _removeItem() {
//     final controller = context.read<RestaurantDetailsCubit>();
//     controller.removeMeal(meal: widget.meal);
//     // Optionally, show a confirmation dialog before removing
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<RestaurantDetailsCubit>();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.4),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Row(
//             children: [
//               // Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12.0),
//                 child: SquareImage(
//                   url: widget.meal.picture?.mediaKey ?? "",
//                   width: 80.0,
//                   height: 80.0,
//                 ),
//               ),
//               const SizedBox(width: 12.0),
//               // Item Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.meal.foodName ?? 'Unknown',
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Row(
//                       children: [
//                         // Decrease Quantity Button
//                         Container(
//                           padding: const EdgeInsets.all(4.0),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey),
//                           ),
//                           child: InkWell(
//                             onTap:
//                                 widget.fromUpdate??false ? null : _decreaseQuantity,
//                             child: const Icon(
//                               Icons.remove,
//                               size: 16.0,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12.0),
//                         // Quantity Text
//                         Text(
//                           '$qty',
//                           style: const TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 12.0),
//                         // Increase Quantity Button
//                         Container(
//                           padding: const EdgeInsets.all(4.0),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey),
//                           ),
//                           child: InkWell(
//                             onTap:
//                                 widget.fromUpdate??false  ? null : _increaseQuantity,
//                             child: const Icon(
//                               Icons.add,
//                               size: 16.0,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Item Price
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     (widget.meal.price! * qty).toStringAsFixed(2),
//                     style: const TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.SECONDARY_COLOR,
//                     ),
//                   ),
//                   const SizedBox(height: 40.0),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
