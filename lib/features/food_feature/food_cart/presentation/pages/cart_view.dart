// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
// // import '../../../../../core/states/basic_state.dart';
// // import '../../domain/entities/cart_entity.dart';
// // import '../cubit/food_cart_cubit.dart';
// //
// // class FoodCartView extends StatelessWidget {
// //   const FoodCartView({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<FoodCartCubit, BasicState<CartEntity>>(
// //         builder: (context, state) {
// //       final controller = context.read<FoodCartCubit>();
// //       return Scaffold(
// //         appBar: const BackAppBar(
// //           label: 'Cart',
// //         ),
// //         bottomNavigationBar: AppButton(
// //             margin: 10,
// //             label: 'Place Order',
// //             onPressed: () => controller.placeOrder(context)),
// //         body: Padding(
// //           padding: EdgeInsets.all(8.0),
// //           child: ListView(
// //             children: [
// //               _buildCartItems(context: context),
// //             ],
// //           ),
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget _buildCartItems({required BuildContext context}) {
// //     // final controller = context.read<FoodCartCubit>();
// //     return BlocBuilder<FoodCartCubit, BasicState<CartEntity>>(
// //         builder: (context, state) {
// //       return ListView.separated(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           itemBuilder: (context, index) => const Text('label'),
// //           separatorBuilder: (context, state) => SizedBox(),
// //           itemCount: state.data?.allItems.length ?? 0);
// //     });
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
//
// class FoodCartView extends StatefulWidget {
//   const FoodCartView({Key? key}) : super(key: key);
//
//   @override
//   _FoodCartViewState createState() => _FoodCartViewState();
// }
//
// class _FoodCartViewState extends State<FoodCartView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<RestaurantDetailsCubit>().fetchCart();
//   }
//
//   void _increaseQuantity(item) {
//     // Implement increase quantity logic
//   }
//
//   void _decreaseQuantity(item) {
//     // Implement decrease quantity logic
//   }
//
//   void _removeItem(item) {
//     // Implement remove item logic
//   }
//
//   void _checkout() {
//     // Implement checkout functionality
//   }
//
//   @override
//   Widget build(BuildContext context) {
//       return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             const Text('Your Cart'),
//             const Spacer(),
//             Icon(
//               FontAwesomeIcons.cartShopping,
//               size: 24.sp,
//             ),
//           ],
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state.cart != null && state.cart!.allItems.isNotEmpty) {
//             final cart = state.cart!;
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     itemCount: cart.allItems.length,
//                     itemBuilder: (context, index) {
//                       final cartItem = cart.allItems[index];
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 16),
//                           Text(
//                             cartItem.restaurant.name,
//                             style: TextStyle(
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: cartItem.restaurantItems.length,
//                             itemBuilder: (context, itemIndex) {
//                               final item = cartItem.restaurantItems[itemIndex];
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                                 child: Slidable(
//                                   key: ValueKey(item.food.id),
//                                   endActionPane: ActionPane(
//                                     motion: const ScrollMotion(),
//                                     children: [
//                                       SlidableAction(
//                                         onPressed: (context) =>
//                                             _removeItem(item),
//                                         backgroundColor: Colors.red,
//                                         foregroundColor: Colors.white,
//                                         icon: Icons.delete,
//                                         label: 'Delete',
//                                       ),
//                                     ],
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(12.r),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.2),
//                                           spreadRadius: 2,
//                                           blurRadius: 5,
//                                           offset: const Offset(0, 3),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         // Image
//                                         ClipRRect(
//                                           borderRadius:
//                                           BorderRadius.circular(12.r),
//                                           child: Image.network(
//                                             cartItem.restaurant
//                                                 .restaurantMedia.first.mediaKey,
//                                             width: 80.w,
//                                             height: 80.w,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error,
//                                                 stackTrace) {
//                                               return Container(
//                                                 width: 80.w,
//                                                 height: 80.w,
//                                                 color: Colors.grey[200],
//                                                 child: Icon(
//                                                   Icons.broken_image,
//                                                   size: 40.sp,
//                                                   color: Colors.grey,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         SizedBox(width: 12.w),
//                                         // Item Details
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 item.food.foodName,
//                                                 style: TextStyle(
//                                                   fontSize: 16.sp,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 8.h),
//                                               Row(
//                                                 children: [
//                                                   GestureDetector(
//                                                     onTap: () =>
//                                                         _decreaseQuantity(item),
//                                                     child: Container(
//                                                       padding:
//                                                       EdgeInsets.all(4.w),
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         border: Border.all(
//                                                             color: Colors.grey),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.remove,
//                                                         size: 16.sp,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 12.w),
//                                                   Text(
//                                                     '${item.quantity}',
//                                                     style: TextStyle(
//                                                       fontSize: 16.sp,
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 12.w),
//                                                   GestureDetector(
//                                                     onTap: () =>
//                                                         _increaseQuantity(item),
//                                                     child: Container(
//                                                       padding:
//                                                       EdgeInsets.all(4.w),
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         border: Border.all(
//                                                             color: Colors.grey),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         size: 16.sp,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         // Item Price
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                           children: [
//                                             Text(
//                                               '\$${item.totalPriceOfItem.toStringAsFixed(2)}',
//                                               style: TextStyle(
//                                                 fontSize: 16.sp,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: AppColors.SECONDARY_COLOR,
//                                               ),
//                                             ),
//                                             SizedBox(height: 40.h),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 8.h),
//                               child: Text(
//                                 'Restaurant Total: \$${cartItem.total.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.sp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 const Divider(),
//                 Padding(
//                   padding:
//                   EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Subtotal:',
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             '\$${cart.subTotal.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.SECONDARY_COLOR,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16.h),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _checkout,
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.symmetric(vertical: 16.h),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             backgroundColor: AppColors.SECONDARY_COLOR,
//                           ),
//                           child: Text(
//                             'Checkout',
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(
//               child: Text(
//                 'Your cart is empty',
//                 style: TextStyle(fontSize: 18.sp),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enums/order_status.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/reels/presentation/widgets/comments.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';

class FoodCartView extends StatefulWidget {
  const FoodCartView({super.key});

  @override
  _FoodCartViewState createState() => _FoodCartViewState();
}

class _FoodCartViewState extends State<FoodCartView> {
  // int qty = 1;

  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailsCubit>().fetchCart();
  }

  Future<void> _increaseQuantity({restaurantId, mealId, qty}) async {
    // Implement increase quantity logic
    setState(() {
      // qty++;
    });
    await context.read<RestaurantDetailsCubit>().addToCart(
        restaurantId: restaurantId ?? "",
        foodId: mealId ?? "",
        quantity: qty.toString());
    await context.read<RestaurantDetailsCubit>().fetchCart();

    // Update quantity in controller if needed
  }

  Future<void> _decreaseQuantity({restaurantId, mealId, qty}) async {
    // Implement decrease quantity logic
    if (qty > 0) {
      setState(() {
        // qty--;
      });
      await context.read<RestaurantDetailsCubit>().addToCart(
          restaurantId: restaurantId ?? "",
          foodId: mealId ?? "",
          quantity: qty.toString());
      await context.read<RestaurantDetailsCubit>().fetchCart();

      // Update quantity in controller if needed
    }
  }

  Future<void> _removeItem({restaurantId, foodId}) async {
    // Implement remove item logic
    await context
        .read<RestaurantDetailsCubit>()
        .deleteFromCart(context, restaurantId: restaurantId, foodId: foodId);
    // await context.read<RestaurantDetailsCubit>().fetchCart();

    Navigator.pop(context);
  }

  void _checkout() {
    // Implement checkout functionality
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantDetailsCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Your Cart',
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            Icon(
              FontAwesomeIcons.cartShopping,
              size: 24.0, // Adjusted size
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.cart != null && state.cart!.allItems.isNotEmpty) {
            final cart = state.cart!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    // Adjusted padding
                    itemCount: cart.allItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.allItems[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0), // Adjusted height
                          Text(
                            cartItem.restaurant.name,
                            style: const TextStyle(
                              fontSize: 20.0, // Adjusted font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItem.restaurantItems.length,
                            itemBuilder: (context, itemIndex) {
                              final item = cartItem.restaurantItems[itemIndex];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0), // Adjusted padding
                                child: Slidable(
                                  key: ValueKey(item.food.id),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _removeItem(
                                              restaurantId:
                                                  cartItem.restaurant.id,
                                              foodId: item.food.id);
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      // Adjusted radius
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          // Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Adjusted radius
                                            child: Image.network(
                                              cartItem
                                                  .restaurant
                                                  .restaurantMedia
                                                  .first
                                                  .mediaKey,
                                              width: 80.0, // Adjusted width
                                              height: 80.0, // Adjusted height
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 80.0,
                                                  height: 80.0,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    size: 40.0, // Adjusted size
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12.0),
                                          // Adjusted width
                                          // Item Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.food.foodName,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    // Adjusted font size
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                // Adjusted height
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () =>
                                                            _decreaseQuantity(
                                                                restaurantId:
                                                                    cartItem
                                                                        .restaurant
                                                                        .id,
                                                                mealId: item
                                                                    .food.id,
                                                                qty:
                                                                    item.quantity -
                                                                        1),
                                                        child: const Icon(
                                                          Icons.remove,
                                                          size:
                                                              16.0, // Adjusted size
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12.0),
                                                    // Adjusted width
                                                    Text(
                                                      '${item.quantity}',
                                                      // '$qty',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        // Adjusted font size
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12.0),
                                                    // Adjusted width
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () =>
                                                            _increaseQuantity(
                                                                restaurantId:
                                                                    cartItem
                                                                        .restaurant
                                                                        .id,
                                                                mealId: item
                                                                    .food.id,
                                                                qty:
                                                                    item.quantity +
                                                                        1),
                                                        child: const Icon(
                                                          Icons.add,
                                                          size:
                                                              16.0, // Adjusted size
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                item.totalPriceOfItem
                                                    .toStringAsFixed(2),
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  // Adjusted font size
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.SECONDARY_COLOR,
                                                ),
                                              ),
                                              const SizedBox(height: 40.0),
                                              // Adjusted height
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              // Adjusted padding
                              child: Text(
                                'Restaurant Total: ${cartItem.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0, // Adjusted font size
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // Adjusted padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal:',
                            style: TextStyle(
                              fontSize: 16.0, // Adjusted font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cart.subTotal.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 16.0, // Adjusted font size
                              fontWeight: FontWeight.bold,
                              color: AppColors.SECONDARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0), // Adjusted height
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                showFoodRequestBottomSheet(context,
                                    cartId: cart.id, orderType: 'premium');
                                // context
                                //     .read<RestaurantDetailsCubit>()
                                //     .createOrder(context,
                                //         cartId: cart.id,
                                //         address: 'ascaaaaaaaaaaaaaaaaaa',
                                //         phone: '0121555158')
                                //     .then((value) => context
                                //         .read<RestaurantDetailsCubit>()
                                //         .fetchCart());
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                // Adjusted padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjusted radius
                                ),
                                backgroundColor: AppColors.SECONDARY_COLOR,
                              ),
                              child: FittedBox(
                                child: Text(
                                  ' Premium Request ',
                                  style: Styles.headerText(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                showFoodRequestBottomSheet(context,
                                    cartId: cart.id, orderType: 'normal');
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                // Adjusted padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjusted radius
                                ),
                                backgroundColor: AppColors.PRIMARY_COLOR,
                              ),
                              child: FittedBox(
                                child: Text(
                                  'Request',
                                  style: Styles.headerText(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0), // Adjusted height
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18.0), // Adjusted font size
              ),
            );
          }
        },
      ),
    );
  }
}

