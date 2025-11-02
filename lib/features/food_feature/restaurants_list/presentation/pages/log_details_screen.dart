import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../res/style/app_colors.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/tinder/data/shared/shared.dart';
import '../../domain/entities/logs_entity.dart';
import '../../domain/usecases/add_rate_restaurant_use_case.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';

class LogDetailsScreen extends StatefulWidget {
  const LogDetailsScreen({super.key, required this.logsEntity});

  final LogsRequestLogsEntity logsEntity;

  @override
  State<LogDetailsScreen> createState() => _LogDetailsScreenState();
}

class _LogDetailsScreenState extends State<LogDetailsScreen> {
  late LogsRequestLogsEntity _currentLogsEntity;

  @override
  void initState() {
    super.initState();
    _currentLogsEntity = widget.logsEntity;
  }

  void _updateRating(double newRating) async {
    setState(() {
      // Create a new UserRateRestaurantEntity with the updated rating
      final updatedRate = _currentLogsEntity.userRateRestaurant?.copyWith(
        rate: newRating.toInt(), // Update only the rate
      );

      // Update the _currentLogsEntity with the new UserRateRestaurantEntity
      _currentLogsEntity = _currentLogsEntity.copyWith(
        userRateRestaurant: updatedRate, // Replace the old one
      );
    });
  }

