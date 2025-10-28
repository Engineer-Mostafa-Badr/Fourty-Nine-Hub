import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../data/models/expired_requests_model.dart';
import '../../../../social_media/tinder/data/shared/shared.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../cubit/restaurants_list_cubit.dart';

class RestaurantExpiredRequestsScreen extends StatefulWidget {
  const RestaurantExpiredRequestsScreen({super.key, this.onClose});

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
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent - 200) {
    //   context.read<RestaurantsCubit>().getExpiredOrders();
    // }
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
        if (controller.expiredOrders.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height *
                .65, // Make sure it takes up full height
            child: CustomEmptyWidget(label: LocaleKeys.thereNoItems.localize),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: OlxPaginationWidget(
              scrollController: _scrollController,
              itemsPerPage: 2,
              loadPage: (page) async {},
              banners: bannersList,
              items: List.generate(
                controller.expiredOrders.length,
                (index) {
                  if (controller.isLoadingExpiredOrdersMore) {
                    return CustomLoadingSearchWidget();
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height *
                    //       .65, // Make sure it takes up full height
                    //   child: const Center(
                    //     child: CustomCircularProgressIndicator(),
                    //   ),
                    // );
                  }
                  final request = controller.expiredOrders[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TripRequestCard(orderData: request),
                  );
                },
              ),
            ),
          );
        }
      } else {
        return CustomLoadingSearchWidget();
        // SizedBox(
        //   height: MediaQuery.of(context).size.height *
        //       .65, // Make sure it takes up full height
        //   child: const Center(
        //     child: CustomCircularProgressIndicator(),
        //   ),
        // );
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
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.getTextColor(context),
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Subscription Type and Subcategory at top
                  Row(
                    children: [
                      if (orderData.restaurant?.subcategory != null)
                        Expanded(
                          child: Text(
                            context.isArabic
                                ? orderData.restaurant!.subcategory!.nameAr
                                    .toString()
                                : capitalizeAndSplit2Only(
                                    orderData.restaurant!.subcategory!.nameEn ??
                                        ''),
                            style: Styles.mediumText(
                              fontWeight: FontWeight.w600,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor.withValues(alpha: 0.8)
                                  : AppColors.black.withValues(alpha: 0.8),
                              fontSize: 30,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      // Expired Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.getRedColor(context)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.getRedColor(context)
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              size: 16,
                              color: AppColors.getRedColor(context),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.isArabic
                                  ? 'طلب منتهي'
                                  : 'Expired Request',
                              style: Styles.smallText(
                                fontWeight: FontWeight.w700,
                                color: AppColors.getRedColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      Text(
                        getSubscriptionType(orderData.subscriptionType?.en),
                        style: Styles.headerText(
                            color: AppColors.getRedColor(context),
                            fontSize: 32),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildHeader(context),
                  _buildFooter(context),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // User Info Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            ImageFromInternet(
              image: '',
              width: 70,
              height: 70,
              isCircle: true,
              isMale: orderData.user?.gender?.toLowerCase() == 'male',
              defaultLogo: false,
              fit: BoxFit.cover,
              charPadding: 1,
              firstChar: orderData.user?.firstName?.isNotEmpty == true
                  ? orderData.user!.firstName![0].toUpperCase()
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon(
                  //   Icons.person_outline,
                  //   size: 18,
                  //   color: context.isDarkMode
                  //       ? AppColors.whiteColor.withValues(alpha: 0.7)
                  //       : AppColors.black.withValues(alpha: 0.7),
                  // ),
                  // const SizedBox(width: 6),
                  _buildUserName(context),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
        // Restaurant Info Section
        _buildRestaurantDetails(context),
      ],
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Label(
      text: capitalizeAndSplit2Only(
          orderData.user?.firstName ?? LocaleKeys.noName.tr()),
      style: Styles.mediumText(
        fontWeight: FontWeight.w600,
        color: AppColors.getTextColor(context),
      ),
      maxLines: 2,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Restaurant Name with Icon and Rating
        Row(
          children: [
            Icon(
              Icons.restaurant,
              size: 20,
              color: context.isDarkMode
                  ? AppColors.whiteColor.withValues(alpha: 0.7)
                  : AppColors.black.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                capitalizeAndSplit2Only(orderData.restaurant?.name ??
                    LocaleKeys.unknownRestaurant.tr()),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextColor(context),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Rating Badge
            GestureDetector(
              onTap: () {
                // TODO: Navigate to restaurant ratings page
                // Similar to pick me & trip join
                // Navigator.push or context.push to ratings screen
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cF5F5F5,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 18,
                      color: AppColors.ACCENT_COLOR,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.isArabic ? numAr(4.5) : '4.5',
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // if (orderData.restaurant?.subcategory != null) ...[
        //   const SizedBox(height: 4),
        //   Row(
        //     children: [
        //       Icon(
        //         Icons.category_outlined,
        //         size: 16,
        //         color: context.isDarkMode
        //             ? AppColors.whiteColor.withValues(alpha: 0.6)
        //             : AppColors.black.withValues(alpha: 0.6),
        //       ),
        //       const SizedBox(width: 8),
        //       Expanded(
        //         child: Text(
        //           context.isArabic
        //               ? orderData.restaurant!.subcategory!.nameAr.toString()
        //               : capitalizeAndSplit2Only(
        //                   orderData.restaurant!.subcategory!.nameEn ?? ''),
        //           style: Styles.smallText(
        //             fontWeight: FontWeight.w600,
        //             color: context.isDarkMode
        //                 ? AppColors.whiteColor.withValues(alpha: 0.8)
        //                 : AppColors.black.withValues(alpha: 0.8),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
        const SizedBox(height: 8),
        _buildFoodDetails(context),
        const SizedBox(height: 8),
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.black.withValues(alpha: 0.2)
            : AppColors.cF5F5F5,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fastfood_outlined,
                size: 16,
                color: context.isDarkMode
                    ? AppColors.whiteColor.withValues(alpha: 0.7)
                    : AppColors.black.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                context.isArabic ? 'العناصر المطلوبة' : 'Ordered Items',
                style: Styles.smallText(
                  fontWeight: FontWeight.w600,
                  color: context.isDarkMode
                      ? AppColors.whiteColor.withValues(alpha: 0.8)
                      : AppColors.black.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...orderData.orders!.map((order) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.food?.foodName ?? LocaleKeys.unknownFood.tr(),
                      style: Styles.smallText(
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: context.isArabic
                              ? numAr(order.price ?? 0)
                              : order.price.toString(),
                          style: Styles.headerText(
                            fontWeight: FontWeight.w700,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' ${context.isArabic ? orderData.currencyAr : orderData.currencyEn}',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w500,
                            color: AppColors.getRedColor(context),
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalAndCurrency(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.ACCENT_COLOR.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.ACCENT_COLOR.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 18,
                color: AppColors.ACCENT_COLOR,
              ),
              const SizedBox(width: 6),
              Text(
                context.isArabic ? 'المجموع' : 'Total',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextColor(context),
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.isArabic
                      ? numAr(orderData.total ?? 0)
                      : orderData.total?.toString() ?? '0',
                  style: Styles.headerText(
                    fontWeight: FontWeight.w700,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.black,
                  ),
                ),
                TextSpan(
                  text:
                      ' ${context.isArabic ? orderData.currencyAr : orderData.currencyEn ?? ''}',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w500,
                    fontSize: 35,
                    color: AppColors.getRedColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return Column(
      children: [
        const SizedBox(height: 8),
        // Date
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 18,
              color: context.isDarkMode
                  ? AppColors.whiteColor.withValues(alpha: 0.7)
                  : AppColors.black.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                orderData.createdAt != null
                    ? (context.isArabic
                        ? DateFormat('d MMM, yyyy h:mm a', 'ar')
                            .format(orderData.createdAt!)
                        : DateFormat('MMM d, yyyy h:mm a')
                            .format(orderData.createdAt!))
                    : LocaleKeys.noDate.tr(),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextColor(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
