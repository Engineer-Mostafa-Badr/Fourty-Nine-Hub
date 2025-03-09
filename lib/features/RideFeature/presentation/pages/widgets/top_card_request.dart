import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import 'font_manager.dart';
import 'gradient_button.dart';
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
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final cardColor = isDark ? const Color(0xff2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    final shadowColor = isDark ? Colors.black54 : Colors.grey.shade300;
    final refuseButtonColor = isDark
        ? AppColors.BG_GRAY_COLOR.withOpacity(.6)
        : AppColors.BG_GRAY_COLOR.withOpacity(.3);

    return Card(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driverName,
                          style: TextStyle(
                            fontSize:  FontSize.s14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.amber.shade700, size:  FontSize.s14),
                        const SizedBox(width: 2),
                        Text(
                          "$driverRating ($ratingCount)",
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            color: subTextColor,
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
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  timeDistance,
                  style: TextStyle(
                    fontSize: FontSize.s12,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Text(
                  "$price EGP",
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: refuseButtonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MaterialButton(
                      onPressed: onRefuse,
                      child: Text(
                        LocaleKeys.refuse.tr(),
                        style: TextStyle(color: textColor, fontSize: FontSize.s14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GradientButton(
                    text: LocaleKeys.acceptRequest.tr(),
                    onPressed: onAccept,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


