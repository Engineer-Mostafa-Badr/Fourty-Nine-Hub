import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import '../../../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../../../domain/usecases/dashboards/loading/create_rate_with_driver_loading_use_case.dart';
import '../../../controllers/client_trips_cubit/client_trips_cubit.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RideDetailsRatingWidget extends StatefulWidget {
  final bool isRate;
  final double rate;
  final Function(String comment, double rate)? onRating;
  final String title;
  const RideDetailsRatingWidget(
      {super.key,
       this.onRating,
      required this.isRate,
      required this.rate,
      required this.title});

  @override
  State<RideDetailsRatingWidget> createState() => _RideDetailsRatingWidgetState();
}

class _RideDetailsRatingWidgetState extends State<RideDetailsRatingWidget> {
  double _rating = 4.0;
  double finalRate = 4.0;
  TextEditingController rateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _rating = widget.rate;
      finalRate = _rating;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.tripEntity.driverDetails?.rating?.average ${widget.isRate}");
    print("widget.tripEntity.driverDetails?.rating?.average ${widget.rate}");
    return Row(
      children: [
        Label(
            text: widget.title, //LocaleKeys.noRating.localize,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const Spacer(),
        if (widget.isRate) ...[
           Text(getRatingText(finalRate),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: (){
      ManageVibration.vibrate();
              showModalBottomSheet(
                context: context,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                backgroundColor: context.isDarkMode
                    ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
                    : AppColors.LIGHT_COLOR,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                enableDrag: true,
                useSafeArea: true,
                isDismissible: true,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: rateWidget(),
                  ),
                ),
              );
            },
            child: RatingBar(
              initialRating: widget.rate,
              ignoreGestures: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 3),
              ratingWidget: RatingWidget(
                full: SvgPicture.asset(Assets.star1),
                half: SvgPicture.asset(Assets.star1),
                empty: SvgPicture.asset(Assets.starEmpty),
              ),
              itemSize: 13,
              onRatingUpdate: (double value) {
                showModalBottomSheet(
                  context: context,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  backgroundColor: context.isDarkMode
                      ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
                      : AppColors.LIGHT_COLOR,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  enableDrag: true,
                  useSafeArea: true,
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: rateWidget(),
                    ),
                  ),
                );
              },
            ),
          ),
        ] else
          noRateWidget(widget.onRating),
      ],
    );
  }


  Widget rateWidget(){
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  const  SizedBox(width: 25,),
                  const  Spacer(),
                  Text(
                    LocaleKeys.rateTheClient.localize,
                    style: const TextStyle(fontSize: FontSize.s20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.close,color: Colors.black,),
                  ),
                ],),
                const SizedBox(height: 16,),
                // Text(
                //     _rating >= 5.0?LocaleKeys.excellent.localize:_rating >= 4.0? LocaleKeys.veryGood.localize:_rating >= 3.0 ?LocaleKeys.good.localize:_rating >= 2.0? LocaleKeys.poor2.localize:_rating >= 1.0? LocaleKeys.bad.localize:LocaleKeys.noRating.localize,
                //   style:const TextStyle(fontSize: FontSize.s20, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 26,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // setState(() {
                      _rating = rating;
                    // });
                  },
                ),
                const SizedBox(height: 12),
                DefaultTextFormField(
                  currentController: rateController,
                  fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                  borderColor: Colors.transparent,
                  hint: context.isArabic ? 'اكتب رسالة شكر' : 'Write a thank-you message',
                  // label: LocaleKeys.firstName.localize,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return LocaleKeys.required.localize;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      foregroundColor: Colors.white,
                      padding:const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
      ManageVibration.vibrate();
                      if(formKey.currentState!.validate()){
                        widget.onRating!=null?widget.onRating!(rateController.text, _rating):null;
                      }
                      // context.push(Routes.connectionCallScreen);
                    },
                    child: Text(LocaleKeys.send.localize),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getRatingText(double rating) {
    print(rating);
    if (_rating >= 5.0) return LocaleKeys.excellent.localize;
    if (_rating >= 4.0) return LocaleKeys.veryGood.localize;
    if (_rating >= 3.0) return LocaleKeys.good.localize;
    if (_rating >= 2.0) return LocaleKeys.poor2.localize;
    if (_rating >= 1.0) return LocaleKeys.bad.localize;
    return LocaleKeys.noRating.localize;
  }

  Widget noRateWidget(Function(String comment, double rate)? onRating) => ClickableWidget(
    onTap: onRating!=null?()=> showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      backgroundColor: context.isDarkMode
          ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
          : AppColors.LIGHT_COLOR,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      enableDrag: true,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: rateWidget(),
        ),
      ),
    ):null,
    child: Container(
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
        ),
  );
}


