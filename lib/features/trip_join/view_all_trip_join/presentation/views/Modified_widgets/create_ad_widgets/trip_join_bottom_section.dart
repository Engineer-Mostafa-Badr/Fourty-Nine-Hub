import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../domain/entities/expected_price_entity.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../helpers/manage_vibration.dart';



class TripJoinBottomSection extends StatelessWidget {
  const TripJoinBottomSection({
    super.key,
    this.expectedPriceTripEntity,
    required this.selectedSeatNum,
    required this.isChecked,
    required this.time,
    required this.onSeatNumChanged,
    required this.onCheckedChanged,
    required this.onTimeChanged,
    required this.formatDistance,
    required this.calculateTotalPrice,
    required this.getTime,
  });

  final ExpectedPriceTripEntity? expectedPriceTripEntity;
  final int? selectedSeatNum;
  final bool isChecked;
  final TimeOfDay? time;
  final void Function(int?) onSeatNumChanged;
  final void Function(bool?) onCheckedChanged;
  final void Function(TimeOfDay?) onTimeChanged;
  final String Function(double) formatDistance;
  final String Function() calculateTotalPrice;
  final String Function() getTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.h),
      decoration: BoxDecoration(
        color: AppColors.getFillColor(context),
        borderRadius: BorderRadius.circular(30.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /// LEFT SIDE: Icon + Distance
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 30,
                            color: AppColors.getTextColor(context),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              formatDistance(expectedPriceTripEntity?.distance ?? 0),
                              style: Styles.headerText(color: AppColors.getTextColor(context)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    /// RIGHT SIDE: Price + Currency
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              calculateTotalPrice(),
                              style: Styles.headerText(
                                color: AppColors.getTextColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.isArabic ? 'جنيه' : 'EGP',
                            style: Styles.mediumText(
                              fontSize: context.locale.languageCode == "ar" ? 35 : 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.getRedColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                Row(
                  children: [
                    /// LEFT SIDE: Time Picker
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
      ManageVibration.vibrate();
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(hour: 0, minute: 0),
                              );
                              onTimeChanged(newTime);
                            },
                            child: Icon(
                              Icons.access_time,
                              size: 30,
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              getTime(),
                              style: Styles.headerText(color: AppColors.getTextColor(context)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    /// RIGHT SIDE: Checkbox + Repeat Text
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: isChecked,
                            onChanged: onCheckedChanged,
                            checkColor: context.isDarkMode ? Colors.black : Colors.white,
                            activeColor: AppColors.getTextColor(context),
                            side: BorderSide(
                              color: AppColors.getTextColor(context),
                              width: 2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              LocaleKeys.repeat.localize,
                              style: Styles.headerText(color: AppColors.getTextColor(context)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// LEFT SIDE: Seat Picker
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton<int>(
                            dropdownColor: AppColors.getFillColor(context),
                            borderRadius: BorderRadius.circular(15),
                            menuWidth: 100.w,
                            enableFeedback: false,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            underline: const SizedBox.shrink(),
                            value: selectedSeatNum,
                            items: [1, 2, 3, 4, 5, 6].map(
                                  (e) => DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: e,
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(color: AppColors.getTextColor(context)),
                                ),
                              ),
                            ).toList(),
                            onChanged: onSeatNumChanged,
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            LocaleKeys.seat.localize,
                            style: Styles.headerText(color: AppColors.getTextColor(context)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    /// RIGHT SIDE: Baby Seat Icon + Text
                    Expanded(
                      flex: 1,
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Assets.tripJoinBabySeatIcon,
                            height: 40.h,
                            color: AppColors.getTextColor(context),
                          ),
                          Flexible(
                            child: Text(
                              LocaleKeys.seat.localize,
                              style: Styles.headerText(
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





/*
class TripJoinBottomSection extends StatefulWidget {
  const TripJoinBottomSection({super.key, this.expectedPriceTripEntity});

  final ExpectedPriceTripEntity? expectedPriceTripEntity;

  @override
  State<TripJoinBottomSection> createState() => _TripJoinBottomSectionState();
}

class _TripJoinBottomSectionState extends State<TripJoinBottomSection> {
  String? selectedBrand;
  String? selectedModel;
  int? selectedSeatNum;
  bool isChecked = false;
  TimeOfDay? time;
  int seatNum = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.h),
      decoration: BoxDecoration(
          color: AppColors.getFillColor(context),
          borderRadius: BorderRadius.circular(30.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /// LEFT SIDE: Icon + Distance
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 30,
                            color: AppColors.getTextColor(context),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            // Ensures text doesn't overflow
                            child: Text(
                              _formatDistance(
                                  widget.expectedPriceTripEntity?.distance ??
                                      0),
                              style: Styles.headerText(
                                  color: AppColors.getTextColor(context)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// RIGHT SIDE: Price + Currency
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              '${_calculateTotalPrice()}',
                              style: Styles.headerText(
                                color: AppColors.getTextColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.isArabic ? 'جنيه' : 'EGP',
                            style: Styles.mediumText(
                              fontSize:
                                  context.locale.languageCode == "ar" ? 35 : 28,
                              fontWeight: FontWeight.w500,
                              color: AppColors.getRedColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                Row(
                  children: [
                    /// LEFT SIDE: Time Picker
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
      ManageVibration.vibrate();
                              time = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(hour: 0, minute: 0),
                              );
                              setState(() {});
                            },
                            child: Icon(
                              Icons.access_time,
                              size: 30,
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getTime(),
                              style: Styles.headerText(color: AppColors.getTextColor(context)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// RIGHT SIDE: Checkbox + Repeat Text
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min, // Keep content compact
                        children: [
                          Checkbox(
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: isChecked,
                            onChanged: (value) {
                              isChecked = value ?? false;
                              setState(() {});
                            },
                            checkColor: context.isDarkMode ? Colors.black : Colors.white,
                            activeColor: AppColors.getTextColor(context),
                            side: BorderSide(
                              color: AppColors.getTextColor(context),
                              width: 2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              LocaleKeys.repeat.localize,
                              style: Styles.headerText(color: AppColors.getTextColor(context)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                const Sizer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// LEFT SIDE: Time Picker
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Align vertically center
                        children: [
                          DropdownButton<int>(
                            dropdownColor: AppColors.getFillColor(context),
                            borderRadius: BorderRadius.circular(15),
                            menuWidth: 100.w,
                            enableFeedback: false,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            underline: const SizedBox.shrink(),
                            value: selectedSeatNum, // Set the selected value
                            items: [1, 2, 3, 4, 5, 6].map(
                                  (e) => DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: e,
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(color: AppColors.getTextColor(context)),
                                ),
                              ),
                            ).toList(),
                            onChanged: (int? value) {
                              selectedSeatNum = value ?? 1;
                              setState(() {});
                            },
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down), // Keep standard icon
                          ),
                          const SizedBox(width: 8),
                          Text(
                            LocaleKeys.seat.localize,
                            style: Styles.headerText(color: AppColors.getTextColor(context)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    /// RIGHT SIDE: Checkbox + Repeat Text
                    Expanded(
                      flex: 1,
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min, // Keep content compact
                        children: [
                          Image.asset(
                            Assets.tripJoinBabySeatIcon,
                            height: 40.h,
                            color: AppColors.getTextColor(context),
                          ),
                          Flexible(
                            child:     Text(
                              LocaleKeys.seat.localize,
                              style: Styles.headerText(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextColor(context)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDistance(double meters) {
    final km = (meters / 1000).toStringAsFixed(1);
    return '$km KM';
  }


  String _calculateTotalPrice() {
    final pricePerSeat = widget.expectedPriceTripEntity?.price ?? 0;
    final seatCount = selectedSeatNum ?? 1;
    final total = pricePerSeat * seatCount;

    // If total is a whole number, remove the decimal
    if (total % 1 == 0) {
      return total.toInt().toString();
    } else {
      return total.toStringAsFixed(1); // or more precision if needed
    }
  }

  String _getTime() {
    String result = '';
    if (time == null) {
      result = TimeOfDay.now().format(context);
      return result;
    }
    return time!.format(context);
  }
}
*/