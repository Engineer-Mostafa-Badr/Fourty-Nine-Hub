import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/user_order_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/restaurants_list_cubit.dart';

class UserOrderRequestScreen extends StatefulWidget {
  const  UserOrderRequestScreen({super.key, this.onClose});
  final VoidCallback? onClose; // Callback to hide search UI

  @override
  State<UserOrderRequestScreen> createState() =>
      _UserOrderRequestScreenState();
}

class _UserOrderRequestScreenState
    extends State<UserOrderRequestScreen> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantsCubit>().getExpiredOrders();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
          final controller = context.read<RestaurantsCubit>();

          if (!state.isLoading) {
            return SizedBox(
              height:MediaQuery.sizeOf(context).height * .8,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: controller.expiredOrders.length,
                      itemBuilder: (context, index) {
                        final request = controller.userOrders[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TripRequestCard(orderData: request),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Sizer();
                      },
                    ),
                  ),
                  if (controller.isLoadingExpiredOrdersMore)
                    const Center(
                      child: CustomCircularProgressIndicator(),
                    )
                ],
              ),
            );
          } else {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }
        });
  }
}

class TripRequestCard extends StatelessWidget {
  final UserOrderEntity orderData;

  const TripRequestCard({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    if (orderData.user?.id?.isNotEmpty != true || orderData.id?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userImage = orderData.user?.profile?.profilePictureKey;

    return Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey[600],
              backgroundImage: userImage != null
                  ? NetworkImage(userImage)
                  : AssetImage(Assets.maleImagePlaceholder) as ImageProvider,
            ),
            Container(
              width: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 10, color: AppColors.ACCENT_COLOR),
                  SizedBox(width: 2),
                  Text(
                    '4.5',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: capitalizeAndSplit2Only(
                  orderData.user?.firstName ?? LocaleKeys.noName.tr(),
                ),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRestaurantDetails(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    final restaurant = orderData.restaurants?.first.restaurant;
    final foodItems = orderData.restaurants?.first.orders
        ?.map((o) => o.food ?? LocaleKeys.unknownFood.tr())
        .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeAndSplit2Only(restaurant?.name ?? LocaleKeys.unknownRestaurant.tr()),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        if (foodItems.isNotEmpty)
          // Text(
          //   foodItems.length > 1
          //       ? "${foodItems[0]}, ${foodItems[1]}"
          //       : foodItems[0],
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          // ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              "${LocaleKeys.total.tr()}: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "${orderData.subTotal ?? 0} ${orderData.currencyEn ?? ''}",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Text(
          orderData.createdAt != null
              ? DateFormat('MMM d, yyyy h:mm a').format(orderData.createdAt!)
              : LocaleKeys.noDate.tr(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          orderData.isPremium == true ? LocaleKeys.premium.tr() : LocaleKeys.noSubscription.tr(),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.SECONDARY_COLOR_DARK,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