class RideDetailsRatingNonSocketWidget extends StatelessWidget {
  final double? rate;
  final String title;
  final DashboardsCubit cubit;
  final String tripId;
  final bool isClient;
  final bool? isRide;
  final Function(double)? onRatingUpdated;

  const RideDetailsRatingNonSocketWidget({
    super.key,
    required this.rate,
    required this.title,
    required this.cubit,
    required this.tripId,
    this.onRatingUpdated,
    this.isClient = false,
    this.isRide = true,
  });

  bool get isRate => rate != null && rate! > 0;

  String getRatingLabel(double rate) {
    if (rate >= 1 && rate <= 1.5) return LocaleKeys.poor2.tr();
    if (rate > 1.5 && rate <= 2.5) return LocaleKeys.bad.tr();
    if (rate > 2.5 && rate <= 3.5) return LocaleKeys.good.tr();
    if (rate > 3.5 && rate <= 4.5) return LocaleKeys.veryGood.tr();
    if (rate > 4.5 && rate <= 5) return LocaleKeys.excellent.tr();
    return '';
  }

  Color getRatingColor(double rate) {
    if (rate >= 1 && rate <= 1.5) return Colors.red;
    if (rate > 1.5 && rate <= 2.5) return Colors.orange;
    if (rate > 2.5 && rate <= 3.5) return Colors.amber;
    if (rate > 3.5 && rate <= 4.5) return Colors.lightGreen;
    if (rate > 4.5 && rate <= 5) return Colors.green;
    return Colors.grey;
  }

  void _openRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RatingBottomSheet(
        isRide:  isRide!,
        tripId: tripId,
        cubit: cubit,
        onRatingUpdated: onRatingUpdated,
        existingRate: rate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title: Expanded to take leftover space but ellipsize if needed
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),

        if (isClient && isRate) const SizedBox(width: 8),

        if (isClient && isRate)
        // Wrap rating display in IntrinsicWidth to avoid shrinking rating text too much
          IntrinsicWidth(child: _buildRatingDisplay(context)),

        if (!isClient && isRate) const SizedBox(width: 8),

        if (!isClient && isRate)
        // Wrap the rating + modify button inside IntrinsicWidth and Row
          IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rating display with flexible text that can shrink if needed
                Flexible(
                  child: _buildRatingDisplay(context),
                ),
                const SizedBox(width: 6),

                // Modify button wrapped in ConstrainedBox with minWidth so it never shrinks too much
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: InkWell(
                    onTap: () => _openRatingSheet(context),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cF3F3F3,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        LocaleKeys.modify.localize,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,

                        style: Styles.smallText(
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (!isRate && !isClient) const SizedBox(width: 8),

        if (!isRate && !isClient)
          Flexible(child: _buildNoRatingButton(context)),
      ],
    );
  }

  Widget _buildRatingDisplay(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            getRatingLabel(rate!),
            style: Styles.smallText(
              fontWeight: FontWeight.w600,
              color: getRatingColor(rate!),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 6),
        RatingBar(
          initialRating: rate!,
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
      ],
    );
  }

  Widget _buildNoRatingButton(BuildContext context) {
    return InkWell(
      onTap: () => _openRatingSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cF3F3F3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          LocaleKeys.noRating.localize,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextColor(context),
          ),
        ),
      ),
    );
  }
}

class RatingBottomSheet extends StatefulWidget {
  final String tripId;
  final DashboardsCubit cubit;
  final Function(double)? onRatingUpdated;
  final double? existingRate;
  final bool isRide;

  const RatingBottomSheet({
    super.key,
    required this.tripId,
    required this.cubit,
    this.onRatingUpdated,
    this.existingRate,
    required this.isRide,
  });

  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}
