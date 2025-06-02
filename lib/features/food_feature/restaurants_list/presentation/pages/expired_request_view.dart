import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/restaurants_list_cubit.dart';

class RestaurantExpiredRequestsScreen extends StatefulWidget {
  const  RestaurantExpiredRequestsScreen({super.key, this.onClose});
  final VoidCallback? onClose; // Callback to hide search UI

  @override
  State<RestaurantExpiredRequestsScreen> createState() =>
      _RestaurantExpiredRequestsScreenState();
}

class _RestaurantExpiredRequestsScreenState
    extends State<RestaurantExpiredRequestsScreen> {
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

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       backgroundColor: scaffoldDarkColor(context),
//       appBar: BackAppBar(
//         label: LocaleKeys.expiredRequests.tr(),
//       ),
//       body: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
//           builder: (context, state) {
//         final controller = context.read<RestaurantsCubit>();
//
//         if (!state.isLoading) {
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.separated(
//                   controller: _scrollController,
//                   itemCount: controller.expiredOrders.length,
//                   itemBuilder: (context, index) {
//                     final request = controller.expiredOrders[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: TripRequestCard(orderData: request),
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return const Sizer();
//                   },
//                 ),
//               ),
//               if (controller.isLoadingExpiredOrdersMore)
//                 const Center(
//                   child: CustomCircularProgressIndicator(),
//                 )
//             ],
//           );
//         } else {
//           return const Center(
//             child: CustomCircularProgressIndicator(),
//           );
//         }
//       }),
//     );
//   }
// }
@override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
          final controller = context.read<RestaurantsCubit>();
          if (!state.isLoading) {
            if(controller.expiredOrders.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * .65, // Make sure it takes up full height
                child:CustomEmptyWidget(label: LocaleKeys.thereNoItems.localize) ,
              );
            } else {
              return SizedBox(
              // height:double.minPositive,
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // controller: _scrollController,
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
                  if (controller.isLoadingExpiredOrdersMore)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .65, // Make sure it takes up full height
                      child: const Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            );
            }
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .65, // Make sure it takes up full height
              child: const Center(
                child: CustomCircularProgressIndicator(),
              ),
            );
          }
        });
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
        ? Container(
            // elevation: context.isDarkMode ? 0 : 2,
           decoration: BoxDecoration(
             // color: cardDarkColor(context),
             border: Border.all(
               color:AppColors.getTextColor(context),
             ),
             borderRadius: BorderRadius.circular(15)
           ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:14.0),
              child:CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[600],
                backgroundImage:
                orderData.user?.userProfile?.profilePictureKey !=
                    null
                    ? NetworkImage(orderData.user?.userProfile?.profilePictureKey?.mediaKey??'')
                    : null,
                child: orderData.user?.userProfile?.profilePictureKey ==
                    null
                    ? const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                )
                    : null,
              ),
            ),
            Container(
              width: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(10),
                // shape: BoxShape.circle,
              ),
              child:  Row(
                children: [
                  Icon(Icons.star,size: 6.6,color: AppColors.ACCENT_COLOR,),
                  Text(
                    context.isArabic?numAr(4.5):'4.5',
                    style: Styles.smallText(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: 8.h),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserName(context),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Center(child: _buildRestaurantDetails(context)),
        ),
      ],
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Label(
     text:  capitalizeAndSplit2Only(
          orderData.user?.firstName ?? LocaleKeys.noName.tr()),
      style: Styles.mediumText(
        fontWeight: FontWeight.w600,
        color:AppColors.getTextColor(context),
      ),
      maxLines: 2,
      textAlign: TextAlign.start,
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
          style: Styles.mediumText(
            fontWeight: FontWeight.w700,
            color:AppColors.getTextColor(context),

          ),),
        if (orderData.restaurant?.subcategory != null)
          Text(
              context.isArabic
                  ? orderData.restaurant!.subcategory!.nameAr.toString()
                  : capitalizeAndSplit2Only(
                      orderData.restaurant!.subcategory!.nameEn ?? ''),
            style: Styles.mediumText(
              fontWeight: FontWeight.w700,
              color:AppColors.getTextColor(context),

            ),
          ),
        _buildFoodDetails(context),
        _buildTotalAndCurrency(context),
      ],
    );
  }

  Widget _buildFoodDetails(BuildContext context) {
    if (orderData.orders == null || orderData.orders!.isEmpty) {
      return Text(
        LocaleKeys.noOrders.tr(),
        style: Styles.headerText(color: AppColors.getRedColor(context)),
      );
    }

    final foodList = orderData.orders!
        .map((order) => order.food?.foodName ?? LocaleKeys.unknownFood.tr())
        .toList();

    return Text(
      foodList.length > 1 ? "${foodList[0]}, ${foodList[1]}" : foodList[0],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Styles.mediumText(
        fontWeight: FontWeight.w700,
        color:AppColors.getTextColor(context),
      ),
    );
  }

  Widget _buildTotalAndCurrency(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
                "${context.isArabic?numAr(orderData.total??0):orderData.total?.toString() ?? '0'}"
                " ${context.isArabic ? orderData.currencyAr
                : orderData.currencyEn ?? ''}",
            style: Styles.mediumText(
              fontWeight: FontWeight.w700,
              color:AppColors.getTextColor(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

  }

  String getSubscriptionType(String? subscriptionType) {
    final normalizedType = subscriptionType?.trim().toLowerCase();

    // 'Premium subscription': 2
    // 'Regular subscription': 1
    // 'No subscription': 0
    switch (normalizedType) {
      case ('no subscription'):
        return LocaleKeys.notSubscribed.localize;
      case ('premium subscription'):
        return LocaleKeys.premium2.localize;
      case ('regular subscription'):
        return LocaleKeys.regular.localize;
      default:
        return 'N/A';
    }
  }


  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderData.createdAt != null
              ? (context.isArabic?DateFormat('d MMM, yyyy h:mm a','ar').format(orderData.createdAt!):DateFormat('MMM d, yyyy h:mm a').format(orderData.createdAt!))
              : LocaleKeys.noDate.tr(),
          style: Styles.smallText(
            fontWeight: FontWeight.w600,
            color:AppColors.getTextColor(context),

          ),
        ),
        const Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            (getSubscriptionType(orderData.subscriptionType?.en))
                ?? LocaleKeys.notSubscribed.tr(),
            style: Styles.smallText(
              color: AppColors.getRedColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),

        ),
      ],
    );
  }

  String _getGenderImage(User? user) {
    if (user == null) return Assets.maleImagePlaceholder;
    return user.gender == 'male'
        ? Assets.maleImagePlaceholder
        : Assets.femaleImagePlacehlder;
  }
}
