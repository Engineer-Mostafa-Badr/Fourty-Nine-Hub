import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../common/widgets/stateless/verified_widget.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/loading/get_loading_avaliable_entity.dart';
import '../../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
// Solution 1: Check if widget is mounted before using context
class AvailableNonSocketLoadingWidget extends StatefulWidget {
  final GetLoadingAvailableEntity? offers;

  const AvailableNonSocketLoadingWidget({
    super.key,
    this.offers,
  });

  @override
  State<AvailableNonSocketLoadingWidget> createState() => _AvailableNonSocketLoadingWidgetState();
}

class _AvailableNonSocketLoadingWidgetState extends State<AvailableNonSocketLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        widget.offers?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Column(children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: widget.offers?.clientDetails?.profilePictureUrl == null ||
                              widget.offers!.clientDetails!.profilePictureUrl!.isEmpty
                              ? Image.asset(
                            Assets.maleImagePlaceholder,
                            fit: BoxFit.cover,
                          )
                              : ImageFromInternet(
                            image: widget.offers!.clientDetails!.profilePictureUrl!,
                          )
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: -5,
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cF5F5F5,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(children: [
                                  SvgPicture.asset(Assets.star2, width: 8, height: 8),
                                  const Sizer(width: 4),
                                  Label(
                                      text:formatPrice(widget.offers?.clientDetails?.rating?.count  ?? 0,context),
                                      style: Styles.smallText(color: AppColors.PRIMARY_COLOR))
                                ])))),
                    const VerifiedWidget(),
                  ],
                ),
                Label(
                    text: widget.offers?.clientDetails?.firstName ?? '',
                    style: Styles.mediumText()),
              ])),
          const Sizer(width: 32),
          Expanded(
            flex: 8,
            child: IntrinsicWidth(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(Assets.rideFrom, width: 24, height: 24),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: widget.offers?.tripDetails?.startLocation?.title ??
                                            'Cairo International Airport',
                                        style: Styles.headerText()))
                              ],
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(Assets.rideTo, width: 24, height: 24)),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: widget.offers?.tripDetails?.targetLocation?.title ??
                                            'Cairo International Airport',
                                        style: Styles.mediumText(fontWeight: FontWeight.w300)))
                              ],
                            ),
                            Label(
                                text: widget.offers?.tripDetails?.cargoDescription ?? "",
                                style: Styles.mediumText())
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              ImageFromInternet(
                                  image: widget.offers!.subCategory?.pictureUrl ?? "",
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain),
                              Label(
                                  text: context.isArabic
                                      ? (widget.offers?.subCategory?.nameAr ?? '')
                                      : (widget.offers?.subCategory?.nameEn ?? ''),
                                  style: Styles.mediumText(fontSize: 25))
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                          text: "${widget.offers?.tripDetails?.price ?? 300}",
                          style: Styles.mediumText(fontWeight: FontWeight.w700)),
                      const Sizer(width: 4),
                      Label(
                          text: LocaleKeys.egp.tr(),
                          style: Styles.mediumText(
                              color: AppColors.SECONDARY_COLOR,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: formatTimeOnly(widget.offers!.tripDetails?.pickupTime, context),
                        // text: formatTimeOnly(widget.offers?.createdAt, context),
                        style: Styles.mediumText(fontWeight: FontWeight.w700),
                      ),
                      Label(
                        text: formatPickupDate(widget.offers!.tripDetails?.pickupTime, context),
                        style: Styles.mediumText(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 30,
                          radius: 15,
                          widget: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Label(
                                    text: "${LocaleKeys.Accept.tr()} ${widget.offers?.tripDetails?.price ?? 0} ${LocaleKeys.egp.localize}",
                                    style: Styles.mediumText(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            if (!mounted) return; // Check if widget is still mounted

                            final price = widget.offers?.tripDetails?.price ?? 0;
                            final tripId = widget.offers?.tripDetails?.id ?? '';
                            print("XXQ $tripId");
                            print("XXQ ${widget.offers?.tripDetails?.id}");

                            context.read<DashboardsCubit>().createLoadingOffer(
                                CreateNonTrackOfferParams(
                                  tripId: tripId,
                                  priceOffer: price,
                                ),
                                context,
                                widget.offers?.clientDetails?.id ?? ""
                            );
                          },
                          backColor: context.isDarkMode
                              ? AppColors.ACCENT_COLOR
                              : AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: AppButton(
                          radius: 15,
                          height: 30,
                          label: LocaleKeys.acceptAnothePrice.tr(),
                          style: Styles.mediumText(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                          onPressed: () {
                            if (!mounted) return; // Check if widget is still mounted
                            _showOfferFareBottomSheet(context, widget.offers?.tripDetails?.id ?? '');
                          },
                          backColor: AppColors.SECONDARY_COLOR_DARK2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showOfferFareBottomSheet(BuildContext parentContext, String tripId) {
    final TextEditingController offerPriceController = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      builder: (BuildContext bottomSheetContext) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Label(
                        text: LocaleKeys.offerYourFare.localize,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(bottomSheetContext),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.cEEEEEEE,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: offerPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.egp.tr(),
                    hintStyle: const TextStyle(fontSize: 40, color: AppColors.c96979B),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
                const SizedBox(height: 50),
                AppButton(
                  radius: 15,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {
                    final enteredPrice = num.tryParse(offerPriceController.text) ?? 0;

                    // Close the bottom sheet first
                    Navigator.pop(bottomSheetContext);

                    // Use the PARENT context here to avoid deactivated context error
                    context.read<DashboardsCubit>().createLoadingOffer(
                      CreateNonTrackOfferParams(
                        tripId: tripId,
                        priceOffer: enteredPrice,
                      ),
                      parentContext,
                      widget.offers?.subCategory?.id ?? "",
                    );
                  },
                  label: LocaleKeys.done.localize,
                  style: const TextStyle(
                    color: AppColors.LIGHT_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOfferFareBottomSheet2(BuildContext context, String tripId) {
    final TextEditingController offerPriceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Label(
                        text: LocaleKeys.offerYourFare.localize,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.PRIMARY_COLOR),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.cEEEEEEE,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: AppColors.PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: offerPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.egp.tr(),
                    hintStyle: const TextStyle(fontSize: 40, color: AppColors.c96979B),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                ),
                const SizedBox(height: 50),
                AppButton(
                  radius: 15,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {
                    final enteredPrice = num.tryParse(offerPriceController.text) ?? 0;
                    Navigator.pop(context);

                    // Check if the original widget is still mounted before using context
                    if (mounted) {
                      context.read<DashboardsCubit>().createLoadingOffer(
                          CreateNonTrackOfferParams(
                            tripId: tripId,
                            priceOffer: enteredPrice,
                          ),
                          context,
                          widget.offers?.subCategory?.id ?? ""
                      );
                    }
                  },
                  label: LocaleKeys.done.localize,
                  style: const TextStyle(
                    color: AppColors.LIGHT_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


