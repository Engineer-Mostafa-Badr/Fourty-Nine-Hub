import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/custom_row_v2.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinBottomSection extends StatefulWidget {
  const TripJoinBottomSection({super.key});

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
          color: AppColors.colorGreyLight,
          borderRadius: BorderRadius.circular(30.h)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRow(
                  children: [
                    Center(child: const Icon(Icons.directions_car, size: 30,)),
                    Text('0.0 ${LocaleKeys.KM.localize}',
                        style: Styles.headerText()),
                    Center(
                      child: Text(
                          '${20} ',
                          style: Styles.headerText(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      context.isArabic ? 'جنيه' : 'EGP',
                      style: Styles.mediumText(
                          fontSize:
                          context.locale.languageCode == "ar" ? 35 : 28,
                          fontWeight: FontWeight.w500,
                          color: AppColors.SECONDARY_COLOR),
                    )
                  ],
                ),
                Sizer(),
                CustomRow(
                  children: [
                    Center(
                      child:
                      IconButton(
                        visualDensity:const  VisualDensity(
                            horizontal: -4, vertical: -4),
                        onPressed: () async {
                          time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 0, minute: 0),
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.access_time, size: 30,),
                      ),
                    ),
                    Text(_getTime(), style: Styles.headerText()),
                    Checkbox(
                      visualDensity:const VisualDensity(
                          horizontal: -4, vertical: -4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: isChecked,
                      onChanged: (value) {
                        isChecked = value ?? false;
                        setState(() {});
                      },
                      checkColor: Colors.white,
                      activeColor: AppColors.PRIMARY_COLOR,
                    ),
                    Text(
                        LocaleKeys.repeat.localize, style: Styles.headerText()),
                  ],
                ),
                const Sizer(),
                CustomRow(
                  children: [
                    DropdownButton(
                      dropdownColor:const Color.fromRGBO(225, 225, 225, 1),
                      borderRadius: BorderRadius.circular(15),
                      menuWidth: 100.w,
                      enableFeedback: false,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.center,
                      underline:const SizedBox.shrink(),
                      items: [1, 2, 3, 4, 5, 6]
                          .map((e) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: e,
                          child: Text(
                            e.toString(),
                            style:const TextStyle(
                              color: Colors.black,
                            ),
                          )))
                          .toList(),
                      onChanged: (int? value) {
                        selectedSeatNum
                        = value ?? 1;
                        setState(() {});
                      },
                      icon:const Icon(Icons.keyboard_arrow_down, size: 30,),
                      isDense: true,
                    ),

                    Text(LocaleKeys.seat.localize,
                        style: Styles.headerText()),
                    Image.asset(Assets.tripJoinBabySeatIcon,height: 40.h,),
                    Text(
                      LocaleKeys.seat.localize,
                      style: Styles.headerText(fontWeight: FontWeight.bold),
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

  String _getTime() {
    String result = '';
    if (time == null) {
      result = TimeOfDay.now().format(context);
      return result;
    }
    return time!.format(context);
  }

  void _showDropdownMenu({required BuildContext context,
    required Offset position,
    required List items,
    required var selectedItem}) async {
    final RenderBox overlay =
    Overlay
        .of(context)
        .context
        .findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      color: AppColors.colorGreyLight,
      context: context,
      position: RelativeRect.fromLTRB
        (
        position.dx,
        position.dy-50,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: items
          .map((brand) =>
          PopupMenuItem<String>(
            value: brand,
            child: Text(brand),
          ))
          .toList(),
    );

    if (selected != null) {
      setState(() {
        selectedItem = selected;
      });
    }
  }


}

