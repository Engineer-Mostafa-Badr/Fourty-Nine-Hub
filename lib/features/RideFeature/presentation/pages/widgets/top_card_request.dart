import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import 'font_manager.dart';

class TopCardRequest extends StatelessWidget {
  final RideOfferEntity rideOffer;
  final VoidCallback onAccept;
  final RideCubit rideCubit;

  const TopCardRequest({
    super.key,
    required this.rideOffer,
    required this.onAccept,
    required this.rideCubit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final cardColor = isDark ? const Color(0xff2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xff0B1035);
    final subTextColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    final shadowColor = isDark ? Colors.black54 : Colors.grey.shade300;
    final refuseButtonColor = isDark
        ? AppColors.BG_GRAY_COLOR.withOpacity(.6)
        : const Color(0xffF5F5F5);

    return rideOffer.isExpired? const SizedBox.shrink() : Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardColor,
        shadowColor: shadowColor,
        child: Container(
          padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width - 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: rideOffer.driverImage != null && rideOffer.driverImage!.isNotEmpty
                        ? NetworkImage(rideOffer.driverImage!) as ImageProvider<Object>
                        : AssetImage(Assets.maleImagePlaceholder) as ImageProvider<Object>,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              rideOffer.driverName?? "",
                              style: TextStyle(
                                fontSize: FontSize.s14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                            const SizedBox(width: 2),
                            (rideOffer.rating == null || rideOffer.ratingCount == null)? const SizedBox.shrink() : Text(
                              "${FormatNumbers().convertNumberToLocalizedString(rideOffer.rating!.toStringAsFixed(2), isArabic: context.isArabic)} (${FormatNumbers().convertNumberToLocalizedString(rideOffer.ratingCount.toString(), isArabic: context.isArabic)})",
                              style: TextStyle(
                                fontSize: FontSize.s14,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            (rideOffer.tripsCount == null || rideOffer.tripsCount == 0) ? const SizedBox.shrink() : Text(
                              "(${FormatNumbers().convertNumberToLocalizedString(rideOffer.tripsCount.toString(), isArabic: context.isArabic)})",
                              style: TextStyle(
                                fontSize: FontSize.s12,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Text(
                        //   FormatNumbers().convertNumberToLocalizedString(rideOffer.carModel ?? "بسب" , isArabic: context.isArabic),
                        //   style: TextStyle(
                        //     fontSize: FontSize.s12,
                        //     color: textColor,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        Row(
                          children: [
                            rideOffer.isComfort?
                            Image.asset(
                              Assets.airConditioner,
                              height: 20,
                              width: 20,
                            ) : Image.asset(
                              Assets.noAirConditioner,
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            rideOffer.isNonSmoking?
                            Image.asset(
                              Assets.noSmokingIcon,
                              height: 20,
                              width: 20,
                            ) : Image.asset(
                              Assets.smokingIcon,
                              height: 16,
                              width: 16,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${FormatNumbers().convertNumberToLocalizedString(formatDuration(rideOffer.duration ?? 0, context), isArabic: context.isArabic)}, ${formatDistance(rideOffer.distance ?? 0, context)}",
                        style: TextStyle(
                          fontSize: FontSize.s12,
                          color: subTextColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${FormatNumbers().convertNumberToLocalizedString(rideOffer.price?.toInt().toString() ?? "0", isArabic: context.isArabic)} ${context.isArabic ? "ج.م" : "EGP"}",
                        style: TextStyle(
                          fontSize: FontSize.s18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 10),
                      tween: Tween(begin: 0.0, end: 1.0),
                      onEnd: (){
                        ManageVibration.vibrate();
                        rideCubit.removeRideOfferFromRideOffers(rideOffer);
                      },
                      builder: (context, value, child) {
                        return Stack(
                          children: [
                            Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xff0B1035),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF33D49),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 38,
                                child: MaterialButton(
                                  onPressed: onAccept,
                                  child: Text(
                                    context.isArabic ? "قبول" : "Accept",
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: refuseButtonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MaterialButton(
                        onPressed: (){
                          rideCubit.removeRideOfferFromRideOffers(rideOffer);
                        },
                        child: Text(
                          LocaleKeys.refuse.tr(),
                          style: TextStyle(color: textColor, fontSize: 18),
                        ),
                      ),
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

  static String formatDistance(double distance, BuildContext context) {
    return "${FormatNumbers().convertNumberToLocalizedString((distance / 1000).toStringAsFixed(1), isArabic: context.isArabic)} ${context.isArabic ? "كم" : "KM"}";
  }

  // static String formatDuration(double duration, BuildContext context) {
  //   int minutes = (duration / 60).ceil();
  //   return "${FormatNumbers().convertNumberToLocalizedString(minutes.toString(), isArabic: context.isArabic)} ${context.isArabic ? "دقيقة" : "Mins"}";
  // }
  static String formatDuration(num arrivalTimestamp, BuildContext context) {
    final now = DateTime.now();
    final arrivalTime = DateTime.fromMillisecondsSinceEpoch(arrivalTimestamp.toInt());

    final duration = arrivalTime.difference(now);
    int minutes = duration.inMinutes;

    if (minutes <= 0) {
      minutes = 1;
    }

    final localizedMinutes = FormatNumbers()
        .convertNumberToLocalizedString(minutes.toString(), isArabic: context.isArabic);

    return "$localizedMinutes ${context.isArabic ? "دقيقة" : "mins"}";
  }

}
