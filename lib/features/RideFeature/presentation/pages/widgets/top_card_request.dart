import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import 'font_manager.dart';

class TopCardRequest extends StatelessWidget {
  final String driverName;
  final String driverImage;
  final double driverRating;
  final int ratingCount;
  final int totalTrips;
  final String carModel;
  final String timeDistance;
  final int price;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  const TopCardRequest({
    super.key,
    required this.driverName,
    required this.driverImage,
    required this.driverRating,
    required this.ratingCount,
    required this.totalTrips,
    required this.carModel,
    required this.timeDistance,
    required this.price,
    required this.onAccept,
    required this.onRefuse,
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

    return Padding(
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
                    backgroundImage: NetworkImage(driverImage),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              driverName,
                              style: TextStyle(
                                fontSize: FontSize.s14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              "$driverRating ($ratingCount)",
                              style: TextStyle(
                                fontSize: FontSize.s14,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "($totalTrips)",
                              style: TextStyle(
                                fontSize: FontSize.s12,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          carModel,
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeDistance,
                        style: TextStyle(
                          fontSize: FontSize.s12,
                          color: subTextColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$price ${context.isArabic ? "ج.م" : "EGP"}",
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
                        onPressed: onRefuse,
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
}
