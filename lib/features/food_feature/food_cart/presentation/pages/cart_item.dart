import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/cart_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BuildCartItem extends StatefulWidget {
  const BuildCartItem(
      {super.key,
      required this.foodImageUrl,
      required this.cartItem,
      required this.foodId,
      required this.foodName,
      required this.quantity,
      required this.totalPrice,
      required this.restaurantId,
      required this.currency,
      required this.removeItem});
  final String foodImageUrl;
  final CartItem cartItem;
  final String foodId;
  final String restaurantId;
  final String foodName;
  final int quantity;
  final double totalPrice;
  final String currency;
  final Function(String restaurantId, String foodId) removeItem;
  @override
  State<BuildCartItem> createState() => _BuildCartItemState();
}

class _BuildCartItemState extends State<BuildCartItem> {
  int? localQuantity;
  @override
  void initState() {
    localQuantity = widget.quantity;

    super.initState();
  }

  Future<void> _updateQuantity({
    required String restaurantId,
    required String mealId,
    required int qtyChange,
    required int currentQty,
  }) async {
    setState(() {});
    final newQty = currentQty + qtyChange;
    if (newQty < 0) return;

    await context.read<RestaurantDetailsCubit>().decrement(
          context,
          restaurantId: restaurantId,
          foodId: mealId,
          quantity: currentQty,
        );
    await context.read<RestaurantDetailsCubit>().fetchCart();
  }

  Future<void> _removeItem({
    required String restaurantId,
    required String foodId,
  }) async {
    await context.read<RestaurantDetailsCubit>().deleteFromCart(
          context,
          restaurantId: restaurantId,
          foodId: foodId,
        );
    await context.read<RestaurantDetailsCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
      return Column(
        children: [
          Card(
            color: cardDarkColor(context),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.foodImageUrl.isNotEmpty
                        ? Image.network(
                            widget.foodImageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
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
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.foodName,
                                      style: Styles.headerText(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.totalPrice.toStringAsFixed(2),
                                        style: Styles.headerText(),
                                      ),
                                      Text(
                                        ' ${widget.currency}',
                                        style: Styles.mediumText(
                                            color: AppColors.SECONDARY_COLOR,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _buildQuantityButton(
                                          icon: widget.quantity > 1
                                              ? Icons.remove
                                              : Icons.delete,
                                          color: widget.quantity > 1
                                              ? null
                                              : AppColors.SECONDARY_COLOR,
                                          onTap: () {
                                            setState(() {
                                              if ((localQuantity ?? 0) > 1) {
                                                localQuantity =
                                                    (localQuantity ?? 1) - 1;
                                              }
                                              if (widget.quantity == 1) {
                                                widget.removeItem(
                                                  widget.cartItem.restaurant
                                                          ?.id ??
                                                      '',
                                                  widget.foodId,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '$localQuantity',
                                          style: Styles.headerText(),
                                        ),
                                        const SizedBox(width: 12),
                                        _buildQuantityButton(
                                          icon: Icons.add,
                                          onTap: () {
                                            print("object");
                                            setState(() {
                                              localQuantity =
                                                  (localQuantity ?? 0) + 1;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (localQuantity != widget.quantity)
                                    Row(
                                      children: [
                                        BadgedLabel(
                                            onTap: () {
                                              setState(() {
                                                _updateQuantity(
                                                  restaurantId: widget.cartItem
                                                          .restaurant?.id ??
                                                      '',
                                                  mealId: widget.foodId,
                                                  qtyChange: 1,
                                                  currentQty: localQuantity !=
                                                          widget.quantity
                                                      ? localQuantity ?? 0
                                                      : widget.quantity,
                                                );
                                              });
                                            },
                                            color: AppColors.SECONDARY_COLOR,
                                            label: LocaleKeys.confirm.localize),
                                        const Sizer(),
                                        BadgedLabel(
                                            onTap: () {
                                              setState(() {
                                                localQuantity = widget.quantity;
                                              });
                                            },
                                            label: LocaleKeys.cancel.localize),
                                      ],
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (localQuantity != widget.quantity) ...[
            const SizedBox(height: 8),
            Text(
              'Press Confirm button to confirm the new quantity or we will take the old quantity (${widget.quantity}).',
              style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildQuantityButton(
      {required IconData icon, required VoidCallback onTap, Color? color}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }
}