void showFoodRequestBottomSheet(BuildContext context,
    {String? cartId, required String? orderType}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Allows the bottom sheet to resize when the keyboard is shown

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: isDarkTheme(context)
        ? Colors.black.withOpacity(0.9)
        : Colors.white.withOpacity(0.9),
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: serviceLocator<RestaurantDetailsCubit>(),
        child: FoodRequestBottomSheet(cartId: cartId!, orderType: orderType!),
      );
    },
  );
}

class FoodRequestBottomSheet extends StatefulWidget {
  final String cartId;
  final String orderType;

  const FoodRequestBottomSheet(
      {super.key, required this.cartId, required this.orderType});

  @override
  _FoodRequestBottomSheetState createState() => _FoodRequestBottomSheetState();
}

class _FoodRequestBottomSheetState extends State<FoodRequestBottomSheet> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder(cartId) async {
    if (_formKey.currentState?.validate() ?? false) {
      // final address = _addressController.text.trim();
      const address = '  ';
      final phone = _phoneController.text.trim();

      final cartId = widget.cartId;

      if (widget.orderType == 'premium') {
        await context.read<RestaurantDetailsCubit>().createPremiumOrder(context,
            cartId: cartId, address: address, phone: phone);
      }
      if (widget.orderType == 'normal') {
        await context.read<RestaurantDetailsCubit>().createNormalOrder(context,
            cartId: cartId, address: address, phone: phone);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<RestaurantDetailsCubit, RestaurantDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                right: screenHeight * 0.02,
                top: screenHeight * 0.03,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    screenHeight * 0.02,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Enter Order Details',
                    //   style: Theme.of(context).textTheme.headline6?.copyWith(
                    //       fontWeight: FontWeight.bold,
                    //       color: Theme.of(context).primaryColor),
                    // ),
                    // const SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _addressController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Your Address',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: Theme.of(context).primaryColor, width: 2),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your address';
                    //     }
                    //     return null;
                    //   },
                    //   maxLines: null,
                    // ),
                    const SizedBox(height: 24),
                    TextFormField(
                      maxLines: null,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Your Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (state.status != RestaurantDetailsStates.loading) {
                            _submitOrder(widget.cartId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                        ),
                        child: state.status == RestaurantDetailsStates.loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Submit Order',
                                style: Styles.headerText(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
