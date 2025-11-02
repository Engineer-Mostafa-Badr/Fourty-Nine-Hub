import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/restaurant_details_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../../restaurants_list/domain/entities/restaurant_menu.dart';

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
  int? lastCartQty; // Track last cart quantity to detect changes
  bool isAddingToCart = false;
  bool userIsEditing = false; // Track if user is currently editing quantity
  bool isInitialized = false; // Track if qty has been initialized from cart

  @override
  void initState() {
    super.initState();
    // Quantity will be initialized from cart in first build
  }

  // Helper method to get current quantity from cart
  int _getQuantityFromCart(RestaurantDetailsState state) {
    if (state.cart == null) return 0;

    for (var cartItem in state.cart!.allItems) {
      for (var restaurantItem in cartItem.restaurantItems) {
        if (restaurantItem.food?.id == widget.meal.id) {
          return restaurantItem.quantity;
        }
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
      buildWhen: (previous, current) {
        // Rebuild on any state change to catch cart updates
        return true;
      },
      builder: (context, state) {
        // Get current cart quantity
        final cartQty = _getQuantityFromCart(state);

        // Initialize qty from cart on first build (works even if cart is null/empty)
        if (!isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                qty = cartQty; // Will be 0 if cart is empty
                lastCartQty = cartQty;
                isInitialized = true;
              });
            }
          });
        }

        // Sync logic:
        // 1. Always sync with cart when not adding or editing
        // 2. Detect changes from cart_view by comparing with lastCartQty
        if (isInitialized && !isAddingToCart && !userIsEditing) {
          if (lastCartQty != cartQty) {
            // Cart changed (from cart_view or after our update), sync it
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  qty = cartQty;
                  lastCartQty = cartQty;
                });
              }
            });
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.getFillColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items to top
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.meal.picture != null &&
                          widget.meal.picture!.isNotEmpty
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.meal.foodName ?? 'Unknown',
                          style: Styles.mediumText(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatPrice(widget.meal.price ?? 0.0).toArabicNumbers(context)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w600,
                            color: qty > 0 ? Colors.grey : null,
                          ),
                        ),
                        // Total Price (shown when quantity > 0)
                        if (qty > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${LocaleKeys.total.localize}: ${_formatPrice((widget.meal.price ?? 0.0) * qty).toArabicNumbers(context)} ${context.isArabic ? 'ج.م' : 'EGP'}',
                            style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.getRedColor(context),
                            ),
                          ),
                        ],
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
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
                                  size: 25.sp,
                                  color: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.black),
                            ),
                            const SizedBox(width: 12),
                            Label(
                              text: '$qty'.toArabicNumbers(context),
                              style: TextStyle(
                                  fontSize: 16,
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
                                  size: 25.sp,
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
                          visible: qty > 0 &&
                              cartQty == 0, // Show only if item NOT in cart
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: GestureDetector(
                              onTap: isAddingToCart
                                  ? null
                                  : () {
                                      ManageVibration.vibrate();
                                      if (context.isUserLoggedIn) {
                                        _addToCart();
                                      } else {
                                        return pleaseLoginDialog(context);
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isAddingToCart
                                      ? AppColors.getRedColor(context)
                                          .withValues(alpha: 0.6)
                                      : AppColors.getRedColor(context),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: isAddingToCart
                                    ? SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppColors.getReversedTextColor(
                                                context),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        LocaleKeys.addToCart.localize,
                                        style: Styles.smallText(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                AppColors.getReversedTextColor(
                                                    context)),
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
      },
    );
  }

  void _addToCart() async {
    if (!mounted) return;

    setState(() {
      isAddingToCart = true;
    });

    final cubit = context.read<RestaurantDetailsCubit>();
    final success = await cubit.addToCart(
      context,
      restaurantId: widget.restaurantId,
      foodId: widget.meal.id ?? "",
      quantity: qty,
    );

    if (success && mounted) {
      // Fetch cart to update quantities across all items
      await cubit.fetchCart();
    }

    if (mounted) {
      setState(() {
        // Reset editing flag and update lastCartQty
        userIsEditing = false;
        isAddingToCart = false;
        lastCartQty = qty; // Update lastCartQty to current qty
      });
    }
  }

  void _decreaseQuantity() async {
    if (!mounted) return;

    final cubit = context.read<RestaurantDetailsCubit>();
    final cartQty = _getQuantityFromCart(cubit.state);

    if (cartQty > 0) {
      // Item exists in cart, update cart directly
      setState(() {
        userIsEditing = true;
        qty--;
      });

      if (qty == 0) {
        // Remove from cart
        await cubit.deleteFromCart(
          context,
          restaurantId: widget.restaurantId,
          foodId: widget.meal.id ?? "",
        );
      } else {
        // Update quantity in cart
        await cubit.decrement(
          context,
          restaurantId: widget.restaurantId,
          foodId: widget.meal.id ?? "",
          quantity: qty,
        );
      }

      if (mounted) {
        await cubit.fetchCart();
        setState(() {
          userIsEditing = false;
          lastCartQty = qty;
        });
      }
    } else {
      // Item not in cart, just decrease local qty
      if (qty > 0) {
        setState(() {
          userIsEditing = true;
          qty--;
        });
      }
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
    if (!mounted) return;

    final cubit = context.read<RestaurantDetailsCubit>();
    final cartQty = _getQuantityFromCart(cubit.state);

    if (cartQty > 0) {
      // Item exists in cart, update cart directly
      setState(() {
        userIsEditing = true;
        qty++;
      });

      // Update quantity in cart
      await cubit.addToCart(
        context,
        restaurantId: widget.restaurantId,
        foodId: widget.meal.id ?? "",
        quantity: 1, // Add 1 more
      );

      if (mounted) {
        await cubit.fetchCart();
        setState(() {
          userIsEditing = false;
          lastCartQty = qty;
        });
      }
    } else {
      // Item not in cart, just increase local qty
      setState(() {
        userIsEditing = true;
        qty++;
      });
    }
  }
}
