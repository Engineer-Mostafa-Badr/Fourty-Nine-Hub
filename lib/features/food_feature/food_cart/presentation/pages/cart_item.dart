import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../restaurant_details/data/models/cart_model.dart';
import '../../../restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

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
              Container(
                decoration: BoxDecoration(
                  color:AppColors.getFillColor(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // align top
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: widget.foodImageUrl.isNotEmpty
                          ? Image.network(
                        widget.foodImageUrl,
                        width: 100,
                        height: localQuantity != widget.quantity ? 100 : 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: localQuantity != widget.quantity ? 100 : 70,
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
                        height: localQuantity != widget.quantity ? 100 : 70,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.foodName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${context.isArabic?(widget.totalPrice).toLocalizedArabic(context):(widget.totalPrice).toStringAsFixed(0)} ${widget.currency}' ,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _buildQuantityButton(
                                          icon: widget.quantity > 1
                                              ? Icons.remove
                                              : Icons.delete,
                                          color: widget.quantity > 1
                                              ? null
                                              : AppColors.SECONDARY_COLOR,
                                          onTap: () {
      ManageVibration.vibrate();
                                            setState(() {
                                              if ((localQuantity ?? 0) > 1) {
                                                localQuantity = (localQuantity ?? 1) - 1;
                                              }
                                              if (widget.quantity == 1) {
                                                widget.removeItem(
                                                  widget.cartItem.restaurant?.id ?? '',
                                                  widget.foodId,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '$localQuantity'.toArabicNumbers(context),
                                          style: Styles.headerText(),
                                        ),
                                        const SizedBox(width: 12),
                                        _buildQuantityButton(
                                          icon: Icons.add,
                                          onTap: () {
      ManageVibration.vibrate();
                                            setState(() {
                                              localQuantity = (localQuantity ?? 0) + 1;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (localQuantity != widget.quantity)
                              Padding(
                                padding:  EdgeInsetsDirectional.only(top: 10.0,end: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BadgedLabel(
                                      onTap: () {
      ManageVibration.vibrate();
                                        setState(() {
                                          _updateQuantity(
                                            restaurantId: widget.cartItem.restaurant?.id ?? '',
                                            mealId: widget.foodId,
                                            qtyChange: 1,
                                            currentQty: localQuantity ?? 0,
                                          );
                                        });
                                      },textColor: AppColors.getReversedTextColor(context),
                                      color: AppColors.getRedColor(context),
                                      label: LocaleKeys.confirm.localize,
                                    ),
                                    const SizedBox(width: 8),
                                    BadgedLabel(
                                      color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                      textColor:  context.isDarkMode ? AppColors.PRIMARY_COLOR :AppColors.whiteColor ,
                                      onTap: () {
      ManageVibration.vibrate();
                                        setState(() {
                                          localQuantity = widget.quantity;
                                        });
                                      },
                                      label: LocaleKeys.cancel.localize,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (localQuantity != widget.quantity) ...[
                const SizedBox(height: 8),
                Text(
                  '${LocaleKeys.confirmQuantity.localize} (${context.isArabic?(widget.quantity).toLocalizedArabic(context):widget.quantity}).',
                  style: Styles.mediumText(color: AppColors.getRedColor(context)),
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