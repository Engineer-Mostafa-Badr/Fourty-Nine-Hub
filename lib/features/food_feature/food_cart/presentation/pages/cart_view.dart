import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/cart_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../core/localization/locale_keys.g.dart'; // Ensure correct path

// Helper functions (assuming these are defined elsewhere in your project)
Color scaffoldDarkColor(BuildContext context) {
  return context.isDarkMode ? Colors.white.withOpacity(0.09) : Colors.white;
}

Color cardDarkColor(BuildContext context) {
  return context.isDarkMode ? Colors.white.withOpacity(0.04) : Colors.white;
}

class FoodCartView extends StatefulWidget {
  const FoodCartView({super.key});

  @override
  State<FoodCartView> createState() => _FoodCartViewState();
}

class _FoodCartViewState extends State<FoodCartView> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailsCubit>().fetchCart();
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

    await context.read<RestaurantDetailsCubit>().addToCart(
          context,
          restaurantId: restaurantId,
          foodId: mealId,
          quantity: newQty.toString(),
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

  void _showFoodRequestBottomSheet({
    required String cartId,
    required String orderType,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
      builder: (context) {
        return BlocProvider.value(
          value: serviceLocator<RestaurantDetailsCubit>(),
          child: FoodRequestBottomSheet(
            cartId: cartId,
            orderType: orderType,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldDarkColor(context),
      appBar: _buildAppBar(),
      body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
          if (state.cart != null && state.cart!.allItems.isNotEmpty) {
            return _buildCartContent(state.cart!);
          } else {
            return Center(
              child: Text(
                LocaleKeys.your_cart_empty.tr(),
                style: Styles.headerText(),
              ),
            );
          }
        },
      ),
    );
  }

  _buildAppBar() {
    return BackAppBar(
      label: LocaleKeys.your_cart.tr(),
    );
    //   AppBar(
    //   title: const Text(
    //     'Your Cart',
    //     style: TextStyle(fontSize: 20),
    //   ),
    //   elevation: 0,
    //   backgroundColor: Colors.transparent,
    //   foregroundColor: Colors.black,
    //   actions: const [
    //     Icon(
    //       FontAwesomeIcons.cartShopping,
    //       size: 24,
    //     ),
    //     SizedBox(width: 16),
    //   ],
    // );
  }

  Widget _buildCartContent(Cart cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: cart.allItems.length,
            itemBuilder: (context, index) {
              final cartItem = cart.allItems[index];
              return _buildCartItem(cartItem, cart.currency);
            },
          ),
        ),
        const Divider(),
        _buildCartSummary(cart, cart.currency),
      ],
    );
  }

  Widget _buildCartItem(CartItem cartItem, String currency) {
    final restaurantName =
        cartItem.restaurant?.name ?? LocaleKeys.unknownRestaurant.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          restaurantName,
          style: Styles.headerText(),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItem.restaurantItems.length,
          itemBuilder: (context, itemIndex) {
            final item = cartItem.restaurantItems[itemIndex];
            return _buildRestaurantItem(cartItem, item, currency);
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${LocaleKeys.restaurant_total.tr()} ${cartItem.total.toStringAsFixed(2)}',
              style: Styles.headerText(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantItem(
      CartItem cartItem, RestaurantItem item, String currency) {
    final food = item.food;
    if (food == null) return const SizedBox();

    final foodName = food.foodName ?? LocaleKeys.unknownFood.tr();
    final foodId = food.id ?? '';
    final String foodImageUrl = food.picture.mediaKey ?? '';
    final quantity = item.quantity ?? 0;
    final totalPrice = item.totalPriceOfItem ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        key: ValueKey(foodId),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                _removeItem(
                  restaurantId: cartItem.restaurant?.id ?? '',
                  foodId: foodId,
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: LocaleKeys.delete.tr(),
            ),
          ],
        ),
        child: Card(
          color: cardDarkColor(context),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.2),
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
                _buildFoodImage(foodImageUrl.toString()),
                const SizedBox(width: 12),
                _buildItemDetails(
                  cartItem,
                  foodId,
                  foodName,
                  quantity,
                  currency,
                ),
                _buildItemPrice(totalPrice, currency),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _placeholderImage();
              },
            )
          : _placeholderImage(),
    );
  }

  Widget _placeholderImage() {
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
  }

  Widget _buildItemDetails(
    CartItem cartItem,
    String foodId,
    String foodName,
    int quantity,
    String currency,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            foodName,
            style: Styles.headerText(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onTap: () {
                  setState(() {
                    _updateQuantity(
                      restaurantId: cartItem.restaurant?.id ?? '',
                      mealId: foodId,
                      qtyChange: -1,
                      currentQty: quantity,
                    );
                  });
                },
              ),
              const SizedBox(width: 12),
              Text(
                '$quantity',
                style: Styles.headerText(),
              ),
              const SizedBox(width: 12),
              _buildQuantityButton(
                icon: Icons.add,
                onTap: () {
                  setState(() {
                    _updateQuantity(
                      restaurantId: cartItem.restaurant?.id ?? '',
                      mealId: foodId,
                      qtyChange: 1,
                      currentQty: quantity,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
        ),
      ),
    );
  }

  Widget _buildItemPrice(double totalPrice, String currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              totalPrice.toStringAsFixed(2),
              style: Styles.headerText(),
            ),
            Text(
              ' $currency',
              style: Styles.mediumText(
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCartSummary(Cart cart, String currency) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildSubtotalRow(cart.subTotal, currency),
          const SizedBox(height: 16),
          _buildActionButtons(cart.id),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSubtotalRow(double? subTotal, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${LocaleKeys.total.tr()}:',
          style: Styles.headerText(),
        ),
        Row(
          children: [
            Text(
              (subTotal ?? 0.0).toStringAsFixed(2),
              style: Styles.headerText(),
            ),
            Text(
              ' $currency',
              style: Styles.mediumText(
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(String cartId) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showFoodRequestBottomSheet(
                cartId: cartId,
                orderType: 'premium',
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: AppColors.SECONDARY_COLOR,
            ),
            child: FittedBox(
              child: Text(
                LocaleKeys.premium_request.tr(),
                style: Styles.headerText(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showFoodRequestBottomSheet(
                cartId: cartId,
                orderType: 'normal',
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: AppColors.PRIMARY_COLOR,
            ),
            child: FittedBox(
              child: Text(
                LocaleKeys.request.tr(),
                style: Styles.headerText(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FoodRequestBottomSheet extends StatefulWidget {
  final String cartId;
  final String orderType;

  const FoodRequestBottomSheet({
    super.key,
    required this.cartId,
    required this.orderType,
  });

  @override
  State<FoodRequestBottomSheet> createState() => _FoodRequestBottomSheetState();
}

class _FoodRequestBottomSheetState extends State<FoodRequestBottomSheet> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim();

      if (widget.orderType == 'premium') {
        await context.read<RestaurantDetailsCubit>().createPremiumOrder(
              context,
              cartId: widget.cartId,
              phone: phone,
              address: '',
            );
      } else if (widget.orderType == 'normal') {
        await context.read<RestaurantDetailsCubit>().createNormalOrder(
              context,
              cartId: widget.cartId,
              phone: phone,
              address: '',
            );
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDetailsCubit, RestaurantDetailsState>(
      listener: (context, state) {
        // Handle state changes if necessary
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.your_phone_number.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.please_enter_phone_number.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.status != RestaurantDetailsStates.loading
                        ? _submitOrder
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                            LocaleKeys.submit_order.tr(),
                            style: Styles.headerText(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
