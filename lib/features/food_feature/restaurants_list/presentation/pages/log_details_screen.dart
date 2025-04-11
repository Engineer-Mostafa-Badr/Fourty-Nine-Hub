import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/tinder/data/shared/shared.dart';
import '../../domain/entities/logs_entity.dart';
import '../../domain/usecases/add_rate_restaurant_use_case.dart';
import '../cubit/restaurants_list_cubit.dart';

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

  void _updateRating(double newRating) {
    setState(() {
      _currentLogsEntity = _currentLogsEntity.copyWith(
        userRateRestaurant: newRating.toInt(),
      );
    });
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
          title: const Text("Order Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                // elevation: context.isDarkMode ? 0 : 2,
                decoration: BoxDecoration(
                    // color: cardDarkColor(context),
                    border: Border.all(
                      color: AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
              widget.logsEntity.userRateRestaurant == null ||
                      widget.logsEntity.userRateRestaurant == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: LocaleKeys.noRating.localize,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.black),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cF3F3F3),
                            onPressed: () {},
                            child: Label(
                              text: LocaleKeys.rate.localize,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.black),
                            )),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: LocaleKeys.yourRate.localize,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.black),
                        ),
                        Row(
                          children: [
                            const Label(
                              text: "Good",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            RatingBar(
                              initialRating: _currentLogsEntity.userRateRestaurant?.toDouble() ?? 0,
                              // initialRating:
                              //     widget.logsEntity.userRateRestaurant?.toDouble() ?? 0,
                              ignoreGestures: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              ratingWidget: RatingWidget(
                                full: SvgPicture.asset(Assets.star1),
                                half: SvgPicture.asset(Assets.star1),
                                empty: SvgPicture.asset(Assets.starEmpty),
                              ),
                              itemSize: 13,
                              onRatingUpdate: (double value) {},
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.cF3F3F3),
                                onPressed: () {
                                  final cubit = context.read<RestaurantsCubit>();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return BlocProvider(
                                        create: (context) =>
                                            serviceLocator<RestaurantsCubit>(),
                                        child: RatingBottomSheet(
                                          restaurantId:
                                              widget.logsEntity.restaurantId!.id!,
                                          cubit: cubit,
                                          onRatingUpdated: _updateRating,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Label(
                                  text: LocaleKeys.modify.localize,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.black),
                                )),
                          ],
                        ),
                      ],
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                    text: LocaleKeys.restaurantRateYou.localize,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.black),
                  ),
                  Row(
                    children: [
                      const Label(
                        text: "Good",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      RatingBar(
                        initialRating: _currentLogsEntity.restaurantRateUser?.toDouble() ?? 0,
                        // initialRating:
                        //     widget.logsEntity.userRateRestaurant?.toDouble() ?? 0,
                        ignoreGestures: true,
                        itemPadding:
                        const EdgeInsets.symmetric(horizontal: 3),
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset(Assets.star1),
                          half: SvgPicture.asset(Assets.star1),
                          empty: SvgPicture.asset(Assets.starEmpty),
                        ),
                        itemSize: 13,
                        onRatingUpdate: (double value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[600],
              backgroundImage:
                  widget.logsEntity.userId?.userProfile?.profilePictureKey != null
                      ? NetworkImage(
                          widget.logsEntity.userId!.userProfile!.profilePictureKey!)
                      : null,
              child: widget.logsEntity.userId?.userProfile?.profilePictureKey == null
                  ? const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    )
                  : null,
            ),
            Container(
              width: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(10),
                // shape: BoxShape.circle,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 6.6,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  Text(
                    '4.5',
                    style: TextStyle(
                      fontSize: 10,
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
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserName(),
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
    return Label(
      text: capitalizeAndSplit2Only(
          widget.logsEntity.userId?.firstName ?? LocaleKeys.noName.tr()),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          capitalizeAndSplit2Only(widget.logsEntity.restaurantId?.name ??
              LocaleKeys.unknownRestaurant.tr()),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (widget.logsEntity.restaurantId?.subcategoryId != null)
          Text(
            context.isArabic
                ? widget.logsEntity.restaurantId!.subcategoryId!.nameAr.toString()
                : capitalizeAndSplit2Only(
                    widget.logsEntity.restaurantId!.subcategoryId!.nameEn ?? ''),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        _buildFoodDetails(),
        _buildTotalAndCurrency(),
      ],
    );
  }

  Widget _buildFoodDetails() {
    if (widget.logsEntity.orders == null || widget.logsEntity.orders!.isEmpty) {
      return Text(
        LocaleKeys.noOrders.tr(),
        style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
      );
    }

    final foodList = widget.logsEntity.orders!
        .map((order) => order.foodId?.foodName ?? LocaleKeys.unknownFood.tr())
        .toList();

    return Text(
      foodList.length > 1 ? "${foodList[0]}, ${foodList[1]}" : foodList[0],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTotalAndCurrency() {
    return Row(
      children: [
        Text(
          "${LocaleKeys.total.tr()}: ",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        // const Spacer(),
        Text(
          widget.logsEntity.total?.toString() ?? '0',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          " ${widget.logsEntity.currencyEn ?? ''}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.logsEntity.createdAt != null
              ? DateFormat('MMM d, yyyy h:mm a')
                  .format(DateTime.parse(widget.logsEntity.createdAt!))
              : LocaleKeys.noDate.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 5,
          child: Text(
            widget.logsEntity.subscriptionType?.toString() ??
                LocaleKeys.noSubscription.tr(),
            style: const TextStyle(
              fontSize: 12,
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
          const SnackBar(content: Text('Submitting rating...')),
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
          const SnackBar(content: Text('Rating submitted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating')),
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: LocaleKeys.rateTheRestaurant.localize,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Label(
            text:getRatingText(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
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
              empty: SvgPicture.asset(Assets.starEmpty),
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
              backColor: AppColors.PRIMARY_COLOR,
              color: AppColors.whiteColor,
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: AppColors.PRIMARY_COLOR,
              //   padding: const EdgeInsets.symmetric(vertical: 12),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              // ),

              onPressed: () => _sendRating(context),
              label: LocaleKeys.send.localize),
        ],
      ),
    );
  }
}

// class RatingBottomSheet extends StatefulWidget {
//   final String restaurantId;
//   final RestaurantsCubit cubit;
//
//   const RatingBottomSheet({
//     super.key,
//     required this.restaurantId,
//     required this.cubit,
//   });
//
//   @override
//   _RatingBottomSheetState createState() => _RatingBottomSheetState();
// }
//
// class _RatingBottomSheetState extends State<RatingBottomSheet> {
//   double _rating = 0;
//   TextEditingController _commentController = TextEditingController();
//
//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }
//
//   void _sendRating(BuildContext context) {
//     if (_rating > 0) {
//       final params = AddRateRestaurantParams(
//         restaurantId: widget.restaurantId,
//         rate: _rating,
//         comment: "Elmon",
//       );
//
//       // Call the Cubit to rate the restaurant
//       widget.cubit.rateRestaurant(params: params);
//
//       // Wait for the response and then refresh the list
//       widget.cubit.rateRestaurant(params: params).then((_) {
//         // Refresh the data after rating is submitted
//         widget.cubit.loadInitialReqLogs();
//       });
//       Navigator.pop(context); // Close the bottom sheet after sending the rating
//       Navigator.pop(context); // Close the bottom sheet after sending the rating
//       Navigator.pop(context); // Close the bottom sheet after sending the rating
//     } else {
//       // Show an error if no rating or comment is provided
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please provide a rating ')),
//       );
//     }
//   }
//
//   // Method to return the text based on the rating
//   String getRatingText() {
//     if (_rating == 1) {
//       return LocaleKeys.bad.localize;
//     } else if (_rating == 2) {
//       return LocaleKeys.poor2.localize;
//     } else if (_rating == 3) {
//       return LocaleKeys.good.localize;
//     } else if (_rating == 4) {
//       return LocaleKeys.veryGood.localize;
//     } else if (_rating == 5) {
//       return LocaleKeys.excellent.localize;
//     }
//     return '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Label(
//             text: LocaleKeys.rateTheRestaurant.localize,
//             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
//           ),
//           const SizedBox(height: 8),
//           // Rating Bar
//           RatingBar(
//             initialRating: _rating,
//             ignoreGestures: false,
//             // Allow interaction
//             itemPadding: const EdgeInsets.symmetric(horizontal: 3),
//             ratingWidget: RatingWidget(
//               full: SvgPicture.asset(Assets.star1),
//               half: SvgPicture.asset(Assets.star1),
//               // You can adjust the half icon if needed
//               empty: SvgPicture.asset(Assets.starEmpty),
//             ),
//             itemSize: 40,
//             // Adjust the size of the star
//             onRatingUpdate: (rating) {
//               setState(() {
//                 _rating = rating;
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           // Displaying the rating text based on the selected rating
//           Text(
//             getRatingText(),
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 24),
//           AppButton(
//               backColor: AppColors.PRIMARY_COLOR,
//               color: AppColors.whiteColor,
//               // style: ElevatedButton.styleFrom(
//               //   backgroundColor: AppColors.PRIMARY_COLOR,
//               //   padding: const EdgeInsets.symmetric(vertical: 12),
//               //   shape: RoundedRectangleBorder(
//               //     borderRadius: BorderRadius.circular(8),
//               //   ),
//               // ),
//
//               onPressed: () => _sendRating(context),
//               label: LocaleKeys.send.localize),
//         ],
//       ),
//     );
//   }
// }
