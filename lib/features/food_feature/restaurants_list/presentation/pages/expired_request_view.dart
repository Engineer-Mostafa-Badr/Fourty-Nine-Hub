import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../cubit/restaurants_list_cubit.dart';

class RestaurantExpiredRequestsScreen extends StatefulWidget {
  const RestaurantExpiredRequestsScreen({super.key});

  @override
  State<RestaurantExpiredRequestsScreen> createState() => _RestaurantExpiredRequestsScreenState();
}

class _RestaurantExpiredRequestsScreenState extends State<RestaurantExpiredRequestsScreen> {

  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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

    return Scaffold(
      backgroundColor: scaffoldDarkColor(context),
      appBar: BackAppBar(
        label: LocaleKeys.expiredRequests.tr(),
      ),
      body: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
    builder: (context, state) {
      final controller = context.read<RestaurantsCubit>();

      if(!state.isLoading){
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: controller.expiredOrders.length,
                itemBuilder: (context, index) {
                  final request = controller.expiredOrders[index];
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
            if(controller.isLoadingExpiredOrdersMore) const Center(child: CircularProgressIndicator(),)
          ],
        );
      }else{
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }),
    );
  }
}

class TripRequestCard extends StatelessWidget {
  final OrderData orderData;

  const TripRequestCard({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return orderData.user != null ||
            orderData.user!.id!.isNotEmpty ||
            orderData.restaurant != null ||
            orderData.restaurant!.id!.isNotEmpty
        ? Card(
            elevation: context.isDarkMode ? 0 : 2,
            color: cardDarkColor(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildFooter(context),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 65.w,
          backgroundColor: Colors.grey[600],
          backgroundImage: AssetImage(_getGenderImage(orderData.user)),
        ),
        SizedBox(width: 16.h),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserName(),
              const SizedBox(height: 50),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Center(child: _buildRestaurantDetails(context)),
        ),
      ],
    );
  }

  Widget _buildUserName() {
    return Text(
      capitalizeAndSplit2Only(
          orderData.user?.firstName ?? LocaleKeys.noName.tr()),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
            capitalizeAndSplit2Only(orderData.restaurant?.name ??
                LocaleKeys.unknownRestaurant.tr()),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Styles.headerText()),
        if (orderData.restaurant?.subcategory != null)
          Text(
              context.isArabic
                  ? orderData.restaurant!.subcategory!.nameAr.toString()
                  : capitalizeAndSplit2Only(
                      orderData.restaurant!.subcategory!.nameEn ?? ''),
              style: Styles.headerText()),
        _buildFoodDetails(),
        _buildTotalAndCurrency(),
      ],
    );
  }

  Widget _buildFoodDetails() {
    if (orderData.orders == null || orderData.orders!.isEmpty) {
      return Text(
        LocaleKeys.noOrders.tr(),
        style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
      );
    }

    final foodList = orderData.orders!
        .map((order) => order.food?.foodName ?? LocaleKeys.unknownFood.tr())
        .toList();

    return Text(
      foodList.length > 1 ? "${foodList[0]}, ${foodList[1]}" : foodList[0],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Styles.headerText(),
    );
  }

  Widget _buildTotalAndCurrency() {
    return Row(
      children: [
        Text(
          "${LocaleKeys.total.tr()}: ",
          style: Styles.headerText(),
        ),
        const Spacer(),
        Text(
          orderData.total?.toString() ?? '0',
          style: Styles.headerText(),
        ),
        Text(
          " ${orderData.currency ?? ''}",
          style: Styles.mediumText(
              color: AppColors.SECONDARY_COLOR, fontWeight: FontWeight.bold),
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
          style: Styles.mediumText(
            fontWeight: FontWeight.normal,
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            orderData.subscriptionType?.toString() ??
                LocaleKeys.noSubscription.tr(),
            style: Styles.headerText(
              color: AppColors.SECONDARY_COLOR_DARK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _getGenderImage(User? user) {
    if (user == null) return Assets.maleImagePlaceholder; // Default image
    return user.gender == 'male'
        ? Assets.maleImagePlaceholder
        : Assets.femaleImagePlacehlder;
  }
}
