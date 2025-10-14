import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';
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
import 'package:fourtyninehub/helpers/manage_vibration.dart';
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
      // padding: const EdgeInsets.all(8.0),
      // decoration: BoxDecoration(
      //     color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
      //     borderRadius: BorderRadius.circular(20)
      // ),
      child: GlobalCard(
        otherUserId: '',
        phone: '',
        reportId: widget.offers?.clientDetails?.id??'',
        subcategoryId: widget.offers?.subCategory?.id??'',
        // isButtonEnabled: offers.,
        subCategoryTitle: context.isArabic?widget.offers?.subCategory?.nameAr??'':widget.offers?.subCategory?.nameEn??'',

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClickableWidget(
                              onTap: (){},
                              child: ProfilePictureWidget(
                                rating:(widget.offers?.clientDetails?.rating?.average??0).toInt(),
                                image: '',
                                firstChar: widget.offers?.clientDetails?.firstName?[0].toUpperCase() ?? '',
                                hasStories: false,
                              ),
                            ),
                            Sizer(),
                            Expanded(
                              child: Label(
                                  text: widget.offers?.clientDetails?.firstName ?? '',
                                  style: Styles.mediumText()),
                            ),
                          ],
                        ),
                        Sizer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TripLocationWidget(isFrom: true, title: widget.offers?.tripDetails?.startLocation
                                ?.title ??
                                'From Location',fontSize:28),
                            TripLocationWidget(isFrom: false, title: widget.offers?.tripDetails?.targetLocation
                                ?.title ??
                                'Cairo International Airport',fontSize:28),
                            Label(
                              text:
                              "${context.isArabic?"وصف الحمولة":"Cargo Description"} : ${widget.offers?.tripDetails?.cargoDescription??''} ",
                              style: Styles.mediumText(),maxLines: 2,),
                          ],
                        ),
                      ])),
                  const Sizer(width: 32),
                  Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Label(
                            text: formatPrice(
                                (widget.offers?.tripDetails?.price??0)>0?(widget.offers?.tripDetails?.price??0):(widget.offers?.tripDetails?.price ?? 0), context),
                            style: Styles.mediumText(fontWeight: FontWeight.w700),
                          ),
                          const Sizer(width: 4),
                          Label(
                            text: LocaleKeys.egp.tr(),
                            style: Styles.mediumText(
                              color: AppColors.SECONDARY_COLOR,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ImageFromInternet(
                              image:
                              widget.offers?.subCategory?.pictureUrl ?? '',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain),
                          Label(
                              text: context.isArabic
                                  ? (widget.offers?.subCategory?.nameAr ?? '')
                                  : (widget.offers?.subCategory?.nameEn ?? ''),
                              style: Styles.mediumText(fontSize: 25))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Sizer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                    text:
                    formatTimeOnly(widget.offers?.tripDetails?.pickupTime, context),
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Label(
                    text: formatPickupDate(
                        widget.offers?.tripDetails?.pickupTime, context),
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Sizer(),
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
                        ManageVibration.vibrate();
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
                          widget.offers?.subCategory?.id ?? "",
                          context.isArabic?widget.offers?.subCategory?.nameAr ?? "":widget.offers?.subCategory?.nameEn ?? "",
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
                        ManageVibration.vibrate();
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
      ManageVibration.vibrate();
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
                      context.isArabic?widget.offers?.subCategory?.nameAr ?? "":widget.offers?.subCategory?.nameEn ?? "",
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
      ManageVibration.vibrate();
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
                          widget.offers?.subCategory?.id ?? "",
                        context.isArabic?widget.offers?.subCategory?.nameAr ?? "":widget.offers?.subCategory?.nameEn ?? "",
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

