import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/restaurant_details_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';

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
  Widget build(BuildContext context) {
    context.read<RestaurantDetailsCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getFillColor(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to top
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
                  widget.meal.picture != null && widget.meal.picture!.isNotEmpty
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
                padding: const EdgeInsets.only(
                    top: 8), // Align with quantity controls
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.foodName ?? 'Unknown',
                      style: Styles.mediumText(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatPrice(widget.meal.price ?? 0.0).toArabicNumbers(context)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsetsDirectional.only(top: 8, end: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quantity Container
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.black),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          // ManageVibration.vibrate();
                          onTap: () {
                            ManageVibration.vibrate();
                            (widget.fromUpdate ?? false)
                                ? null
                                : _decreaseQuantity();
                          },

                          child: Icon(Icons.remove,
                              size: 20.sp,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.black),
                        ),
                        const SizedBox(width: 12),
                        Label(
                          text: '$qty'.toArabicNumbers(context),
                          style: TextStyle(
                              fontSize: 12,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.black),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            ManageVibration.vibrate();
                            (widget.fromUpdate ?? false)
                                ? null
                                : _increaseQuantity();
                          },
                          child: Icon(Icons.add,
                              size: 20.sp,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    child: Visibility(
                      visible: qty > 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: GestureDetector(
                          onTap: () {
                            ManageVibration.vibrate();
                            if (context.isUserLoggedIn) {
                              _addToCart();
                            } else {
                              return pleaseLoginDialog(context);

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.localize,
                              //       style: Styles.smallText(
                              //         color: AppColors.whiteColor
                              //       ),
                              //     ),
                              //     backgroundColor: Colors.red,
                              //     duration: Duration(seconds: 4),
                              //     action: SnackBarAction(
                              //       label: LocaleKeys.login.localize,
                              //       textColor: Colors.white,
                              //       onPressed: () {
                              ManageVibration.vibrate();
                              //        // context.pushNamed(Routes.LOGIN);
                              //       },
                              //     ),
                              //   ),
                              // );
                              // context.pushNamed(Routes.LOGIN);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.getRedColor(context),
                              borderRadius: BorderRadius.circular(15),
                              // border: Border.all(color: AppColors.LIGHT_COLOR),
                            ),
                            child: Text(
                              LocaleKeys.addToCart.localize,
                              style: Styles.smallText(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppColors.getReversedTextColor(context)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (qty > 0)
                    SizedBox(
                      height: 6,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize quantity if needed
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

  String _formatPrice(double price) {
    if (price % 1 == 0) {
      return price.toStringAsFixed(0); // No decimal part
    } else {
      return price.toStringAsFixed(2); // Show up to 2 decimals
    }
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
}