class _RatingBottomSheetState extends State<RatingBottomSheet> {
  late double _rating;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.existingRate ?? 0;
    if (widget.existingRate != null) {
      _commentController.text = ''; // Load existing comment if available
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  Future<void> _sendRating(BuildContext context) async {
    if (_rating == 0) {
      return;
    }

    try {
      if (widget.isRide == true) {
        if (widget.existingRate == null || widget.existingRate == 0) {
          // First time rating for ride
          final params = AddRateWithDriverParams(
            tripId: widget.tripId,
            rate: _rating,
            comment: _commentController.text.trim(),
          );
          await widget.cubit.rateDriverNonSocket(params: params);
        } else {
          // Update existing rating for ride
          // Using correct parameter class for driver rating update
          final params = UpdateClientRateParams(
            tripId: widget.tripId,
            newRatingValue: _rating,
            newComment: _commentController.text.trim(),
          );
          await widget.cubit.updateRateDriverNonSocket(params: params, context: context);
        }
      } else {
        // Loading/delivery trip
        if (widget.existingRate == null || widget.existingRate == 0) {
          // First time rating for loading
          final params = AddRateWithDriverLoadingParams(
            tripId: widget.tripId,
            rate: _rating,
            comment: _commentController.text.trim(),
          );
          await widget.cubit.rateDriverLoadingNonSocket(params: params);
        } else {
          // Update existing rating for loading
          // Using correct parameter class for driver loading rating update
          final params = UpdateClientRateParams(
            tripId: widget.tripId,
            newRatingValue: _rating,
            newComment: _commentController.text.trim(),
          );
          await widget.cubit.updateRateDriverLoadingNonSocket(params: params, context: context);
        }
      }

      // Notify callback if provided
      if (widget.onRatingUpdated != null) {
        widget.onRatingUpdated!(_rating);
      }

      // Close dialog if widget is still mounted
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message if widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.errorHappen.localize}: $e'),
            backgroundColor: AppColors.getFindFillColor(context),
          ),
        );
      }
    }
  }
