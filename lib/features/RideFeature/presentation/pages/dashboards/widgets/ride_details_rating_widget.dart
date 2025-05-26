import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';

class RideDetailsRatingWidget extends StatelessWidget {
  final bool isRate;
  final double rate;
  final String title;
  const RideDetailsRatingWidget(
      {super.key,
      required this.isRate,
      required this.rate,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(
            text: title, //LocaleKeys.noRating.localize,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const Spacer(),
        if (isRate) ...[
           Text(LocaleKeys.good.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 5),
          RatingBar(
            initialRating: rate,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 3),
            ratingWidget: RatingWidget(
              full: SvgPicture.asset(Assets.star1),
              half: SvgPicture.asset(Assets.star1),
              empty: SvgPicture.asset(Assets.starEmpty),
            ),
            itemSize: 13,
            onRatingUpdate: (double value) {},
          ),
        ] else
          noRateWidget(),
      ],
    );
  }

  Widget noRateWidget() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cF3F3F3,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Label(
          text: LocaleKeys.noRating.localize,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}


class RideDetailsRatingNonSocketWidget extends StatelessWidget {
  final double? rate;
  final String title;
  final DashboardsCubit cubit;
  final String tripId;
  final Function(double)? onRatingUpdated;

  const RideDetailsRatingNonSocketWidget({
    super.key,
    required this.rate,
    required this.title,
    required this.cubit,
    required this.tripId,
    this.onRatingUpdated,
  });

  bool get isRate => rate != null && rate! > 0;

  void _openRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RatingBottomSheet(
        restaurantId: tripId,
        cubit: cubit,
        onRatingUpdated: onRatingUpdated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(
          text: title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const Spacer(),
        if (isRate) ...[
          RatingBar(
            initialRating: rate ?? 0,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2),
            ratingWidget: RatingWidget(
              full: SvgPicture.asset(Assets.star1),
              half: SvgPicture.asset(Assets.halfStar),
              empty: SvgPicture.asset(Assets.starEmpty),
            ),
            itemSize: 14,
            onRatingUpdate: (_) {},
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => _openRatingSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.cF3F3F3,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                LocaleKeys.modify.localize,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.PRIMARY_COLOR,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ] else
          InkWell(
            onTap: () => _openRatingSheet(context),
            child: noRateWidget(context),
          ),
      ],
    );
  }

  Widget noRateWidget(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    decoration: BoxDecoration(
      color: AppColors.cF3F3F3,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      LocaleKeys.noRating.localize,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextColor(context),
      ),
    ),
  );
}


class RatingBottomSheet extends StatefulWidget {
  final String restaurantId;
  final DashboardsCubit cubit;
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
  final TextEditingController _commentController = TextEditingController(); // Comment controller

  @override
  void dispose() {
    _commentController.dispose(); // Clean up controller
    super.dispose();
  }

  Future<void> _sendRating(BuildContext context) async {
    if (_rating > 0) {
      final params = AddRateWithDriverParams(
        tripId: widget.restaurantId,
        rate: _rating,
        comment: _commentController.text.trim(), // Use the comment from input
      );

      try {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.submittingRating.localize,style: Styles.mediumText(color: AppColors.getTextColor(context)),),backgroundColor: AppColors.getFindFillColor(context),),
        );

        // Submit rating
        await widget.cubit.rateDriverNonSocket(params: params);

        // Call the callback if provided
        widget.onRatingUpdated?.call(_rating);

        // Refresh data
        widget.cubit.loadInitialPastNonSocketTrips();

        // Close bottom sheet
        Navigator.pop(context);

        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.ratingSubmittedSuccessfully.localize,style: Styles.mediumText(color: AppColors.getTextColor(context))),backgroundColor: AppColors.getFindFillColor(context),),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}',style: Styles.mediumText(color: AppColors.getTextColor(context))),backgroundColor: AppColors.getFindFillColor(context)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.pleaseProvideRate.localize,style: Styles.mediumText(color: AppColors.getTextColor(context))),backgroundColor: AppColors.getFindFillColor(context)),
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
      decoration:  BoxDecoration(
        color: AppColors.getFindFillColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: LocaleKeys.rateTheRestaurant.localize,
            style:  Styles.headerText(
              fontWeight: FontWeight.w700,
              color: context.isDarkMode ? AppColors.whiteColor :AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Label(
            text: getRatingText(),
            style:  Styles.mediumText(
              fontWeight: FontWeight.w500, fontSize: 30,
              color: context.isDarkMode ? AppColors.whiteColor :AppColors.black,
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
              empty: SvgPicture.asset(Assets.starEmpty,color: context.isDarkMode ? AppColors.whiteColor :AppColors.black,),
            ),
            itemSize: 40,
            // Adjust the size of the star
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 16),

          // New Comment Field
          TextFormField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: LocaleKeys.comment.localize,
              hintStyle: Styles.smallText(color: AppColors.getTextColor(context).withOpacity(0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.getTextColor(context).withOpacity(0.4)),
              ),
              filled: true,
              fillColor: context.isDarkMode ? Colors.black12 : Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
              backColor: context.isDarkMode ? AppColors.whiteColor :AppColors.PRIMARY_COLOR,
              color: context.isDarkMode ? AppColors.PRIMARY_COLOR :AppColors.whiteColor,
              style: Styles.mediumText(
                fontSize: 50,
                color: context.isDarkMode ? AppColors.PRIMARY_COLOR :AppColors.whiteColor,
              ),
              onPressed: () => _sendRating(context),
              label: LocaleKeys.send.localize),
        ],
      ),
    );
  }
}
