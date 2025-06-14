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
import '../../../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';

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
  TextEditingController rateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _rating = widget.rate;
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
           Text(getRatingText(widget.rate),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: (){
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
                    setState(() {
                      _rating = rating;
                    });
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
  final Function(double)? onRatingUpdated;

  const RideDetailsRatingNonSocketWidget({
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
    if (rate >= 1 && rate <= 1.5) {
      return LocaleKeys.poor2.tr();
    } else if (rate > 1.5 && rate <= 2.5) {
      return LocaleKeys.bad.tr();
    } else if (rate > 2.5 && rate <= 3.5) {
      return LocaleKeys.good.tr();
    } else if (rate > 3.5 && rate <= 4.5) {
      return LocaleKeys.veryGood.tr();
    } else if (rate > 4.5 && rate <= 5) {
      return LocaleKeys.excellent.tr();
    }
    return '';
  }

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
  Color getRatingColor(double rate) {
    if (rate >= 1 && rate <= 1.5) {
      return Colors.red;
    } else if (rate > 1.5 && rate <= 2.5) {
      return Colors.orange;
    } else if (rate > 2.5 && rate <= 3.5) {
      return Colors.amber;
    } else if (rate > 3.5 && rate <= 4.5) {
      return Colors.lightGreen;
    } else if (rate > 4.5 && rate <= 5) {
      return Colors.green;
    }
    return Colors.grey;
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

        // Show for client
        if (isClient && isRate)
          Row(
            children: [
              Text(
                getRatingLabel(rate!),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: getRatingColor(rate!),
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
          ),

        // Show for non-client with rate
        if (!isClient && isRate)
          Row(
            children: [
              Text(
                getRatingLabel(rate!),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: getRatingColor(rate!),
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
            ],
          ),

        // No rate, and not client
        if (!isRate && !isClient)
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