/*
  Future<void> _sendRating(BuildContext context) async {
    if (_rating == 0) {
      return;
    }

    try {
      if(widget.isRide == true){
        if (widget.existingRate == null || widget.existingRate == 0) {
          // First time rating
          final params = AddRateWithDriverParams(
            tripId: widget.tripId,
            rate: _rating,
            comment: _commentController.text.trim(),
          );
          await widget.cubit.rateDriverNonSocket(params: params);
        } else {
          // Update existing rating
          // Note: You'll need to create UpdateDriverRateParams similar to UpdateClientRateParams
          final params = UpdateClientRateParams(
            tripId: widget.tripId,
            newRatingValue: _rating,
            newComment: _commentController.text.trim(),
          );
          await widget.cubit.updateRateDriverNonSocket(params: params, context: context);

          print("x");
        }

      }else {
        if (widget.existingRate == null || widget.existingRate == 0) {
          // First time rating
          final params = AddRateWithDriverLoadingParams(
            tripId: widget.tripId,
            rate: _rating,
            comment: _commentController.text.trim(),
          );
          await widget.cubit.rateDriverLoadingNonSocket(params: params);
        } else {
          // Update existing rating
          // Note: You'll need to create UpdateDriverRateParams similar to UpdateClientRateParams
          final params = UpdateClientRateParams(
            tripId: widget.tripId,
            newRatingValue: _rating,
            newComment: _commentController.text.trim(),
          );
          await widget.cubit.updateRateDriverLoadingNonSocket(params: params, context: context);

          print("x");
        }
        print("Hahahahahahahaha");
      }

      if (widget.onRatingUpdated != null) {
        widget.onRatingUpdated!(_rating);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.errorHappen.localize}: $e'),
            backgroundColor: AppColors.getFindFillColor(context),
          ),
        );
      }
    }
  }
*/
  String getRatingText() {
    if (_rating == 1) return LocaleKeys.poor2.localize;
    if (_rating == 2) return LocaleKeys.bad.localize;
    if (_rating == 3) return LocaleKeys.good.localize;
    if (_rating == 4) return LocaleKeys.veryGood.localize;
    if (_rating == 5) return LocaleKeys.excellent.localize;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.getFindFillColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.existingRate != null
                    ? LocaleKeys.update.localize
                    : LocaleKeys.rateTheRestaurant.localize,
                style: Styles.headerText(
                  fontWeight: FontWeight.w700,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                getRatingText(),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              RatingBar(
                initialRating: _rating,
                ignoreGestures: false,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                ratingWidget: RatingWidget(
                  full: SvgPicture.asset(Assets.star1),
                  half: SvgPicture.asset(Assets.star1),
                  empty: SvgPicture.asset(Assets.starEmpty,
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black),
                ),
                itemSize: 40,
                onRatingUpdate: (rating) => setState(() => _rating = rating),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: LocaleKeys.comment.localize,
                  hintStyle: Styles.smallText(
                      color: AppColors.getTextColor(context).withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color:
                        AppColors.getTextColor(context).withOpacity(0.4)),
                  ),
                  filled: true,
                  fillColor: context.isDarkMode
                      ? Colors.black12
                      : Colors.grey.shade100,
                ),
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
                label: widget.existingRate != null
                    ? LocaleKeys.update.localize
                    : LocaleKeys.submit.localize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Client
class RideDetailsRatingNonSocketClientWidget extends StatelessWidget {
  final double? rate;
  final String title;
  final ClientTripsCubit cubit;
  final String tripId;
  final bool isClient;
  final Function(double)? onRatingUpdated;

  const RideDetailsRatingNonSocketClientWidget({
    super.key,
    required this.rate,
    required this.title,
    required this.cubit,
    required this.tripId,
    this.onRatingUpdated,
    this.isClient = false,
  });

  bool get isRate => rate != null && rate! > 0;

  String getRatingLabel(double rate) {
    if (rate >= 1 && rate <= 1.5) return LocaleKeys.poor2.tr();
    if (rate > 1.5 && rate <= 2.5) return LocaleKeys.bad.tr();
    if (rate > 2.5 && rate <= 3.5) return LocaleKeys.good.tr();
    if (rate > 3.5 && rate <= 4.5) return LocaleKeys.veryGood.tr();
    if (rate > 4.5 && rate <= 5) return LocaleKeys.excellent.tr();
    return '';
  }

  Color getRatingColor(double rate) {
    if (rate >= 1 && rate <= 1.5) return Colors.red;
    if (rate > 1.5 && rate <= 2.5) return Colors.orange;
    if (rate > 2.5 && rate <= 3.5) return Colors.amber;
    if (rate > 3.5 && rate <= 4.5) return Colors.lightGreen;
    if (rate > 4.5 && rate <= 5) return Colors.green;
    return Colors.grey;
  }

  void _openRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => RatingBottomSheetClient(
        tripId: tripId,
        cubit: cubit,
        onRatingUpdated: onRatingUpdated,
        existingRate: rate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title: Expanded to take leftover space but ellipsize if needed
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),

        if (isClient && isRate) const SizedBox(width: 8),

        if (isClient && isRate)
        // Wrap rating display in IntrinsicWidth to avoid shrinking rating text too much
          IntrinsicWidth(child: _buildRatingDisplay(context)),

        if (!isClient && isRate) const SizedBox(width: 8),

        if (!isClient && isRate)
        // Wrap the rating + modify button inside IntrinsicWidth and Row
          IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rating display with flexible text that can shrink if needed
                Flexible(
                  child: _buildRatingDisplay(context),
                ),
                const SizedBox(width: 6),

                // Modify button wrapped in ConstrainedBox with minWidth so it never shrinks too much
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 60),
                  child: InkWell(
                    onTap: () => _openRatingSheet(context),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cF3F3F3,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        LocaleKeys.modify.localize,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: Styles.smallText(
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (!isRate && !isClient) const SizedBox(width: 8),

        if (!isRate && !isClient)
          Flexible(child: _buildNoRatingButton(context)),
      ],
    );
  }


  Widget _buildRatingDisplay(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            getRatingLabel(rate!),
            style: Styles.smallText(
              fontWeight: FontWeight.w600,
              color: getRatingColor(rate!),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 6),
        RatingBar(
          initialRating: rate!,
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
      ],
    );
  }


  Widget _buildNoRatingButton(BuildContext context) {
    return InkWell(
      onTap: () => _openRatingSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8), // reduced padding
        decoration: BoxDecoration(
          color: AppColors.cF3F3F3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          LocaleKeys.noRating.localize,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextColor(context),
          ),
        ),
      ),
    );
  }




}

