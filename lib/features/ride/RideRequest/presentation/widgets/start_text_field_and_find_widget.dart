import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_starting_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/record_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class StartTextFieldAndFindWidget extends StatefulWidget {
  const StartTextFieldAndFindWidget({super.key});
  static TextEditingController startingPoint = TextEditingController();

  @override
  State<StartTextFieldAndFindWidget> createState() =>
      _StartTextFieldAndFindWidgetState();
}

class _StartTextFieldAndFindWidgetState
    extends State<StartTextFieldAndFindWidget> {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: 105.h,
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<GetStartingPointRideCubit, RiderState>(
                builder: (context, state) {
                  return TextFormField(
                    decoration: InputDecoration(
                      // constraints: const BoxConstraints(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.transparent,
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: _getIcon(state),
                      labelText: LocaleKeys.startingPoint.localize,
                    ),
                    controller: StartTextFieldAndFindWidget.startingPoint,
                    // labelStyle: const TextStyle(color: Colors.black),
                    // hint: 'Find your starting Point..!',
                    validator: _validator,
                  );
                },
              ),
            ),
            const Sizer(width: 5),
            SizedBox(
              height: 75.h,
              child: CustomButton(
                title: LocaleKeys.searchFind.localize,
                onTap: () {
                  
                  if (formKey.currentState!.validate()) {
                    context.read<GetStartingPointRideCubit>().getStartingPoint(
                        address:
                            StartTextFieldAndFindWidget.startingPoint.text);
                  }
                },
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(RiderState state) {
    if (state is SuccessGetStartingPointState) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }
    if (state is StartingLocationLoading) {
      return const SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.PRIMARY_COLOR,
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (state is StartingLocationFailed) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      );
    }
    return const Icon(
      Icons.error,
      color: Colors.grey,
      size: 30,
    ); // Default case
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.youCantLeaveFieldEmpty.localize;
    }
    // if (value.length < 10) {
    //   return LocaleKeys.addressMustBeAtLeast10Chars.localize;
    // }
    return null;
  }
}
