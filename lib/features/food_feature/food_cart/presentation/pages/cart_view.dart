import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'cart_item.dart';
import '../../../restaurant_details/data/models/cart_model.dart';
import '../../../restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart'; // Ensure correct path
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../RideFeature/presentation/pages/widgets/pickup_text_form_field.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../ads_feature/ads/presentation/widgets/request_button.dart';

// Helper functions (assuming these are defined elsewhere in your project)
Color scaffoldDarkColor(BuildContext context) {
  return context.isDarkMode ? Colors.white.withOpacity(0.09) : Colors.white;
}

Color cardDarkColor(BuildContext context, {bool isRestruantItem = false}) {
  return context.isDarkMode
      ? Colors.white.withOpacity(0.04)
      : isRestruantItem
          ? AppColors.PRIMARY_COLOR
          : Colors.white;
}

class FoodCartView extends StatefulWidget {
  const FoodCartView({super.key});

  @override
  State<FoodCartView> createState() => _FoodCartViewState();
}

class _FoodCartViewState extends State<FoodCartView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailsCubit>().fetchCart(first: true);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Future<void> _updateQuantity({
  //   required String restaurantId,
  //   required String mealId,
  //   required int qtyChange,
  //   required int currentQty,
  // }) async {
  //   setState(() {});
  //   final newQty = currentQty + qtyChange;
  //   if (newQty < 0) return;
  //
  //   await context.read<RestaurantDetailsCubit>().addToCart(
  //         context,
  //         restaurantId: restaurantId,
  //         foodId: mealId,
  //         quantity: 1,
  //       );
  //   await context.read<RestaurantDetailsCubit>().fetchCart();
  // }
  //
  // Future<void> _decrement({
  //   required String restaurantId,
  //   required String mealId,
  //   required int qtyChange,
  //   required int currentQty,
  // }) async {
  //   setState(() {});
  //   final newQty = currentQty - qtyChange;
  //   if (newQty < 0) return;
  //
  //   await context.read<RestaurantDetailsCubit>().decrement(
  //         context,
  //         restaurantId: restaurantId,
  //         foodId: mealId,
  //         quantity: newQty,
  //       );
  //   await context.read<RestaurantDetailsCubit>().fetchCart();
  // }
  //
  // Future<void> _deleteFromCart({
  //   required String restaurantId,
  //   required String mealId,
  // }) async {
  //   setState(() {});
  //
  //   await context.read<RestaurantDetailsCubit>().deleteFromCart(
  //         context,
  //         restaurantId: restaurantId,
  //         foodId: mealId,
  //       );
  //   if (context.read<RestaurantDetailsCubit>().state.cart?.allItems.length ==
  //       1) {
  //     context.pop();
  //   } else {
  //     await context.read<RestaurantDetailsCubit>().fetchCart();
  //   }
  // }

  Future<void> _removeItem({
    required String restaurantId,
    required String foodId,
  }) async {
    if (!mounted) return;

    final cubit = context.read<RestaurantDetailsCubit>();
    final isLastItem = cubit.state.cart?.allItems.length == 1 &&
        cubit.state.cart?.allItems.first.restaurantItems.length == 1;

    await cubit.deleteFromCart(
          context,
          restaurantId: restaurantId,
          foodId: foodId,
        );

    if (mounted) {
      await cubit.fetchCart();

      if (isLastItem && mounted) {
        context.pop();
      }
    }
  }

  void _showFoodRequestBottomSheet({
    required String cartId,
    required String orderType,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isDismissible: true,
      builder: (buildContext) {
        return BlocProvider.value(
          value: serviceLocator<RestaurantDetailsCubit>(),
          child: BlocConsumer<RestaurantDetailsCubit, RestaurantDetailsState>(
            listener: (context, state) {
              if (state.status == RestaurantDetailsStates.success) {
                Navigator.pop(buildContext);
                _phoneController.clear();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(
                //       context.isArabic
                //           ? 'تم إرسال الطلب بنجاح'
                //           : 'Order sent successfully',
                //     ),
                //     backgroundColor: Colors.green,
                //   ),
                // );
              } else if (state.status == RestaurantDetailsStates.error) {
                Navigator.pop(buildContext);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(
                //       context.isArabic
                //           ? 'حدث خطأ، حاول مرة أخرى'
                //           : 'An error occurred, please try again',
                //     ),
                //     backgroundColor: Colors.red,
                //   ),
                // );
              }
            },
            builder: (context, state) {
              return RequestNumberBottomSheet(
                formKey: _formKey,
                textController: _phoneController,
                onChanged: (value) {},
                isLoading: state.status == RestaurantDetailsStates.loading,
                onTap: () async {
                  ManageVibration.vibrate();
                  if (_formKey.currentState!.validate()) {
                    // Clean the phone number before sending
                    final phone = _phoneController.text
                        .trim()
                        .replaceAll(' ', '')
                        .replaceAll('-', '')
                        .replaceAll('+20', '')
                        .replaceAll('(', '')
                        .replaceAll(')', '');

                    if (orderType == 'premium') {
                      await context
                          .read<RestaurantDetailsCubit>()
                          .createPremiumOrder(
                            context,
                            cartId: cartId,
                            phone: phone,
                            address: '',
                          );
                    } else if (orderType == 'normal') {
                      await context
                          .read<RestaurantDetailsCubit>()
                          .createNormalOrder(
                            context,
                            cartId: cartId,
                            phone: phone,
                            address: '',
                          );
                    }
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // backgroundColor: scaffoldDarkColor(context),
      enableCustomAppBar: true,
      appBar: _buildAppBar(),
      body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          } else if (state.cart != null && state.cart!.allItems.isNotEmpty) {
            // return Text("hi wwwwwwwwwwwwwwwwwwwwwwwwwwww");
            return _buildCartContent(state.cart!);
          } else {
            return CustomEmptyWidget(
              label: context.isArabic
                  ? 'السلة فارغة'
                  : LocaleKeys.your_cart_empty.tr(),
            );
          }
        },
      ),
    );
  }

  _buildAppBar() {
    return BackAppBar(
      label: context.isArabic ? 'السلة' : 'Cart',
    );
  }

  Widget _buildCartContent(Cart cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            itemCount: cart.allItems.length,
            itemBuilder: (context, index) {
              final cartItem = cart.allItems[index];
              return _buildCartItem(cartItem,
                  context.isArabic ? cart.currencyAr : cart.currencyEn);
            },
          ),
        ),
        const Divider(),
        _buildCartSummary(
            cart, context.isArabic ? cart.currencyAr : cart.currencyEn),
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
        Row(
          children: [
            ClipOval(
              child: Image.network(
                cartItem.restaurant?.restaurantMedia.first.mediaKey ?? "",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported,
                        size: 20, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              restaurantName,
              style: Styles.headerText(),
            ),
          ],
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
          alignment:
              context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${LocaleKeys.restaurant_total.tr()} ${context.isArabic ? (cartItem.total).toLocalizedArabic(context) : (cartItem.total).toStringAsFixed(0)} $currency',
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

    final foodName = food.foodName;
    final foodId = food.id;
    final String foodImageUrl = food.picture.mediaKey;
    final quantity = item.quantity;
    final totalPrice = item.price;

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
              backgroundColor: AppColors.getRedColor(context),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: context.isArabic ? 'تأكيد المسح؟' : 'Confirm Delete?',
            ),
          ],
        ),
        child: BuildCartItem(
          foodImageUrl: foodImageUrl,
          quantity: quantity,
          currency: currency,
          cartItem: cartItem,
          foodId: foodId,
          foodName: foodName,
          totalPrice: totalPrice,
          restaurantId: cartItem.restaurant?.id ?? '',
          removeItem: (String restaurantId, String foodId) =>
              _removeItem(restaurantId: restaurantId, foodId: foodId),
        ),
      ),
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
              context.isArabic
                  ? (subTotal ?? 0.0).toLocalizedArabic(context)
                  : (subTotal ?? 0.0).toStringAsFixed(0),
              style: Styles.headerText(),
            ),
            Text(
              ' $currency',
              style: Styles.mediumText(
                  color: AppColors.getRedColor(context),
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
              ManageVibration.vibrate();
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
              backgroundColor: AppColors.getRedColor(context),
            ),
            child: FittedBox(
              child: Text(
                LocaleKeys.premium_request.tr(),
                style: Styles.headerText(
                    color: AppColors.getReversedTextColor(context)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ManageVibration.vibrate();
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
              backgroundColor: AppColors.getButtonPrimaryColor(context),
            ),
            child: FittedBox(
              child: Text(
                LocaleKeys.request.tr(),
                style: Styles.headerText(
                    color: AppColors.getReversedTextColor(context)),
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
  final FocusNode _focusNode = FocusNode();
  bool? isChecked;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!mounted) return;

      // Clean the phone number before sending
      final phone = _phoneController.text
          .trim()
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('+20', '')
          .replaceAll('(', '')
          .replaceAll(')', '');

      final cubit = context.read<RestaurantDetailsCubit>();
      final currentContext = context;

      if (widget.orderType == 'premium') {
        await cubit.createPremiumOrder(
              currentContext,
              cartId: widget.cartId,
              phone: phone,
              address: '',
            );
      } else if (widget.orderType == 'normal') {
        await cubit.createNormalOrder(
              currentContext,
              cartId: widget.cartId,
              phone: phone,
              address: '',
            );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDetailsCubit, RestaurantDetailsState>(
      listener: (context, state) {
        // Handle state changes if necessary
      },
      builder: (context, state) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      ManageVibration.vibrate();
                      _focusNode.unfocus();
                      context.pop();
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD9D9D9),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Checkbox(
                          checkColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: isChecked ?? false,
                          activeColor: AppColors.PRIMARY_COLOR,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value ?? true;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Label(
                        text: context.isArabic
                            ? 'الرجاء إدخال رقم تواصل مباشر مع مقدم الخدمة'
                            : "Please enter a direct contact number for the service provider.",
                        style: Styles.mediumText(
                          color: AppColors.c717171,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Sizer(height: 16.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 180.h),
                  child: Form(
                    key: _formKey,
                    child: PickUpTextFormField(
                      controller: _phoneController,
                      focusNode: _focusNode,
                      onChanged: (value) {},
                      fillColor: AppColors.getFillColor(context),
                      textColor: AppColors.getTextColor(context),
                      hintText: LocaleKeys.phoneNumber.localize,
                      fieldType: FieldType.phone,
                      validator: (value) => validatorPhone(value),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Label(
                  text: context.isArabic
                      ? "كتابة رقم عميل آخر علي مسؤوليتك و يعرض للمسائله القانونيه."
                      : "Entering another customer's number is at your own risk and may subject you to legal liability.",
                  style: Styles.mediumText(
                    color: AppColors.c717171,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                state.status == RestaurantDetailsStates.loading
                    ? const CustomCircularProgressIndicator()
                    : InkWell(
                        onTap: _submitOrder,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.getButtonPrimaryColor(context),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Label(
                            text: LocaleKeys.submit_order.localize,
                            style: Styles.headerText(
                              color: AppColors.getReversedTextColor(context),
                            ),
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