class RatingBottomSheetClient extends StatefulWidget {
  final String tripId;
  final ClientTripsCubit cubit;
  final Function(double)? onRatingUpdated;
  final double? existingRate;

  const RatingBottomSheetClient({
    super.key,
    required this.tripId,
    required this.cubit,
    this.onRatingUpdated,
    this.existingRate,
  });

  @override
  _RatingBottomSheetClientState createState() =>
      _RatingBottomSheetClientState();
}

class _RatingBottomSheetClientState extends State<RatingBottomSheetClient> {
  late double _rating;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.existingRate ?? 0;
    if (widget.existingRate != null) {
      _commentController.text =
          ''; // You might want to load existing comment here
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendRating(BuildContext context) async {
    if (_rating == 0) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(LocaleKeys.pleaseProvideRate.localize),
      //     backgroundColor: AppColors.PRIMARY_COLOR,
      //
      //   ),
      // );
      return;
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(LocaleKeys.submittingRating.localize),
    //     backgroundColor: AppColors.PRIMARY_COLOR,
    //
    //   ),
    // );

    try {
      if (widget.existingRate == null || widget.existingRate == 0) {
        // First time rating
        final params = AddRateWithDriverParams(
          tripId: widget.tripId,
          rate: _rating,
          comment: _commentController.text.trim(),
        );
        await widget.cubit
            .rateClientNonSocket(params: params, context: context);
      } else {
        // Update existing rating
        final params = UpdateClientRateParams(
          tripId: widget.tripId,
          newRatingValue: _rating,
          newComment: _commentController.text.trim(),
        );
        await widget.cubit
            .updateRateClientNonSocket(params: params, context: context);
      }

      // This is the key part - call the callback before navigation
      if (widget.onRatingUpdated != null) {
        widget.onRatingUpdated!(_rating);
      }

      if (mounted) {
        Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(LocaleKeys.ratingSubmittedSuccessfully.localize),
        //     backgroundColor: AppColors.PRIMARY_COLOR,
        //
        //   ),
        // );
      }
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('${LocaleKeys.errorHappen.localize}: $e'),
        //     backgroundColor: AppColors.getFindFillColor(context),
        //   ),
        // );
      }
    }
  }

  String getRatingText() {
    if (_rating == 1) return LocaleKeys.poor2.localize;
    if (_rating == 2) return LocaleKeys.bad.localize;
    if (_rating == 3) return LocaleKeys.good.localize;
    if (_rating == 4) return LocaleKeys.veryGood.localize;
    if (_rating == 5) return LocaleKeys.excellent.localize;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.getFindFillColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Label(
                text: widget.existingRate != null
                    ? LocaleKeys.update.localize
                    : LocaleKeys.rateTheDriver.localize,
                style: Styles.headerText(
                  fontWeight: FontWeight.w700,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Label(
                text: getRatingText(),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              RatingBar(
                initialRating: _rating,
                ignoreGestures: false,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                ratingWidget: RatingWidget(
                  full: SvgPicture.asset(Assets.star1),
                  half: SvgPicture.asset(Assets.star1),
                  empty: SvgPicture.asset(Assets.starEmpty,
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black),
                ),
                itemSize: 40,
                onRatingUpdate: (rating) => setState(() => _rating = rating),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: LocaleKeys.comment.localize,
                  hintStyle: Styles.smallText(
                      color: AppColors.getTextColor(context).withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color:
                            AppColors.getTextColor(context).withOpacity(0.4)),
                  ),
                  filled: true,
                  fillColor: context.isDarkMode
                      ? Colors.black12
                      : Colors.grey.shade100,
                ),
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
                label: widget.existingRate != null
                    ? LocaleKeys.update.localize
                    : LocaleKeys.submit.localize,
              ),
            ],
          ),
        ),
      ),
    );
  }


}

