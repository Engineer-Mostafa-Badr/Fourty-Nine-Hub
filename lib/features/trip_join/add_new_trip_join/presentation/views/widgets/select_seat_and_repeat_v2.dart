import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../cubits/trip_join_view/trip_join_view_cubit.dart';
import 'custom_row_v2.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class SelectSeatAndRepeatV2 extends StatefulWidget {
  const SelectSeatAndRepeatV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  State<SelectSeatAndRepeatV2> createState() => _SelectSeatAndRepeatV2State();
}

class _SelectSeatAndRepeatV2State extends State<SelectSeatAndRepeatV2> {
  bool repeated = false;
  int seatsNumber = 1;
  late final TripJoinViewCubit tripJoinViewCubit;
  @override
  void initState() {
    tripJoinViewCubit = context.read<TripJoinViewCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRow(
      children: [
        DropdownButton(
          dropdownColor: Color.fromRGBO(225, 225, 225, 1),
          borderRadius: BorderRadius.circular(15),
          menuWidth: 100.w,
          enableFeedback: false,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.center,
          underline: SizedBox.shrink(),
          items: [1, 2, 3, 4, 5, 6]
              .map((e) => DropdownMenuItem(
                  alignment: AlignmentDirectional.center,
                  value: e,
                  child: Text(
                    e.toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )))
              .toList(),
          onChanged: (int? value) {
            seatsNumber = value ?? 1;
            tripJoinViewCubit.changeNumberOfSeats(value ?? 1);
            setState(() {});
          },
          icon: Icon(Icons.keyboard_arrow_down, size: widget.size),
        ),
        Text('$seatsNumber ${LocaleKeys.seat.localize} ',
            style: Styles.headerText()),
        Checkbox(
          value: repeated,
          onChanged: (value) {
            repeated = value ?? false;
            tripJoinViewCubit.controlDateVisibilty(value ?? false);
            setState(() {});
          },
          checkColor: Colors.white,
          activeColor: AppColors.PRIMARY_COLOR,
        ),
        Text(LocaleKeys.repeat.localize, style: Styles.headerText()),
      ],
    );
  }
}
