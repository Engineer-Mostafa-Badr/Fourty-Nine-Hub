import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
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

  void _updateRating(double newRating)async {
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.orderDetails.localize,
              style: Styles.headerText(fontWeight: FontWeight.w700)),
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
                  _currentLogsEntity.userRateRestaurant == null ||
                      _currentLogsEntity.userRateRestaurant == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Label(
                                text: LocaleKeys.noRating.localize,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  // fontSize: 16,
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
                                            serviceLocator<RestaurantsCubit>(),
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
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: AppColors.cF3F3F3,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Label(
                                    text: LocaleKeys.rate.localize,
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.w700,
                                      // fontSize: 14,
                                      color: AppColors.black,
                                    ),
                                  ),
                                )),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Label(
                                text: LocaleKeys.yourRate.localize,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  // fontSize: 16,
                                  color: context.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.black,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Label(
                                  text: getRatingText(_currentLogsEntity
                                          .userRateRestaurant?.rate ??
                                      0),
                                  // context.isArabic
                                  //     ? _currentLogsEntity.userRateRestaurantName
                                  //     ?.ar ??
                                  //     ""
                                  //     : _currentLogsEntity.userRateRestaurantName
                                  //     ?.en ??
                                  //     "",
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w600,
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.black,
                                  ),
                                ),
                                RatingBar(
                                  initialRating: _currentLogsEntity
                                          .userRateRestaurant?.rate
                                          ?.toDouble() ??
                                      0,
                                  ignoreGestures: true,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(Assets.star1),
                                    half: SvgPicture.asset(Assets.halfStar),
                                    empty: SvgPicture.asset(
                                      Assets.starEmpty,
                                      color: context.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.black,
                                    ),
                                  ),
                                  itemSize: 13,
                                  onRatingUpdate: (double value) {},
                                ),
                                const Sizer(),
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
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: AppColors.cF3F3F3,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Label(
                                        text: LocaleKeys.modify.localize,
                                        style: Styles.mediumText(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                  const Sizer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      _currentLogsEntity.restaurantRateUser == null
                          ? Row(
                              children: [
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
                                    color: context.isDarkMode
                                        ? AppColors.whiteColor
                                        : AppColors.black,
                                  ),
                                ),
                                RatingBar(
                                  initialRating: _currentLogsEntity
                                          .restaurantRateUser
                                          ?.toDouble() ??
                                      0,
                                  // initialRating:
                                  //     widget.logsEntity.userRateRestaurant?.toDouble() ?? 0,
                                  ignoreGestures: true,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(
                                      Assets.star1,
                                    ),
                                    half: SvgPicture.asset(Assets.halfStar),
                                    empty: SvgPicture.asset(
                                      Assets.starEmpty,
                                      color: context.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.black,
                                    ),
                                  ),
                                  itemSize: 13,
                                  onRatingUpdate: (double value) {},
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
                                    : AppColors.black,
                              ),
                            ),
                    ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[600],
                backgroundImage:
                    _currentLogsEntity.userId?.userProfile?.profilePictureKey !=
                            null
                        ? NetworkImage(_currentLogsEntity
                            .userId!.userProfile!.profilePictureKey!.mediaKey!)
                        : null,
                child:
                    _currentLogsEntity.userId?.userProfile?.profilePictureKey ==
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
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(10),
                // shape: BoxShape.circle,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.star,
                    size: 10,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  Text(
                    context.isArabic
                        ? numAr(_currentLogsEntity.userId?.restaurantRate ?? 0)
                        : "${_currentLogsEntity.userId?.restaurantRate ?? 0}",
                    style: Styles.smallText(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserName(),
            ],
          ),
        ),
        // const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Center(child: _buildRestaurantDetails(context)),
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
        Text(
          capitalizeAndSplit2Only(_currentLogsEntity.restaurantId?.name ??
              LocaleKeys.unknownRestaurant.tr()),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Styles.mediumText(
            fontWeight: FontWeight.w700,
            color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
          ),
        ),
        if (_currentLogsEntity.restaurantId?.subcategoryId != null)
          Text(
            context.isArabic
                ? _currentLogsEntity.restaurantId!.subcategoryId!.nameAr
                    .toString()
                : capitalizeAndSplit2Only(
                    _currentLogsEntity.restaurantId!.subcategoryId!.nameEn ??
                        ''),
            style: Styles.mediumText(
              fontWeight: FontWeight.w700,
              color:
                  context.isDarkMode ? AppColors.whiteColor : AppColors.black,
            ),
          ),
        _buildFoodDetails(),
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

    final foodList = _currentLogsEntity.orders!
        .map((order) => order.foodId?.foodName ?? LocaleKeys.unknownFood.tr())
        .toList();

    return Text(
      foodList.length > 1 ? "${foodList[0]}, ${foodList[1]}" : foodList[0],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Styles.mediumText(
        fontWeight: FontWeight.w700,
        color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
      ),
    );
  }

  Widget _buildTotalAndCurrency() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${context.isArabic ? numAr(_currentLogsEntity.total ?? 0) : _currentLogsEntity.total?.toString() ?? '0'} ${context.isArabic ? _currentLogsEntity.currencyAr : _currentLogsEntity.currencyEn}",
            style: Styles.mediumText(
              fontWeight: FontWeight.w700,
              color:
                  context.isDarkMode ? AppColors.whiteColor : AppColors.black,
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
          _currentLogsEntity.createdAt != null
              ? (context.isArabic
                  ? DateFormat('d MMM, yyyy h:mm a', 'ar')
                      .format(DateTime.parse(_currentLogsEntity.createdAt!))
                  : DateFormat('MMM d, yyyy h:mm a')
                      .format(DateTime.parse(_currentLogsEntity.createdAt!)))
              : LocaleKeys.noDate.tr(),
          style: Styles.smallText(
            // fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            getSubscriptionType(_currentLogsEntity.subscriptionType?.en),
            style: Styles.smallText(
              // fontSize: 12,
              color: AppColors.SECONDARY_COLOR_DARK,
              fontWeight: FontWeight.w600,
            ),
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getFindFillColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: LocaleKeys.rateTheRestaurant.localize,
            style: Styles.headerText(
              fontWeight: FontWeight.w700,
              color:
                  context.isDarkMode ? AppColors.whiteColor : AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Label(
            text: getRatingText(),
            style: Styles.mediumText(
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color:
                  context.isDarkMode ? AppColors.whiteColor : AppColors.black,
            ),
          ),

          const SizedBox(height: 8),
          // Rating Bar
          RatingBar(
            initialRating: _rating,
            ignoreGestures: false,
            // Allow interaction
            itemPadding: const EdgeInsets.symmetric(horizontal: 3),
            ratingWidget: RatingWidget(
              full: SvgPicture.asset(Assets.star1),
              half: SvgPicture.asset(Assets.star1),
              // You can adjust the half icon if needed
              empty: SvgPicture.asset(
                Assets.starEmpty,
                color:
                    context.isDarkMode ? AppColors.whiteColor : AppColors.black,
              ),
            ),
            itemSize: 40,
            // Adjust the size of the star
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 24),
          AppButton(
              backColor: context.isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.PRIMARY_COLOR,
              color: context.isDarkMode
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.whiteColor,
              style: Styles.mediumText(
                fontSize: 50,
                color: context.isDarkMode
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.whiteColor,
              ),
              onPressed: () => _sendRating(context),
              label: LocaleKeys.send.localize),
        ],
      ),
    );
  }
}