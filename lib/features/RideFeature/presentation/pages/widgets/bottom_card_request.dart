import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import 'font_manager.dart';


class BottomCardRequest extends StatefulWidget {
  final int driversCount;
  final int price;
  final VoidCallback onCancel;

  const BottomCardRequest({
    Key? key,
    required this.driversCount,
    required this.price,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<BottomCardRequest> createState() => _BottomCardRequestState();
}

class _BottomCardRequestState extends State<BottomCardRequest> {
  bool isAutomatic = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color cardColor = isDark ? const Color(0xff2C2C2C) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    // final Color subTextColor = isDark ? Colors.grey.shade300 : Colors.black54;
    final Color switchActiveTrack = isDark ? Colors.grey.shade700 : Colors.white;

    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      color: cardColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 35,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStackedAvatars(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "${widget.driversCount} ",
                          style: TextStyle(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          LocaleKeys.driversDisplayYourRequest.localize,
                          style: TextStyle(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [

                      Text(
                        " ${widget.price} ",
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: textColor,
                        ),
                      ),
                      Text(
                        LocaleKeys.acceptTheNearestDriverFor.tr(),
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Switch(
                  value: isAutomatic,
                  onChanged: (val) {
                    setState(() {
                      isAutomatic = val;
                    });
                  },
                  activeColor: AppColors.PRIMARY_COLOR,
                  activeTrackColor: AppColors.LightWHATS_APP_COLOR,
                  inactiveThumbColor: AppColors.PRIMARY_COLOR,
                  inactiveTrackColor: AppColors.LIGHT_GRAY_COLOR,
                  // activeColor: AppColors.PRIMARY_COLOR,
                  // activeTrackColor: switchActiveTrack,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.cancelOrder.tr(),
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build overlapping driver avatars
  Widget _buildStackedAvatars() {
    final images = [
      "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
      "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
      "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
    ];

    return SizedBox(
      width: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(images[0]),
            ),
          ),
          Positioned(
            left: 20,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(images[1]),
            ),
          ),
          Positioned(
            left: 40,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(images[2]),
            ),
          ),
        ],
      ),
    );
  }
}