  String getRatingText(int rating) {
    if (rating == 1) {
      return LocaleKeys.bad.localize;
    } else if (rating == 2) {
      return LocaleKeys.poor2.localize;
    } else if (rating == 3) {
      return LocaleKeys.good.localize;
    } else if (rating == 4) {
      return LocaleKeys.veryGood.localize;
    } else if (rating == 5) {
      return LocaleKeys.excellent.localize;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return the updated data when popping
        Navigator.pop(context, _currentLogsEntity);
        return false;
      },
      child: CustomScaffold(
        enableCustomAppBar: true,
        appBar: BackAppBar(
          label: LocaleKeys.orderDetails.localize,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
            builder: (context, state) {
              return ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.black,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        spacing: 8,
                        children: [
                          _buildHeader(context),
                          _buildFooter(context),
                        ],
                      ),
                    ),
                  ),
                  const Sizer(),
                  // Your Rating Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? AppColors.black.withValues(alpha: 0.2)
                          : AppColors.cF5F5F5,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _currentLogsEntity.userRateRestaurant == null ||
                            _currentLogsEntity.userRateRestaurant?.rate ==
                                null ||
                            _currentLogsEntity.userRateRestaurant?.rate == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_border_rounded,
                                    size: 20,
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                            .withValues(alpha: 0.7)
                                        : AppColors.black
                                            .withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 8),
                                  Label(
                                    text: LocaleKeys.noRating.localize,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w700,
                                      color: context.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    final cubit =
                                        context.read<RestaurantsCubit>();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return BlocProvider(
                                          create: (context) => serviceLocator<
                                              RestaurantsCubit>(),
                                          child: RatingBottomSheet(
                                            restaurantId: widget
                                                .logsEntity.restaurantId!.id!,
                                            cubit: cubit,
                                            onRatingUpdated: _updateRating,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: AppColors.ACCENT_COLOR,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Label(
                                      text: LocaleKeys.rate.localize,
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  )),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 20,
                                    color: AppColors.ACCENT_COLOR,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Label(
                                      text: LocaleKeys.yourRate.localize,
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w700,
                                        color: context.isDarkMode
                                            ? AppColors.whiteColor
                                            : AppColors.black,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        ManageVibration.vibrate();
                                        final cubit =
                                            context.read<RestaurantsCubit>();
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return BlocProvider(
                                              create: (context) =>
                                                  serviceLocator<
                                                      RestaurantsCubit>(),
                                              child: RatingBottomSheet(
                                                restaurantId: widget.logsEntity
                                                    .restaurantId!.id!,
                                                cubit: cubit,
                                                onRatingUpdated: _updateRating,
                                              ),
                                            );
                                          },
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                            color: AppColors.BACKGROUND_COLOR
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                size: 14,
                                                color: AppColors.PRIMARY_COLOR),
                                            const SizedBox(width: 4),
                                            Label(
                                              text: LocaleKeys.modify.localize,
                                              style: Styles.smallText(
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.PRIMARY_COLOR),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  RatingBar(
                                    initialRating: _currentLogsEntity
                                            .userRateRestaurant?.rate
                                            ?.toDouble() ??
                                        0,
                                    ignoreGestures: true,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    ratingWidget: RatingWidget(
                                      full: SvgPicture.asset(Assets.star1),
                                      half: SvgPicture.asset(Assets.halfStar),
                                      empty: SvgPicture.asset(
                                        Assets.starEmpty,
                                        colorFilter: ColorFilter.mode(
                                          context.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    itemSize: 16,
                                    onRatingUpdate: (double value) {},
                                  ),
                                  const SizedBox(width: 8),
                                  Label(
                                    text: getRatingText(_currentLogsEntity
                                            .userRateRestaurant?.rate ??
                                        0),
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w700,
                                      color: context.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                  const Sizer(),
                  // Restaurant Rating Card
                  Container(
                    padding: const EdgeInsets.all(16),
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
                              Icons.restaurant_menu,
                              size: 20,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor.withValues(alpha: 0.7)
                                  : AppColors.black.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Label(
                                text: LocaleKeys.restaurantRateYou.localize,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  color: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _currentLogsEntity.restaurantRateUser == null
                            ? Row(
                                children: [
                                  RatingBar(
                                    initialRating: _currentLogsEntity
                                            .restaurantRateUser
                                            ?.toDouble() ??
                                        0,
                                    ignoreGestures: true,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    ratingWidget: RatingWidget(
                                      full: SvgPicture.asset(Assets.star1),
                                      half: SvgPicture.asset(Assets.halfStar),
                                      empty: SvgPicture.asset(
                                        Assets.starEmpty,
                                        colorFilter: ColorFilter.mode(
                                          context.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    itemSize: 16,
                                    onRatingUpdate: (double value) {},
                                  ),
                                  const SizedBox(width: 8),
                                  Label(
                                    text: context.isArabic
                                        ? _currentLogsEntity
                                                .restaurantRateUserName?.ar ??
                                            ""
                                        : _currentLogsEntity
                                                .restaurantRateUserName?.en ??
                                            "",
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.SECONDARY_COLOR_DARK,
                                    ),
                                  ),
                                ],
                              )
                            : Label(
                                text: context.isArabic
                                    ? _currentLogsEntity
                                            .restaurantRateUserName?.ar ??
                                        ""
                                    : _currentLogsEntity
                                            .restaurantRateUserName?.en ??
                                        "",
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                  color: context.isDarkMode
                                      ? AppColors.whiteColor
                                          .withValues(alpha: 0.7)
                                      : AppColors.black.withValues(alpha: 0.7),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            // User Info Section
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[600],
                  backgroundImage: _currentLogsEntity
                              .userId?.userProfile?.profilePictureKey !=
                          null
                      ? NetworkImage(_currentLogsEntity
                          .userId!.userProfile!.profilePictureKey!.mediaKey!)
                      : null,
                  child: _currentLogsEntity
                              .userId?.userProfile?.profilePictureKey ==
                          null
                      ? const Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18,
                            color: context.isDarkMode
                                ? AppColors.whiteColor.withValues(alpha: 0.7)
                                : AppColors.black.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Expanded(child: _buildUserName()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Restaurant Info Section
            _buildRestaurantDetails(context),
          ],
        ),
        Positioned(
          top: -12,
          left: -9,
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
                const SizedBox(width: 2),
                Text(
                  context.isArabic
                      ? numAr(_currentLogsEntity.userId?.restaurantRate ?? 0)
                      : "${_currentLogsEntity.userId?.restaurantRate ?? 0}",
                  style: Styles.smallText(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserName() {
    return Label(
      text: capitalizeAndSplit2Only(
          _currentLogsEntity.userId?.firstName ?? LocaleKeys.noName.tr()),
      style: Styles.mediumText(
        fontWeight: FontWeight.w600,
        color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
      ),
      maxLines: 2,
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Restaurant Name with Icon
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
                capitalizeAndSplit2Only(_currentLogsEntity.restaurantId?.name ??
                    LocaleKeys.unknownRestaurant.tr()),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
            ),
          ],
        ),
        if (_currentLogsEntity.restaurantId?.subcategoryId != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 16,
                color: context.isDarkMode
                    ? AppColors.whiteColor.withValues(alpha: 0.6)
                    : AppColors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.isArabic
                      ? _currentLogsEntity.restaurantId!.subcategoryId!.nameAr
                          .toString()
                      : capitalizeAndSplit2Only(_currentLogsEntity
                              .restaurantId!.subcategoryId!.nameEn ??
                          ''),
                  style: Styles.smallText(
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode
                        ? AppColors.whiteColor.withValues(alpha: 0.8)
                        : AppColors.black.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        _buildFoodDetails(),
        const SizedBox(height: 8),
        _buildTotalAndCurrency(),
      ],
    );
  }

  Widget _buildFoodDetails() {
    if (_currentLogsEntity.orders == null ||
        _currentLogsEntity.orders!.isEmpty) {
      return Text(
        LocaleKeys.noOrders.tr(),
        style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
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
          ..._currentLogsEntity.orders!.map((order) {
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
                      order.foodId?.foodName ?? LocaleKeys.unknownFood.tr(),
                      style: Styles.smallText(
                        fontWeight: FontWeight.w500,
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black,
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
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w600,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black,
                            fontSize: 30,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' ${context.isArabic ? _currentLogsEntity.currencyAr : _currentLogsEntity.currencyEn}',
                          style: Styles.smallText(
                            fontWeight: FontWeight.w600,
                            color: AppColors.getRedColor(context),
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

  Widget _buildTotalAndCurrency() {
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
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
            ],
          ),
          // Text(
          //   "${context.isArabic ? numAr(_currentLogsEntity.total ?? 0) : _currentLogsEntity.total?.toString() ?? '0'} ${context.isArabic ? _currentLogsEntity.currencyAr : _currentLogsEntity.currencyEn}",
          //   style: Styles.mediumText(
          //     fontWeight: FontWeight.w700,
          //     fontSize: 18,
          //     color: AppColors.ACCENT_COLOR,
          //   ),
          // ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.isArabic
                      ? numAr(_currentLogsEntity.total ?? 0)
                      : _currentLogsEntity.total?.toString() ?? '0',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.black,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text:
                      ' ${context.isArabic ? _currentLogsEntity.currencyAr : _currentLogsEntity.currencyEn}',
                  style: Styles.smallText(
                    fontWeight: FontWeight.w600,
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
                _currentLogsEntity.createdAt != null
                    ? (context.isArabic
                        ? DateFormat('d MMM, yyyy h:mm a', 'ar').format(
                            DateTime.parse(_currentLogsEntity.createdAt!))
                        : DateFormat('MMM d, yyyy h:mm a').format(
                            DateTime.parse(_currentLogsEntity.createdAt!)))
                    : LocaleKeys.noDate.tr(),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subscription Type
        Row(
          children: [
            Icon(
              Icons.card_membership_outlined,
              size: 16,
              color: AppColors.SECONDARY_COLOR_DARK,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                getSubscriptionType(_currentLogsEntity.subscriptionType?.en),
                style: Styles.smallText(
                  color: AppColors.SECONDARY_COLOR_DARK,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RatingBottomSheet extends StatefulWidget {
  final String restaurantId;
  final RestaurantsCubit cubit;
  final Function(double)? onRatingUpdated; // Add this callback

  const RatingBottomSheet({
    super.key,
    required this.restaurantId,
    required this.cubit,
    this.onRatingUpdated,
  });

  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double _rating = 0;

  Future<void> _sendRating(BuildContext context) async {
    if (_rating > 0) {
      final params = AddRateRestaurantParams(
        restaurantId: widget.restaurantId,
        rate: _rating,
        comment: "Elmon",
      );

      try {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.submittingRating.localize,
              style: Styles.mediumText(color: AppColors.getTextColor(context)),
            ),
            backgroundColor: AppColors.getFindFillColor(context),
          ),
        );

        // Submit rating
        await widget.cubit.rateRestaurant(params: params);

        // Call the callback if provided
        widget.onRatingUpdated?.call(_rating);

        // Refresh data
        widget.cubit.loadInitialReqLogs();

        // Close bottom sheet
        Navigator.pop(context);

        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.ratingSubmittedSuccessfully.localize,
                style:
                    Styles.mediumText(color: AppColors.getTextColor(context))),
            backgroundColor: AppColors.getFindFillColor(context),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${e.toString()}',
                  style: Styles.mediumText(
                      color: AppColors.getTextColor(context))),
              backgroundColor: AppColors.getFindFillColor(context)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(LocaleKeys.pleaseProvideRate.localize,
                style:
                    Styles.mediumText(color: AppColors.getTextColor(context))),
            backgroundColor: AppColors.getFindFillColor(context)),
      );
    }
  }

  String getRatingText() {
    if (_rating == 1) {
      return LocaleKeys.bad.localize;
    } else if (_rating == 2) {
      return LocaleKeys.poor2.localize;
    } else if (_rating == 3) {
      return LocaleKeys.good.localize;
    } else if (_rating == 4) {
      return LocaleKeys.veryGood.localize;
    } else if (_rating == 5) {
      return LocaleKeys.excellent.localize;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.getFindFillColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? AppColors.whiteColor.withValues(alpha: 0.3)
                  : AppColors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.ACCENT_COLOR.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              size: 40,
              color: AppColors.ACCENT_COLOR,
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Label(
            text: LocaleKeys.rateTheRestaurant.localize,
            style: Styles.headerText(
              fontWeight: FontWeight.w700,
              color:
                  context.isDarkMode ? AppColors.whiteColor : AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
          // Rating Text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Label(
              key: ValueKey(_rating),
              text: getRatingText(),
              style: Styles.mediumText(
                fontWeight: FontWeight.w600,
                fontSize: 35,
                color: _rating > 0
                    ? AppColors.PRIMARY_COLOR
                    : (context.isDarkMode
                        ? AppColors.whiteColor.withValues(alpha: 0.5)
                        : AppColors.black.withValues(alpha: 0.5)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Rating Bar
          RatingBar(
            initialRating: _rating,
            ignoreGestures: false,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            ratingWidget: RatingWidget(
              full: SvgPicture.asset(Assets.star1),
              half: SvgPicture.asset(Assets.star1),
              empty: SvgPicture.asset(
                Assets.starEmpty,
                colorFilter: ColorFilter.mode(
                  context.isDarkMode
                      ? AppColors.whiteColor.withValues(alpha: 0.3)
                      : AppColors.black.withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
            ),
            itemSize: 50,
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 32),
          // Submit Button
          AppButton(
              backColor: _rating > 0
                  ? AppColors.PRIMARY_COLOR
                  : (context.isDarkMode
                      ? AppColors.whiteColor.withValues(alpha: 0.2)
                      : AppColors.black.withValues(alpha: 0.2)),
              color: _rating > 0
                  ? AppColors.whiteColor
                  : (context.isDarkMode
                      ? AppColors.whiteColor.withValues(alpha: 0.5)
                      : AppColors.black.withValues(alpha: 0.5)),
              style: Styles.mediumText(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: _rating > 0
                    ? AppColors.whiteColor
                    : (context.isDarkMode
                        ? AppColors.whiteColor.withValues(alpha: 0.5)
                        : AppColors.black.withValues(alpha: 0.5)),
              ),
              onPressed: _rating > 0 ? () => _sendRating(context) : () {},
              label: LocaleKeys.send.localize),
        ],
      ),
    );
  }
}
